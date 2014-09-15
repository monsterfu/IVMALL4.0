//
//  IVMallPlayerViewController.m
//  player4IVMall
//
//  Created by SmitJh on 14-7-4.
//  Copyright (c) 2014年 JH. All rights reserved.
//

#define LIKE_VIEW_FRAME_LENGTH (iPad?700:380)
#define LIKE_VIEW_FRAME_HEIGHT (iPad?300:160)

#define LIKE_BUTTON_LENGHT (iPad?159:100)
#define LIKE_BUTTON_HEIGHT (iPad?137:80)

#import "IVMallPlayerViewController.h"
#import "YunPlayer.h"
#import "configHeader.h"
#import "CommonTools.h"
#import "IVMallPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

//@interface IVMallPlayerViewController ()
//
//@end

@implementation IVMallPlayerViewController
{
    UIView *topView;            //播放器的标题栏
    UILabel* titleLabel;
    
    UIView* seekView;
    UILabel* seekTimeLabel;
    
    UIView *centreView;
    UIButton *centreBtn;
    
    UIView *bottomView;         //播放器的控制栏
    UILabel *timeLabel;  //开始时间的label
    UISlider * seekSlider;      //播放进度条
    UIButton* searchButton;
    UIButton *playAndPauseButton;//播放暂停按钮
    UIButton *airPlayButton;
    UIButton* mpButton;
    BOOL anyAirPlayDevice;         //标识是否存在AirPlay设备
    BOOL airPlayDeviceListOn;
    MPVolumeView *MPVolumeViewForAirPlay;
    
    UIView *loadingView;                //缓冲页面
    UILabel *loadingSpeed;              //下载速度
    
    UITableView *deviceListTableView;   //设备列表
    UIButton* airPlayBtn;
    NSMutableArray *deviceList;         //设备信息数组
    
    UIAlertView *alert;                 //单一提示弹框
    
    NSTimer* freshTimer;                //刷新下载速度
    NSTimer* processTimer;              //刷新播放时间
    NSTimer* controlTimer;              //控制标题栏和控制栏隐藏
    NSTimer* alertTimer;                //60s提示无法连接服务器
    NSTimer* seekControleTimer;         //快进快退计时器
    
    NSInteger processTimerPin;
    
    NSTimeInterval seekCurrentTime;     //快进快退前的时间
    
    NSTimeInterval historyTime;         //播放器与DRM播放切换时的时间
    BOOL statusBarHidder;               //状态条是否隐藏，在iOS7中使用
    
    BOOL manueExit;                     //手动退出
    BOOL WWAN_FLAG;                     //3G flag
    BOOL localPlayStateWhilePush;                   //用于判断push之前本地播放状态，yes for play
    
    UIPanGestureRecognizer* panRecognizer;
    NSMutableDictionary* callBackInfoDic;//退出时的回调信息
    
    UIView *ifLikeView;
    UIView * dialogView;
    NSTimer * ifLikeTimer;
    
    BOOL AllowDmcPush;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        localPlayStateWhilePush = YES;
    }
    
    return self;
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
    
    [self installNotificationObservers];
    if (localPlayStateWhilePush) {
        [[YunPlayer sharedPlayer] start];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    //取消播放时保持亮屏状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self unInstallNotificationObservers];
}

- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDSCREEN_SIZE_HEIGHT, LDSCREEN_SIZE_WIDTH)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (iOS7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationController.navigationBarHidden=YES;
    
    callBackInfoDic = [[NSMutableDictionary alloc]init];
    AllowDmcPush = NO;
    
    [YunPlayer sharedPlayer].delegate=self;
    [[YunPlayer sharedPlayer]setDisplayOnView:self];
    [[YunPlayer sharedPlayer]setDataSource:self.playUrl];
    [[YunPlayer sharedPlayer]setInitialPlaybackTime:self.startTime];
    [[YunPlayer sharedPlayer]start];
    
    self.dmcPlayVC = [[DMCViewController alloc]init];
    [YunPlayer sharedPlayer].DMCdelegate = self.dmcPlayVC;
    
    [self addGesture];
    
    [self addLoadingView];
    [self addTopView];
    [self addBottomView];
    [self addDeviceListView];
    [self addSeekView];
    [self addCentreView];
    [self addIfLikeThisContentView];
    
    [self checkAirPlay];
    
    airPlayDeviceListOn = NO;
    manueExit = NO;
    
    [self scheduledTimerToHidden];
    
}
#pragma mark -- TopView+BottomView+SeekBar-->Hidden
-(void)scheduledTimerToHidden
{
    if (controlTimer) {
        [controlTimer invalidate];
        controlTimer = nil;
    }
    controlTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(TopBottomDisappearAnimation) userInfo:nil repeats:NO];
}

#pragma mark --UIGestureRecognizer
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
    
    panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handPanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.delegate = self;
    [tapRecognizer1 requireGestureRecognizerToFail:panRecognizer];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    if (ifLikeView) {
        if (!ifLikeView.hidden) {
            return;
        }
    }
    
    if (topView.hidden) {
        [self TopBottomAppearAnimation];
        [self scheduledTimerToHidden];
    }else{
        [self TopBottomDisappearAnimation];
    }
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
            NSLog(@"\n\nsmit----controlTimer=%@",controlTimer);
            [controlTimer invalidate];
            controlTimer = nil;
            NSLog(@"\n\nsmit----controlTimer=%@",controlTimer);
            
            if (sender.numberOfTouches == 1) {
                volumeBegan = [[YunPlayer sharedPlayer]getVolume];
                currentBegan = seekSlider.value*[[YunPlayer sharedPlayer]getDuration]/100.0f;
                [self TopBottomAppearAnimation];
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
                    duration = [[YunPlayer sharedPlayer]getDuration];
                    
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
                        volumeRusult = volumeBegan - point.y/250.0f;
                        if (volumeRusult > 1.0f)
                        {
                            volumeRusult = 1.0f;
                        }else if(volumeRusult < 0.0f)
                        {
                            volumeRusult = 0.0f;
                        }
                    }else if(point.y < -1000.0f){
                        volumeRusult = 1.0;
                    }else if(point.y > 1000.0f){
                        volumeRusult = 0.0;
                    }
                    [[YunPlayer sharedPlayer]setVolume:volumeRusult];
                }
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (XactiveHandle){
                [[YunPlayer sharedPlayer]seekTo:currentRusult];
                processTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(assistProcess) userInfo:nil repeats:NO];
                [self performSelector:@selector(seekViewDisappear) withObject:nil afterDelay:0.5f];
                [self scheduledTimerToHidden];
            }else if(YactiveHandle){
                [self scheduledTimerToHidden];
            }
            break;
        default:
            break;
    }//end switch
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (ifLikeView) {
        if (!ifLikeView.hidden) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if (touch.view == bottomView || touch.view == topView || touch.view == deviceListTableView || touch.view == playAndPauseButton || touch.view == seekSlider || touch.view == loadingView || touch.view == centreView) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    if ([touch.view isDescendantOfView:deviceListTableView] || [touch.view isDescendantOfView:centreView]) {
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
    }else
    {
        //处理tabelViewCell 不响应点击事件
        if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
            return NO;
        }else{
            return YES;
        }
    }
}


# pragma mark  LoadingView
- (void)addLoadingView
{
    loadingView = [[UIView alloc]initWithFrame:CGRectMake((LDSCREEN_SIZE_HEIGHT-160)/2, (LDSCREEN_SIZE_WIDTH-45)/2, 160, 45)];
    loadingView.backgroundColor = [UIColor clearColor];
    loadingView.userInteractionEnabled = NO;
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [activity setHidesWhenStopped:YES];
    [activity startAnimating];
    [loadingView addSubview:activity];
    
    UILabel* loadingInfo = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 135, 22)];
    loadingInfo.backgroundColor = [UIColor clearColor];
    loadingInfo.textColor = [UIColor colorWithRed:(175/255.0f) green:(175/255.0f) blue:(175/255.0f) alpha:1.0];
    loadingInfo.font = [UIFont systemFontOfSize:15.0f];
    loadingInfo.text = @"正在加载，请稍候...";
    [loadingView addSubview:loadingInfo];
    
    loadingSpeed = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, 160, 23)];
    loadingSpeed.backgroundColor = [UIColor clearColor];
    loadingSpeed.textColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0];;
    loadingSpeed.textAlignment = NSTextAlignmentCenter;
    loadingSpeed.font = [UIFont systemFontOfSize:16.5f];
    [loadingView addSubview:loadingSpeed];
    
    freshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(processSecSpeedText) userInfo:loadingSpeed repeats:YES];
    
    [self.view addSubview:loadingView];
}

-(void)processSecSpeedText
{
    
    NSString* teststr = [self bytesToSpeedStr:[[YunPlayer sharedPlayer]getDownloadSpeedBytes]];
    loadingSpeed.text = teststr;
}

-(NSString *)bytesToSpeedStr:(long long int) bytes
{
    if (bytes < 0) {
        return @"0B/s";
    }
    else if(bytes < 1024)     // B
    {
        return [NSString stringWithFormat:@"%lldB/s", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB/s", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

# pragma mark  TopView
- (void)addTopView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDSCREEN_SIZE_HEIGHT, TOPVIEW_HEIGHT)];
    topView.userInteractionEnabled = YES;
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha =0.9;
    
    UIButton* returnButton=[UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame=CGRectMake(20*BTNRATIO, 14*BTNRATIO, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    if (!iPad) {
        returnButton.frame=CGRectMake(20*BTNRATIO, 14*BTNRATIO - 5, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    }
    returnButton.backgroundColor = [UIColor clearColor];
    [returnButton setImage:[UIImage imageNamed:@"backBtn@2x"] forState:UIControlStateNormal];
    [returnButton setImage:[UIImage imageNamed:@"backBtn_sel@2x"] forState:UIControlStateHighlighted];
    [returnButton addTarget:self action:@selector(topReturnButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:returnButton];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*BTNRATIO+55*BTNRATIO, 0, LDSCREEN_SIZE_HEIGHT - 20*BTNRATIO - 55*BTNRATIO, TOPVIEW_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:28.0*BTNRATIO];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.videoName;
    [topView addSubview:titleLabel];
    
    [self.view addSubview:topView];
}

- (void)topReturnButtonTouched
{
    debugMethod();
    manueExit = YES;
    
    [self setLastPlayTime:[[YunPlayer sharedPlayer]getCurrentPosition]];
    [self endPlayer];
    
    [self invalideTimers];
}
-(void)invalideTimers
{
    debugMethod();
    if (freshTimer) {
        [freshTimer invalidate];
        freshTimer = nil;
    }
    
    if (processTimer) {
        [processTimer invalidate];
        processTimer = nil;
    }
    
    if (controlTimer) {
        [controlTimer invalidate];
        controlTimer = nil;
    }
    
    if (alertTimer) {
        [alertTimer invalidate];
        alertTimer = nil;
    }
    
    if (ifLikeTimer) {
        [ifLikeTimer invalidate];
        ifLikeTimer = nil;
    }
}
- (void) endPlayer
{
    debugMethod();
    [[YunPlayer sharedPlayer]stop];
    [YunPlayer sharedPlayer].delegate = nil;
    [[YunPlayer sharedPlayer]removeYunPlayer];
    
    [self showStatusBar];
    //    [self dismissViewControllerAnimated:YES completion:^{}];
    [self dismissViewControllerAnimated:NO completion:nil];
}

# pragma mark centreView
-(void)addCentreView
{
    centreView = [[UIView alloc]init];
    centreView.frame = CGRectMake((LDSCREEN_SIZE_HEIGHT - 507*BTNRATIO/2.0)/2, (LDSCREEN_SIZE_WIDTH - 507*BTNRATIO/2.0)/2, 507*BTNRATIO/2.0, 507*BTNRATIO/2.0);
    centreView.backgroundColor = [UIColor clearColor];
    
    centreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centreBtn.frame = CGRectMake(0, 0, 507*BTNRATIO/2.0, 507*BTNRATIO/2.0);
    [centreBtn setBackgroundImage:[UIImage imageNamed:@"playBtn_centre@2x"] forState:UIControlStateHighlighted];
    [centreBtn setBackgroundImage:[UIImage imageNamed:@"playBtn_centre_sel@2x"] forState:UIControlStateNormal];
    [centreBtn addTarget:self action:@selector(centreBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    centreView.hidden = YES;
    [centreView addSubview:centreBtn];
    [self.view addSubview:centreView];
}

-(void)centreBtnTouched
{
    [[YunPlayer sharedPlayer]start];
    centreView.hidden = YES;
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
        seekView.frame = CGRectMake((LDSCREEN_SIZE_HEIGHT - 32)*seekSlider.value/100 - 215/2.0/2.0 + 16, (LDSCREEN_SIZE_WIDTH - BOTTOMVIEW_HEIGHT - 129/2.0 - 20), 215/2.0, 129/2.0);
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
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, LDSCREEN_SIZE_WIDTH-BOTTOMVIEW_HEIGHT-8, LDSCREEN_SIZE_HEIGHT, BOTTOMVIEW_HEIGHT+8)];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.9;
    bottomView.userInteractionEnabled = YES;
    
    //进度条
    seekSlider = [[UISlider alloc] init];
//    seekSlider.frame = CGRectMake(-18, -16, LDSCREEN_SIZE_HEIGHT+36, 36);
//    seekSlider.frame = CGRectMake(-2, -16, LDSCREEN_SIZE_HEIGHT+4, 36);
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
    seekSlider.opaque = NO;
    
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
        
    searchButton = [[UIButton alloc]initWithFrame:CGRectMake(LDSCREEN_SIZE_HEIGHT - 20*BTNRATIO - BTNFRAME_LENGTH, (BOTTOMVIEW_HEIGHT - BTNFRAME_LENGTH)/2.0, BTNFRAME_LENGTH, BTNFRAME_LENGTH)];
    
    if (!iPad) {
        searchButton.frame = CGRectMake(LDSCREEN_SIZE_HEIGHT - 20*BTNRATIO - BTNFRAME_LENGTH, (BOTTOMVIEW_HEIGHT - BTNFRAME_LENGTH)/2.0 + 5, BTNFRAME_LENGTH, BTNFRAME_LENGTH);
    }
    [searchButton setImage:[UIImage imageNamed:@"search@2x"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"search_sel@2x"] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(searchDevice) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:searchButton];
    
    [self.view addSubview:bottomView];
}



//手指接触控制条
-(void)processTimerStop
{
    NSLog(@"processTimerStop");
    if (processTimer) {
        [processTimer invalidate];
        processTimer = nil;
    }
    if (topView.hidden == NO) {
        if (controlTimer) {
            [controlTimer invalidate];
            controlTimer = nil;
        }
    }
}

//手指滑动
-(void)processSet
{
//    NSLog(@"processSet");
    static NSTimeInterval lastV;
    NSInteger totalTime = [[YunPlayer sharedPlayer]getDuration];
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
    NSInteger totalTime = [[YunPlayer sharedPlayer]getDuration];
    if (totalTime == 0)
    {
        seekSlider.value = 0.0f;
        return;
    }else {
        seekCurrentTime = seekSlider.value/100*totalTime;
        timeLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonTools timeToString:seekCurrentTime],[CommonTools timeToString:totalTime]];
        [[YunPlayer sharedPlayer]seekTo:seekCurrentTime];
        processTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(assistProcess) userInfo:nil repeats:NO];
    }
    
    [self performSelector:@selector(seekViewDisappear) withObject:nil afterDelay:0.5f];
    //添加 隐藏页面时间计时器
    [self scheduledTimerToHidden];
}

-(void)assistProcess
{
    debugMethod();
    NSInteger currentTime = [[YunPlayer sharedPlayer ]getCurrentPosition];
    NSInteger totalTime = [[YunPlayer sharedPlayer]getDuration];
    if (abs(currentTime - totalTime*seekSlider.value/100) < 15) {
        timeLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonTools timeToString:currentTime],[CommonTools timeToString:totalTime]];
        if ( totalTime == 0)
        {
            seekSlider.value = 0.0f;
        }else{
            seekSlider.value= 100.0f*currentTime/totalTime;
        }
        processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(process) userInfo:nil repeats:NO];
    }else{
        if (60 < ++processTimerPin) {
            processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(process) userInfo:nil repeats:NO];
            return;
        }
        processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(assistProcess) userInfo:nil repeats:NO];
    }
}

//刷slider的
-(void)process
{
    processTimerPin = 0;
//    debugMethod();
    NSInteger currentTime = [[YunPlayer sharedPlayer ]getCurrentPosition];
    NSInteger totalTime = [[YunPlayer sharedPlayer]getDuration];
    timeLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonTools timeToString:currentTime],[CommonTools timeToString:totalTime]];
    if ( totalTime == 0){
        seekSlider.value = 0.0f;
    }else{
        seekSlider.value= 100.0f*currentTime/totalTime;
    }
    processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(process) userInfo:nil repeats:NO];
}

-(void)searchDevice
{
    if (deviceListTableView.hidden) {
        anyAirPlayDevice = [self isShowAirPlay];
        deviceList = [[YunPlayer sharedPlayer]DMCRefresh];
        [deviceListTableView reloadData];
        [deviceListTableView setHidden:NO];
    }else{
        [deviceListTableView setHidden:YES];
    }
    //添加中断隐藏页面
    if (controlTimer) {
        [controlTimer invalidate];
        controlTimer = nil;
    }
    if (deviceListTableView.hidden) {
        controlTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(TopBottomDisappearAnimation) userInfo:nil repeats:NO];
    }else{
        //            controlTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(TopBottomDisappearAnimation) userInfo:nil repeats:NO];
    }
}

- (void)gotoPlayOrPause //按钮修改在callback里处理
{
    if ([[YunPlayer sharedPlayer]isPlaying]) {
        
        [[YunPlayer sharedPlayer]pause];
        centreView.hidden = NO;
    }else{
        [[YunPlayer sharedPlayer]start];
        centreView.hidden = YES;
    }
    //添加中断隐藏页面
    [self scheduledTimerToHidden];
}

# pragma mark ifLikeThisContentView

-(void)addIfLikeThisContentView
{
    ifLikeView = [[UIView alloc]init];
    ifLikeView.frame = CGRectMake(0, 0, LDSCREEN_SIZE_HEIGHT, LDSCREEN_SIZE_WIDTH);
    ifLikeView.backgroundColor = [UIColor blackColor];
    ifLikeView.alpha = 0.5;
    ifLikeView.opaque = NO;
    
    
    dialogView = [[UIView alloc]init];
    
    dialogView.frame = CGRectMake((LDSCREEN_SIZE_HEIGHT - LIKE_VIEW_FRAME_LENGTH)/2.0, (LDSCREEN_SIZE_WIDTH - LIKE_VIEW_FRAME_HEIGHT)/2.0, LIKE_VIEW_FRAME_LENGTH, LIKE_VIEW_FRAME_HEIGHT);
    UIImageView * bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ifLike_bg"]];
    bgImg.frame = CGRectMake(0, 0, LIKE_VIEW_FRAME_LENGTH, LIKE_VIEW_FRAME_HEIGHT);
    [dialogView addSubview:bgImg];
    
    UIButton * likeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    likeBtn.frame = CGRectMake((LIKE_VIEW_FRAME_LENGTH/2.0 - LIKE_BUTTON_LENGHT)/2.0, (LIKE_VIEW_FRAME_HEIGHT - LIKE_BUTTON_HEIGHT)/2.0, LIKE_BUTTON_LENGHT, LIKE_BUTTON_HEIGHT);
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"like@2x"] forState:UIControlStateNormal];
    likeBtn.tag = 3698741;
    [likeBtn addTarget:self action:@selector(howAboutThisVideo:) forControlEvents:UIControlEventTouchUpInside];
    [dialogView addSubview:likeBtn];
    
    UIButton * dislikeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    dislikeBtn.frame = CGRectMake((LIKE_VIEW_FRAME_LENGTH/2.0 - LIKE_BUTTON_LENGHT)/2.0 + LIKE_VIEW_FRAME_LENGTH/2.0, (LIKE_VIEW_FRAME_HEIGHT - LIKE_BUTTON_HEIGHT)/2.0, LIKE_BUTTON_LENGHT, LIKE_BUTTON_HEIGHT);
    [dislikeBtn setBackgroundImage:[UIImage imageNamed:@"dislike@2x"] forState:UIControlStateNormal];
    dislikeBtn.tag = 3698742;
    [dislikeBtn addTarget:self action:@selector(howAboutThisVideo:) forControlEvents:UIControlEventTouchUpInside];
    [dialogView addSubview:dislikeBtn];
    
    dialogView.alpha = 1;
    
    ifLikeView.hidden = YES;
    [self.view addSubview:ifLikeView];

    dialogView.hidden = YES;
    [self.view addSubview:dialogView];
    
}


# pragma mark deviceTabelView
- (void)addDeviceListView
{
    deviceList = [[YunPlayer sharedPlayer]DMCRefresh];
    deviceListTableView = [[UITableView alloc]initWithFrame:CGRectMake(LDSCREEN_SIZE_HEIGHT - DEVICELIST_TABLEWIDTH - 20, LDSCREEN_SIZE_WIDTH - 80 - DEVICELIST_TABLEHEIGHT, DEVICELIST_TABLEWIDTH, DEVICELIST_TABLEHEIGHT) style:UITableViewStylePlain];
    deviceListTableView.backgroundColor = [CommonTools colorFromHexRGB:@"42b02e"];
    deviceListTableView.alpha = 0.95;
    deviceListTableView.backgroundView = nil;
    deviceListTableView.layer.cornerRadius = 5.0f;
    deviceListTableView.separatorStyle = NO;
    deviceListTableView.allowsSelection = NO;
    
    deviceListTableView.delegate = self;
    deviceListTableView.dataSource = self;
    deviceListTableView.hidden = YES;
    
    [self.view addSubview:deviceListTableView];
}


#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (anyAirPlayDevice && [deviceList count] != 0) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (tableView == deviceListTableView) {
        if (anyAirPlayDevice && [deviceList count] != 0) {
            if (section == 0) {
                number = 1;
            }else{
                number = [deviceList count];
                if (number > 3) {
                    tableView.scrollEnabled = YES;
                    [tableView setFrame:CGRectMake(LDSCREEN_SIZE_HEIGHT - DEVICELIST_TABLEWIDTH - 20*BTNRATIO, LDSCREEN_SIZE_WIDTH - 100*BTNRATIO - DEVICELIST_TABLEHEIGHT, DEVICELIST_TABLEWIDTH, DEVICELIST_TABLEHEIGHT)];
                }else{
                    tableView.scrollEnabled = NO;
                    [tableView setFrame:CGRectMake(LDSCREEN_SIZE_HEIGHT - DEVICELIST_TABLEWIDTH - 20*BTNRATIO, LDSCREEN_SIZE_WIDTH - 100*BTNRATIO - DEVICELIST_CELLHEIGHT*(number + 1), DEVICELIST_TABLEWIDTH, DEVICELIST_CELLHEIGHT*(number + 1))];
                }
            }
        }else if(anyAirPlayDevice && [deviceList count] == 0){
            number = 1;
            tableView.scrollEnabled = NO;
            [tableView setFrame:CGRectMake(LDSCREEN_SIZE_HEIGHT - DEVICELIST_TABLEWIDTH - 20*BTNRATIO, LDSCREEN_SIZE_WIDTH - 100*BTNRATIO - DEVICELIST_CELLHEIGHT, DEVICELIST_TABLEWIDTH, DEVICELIST_CELLHEIGHT)];
        }else if (anyAirPlayDevice == NO && [deviceList count] != 0){
            number = [deviceList count];
            if (number > 4) {
                tableView.scrollEnabled = YES;
                [tableView setFrame:CGRectMake(LDSCREEN_SIZE_HEIGHT - DEVICELIST_TABLEWIDTH - 20*BTNRATIO, LDSCREEN_SIZE_WIDTH - 100*BTNRATIO - DEVICELIST_CELLHEIGHT*4, DEVICELIST_TABLEWIDTH, DEVICELIST_CELLHEIGHT*4)];
            }else{
                tableView.scrollEnabled = NO;
                [tableView setFrame:CGRectMake(LDSCREEN_SIZE_HEIGHT - DEVICELIST_TABLEWIDTH - 20*BTNRATIO, LDSCREEN_SIZE_WIDTH - 100*BTNRATIO - DEVICELIST_CELLHEIGHT*number, DEVICELIST_TABLEWIDTH, DEVICELIST_CELLHEIGHT*number)];
            }
        }else{
            number = 1;
            tableView.scrollEnabled = NO;
            [tableView setFrame:CGRectMake(LDSCREEN_SIZE_HEIGHT - DEVICELIST_TABLEWIDTH - 20*BTNRATIO, LDSCREEN_SIZE_WIDTH - 100*BTNRATIO - DEVICELIST_CELLHEIGHT, DEVICELIST_TABLEWIDTH, DEVICELIST_CELLHEIGHT)];
        }
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == deviceListTableView) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [CommonTools colorFromHexRGB:@"42b02e"];
            cell.backgroundColor = [UIColor clearColor];
            cell.alpha = 0.9;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor clearColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.numberOfLines = 1;
            cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            
            
//            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//            cell.selectedBackgroundView.backgroundColor = [CommonTools  colorFromHexRGB:YELLOW_1];
        }
        
        if (anyAirPlayDevice && [deviceList count] != 0) {
            if (indexPath.section == 0) {
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                [self addAButtonToACell:cell withIndexPath:indexPath andButtonTitle:@"AirPlay"];
//                cell.textLabel.text = @"AirPlay";
                cell.userInteractionEnabled = YES;
                //                [cell addSubview:MPVolumeViewForAirPlay];
            }else{
                if ([deviceList count]){
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    [self addAButtonToACell:cell withIndexPath:indexPath andButtonTitle:[[deviceList objectAtIndex:(indexPath.row)]objectForKey:@"name"]];
//                    cell.textLabel.text = [[deviceList objectAtIndex:(indexPath.row)]objectForKey:@"name"];
                    cell.userInteractionEnabled = YES;
                    //                }else{
                    //                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    //                    cell.textLabel.text = @"没有搜索到DLNA设备";
                    //                    cell.userInteractionEnabled = NO;
                }
            }
        }else if(anyAirPlayDevice && [deviceList count] == 0){
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            [self addAButtonToACell:cell withIndexPath:indexPath andButtonTitle:@"AirPlay"];
//            cell.textLabel.text = @"AirPlay";
            cell.userInteractionEnabled = YES;
        }else if (anyAirPlayDevice == NO && [deviceList count] != 0){
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            [self addAButtonToACell:cell withIndexPath:indexPath andButtonTitle:[[deviceList objectAtIndex:(indexPath.row)]objectForKey:@"name"]];
//            cell.textLabel.text = [[deviceList objectAtIndex:(indexPath.row)]objectForKey:@"name"];
            cell.userInteractionEnabled = YES;
        }else if(anyAirPlayDevice == NO && deviceList.count == 0){
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            [self addAButtonToACell:cell withIndexPath:indexPath andButtonTitle:@"没有找到设备"];
//            cell.textLabel.text = @"没有搜索到设备";
            cell.userInteractionEnabled = NO;
        }else{
            
        }
        return cell;
    }
    return nil;
}

-(void)addAButtonToACell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath andButtonTitle:(NSString *)btnTitle
{
    UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cellBtn.frame = CGRectMake(8, 8, DEVICELIST_TABLEWIDTH - 8*2, DEVICELIST_CELLHEIGHT - 8*2);
    cellBtn.backgroundColor = [CommonTools colorFromHexRGB:@"42b02e"];
    cellBtn.layer.masksToBounds = YES;
    cellBtn.layer.cornerRadius = (iPad?22:10);
    cellBtn.tag = indexPath.section*10000 + indexPath.row;
    [cellBtn setBackgroundImage:[CommonTools imageFromColor:[CommonTools colorFromHexRGB:@"ff7900"] forButton:cellBtn] forState:UIControlStateHighlighted];
    [cellBtn addTarget:self action:@selector(cellSelect:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:cellBtn];
    cellBtn.titleLabel.font = [UIFont systemFontOfSize:21.0*BTNRATIO];
    [cellBtn setTitle:btnTitle forState:UIControlStateNormal];
}

-(void)cellSelect:(UIButton *)sender
{
    if (!AllowDmcPush) {
        return;
    }
    if (anyAirPlayDevice && [deviceList count] != 0) {
        if (sender.tag/10000 == 0) {
            deviceListTableView.hidden = YES;
            [self airPlayClicked];
        }else{
            if (controlTimer) {
                [controlTimer invalidate];
                controlTimer = nil;
            }
            [deviceListTableView setHidden:YES];
            
            NSString* uuid = [[deviceList objectAtIndex:sender.tag%10000]objectForKey:@"uuid"];
            
            [self pushActionWithUUid:uuid];
            
            [callBackInfoDic setObject:[[deviceList objectAtIndex:sender.tag%10000]objectForKey:@"name"] forKey:@"DMRName"];
            [callBackInfoDic setObject:self.videoName forKey:@"videoName"];
        }
    }else if(anyAirPlayDevice && [deviceList count] == 0){
        deviceListTableView.hidden = YES;
        [self airPlayClicked];
    }else if(anyAirPlayDevice == NO && [deviceList count] != 0){
        if (controlTimer) {
            [controlTimer invalidate];
            controlTimer = nil;
        }
        [deviceListTableView setHidden:YES];
        
        NSString* uuid = [[deviceList objectAtIndex:sender.tag%10000]objectForKey:@"uuid"];
        
        [self pushActionWithUUid:uuid];
        
        [callBackInfoDic setObject:[[deviceList objectAtIndex:sender.tag%10000]objectForKey:@"name"] forKey:@"DMRName"];
        [callBackInfoDic setObject:self.videoName forKey:@"videoName"];
    }else{
        
    }
}



//设置header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0){
        return 0;
    }
    return 0;
}
//设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == deviceListTableView) {
        return 60*BTNRATIO;
    }
    return 0;
}


#pragma mark DMC PUSH ACTION
-(void)pushActionWithUUid:(NSString*)uuid
{
    debugMethod();
    historyTime = [[YunPlayer sharedPlayer]getCurrentPosition];
    
    if ([[YunPlayer sharedPlayer] isPlaying]) {
        [[YunPlayer sharedPlayer] pause];
        localPlayStateWhilePush = YES;
    }else{
        localPlayStateWhilePush = NO;
    }
    
    if (processTimer) {
        [processTimer invalidate];
        processTimer = nil;
    }
    
    self.dmcPlayVC.url = self.playUrl;
    self.dmcPlayVC.videoName = self.videoName;
    self.dmcPlayVC.startTime = 0;
    
    [[YunPlayer sharedPlayer]DMCPush:uuid WithURL:self.playUrl];
    [[YunPlayer sharedPlayer]DMCGetVolume];
    
//    DMCViewController* dmcPlayVC = [[DMCViewController alloc]init];
//    dmcPlayVC.url = self.playUrl;
//    dmcPlayVC.videoName = self.videoName;
    
    
    [self.navigationController pushViewController:self.dmcPlayVC animated:NO];
}

#pragma mark StatusBar
-(void)showStatusBar
{
//    if (iOS7){
//        statusBarHidder = NO;
//        [self setNeedsStatusBarAppearanceUpdate];
//    }else{
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    }
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


#pragma mark YunPlayer的代理

-(BOOL)isAlertViewOn
{
    if (alert) {
        return YES;
    }
    return NO;
}

-(void)alertForSituation
{
//    if (self && self.view.hidden == NO && isPlay_FLAG != 2 && [YunPlayer sharedPlayer].delegate) {
//        if (alert == nil) {
//            alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"连接服务器失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            alert.tag = 100;
//            alert.delegate = self;
//            NSLog(@"smit----链接服务器失败");
//            [alert show];
//        }
//    }
    //    alertTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(alertForSituation) userInfo:nil repeats:NO];
}

-(void)performDelegateSelector:(NSString *)type
{
    if ([IVMallPlayer sharedIVMallPlayer].delegate && [[IVMallPlayer sharedIVMallPlayer].delegate respondsToSelector:@selector(PlayerCallBack:withParameter:)]){
        [[IVMallPlayer sharedIVMallPlayer].delegate PlayerCallBack:[type intValue] withParameter:callBackInfoDic];
    }
}

-(void)setCallBackInfoDic:(NSInteger)playbackEndType
{
    [callBackInfoDic setObject:[NSString stringWithFormat:@"%d",playbackEndType] forKey:@"playbackEndType"];
    [self setLastPlayTime:0];
}

-(void)howAboutThisVideo:(id)sender
{
    UIButton *aBtn = sender;
    if (aBtn.tag == 3698741) {
        if (ifLikeTimer) {
            [ifLikeTimer invalidate];
            ifLikeTimer = nil;
        }
        [[YunPlayer sharedPlayer]stop];
        [[YunPlayer sharedPlayer]removeYunPlayer];
        [self setCallBackInfoDic:1];
        [self performSelector:@selector(performDelegateSelector:) withObject:[NSString stringWithFormat:@"%d",PlayerWillPlaybackEnded] afterDelay:0.5];
        ifLikeView.hidden = YES;
        dialogView.hidden = YES;
    }else{
        [self invalideTimers];
        [self endPlayer];
        [self setCallBackInfoDic:2];
        [self performSelector:@selector(performDelegateSelector:) withObject:[NSString stringWithFormat:@"%d",PlayerWillPlaybackEnded] afterDelay:0.5];
    }
}

-(void)autoConnectionPlay
{
    [[YunPlayer sharedPlayer]stop];
    [[YunPlayer sharedPlayer]removeYunPlayer];
    [self setCallBackInfoDic:3];
    [self performSelector:@selector(performDelegateSelector:) withObject:[NSString stringWithFormat:@"%d",PlayerWillPlaybackEnded] afterDelay:0.1];
    ifLikeView.hidden = YES;
    dialogView.hidden = YES;
}


- (void)handlePlayerCallBackEvent:(NSInteger)eventType firstParameter:(NSInteger)parameter1
{
    if (eventType==YunPlayerPlaybackFinish) {
        NSLog(@"smit----YunPlayerPlaybackFinish_parameter1=%d",parameter1);
        if (parameter1==YunPlayerFinishReasonPlaybackEnded || parameter1 == YunPlayerFinishReasonUserExited) {
            if (manueExit == NO) {//if playback end
                if (self.connectionType == LastVideoOfEpisode || self.connectionType == VideoNotEpisode) {//video without next one, could not connectionPlay; exit player directly
                    [self invalideTimers];
                    [self endPlayer];
                    [self setCallBackInfoDic:4];
                    [self performSelector:@selector(performDelegateSelector:) withObject:[NSString stringWithFormat:@"%d",PlayerWillPlaybackEnded] afterDelay:0.5];
                }else{//user to evaluate this video and determine if autoplay next one in episode
                    [self TopBottomDisappearAnimation];
                    ifLikeView.hidden = NO;
                    dialogView.hidden = NO;
                    ifLikeTimer = [NSTimer scheduledTimerWithTimeInterval:8.0f target:self selector:@selector(autoConnectionPlay) userInfo:nil repeats:NO];
                }
            }else{//if manu exit player
                [self performSelector:@selector(performDelegateSelector:) withObject:[NSString stringWithFormat:@"%d",PlayerUserExited] afterDelay:0.5];
            }
        }else if (parameter1==YunPlayerinishReasonPlaybackError){
            if (alertTimer){
                [alertTimer invalidate];
                alertTimer = nil;
            }
            alertTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(alertForSituation) userInfo:nil repeats:NO];
        }
    }else if (eventType==YunPlayerLoadStateDidChange) {
        switch (parameter1) {
            case YunPlayerLoadStateStalled:
                loadingView.hidden = NO;
                break;
            case YunPlayerLoadStatePlaythroughOK:
                loadingView.hidden = YES;
                break;
            default:
                break;
        }
    }else if (eventType==YunPlayerPlaybackStateDidChange) {
        NSLog(@"parameter1 =%d",(int)parameter1);
        switch (parameter1) {
            case YunPlayerPlaybackStateStopped:
//                isPlay_FLAG = 1;
                break;
            case YunPlayerPlaybackStatePlaying:
                [playAndPauseButton setImage:[UIImage imageNamed:@"pause@2x"] forState:UIControlStateNormal];
                [playAndPauseButton setImage:[UIImage imageNamed:@"pause_sel@2x"] forState:UIControlStateHighlighted];
                AllowDmcPush = YES;
//                isPlay_FLAG = 2;
                break;
            case YunPlayerPlaybackStatePaused:
                [playAndPauseButton setImage:[UIImage imageNamed:@"play@2x"] forState:UIControlStateNormal];
                [playAndPauseButton setImage:[UIImage imageNamed:@"play_sel@2x"] forState:UIControlStateHighlighted];
//                isPlay_FLAG = 3;
                break;
            case YunPlayerPlaybackStateInterrupted:
//                isPlay_FLAG = 4;
                break;
            case YunPlayerPlaybackStateSeekingForward:
            case YunPlayerPlaybackStateSeekingBackward:
//                isPlay_FLAG = 5;
                //                processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(process) userInfo:nil repeats:NO];
                break;
            default:
//                isPlay_FLAG = 6;
                break;
        }
    }else if (eventType==YunPlayerNetWorkStatusDidChange) {
        switch (parameter1) {
            case NetworkNotReachable:
                //网络未连接
            {
                if (alert == nil) {
                    if (alertTimer){
                        [alertTimer invalidate];
                        alertTimer = nil;
                    }
                    alert = [[UIAlertView alloc]initWithTitle:@"网络连接状况" message:@"当前网络不可用\n请检查网络！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag=101;
                    alert.delegate=self;
                    [alert show];
                }
            }
                break;
            case NetworkReachableViaWWAN:
            {
                //网络通过3g连接
                
                if (alert == nil) {
                    if (alertTimer){
                        [alertTimer invalidate];
                        alertTimer = nil;
                    }
                    alert = [[UIAlertView alloc]initWithTitle:@"网络连接状况" message:@"当前是2G/3G网络环境\n继续观看会产生超额流量费用！" delegate:self cancelButtonTitle:@"取消观看" otherButtonTitles:@"继续观看", nil];
                    alert.tag=102;
                    alert.delegate=self;
                    [alert show];
                }
            }
                break;
            default:
                break;
        }
    }else if(eventType==YunPlayerReadyForDisplay){
        [[YunPlayer sharedPlayer]setScreenOnWhilePlaying:NO];
    }
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
#pragma mark  UIAlertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100 || alertView.tag == 102) {
        if (buttonIndex==0) {
            [self topReturnButtonTouched];
        }else{
            [[YunPlayer sharedPlayer]start];
            alert = nil;
            return;
        }
    }else if (alertView.tag==101){
        if (buttonIndex==0) {
            [[YunPlayer sharedPlayer]start];
            alert = nil;
            return;
        }else{
            [self topReturnButtonTouched];
        }
    }
    alert = nil;
    return;
}

-(void)willPresentAlertView:(UIAlertView *)alertView
{
    if (alertView.tag == 102 || alert.tag == 101) {
        [[YunPlayer sharedPlayer]pause];
    }
}


#pragma mark hide top and bottom
-(void)TopBottomAppearAnimation//显示状态栏、标题栏和控制条，对标题栏使用动画
{
    //    if (iOS7)
    //    {
    //        statusBarHidder = NO;
    //        [self setNeedsStatusBarAppearanceUpdate];
    //    }else
    //    {
    //        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //    }
    [self showStatusBar];
    [UIView beginAnimations:@"TopBottomAppearAnimation" context:nil];
    /* 5 seconds animation */
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    /* End at the bottom right corner */
    [topView setHidden:NO];
    [bottomView setHidden:NO];
    
    [UIView commitAnimations];
}

-(void)TopBottomDisappearAnimation//隐藏状态栏、标题栏和控制条，对标题栏使用动画
{
    //    if (iOS7)
    //    {
    //        statusBarHidder = YES;
    //        [self setNeedsStatusBarAppearanceUpdate];
    //    }else
    //    {
    //        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    //    }
    [self hideStatusBar];
    [UIView beginAnimations:@"TopBottomDisappearAnimation" context:nil];
    /* 5 seconds animation */
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [deviceListTableView setHidden:YES];
    [topView setHidden:YES];
    [bottomView setHidden:YES];
    //    [definitionView setHidden:YES];
    [UIView commitAnimations];
}


#pragma mark--监听
-(void)installNotificationObservers
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bottomDragUpControlCenterUp) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bottomDragUpControlCenterDown) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(replay) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
-(void)unInstallNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];

}
-(void)replay
{
    if (self.navigationController.visibleViewController == self) {
        if (centreView.hidden) {
            [[YunPlayer sharedPlayer]start];
        }else{
            [[YunPlayer sharedPlayer]pause];
        }
    }
}
-(void)enterBackground
{
    
}

-(void)bottomDragUpControlCenterUp
{
    debugMethod();
    if (ifLikeTimer) {
        [ifLikeTimer invalidate];
        ifLikeTimer = nil;
    }
    
}
-(void)bottomDragUpControlCenterDown
{
    NSLog(@"smit----bottomDragUpControlCenterDown and play");
    if (alert) {
        [[YunPlayer sharedPlayer]pause];
        NSLog(@"smit----bottomDragUpControlCenterDown and pause");
    }
    if (ifLikeView) {
        if (!ifLikeView.hidden) {
            [[YunPlayer sharedPlayer]stop];
        }
    }
}


#pragma mark last Play time
-(void)setLastPlayTime:(NSTimeInterval)time
{
    [callBackInfoDic setValue:[NSString stringWithFormat:@"%d",(int)time] forKey:@"time"];
}

-(NSTimeInterval)getLastPlayTimeWithURLString:(NSString*)urlString
{
    if (urlString != nil) {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString* mobile = [userDefaults objectForKey:@"mobile"];
        NSString* keyString = [NSString stringWithFormat:@"%@%@",mobile,urlString];
        NSTimeInterval lastPlayTime = [userDefaults doubleForKey:keyString];
        return lastPlayTime;
    }else {
        return 0;
    }
}

#pragma mark -- airPlay

-(void)checkAirPlayShow
{
    airPlayButton.hidden = (![self isShowAirPlay]);
    airPlayButton.hidden = YES;
}

-(void)airPlayClicked
{
    airPlayDeviceListOn = !airPlayDeviceListOn;
    if (mpButton) {
        [mpButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)checkAirPlay
{
    MPVolumeViewForAirPlay = [[MPVolumeView alloc]init];
    MPVolumeViewForAirPlay.showsRouteButton = YES;//
    MPVolumeViewForAirPlay.showsVolumeSlider = NO;
    MPVolumeViewForAirPlay.frame = CGRectMake(LDSCREEN_SIZE_HEIGHT + 6, LDSCREEN_SIZE_WIDTH/2.0, 42, 42);
    [self.view addSubview:MPVolumeViewForAirPlay];
    //    [MPVolumeViewForAirPlay setRouteButtonImage:[IVMallTools nSBundleSetImage:@""] forState:UIControlStateNormal];
    
    for (UIView *item in MPVolumeViewForAirPlay.subviews) {
        if (![item isKindOfClass:NSClassFromString(@"MPButton")]) {
            [item removeFromSuperview];
        }else{
            mpButton = (UIButton *)item;
        }
    }
    
    anyAirPlayDevice = NO;
}

-(BOOL)isShowAirPlay
{
    BOOL ret = NO;
    if (mpButton) {
        ret = mpButton.alpha;
    }
    return  ret;
}

-(void)backToDMC
{
    [[YunPlayer sharedPlayer]DMCFromAPP];
}

-(void)connectionPlayWithUrl:(NSString *)url withConnectionPlayProType:(connectionPlayProType)connectionType andVideoName:(NSString *)videoName
{
    [[YunPlayer sharedPlayer]setDisplayOnView:self];
    [[YunPlayer sharedPlayer]setDataSource:url];
    titleLabel.text = videoName;
    self.connectionType = connectionType;
    [[YunPlayer sharedPlayer]setInitialPlaybackTime:0];
    [[YunPlayer sharedPlayer]start];
    
    [self.view bringSubviewToFront:bottomView];
    [self.view bringSubviewToFront:topView];
    [self.view bringSubviewToFront:loadingView];
    [self.view bringSubviewToFront:centreView];
    [self.view bringSubviewToFront:deviceListTableView];
    [self.view bringSubviewToFront:seekView];
    [self.view bringSubviewToFront:ifLikeView];
    [self.view bringSubviewToFront:dialogView];
    [self.view bringSubviewToFront:alert];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
