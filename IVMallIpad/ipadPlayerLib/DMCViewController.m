//
//  DMCViewController.m
//  IVMallPlayer
//
//  Created by SmitJh on 14-7-12.
//  Copyright (c) 2014年 MJH. All rights reserved.
//

#import "DMCViewController.h"
#import "ConfigHeader.h"
#import "CommonTools.h"

@interface DMCViewController ()

@end

@implementation DMCViewController
{
    UIView * topView;
    
    
    UIView* bottomView;
    UIButton* playAndPauseButton;
    UIButton* volumeAddBtn;
    UIButton* volumeDelBtn;
    UISlider* seekSlider;
    UILabel* timeLabel;
    NSTimer* processTimer;
    
    UIView* seekView;
    UILabel* seekTimeLabel;
    
    UIImageView* TVView;
    
    
    DMCPlayStateEnum DMRPlayState;      //DMR播放状态
    int DMRCurrentTime;                 //DMR当前播放时间
    int DMRTotalTime;                   //DMR总时间
    int DMRVolume;                      //DMR音量
    BOOL DMC_SEEK_FAILED;               //dmc Seek失败标
    BOOL firstPlay;                     //投屏操作时使用，用以设置初试播放时间（进入时seek），在得到第一次播放回调处进行dmcseek动作，因为如果在无任何回调时进行seek或产生其他问题，而之后的回调将是不能进行seek的，
    BOOL statusBarHidder;
    
    NSTimeInterval seekCurrentTime;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self hideStatusBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    //    [self showStatusBar];
    if (processTimer) {
        [processTimer invalidate];
        processTimer = nil;
    }
    processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(process) userInfo:nil repeats:NO];

}

-(void)viewDidDisappear:(BOOL)animated
{
    //取消播放时保持亮屏状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDSCREEN_SIZE_HEIGHT, LDSCREEN_SIZE_WIDTH)];
    self.view.backgroundColor = [CommonTools colorFromHexRGB:@"242424"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (iOS7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden=YES;
    
    [self addTopView];
    [self addBottomView];
    [self addTVView];
    [self addSeekView];
    
    [self addGesture];
    [YunPlayer sharedPlayer].DMCdelegate =self;
    NSLog(@"[YunPlayer sharedPlayer].DMCdelegate =self;");
    
    DMC_SEEK_FAILED = NO;
    firstPlay = YES;
//    statusBarHidder = NO;
//    Do any additional setup after loading the view.
}

#pragma mark gesture
-(void)addGesture
{
    //    单击
    UITapGestureRecognizer * tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapRecognizer1.numberOfTapsRequired = 1;
    [self.view  addGestureRecognizer:tapRecognizer1];
    tapRecognizer1.delegate = self;
    
    //    双击
    UITapGestureRecognizer* doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2; // 双击
    [self.view addGestureRecognizer:doubleTapRecognizer];
    doubleTapRecognizer.delegate = self;
    [tapRecognizer1 requireGestureRecognizerToFail:doubleTapRecognizer];
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handPanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.delegate = self;
    [tapRecognizer1 requireGestureRecognizerToFail:panRecognizer];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    
}

-(void)DoubleTap:(UIPinchGestureRecognizer *)sender
{
    
}

static float volumeBegan = 0.0f;
static float currentBegan = 0.0f;
static BOOL XactiveHandle = YES;
static BOOL YactiveHandle = YES;
static float currentRusult = 0;
static float volumeRusult = 0;

-(void)handPanGesture:(UIPanGestureRecognizer*)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            
            if (sender.numberOfTouches == 1) {
                [[YunPlayer sharedPlayer]DMCGetVolume];
                [[YunPlayer sharedPlayer]DMCGetPosition];
                volumeBegan = DMRVolume;
                currentBegan = seekSlider.value*DMRTotalTime/100.0f;
                
                XactiveHandle = NO;
                YactiveHandle = NO;
            }
            break;
        case UIGestureRecognizerStateChanged:
            if (sender.numberOfTouches == 1) {
                CGPoint point = [sender translationInView:self.view];
                CGFloat xabs = fabsf(point.x);
                CGFloat yabs = fabsf(point.y);
                if (xabs > yabs) {
                    if (YactiveHandle) {
                        return;
                    }
                    if (processTimer) {
                        [processTimer invalidate];
                        processTimer = nil;
                    }
                    XactiveHandle = YES;
                    NSTimeInterval duration;
                    duration = DMRTotalTime;
                    
                    if ((point.x < 5000.0f)&&(point.x > -5000.0f)) {
                        currentRusult = currentBegan + (point.x/5000.0f)*duration;
                        if (currentRusult > duration)
                        {
                            currentRusult = duration-1;
                        }else if(currentRusult < 0.0f)
                        {
                            currentRusult = 0.0f;
                        }
                        seekSlider.value = (currentRusult/duration)*100;
                        
                        timeLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonTools timeToString:currentRusult],[CommonTools timeToString:duration]];
                        
                        int tempF = (point.x > 0)?1:-1;//用于判断快进还是快退，对应设置seekView背景
                        [self setSeekView:tempF secondPara:currentRusult];
                    }
                }else{
                    if (XactiveHandle){
                        return;
                    }
                    YactiveHandle = YES;
                    if ((point.y < 1000.0f)&&(point.y > -1000.0f)){
                        volumeRusult = volumeBegan - point.y/5.0f;
                        if (volumeRusult > 100)
                        {
                            volumeRusult = 100;
                        }else if(volumeRusult < 0.0f)
                        {
                            volumeRusult = 0.0f;
                        }
                    }else if(point.y < -1000.0f){
                        volumeRusult = 100;
                    }else if(point.y > 1000.0f){
                        volumeRusult = 0;
                    }
//                    [[YunPlayer sharedPlayer]setVolume:volumeRusult];
                }
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (XactiveHandle){
                [[YunPlayer sharedPlayer]DMCSeekToTime:currentRusult];
                processTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(assistProcess) userInfo:nil repeats:NO];
                [self performSelector:@selector(seekViewDisappear) withObject:nil afterDelay:0.5f];
            }else if(YactiveHandle){
                NSLog(@"------------volumeRusult = %f", volumeRusult);
            }
            break;
        default:
            break;
    }//end switch
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{

    if ([touch.view isKindOfClass:[UIScrollView class]] || [touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }

    //NSLog(@"touch.view =%@",[touch.view description]);
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 6)
    {
        if ([touch.view isMemberOfClass:[UIButton class]]) {
            //放过UIButton点击拦截
            return NO;
        }else{
            return YES;
        }
    }else{
        //处理tabelViewCell 不响应点击事件
        if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
            return NO;
        }else{
            return YES;
        }
    }
}

#pragma mark ADD TOPVIEW
-(void)addTopView
{
    topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, LDSCREEN_SIZE_HEIGHT, TOPVIEW_HEIGHT);
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.9;
    [self.view addSubview:topView];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2*BTNFRAME_LENGTH, 0, LDSCREEN_SIZE_HEIGHT - 4*BTNFRAME_LENGTH, TOPVIEW_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.videoName;
    NSLog(@"%@", self.videoName);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.alpha = 0.8f;
    titleLabel.font = [UIFont boldSystemFontOfSize:23*BTNRATIO];
    [topView addSubview:titleLabel];
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(BTN_SIDEGAP, BTN_TOPGAP, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    backBtn.frame=CGRectMake(20*BTNRATIO, 14*BTNRATIO, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    if (!iPad) {
        backBtn.frame=CGRectMake(20*BTNRATIO, 14*BTNRATIO - 5, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    }
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"backBtn@2x"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"backBtn_sel@2x"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UIButton* offBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    offBtn.frame = CGRectMake(LDSCREEN_SIZE_HEIGHT - 20*BTNRATIO - BTNFRAME_LENGTH, 14*BTNRATIO, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    if (!iPad) {
        offBtn.frame = CGRectMake(LDSCREEN_SIZE_HEIGHT - 20*BTNRATIO - BTNFRAME_LENGTH, 14*BTNRATIO - 5, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    }
    [offBtn setImage:[UIImage imageNamed:@"powerOffBtn@2x"] forState:UIControlStateNormal];
    [offBtn setImage:[UIImage imageNamed:@"powerOffBtn_sel@2x"] forState:UIControlStateHighlighted];
    [offBtn addTarget:self action:@selector(endDLNA) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:offBtn];
}

#pragma mark TV VIEW
-(void)addTVView
{
    TVView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TVImage@2x"]];
    TVView.frame = CGRectMake((LDSCREEN_SIZE_HEIGHT - 688*BTNRATIO/2.0)/2.0, (LDSCREEN_SIZE_WIDTH - 503*BTNRATIO/2.0)/2.0, 688*BTNRATIO/2.0, 503*BTNRATIO/2.0);
    TVView.backgroundColor = [UIColor clearColor];
    TVView.alpha = 0.9;
    [self.view addSubview:TVView];
    
    UILabel* tvLabel = [[UILabel alloc]init];
    tvLabel.frame = CGRectMake(0, 503*BTNRATIO/2.0 - 45*BTNRATIO - 25*BTNRATIO, 688*BTNRATIO/2.0, 25*BTNRATIO);
    tvLabel.font = [UIFont boldSystemFontOfSize:25*BTNRATIO];
    tvLabel.textColor = [UIColor whiteColor];
    tvLabel.alpha = 0.8;
    tvLabel.textAlignment = NSTextAlignmentCenter;
    tvLabel.backgroundColor = [UIColor clearColor];
    tvLabel.text = @"正在电视上播放";
    [TVView addSubview:tvLabel];
}

# pragma mark seekView
-(void)addSeekView
{
    //快进快退时显示在进度条附近的view
    seekView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, 215*BTNRATIO/2.0, 129*BTNRATIO/2.0)];
    seekView.alpha = 0.9;
    seekView.userInteractionEnabled = NO;
    
    seekTimeLabel = [[UILabel alloc]init];
    seekTimeLabel.frame = CGRectMake(0, (iPad?32:25), 215/2.0, 30*BTNRATIO);
    seekTimeLabel.backgroundColor = [UIColor clearColor];
    seekTimeLabel.textAlignment = NSTextAlignmentCenter;
    seekTimeLabel.textColor = [UIColor whiteColor];
    seekTimeLabel.font = [UIFont systemFontOfSize:16.0f];
    [seekView addSubview:seekTimeLabel];
    
    seekView.hidden = YES;
    [self.view addSubview:seekView];
    //    seekView.backgroundColor = [UIColor colorWithPatternImage:[IVMallTools nSBundleSetImage:@"seekForward_bg"]];
}

-(void)setSeekView:(int)direction secondPara:(int)time//参数决定背景图片和label显示
{
    seekView.hidden = NO;
    if (direction == 1) {
        seekView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seekForward_bg"]];
    }else{
        seekView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seekBackward_bg"]];
    }
    
    seekTimeLabel.text = [CommonTools timeToString:time];
    
    if (iPad) {
        seekView.frame = CGRectMake((LDSCREEN_SIZE_HEIGHT - 32)*seekSlider.value/100 - 215/2.0/2.0 + 16, (LDSCREEN_SIZE_WIDTH - BOTTOMVIEW_HEIGHT - 129/2.0 - 10), 215/2.0, 129/2.0);
    }else{
        seekView.frame = CGRectMake((LDSCREEN_SIZE_HEIGHT - 20)*seekSlider.value/100 - 215/2.0/2.0 + 10, (LDSCREEN_SIZE_WIDTH - BOTTOMVIEW_HEIGHT - 129/2.0 - 10), 215/2.0, 129/2.0);
    }
}

-(void)seekViewDisappear
{
    seekView.hidden = YES;
}

# pragma mark BottomView
- (void)addBottomView
{
    //点击播放器  下面弹出来的view
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, LDSCREEN_SIZE_WIDTH-BOTTOMVIEW_HEIGHT - 8, LDSCREEN_SIZE_HEIGHT, BOTTOMVIEW_HEIGHT + 8)];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.9;
    bottomView.userInteractionEnabled = YES;
    
    //进度条
    seekSlider = [[UISlider alloc] init];
    seekSlider.frame = CGRectMake(-5, -16, LDSCREEN_SIZE_HEIGHT+10, 36);
    [seekSlider addTarget:self action:@selector(processTimerStop) forControlEvents:UIControlEventTouchDown];
    [seekSlider addTarget:self action:@selector(processSet) forControlEvents:UIControlEventTouchDragInside];
    [seekSlider addTarget:self action:@selector(processSetDone) forControlEvents:UIControlEventValueChanged];
    [bottomView addSubview:seekSlider];
    
    seekSlider.minimumValue = 0.0;
    seekSlider.maximumValue=100.0;
    seekSlider.value = 0.0;
    seekSlider.continuous = NO;
    seekSlider.layer.masksToBounds = YES;
    seekSlider.backgroundColor = [UIColor clearColor];
    
    if (iPad) {
        [seekSlider setThumbImage:[UIImage imageNamed:@"track"] forState:UIControlStateNormal];
        [seekSlider setThumbImage:[UIImage imageNamed:@"track_sel"] forState:UIControlStateHighlighted];
    }else{
        [seekSlider setThumbImage:[UIImage imageNamed:@"trackPhone"] forState:UIControlStateNormal];
        [seekSlider setThumbImage:[UIImage imageNamed:@"trackPhone_sel"] forState:UIControlStateHighlighted];
    }
    [seekSlider setMaximumTrackImage:[UIImage imageNamed:@"track_right"] forState:UIControlStateNormal];
    [seekSlider setMinimumTrackImage:[UIImage imageNamed:@"track_left"] forState:UIControlStateNormal];
    NSLog(@"smit----processTimer");
    processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(process) userInfo:nil repeats:NO];
    
    //    播放暂停按钮
    playAndPauseButton = [[UIButton alloc]initWithFrame:CGRectMake(20*BTNRATIO, (BOTTOMVIEW_HEIGHT - BTNFRAME_LENGTH)/2.0, BTNFRAME_LENGTH, BTNFRAME_LENGTH)];
    if (!iPad) {
        playAndPauseButton.frame = CGRectMake(20*BTNRATIO, (BOTTOMVIEW_HEIGHT - BTNFRAME_LENGTH)/2.0 + 5, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    }
    [playAndPauseButton setImage:[UIImage imageNamed:@"play@2x"] forState:UIControlStateNormal];
    [playAndPauseButton setImage:[UIImage imageNamed:@"play_sel@2x"] forState:UIControlStateHighlighted];
    [playAndPauseButton addTarget:self action:@selector(gotoPlayOrPause) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:playAndPauseButton];
    
    
    //时间的label
    timeLabel = [[UILabel alloc]init];
    timeLabel.frame = CGRectMake((LDSCREEN_SIZE_HEIGHT - 200)/2.0, 20*BTNRATIO, 200, 25*BTNRATIO);
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor=[UIColor whiteColor];
    timeLabel.font=[UIFont boldSystemFontOfSize:15];
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonTools timeToString:0],[CommonTools timeToString:0]];
    [bottomView addSubview:timeLabel];
    
    volumeAddBtn = [[UIButton alloc]initWithFrame:CGRectMake(LDSCREEN_SIZE_HEIGHT - 2*BTN_SIDEGAP - 2*BTNFRAME_LENGTH, (BOTTOMVIEW_HEIGHT - BTNFRAME_LENGTH)/2.0, BTNFRAME_LENGTH, BTNFRAME_LENGTH)];
    if (!iPad) {
        volumeAddBtn.frame = CGRectMake(LDSCREEN_SIZE_HEIGHT - 2*BTN_SIDEGAP - 2*BTNFRAME_LENGTH - 5, (BOTTOMVIEW_HEIGHT - BTNFRAME_LENGTH)/2.0 + 5, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    }
    [volumeAddBtn setImage:[UIImage imageNamed:@"volumeAdd@2x"] forState:UIControlStateNormal];
    [volumeAddBtn setImage:[UIImage imageNamed:@"volumeAdd_sel@2x"] forState:UIControlStateHighlighted];
    [volumeAddBtn addTarget:self action:@selector(changeVolume:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:volumeAddBtn];
    
    volumeDelBtn = [[UIButton alloc]initWithFrame:CGRectMake(LDSCREEN_SIZE_HEIGHT - 20*BTNRATIO - BTNFRAME_LENGTH, (BOTTOMVIEW_HEIGHT - BTNFRAME_LENGTH)/2.0, BTNFRAME_LENGTH, BTNFRAME_LENGTH)];
    if (!iPad) {
        volumeDelBtn.frame = CGRectMake(LDSCREEN_SIZE_HEIGHT - 20*BTNRATIO - BTNFRAME_LENGTH, (BOTTOMVIEW_HEIGHT - BTNFRAME_LENGTH)/2.0 + 5, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    }
    [volumeDelBtn setImage:[UIImage imageNamed:@"volumeDel@2x"] forState:UIControlStateNormal];
    [volumeDelBtn setImage:[UIImage imageNamed:@"volumeDel_sel@2x"] forState:UIControlStateHighlighted];
    [volumeDelBtn addTarget:self action:@selector(changeVolume:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:volumeDelBtn];
    
    [self.view addSubview:bottomView];
}


-(void)changeVolume:(id)sender
{
    UIButton* item = (UIButton *)sender;
    int volumeT = DMRVolume;
    [[YunPlayer sharedPlayer]DMCGetVolume];
    if (item == volumeAddBtn && volumeT <= 90) {
//        [volumeAddBtn setEnabled:NO];
        volumeT += 10;
    }else if (item == volumeDelBtn && volumeT >= 10){
//        [volumeDelBtn setEnabled:NO];
        volumeT -= 10;
    }
    [[YunPlayer sharedPlayer]DMCSetVolume:volumeT];
}



//手指接触控制条
-(void)processTimerStop
{
    NSLog(@"processTimerStop");
    if (processTimer) {
        [processTimer invalidate];
        processTimer = nil;
    }
}

//手指滑动
-(void)processSet
{
//    NSLog(@"processSet");
    static NSTimeInterval lastV;
    
    NSInteger totalTime = DMRTotalTime;
    if (totalTime == 0) {
        //            seekSlider.value = 0.0f;
        return;
    }else{
        NSTimeInterval currentTime = seekSlider.value/100*totalTime;
        
        timeLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonTools timeToString:currentTime],[CommonTools timeToString:totalTime]];
        
        if ((seekSlider.value - lastV)*100000 >= 0) {
            [self setSeekView:1 secondPara:currentTime];
        }else{
            [self setSeekView:0 secondPara:currentTime];
        }
        lastV = seekSlider.value;
        return;
    }
}

//手指滑动完成
-(void)processSetDone
{
    NSInteger totalTime = DMRTotalTime;
    if (totalTime == 0)
    {
        seekSlider.value = 0.0f;
        return;
    }else {
        seekCurrentTime = seekSlider.value/100*totalTime;
        timeLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonTools timeToString:seekCurrentTime],[CommonTools timeToString:totalTime]];
        [[YunPlayer sharedPlayer]DMCSeekToTime:seekCurrentTime];
        processTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(assistProcess) userInfo:nil repeats:NO];
    }
    
    [self performSelector:@selector(seekViewDisappear) withObject:nil afterDelay:0.5f];
}

-(void)assistProcess
{
    debugMethod();
    [[YunPlayer sharedPlayer]DMCGetPosition];
    [[YunPlayer sharedPlayer]DMCGetTransInfo];
    NSInteger currentTime = DMRCurrentTime;
    NSInteger totalTime = DMRTotalTime;
    if (DMC_SEEK_FAILED) {//这里添加dmc seek成功与否的判断
        if (processTimer) {
            [processTimer invalidate];
            processTimer = nil;
        }
        processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(process) userInfo:nil repeats:NO];
    }else{
        NSLog(@"currentTime = %d, totalTime = %d, seekSlider.value = %f ",currentTime,totalTime,totalTime*seekSlider.value/100);
        if (abs(currentTime - totalTime*seekSlider.value/100) < 15) {
            timeLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonTools timeToString:currentTime],[CommonTools timeToString:totalTime]];
            if ( totalTime == 0)
            {
                seekSlider.value = 0.0f;
            }else{
                seekSlider.value= 100.0f*currentTime/totalTime;
            }
            if (processTimer) {
                [processTimer invalidate];
                processTimer = nil;
            }
            processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(process) userInfo:nil repeats:NO];
        }else{
            if (processTimer) {
                [processTimer invalidate];
                processTimer = nil;
            }
            processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(assistProcess) userInfo:nil repeats:NO];
        }
    }
}

//刷slider的
-(void)process
{
//    debugMethod();

    //获取DMR的播放时间信息
    [[YunPlayer sharedPlayer]DMCGetPosition];
    [[YunPlayer sharedPlayer]DMCGetTransInfo];
    NSInteger currentTime = DMRCurrentTime;
    NSInteger totalTime = DMRTotalTime;
    timeLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonTools timeToString:currentTime],[CommonTools timeToString:totalTime]];
    if ( totalTime == 0){
        seekSlider.value = 0.0f;
    }else{
        seekSlider.value= 100.0f*currentTime/totalTime;
    }
    if (processTimer) {
        [processTimer invalidate];
        processTimer = nil;
    }
    processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(process) userInfo:nil repeats:NO];
}

- (void)gotoPlayOrPause //按钮修改在callback里处理
{
    if (DMRPlayState == PLAYSTATE_PAUSED) {
        NSLog(@" sent play");
        [[YunPlayer sharedPlayer]DMCPlay];
        [playAndPauseButton setEnabled:NO];
    }else{
         NSLog(@" sent pause");
        [[YunPlayer sharedPlayer]DMCPause];
        [playAndPauseButton setEnabled:NO];
    }
}

-(void)changePlayAndPauseBtnImg:(BOOL)paused
{
    [playAndPauseButton setEnabled:YES];
    if (paused) {
        [playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"play@2x"] forState:UIControlStateNormal];
        [playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"play_sel@2x"] forState:UIControlStateHighlighted];
    }else{
        [playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"pause@2x"] forState:UIControlStateNormal];
        [playAndPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_sel@2x"] forState:UIControlStateHighlighted];
    }
}

#pragma mark DMC CALL BACK DELEGATE
-(BOOL)getPlayerMode
{
    if ([self.navigationController.topViewController isKindOfClass:[DMCViewController class]]) {
        return YES;
    }
    return NO;
}

-(void)handleDMCCallbackWithActionType:(DMCActionTypeEnum)actionType errorCode:(DMCErrorCodeEnum)errorCode firstParameter:(NSInteger)parameter1 secondParameter:(NSInteger)parameter2
{
//    NSLog(@"YunPlayer的代理11 actionType=%d,errorCode=%d,parameter1=%d,parameter2=%d",(int)actionType,(int)errorCode,(int)parameter1,(int)parameter2);
    switch (actionType) {
        case ACTION_REFRESH:
            break;
        case ACTION_OPNEURL:
            //            LOGE(@"smit----LOGE--%s,--ACTION_OPNEURL",__func__);
            //如果返回错误码，就退出投屏，
            break;
        case ACTION_PLAY:
            [seekSlider setEnabled:YES];
            [self changePlayAndPauseBtnImg:NO];
            break;
        case ACTION_STOP:
            break;
        case ACTION_PAUSE:
            [self changePlayAndPauseBtnImg:YES];
            break;
        case ACTION_SEEK:
            if (errorCode != 0) {
                DMC_SEEK_FAILED = YES;
            }
            break;
        case ACTION_GETVOLUME:
            NSLog(@"ACTION_GETVOLUME parameter1=%d",(int)parameter1);
            DMRVolume = (int)parameter1;
            break;
        case ACTION_SETVOLUME:
            [volumeAddBtn setEnabled:YES];
            [volumeDelBtn setEnabled:YES];
            break;
        case ACTION_GETPOSITON:
            DMRCurrentTime = (int)parameter1;
            DMRTotalTime = (int)parameter2;
            break;
        case ACTION_GETTRANSPORTINFO:
            DMRPlayState = parameter1;
            switch (parameter1) {
                case PLAYSTATE_PLAYING:
                    if (firstPlay) {
                        firstPlay = NO;
                        [[YunPlayer sharedPlayer]DMCSeekToTime:self.startTime];
                    }
                    
                    [seekSlider setEnabled:YES];
                    [playAndPauseButton setImage:[UIImage imageNamed:@"pause@2x"] forState:UIControlStateNormal];
                    [playAndPauseButton setImage:[UIImage imageNamed:@"pause_sel@2x"] forState:UIControlStateHighlighted];
//                    if (processTimer == nil) {
//                        processTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(process) userInfo:nil repeats:NO];
//                    }
                    break;
                case PLAYSTATE_STOPPED:
                    if (firstPlay) {
                        [[YunPlayer sharedPlayer]DMCStop];
                        [self endDLNA];
                    }
                    break;
                case PLAYSTATE_PAUSED:
                    [seekSlider setEnabled:NO];
                    [playAndPauseButton setImage:[UIImage imageNamed:@"play@2x"] forState:UIControlStateNormal];
                    [playAndPauseButton setImage:[UIImage imageNamed:@"play_sel@2x"] forState:UIControlStateHighlighted];
                    break;
                case PLAYSTATE_RECORDING:
                    
                    break;
                case PLAYSTATE_TRANSITIONING:
                    
                    [seekSlider setEnabled:YES];
                    [playAndPauseButton setImage:[UIImage imageNamed:@"pause@2x"] forState:UIControlStateNormal];
                    [playAndPauseButton setImage:[UIImage imageNamed:@"pause_sel@2x"] forState:UIControlStateHighlighted];
//                    if (processTimer == nil) {
//                        processTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(process) userInfo:nil repeats:NO];
//                    }
                    
                    break;
                case PLAYSTATE_NO_MEDIA:
                    [[YunPlayer sharedPlayer]DMCStop];
                    [self endDLNA];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}


#pragma mark --
-(void)backAction
{
    [[YunPlayer sharedPlayer]DMCToAPP];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [[IVMallPlayer sharedIVMallPlayer].delegate PlayerCallBack:PlayerWillReturnFromDMRPlay withParameter:nil];
}

-(void)endDLNA
{
    [[YunPlayer sharedPlayer]DMCStop];
    if (processTimer) {
        [processTimer invalidate];
        processTimer = nil;
    }
    [self.navigationController popViewControllerAnimated:NO];
}



#pragma mark StatusBar
-(void)showStatusBar
{
    if (iOS7){
        statusBarHidder = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

-(void)hideStatusBar
{
    if (iOS7){
        statusBarHidder = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:YES];
}

//for iOS7
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return statusBarHidder;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  横屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)) {
        return YES;
    }
    return NO;
}

//为了支持iOS6
-(BOOL)shouldAutorotate
{
    return YES;
}

//为了支持iOS6
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
    //    return UIInterfaceOrientationMaskAll;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end