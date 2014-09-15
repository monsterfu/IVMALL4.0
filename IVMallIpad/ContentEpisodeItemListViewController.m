//
//  ContentEpisodeItemListViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ContentEpisodeItemListViewController.h"
#import "MBProgressHUD.h"
#import "Macro.h"
#import "Commonality.h"
#import "HttpRequest.h"
#import "AppDelegate.h"
#import "ContentEpisodeItemListModel.h"
#import "UIImageView+WebCache.h"
#import "UserLoginViewController.h"
#import "UserPreferenceModel.h"
#import "ProductPlayModel.h"
#import "IVMallPlayer.h"
#import "PurchaseAndRechargeManagerController.h"
#import "AnonymousLoginMode.h"
#import "AppTipsModel.h"
#import "EpisodeDescriptionViewController.h"
#import "UserRegisterViewController.h"
@interface ContentEpisodeItemListViewController ()
{
    NSArray* langsArray;
    MBProgressHUD* myMBProgressHUD;
    NotWiFiView* myNotWiFiView;
    NotWiFiView* downNotWiFiView;
    
    ContentEpisodeItemListModel* myContentEpisodeItemListModel;
    
    int totalPage;
    UIButton* selectedButton;
    BOOL isCollected;
    BOOL isExpanded;
    int favoriteCount;
    
    int currentPlayIndex;
    int historyPlayTime;
    int startTime;
    
    NSString* videoName;
    NSString* contentGuid;
    NSString* playURL;
    NSString* currentLang;
    BOOL firstShow;
    
    connectionPlayProType myconnectionPlayProType;
    
    
    UIView* giftView;
}

@end

@implementation ContentEpisodeItemListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"1236**************begin*******");
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afterLogin:) name:NSNotificationCenterAfterLoginInSuccess object:nil];
    }
    return self;
}

- (void)afterLogin:(NSNotification*)notification
{
    NSLog(@"1236*********************");
    ActionState temp = [[notification object]integerValue];
    if (temp == PlayVideo && contentGuid!=nil)
    {
        [HttpRequest ProductPlayRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}
- (void)playBefoerLoginVideo
{
    [HttpRequest ProductPlayRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

-(void)dealloc
{
    NSLog(@"1236********end*************");
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterAfterLoginInSuccess object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self showlangsButton];
    myMBProgressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    myMBProgressHUD.labelText = @"正在获取数据";
    [self.view addSubview:myMBProgressHUD];
    
    myNotWiFiView = [[NotWiFiView alloc]init];
    [myNotWiFiView setNotWiFiStyle:DialogNotWiFi];
    myNotWiFiView.delegate = self;
    [_scrollView addSubview:myNotWiFiView];
    [myNotWiFiView setHidden:YES];
    
    
    downNotWiFiView = [[NotWiFiView alloc]init];
    [downNotWiFiView setNotWiFiStyle:AreaNotWiFi];
    downNotWiFiView.delegate = self;
    [_downView addSubview:downNotWiFiView];
    [downNotWiFiView setHidden:YES];
    
    UINib *nib;
    if (iPad) {
        nib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    }else{
        nib = [UINib nibWithNibName:@"CollectionViewCellForiPhone" bundle:nil];
    }
    
    [_contentCollectionView registerNib:nib forCellWithReuseIdentifier:@"GradientCell"];
    _contentCollectionView.backgroundColor = [UIColor clearColor];
     _scrollView.backgroundColor = [Commonality colorFromHexRGB:@"f1ffe5"];
    [myMBProgressHUD show:YES];
    
    if (_latestPlayLang == nil) {
        currentLang = @"zh-cn";
        [_langButton1 setSelected:YES];
        [_langButton2 setSelected:NO];
    }else{
        if ([_latestPlayLang isEqualToString:@"en-gb"]) {
            currentLang = _latestPlayLang;
            [_langButton1 setSelected:NO];
            [_langButton2 setSelected:YES];
        }else{
            currentLang = @"zh-cn";
            [_langButton1 setSelected:YES];
            [_langButton2 setSelected:NO];
        }
    }
    
    [HttpRequest ContentEpisodeItemListRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:_episodeGuid lang:@"zh-cn" delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    
    if ([AppDelegate App].myUserLoginMode.token) {
        NSString* preferenceKey = [NSString stringWithFormat:@"episode.%@.%@",_episodeGuid,currentLang];
        [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myUserLoginMode.token preferenceKey: preferenceKey preferenceValue:nil delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
        
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!iPad) {
        _exitButton.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
     [self.view bringSubviewToFront:_exitButton];
    if ([self.navigationController childViewControllers].count >2) {
        [_exitButton setBackgroundImage:[UIImage imageNamed:@"icon_07-18.png"] forState:UIControlStateNormal];
        [_exitButton setBackgroundImage:[UIImage imageNamed:@"icon_07-19.png"] forState:UIControlStateHighlighted];
    }else{
        [_exitButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [_exitButton setBackgroundImage:[UIImage imageNamed:@"close_sel.png"] forState:UIControlStateHighlighted];
    }
}

- (void)refresh
{
    [myMBProgressHUD show:YES];
    _scrollView.backgroundColor = [Commonality colorFromHexRGB:@"f1ffe5"];
    
    if ([AppDelegate App].myUserLoginMode.token) {
        NSString* preferenceKey = [NSString stringWithFormat:@"episode.%@.%@",_episodeGuid,currentLang];
        [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myUserLoginMode.token preferenceKey: preferenceKey preferenceValue:nil delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }

    [HttpRequest ContentEpisodeItemListRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:_episodeGuid lang:currentLang delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];


}

-(void) GetErr:(ASIHTTPRequest *)request
{
    if (request.tag == CONTENT_EPISODEITEMLIST_TYPE || request.tag-1 ==CONTENT_EPISODEITEMLIST_TYPE ) {
        [myMBProgressHUD hide:YES];
        [myNotWiFiView setHidden:NO];
        _scrollView.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];

    }else if(request.tag == USER_PREFERENCE_GET_TYPE || request.tag == PRODUCT_PLAY_TYPE || request.tag == APP_TIPS_TYPE || request.tag == ANONYMOUS_LOGIN_TYPE)
    {
        [myMBProgressHUD hide:YES];
        self.view.userInteractionEnabled = YES;
    }
}

-(void) GetResult:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary   *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (dictionary==nil)
    {
        if (request.tag == CONTENT_EPISODEITEMLIST_TYPE || request.tag-1 ==CONTENT_EPISODEITEMLIST_TYPE) {
            [myMBProgressHUD hide:YES];
            [myNotWiFiView setHidden:NO];
            _scrollView.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];

        }else if(request.tag == USER_PREFERENCE_GET_TYPE || request.tag == PRODUCT_PLAY_TYPE || request.tag == APP_TIPS_TYPE || request.tag == ANONYMOUS_LOGIN_TYPE)
        {
            [myMBProgressHUD hide:YES];
            self.view.userInteractionEnabled = YES;
        }
    }else{
        
        if (request.tag == CONTENT_EPISODEITEMLIST_TYPE  || request.tag - 1 == CONTENT_EPISODEITEMLIST_TYPE) {
            
            myContentEpisodeItemListModel = [[ContentEpisodeItemListModel alloc]initWithDictionary:dictionary];
            if (myContentEpisodeItemListModel.errorCode == 0) {
                [self refreshAllView];
                if (request.tag == CONTENT_EPISODEITEMLIST_TYPE  &&  [currentLang isEqualToString:@"en-gb"]) {
                    [HttpRequest ContentEpisodeItemListRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:_episodeGuid lang:currentLang delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                }else{
                    [myMBProgressHUD hide:YES];
                }
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:myContentEpisodeItemListModel.errorMessage];
                [myMBProgressHUD hide:YES];
            }
        }
        else if(request.tag == USER_PREFERENCE_GET_TYPE)
        {
            UserPreferenceModel* myUserPrefernceModel = [[UserPreferenceModel alloc]initWithDictionary:dictionary];
            if (myUserPrefernceModel.errorCode == 0) {
                if ([myUserPrefernceModel.preferenceKey hasPrefix:@"episode"]) {
                    [self showPlayRecordWithValue:myUserPrefernceModel.preferenceValue];
                }

            }
        }
        else if (request.tag == APP_TIPS_TYPE){
            [myMBProgressHUD hide:YES];
            AppTipsModel* temp = [[AppTipsModel alloc]initWithDictionary:dictionary];
            if (temp.errorCode == 0) {
                NSDate* vipExpiryTime = [Commonality dateFromString:temp.vipExpiryTime];
                NSDate* currentTime = [Commonality dateFromString:temp.currentTime];
                if ([vipExpiryTime earlierDate:currentTime] == currentTime) {
                    NSString* copyright=[[NSUserDefaults standardUserDefaults] objectForKey:@"copyright_Ivmall"];
                    if (copyright && [copyright isEqualToString:@"true"] ) {
                        if (giftView == nil) {
                            if (iPad) {
                                giftView = [[[NSBundle mainBundle] loadNibNamed:@"GiftViewForiPad" owner:self options:nil]objectAtIndex:0];
                            }else{
                            
                                giftView = [[[NSBundle mainBundle] loadNibNamed:@"GiftViewForiPhone" owner:self options:nil]objectAtIndex:0];
                            }
                            [self.view addSubview:giftView];
                            giftView.frame = CGRectMake(0, 0, 1024, 768);
                            
                            UIButton* button1 = (UIButton*)[giftView viewWithTag:102];
                            button1.exclusiveTouch = YES;
                            [button1 addTarget:self action:@selector(getThePackage:) forControlEvents:UIControlEventTouchUpInside];
                            UIButton* button2 = (UIButton*)[giftView viewWithTag:103];
                            button2.exclusiveTouch = YES;
                            [button2 addTarget:self action:@selector(anonymousPlay) forControlEvents:UIControlEventTouchUpInside];
                        }
                        
                        UILabel* label1 = (UILabel*)[giftView viewWithTag:100];
                        label1.text = [NSString stringWithFormat:@"免注册可观看到 %@",[Commonality Date2Str3:vipExpiryTime]];
                        UILabel* label2 = (UILabel*)[giftView viewWithTag:101];
                        label2.text = temp.anonymousTips;
                        [giftView setHidden:NO];
                        self.view.userInteractionEnabled = YES;
                        
                    }else{
                        [self anonymousPlay];
                    }
                }else{
                    [self enterLoginView:PlayVideo];
                }
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:temp.errorMessage];
                self.view.userInteractionEnabled = YES;
            }
        }
        else if(request.tag == ANONYMOUS_LOGIN_TYPE){
            [AppDelegate App].myAnonymousLoginMode = [[AnonymousLoginMode alloc]initWithDictionary:dictionary];
            if ([AppDelegate App].myAnonymousLoginMode.errorCode == 0) {
                [HttpRequest AppTipsRequestRequestToken:[AppDelegate App].myAnonymousLoginMode.token key:nil delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                [HttpRequest DevicesBindRequestToken:[AppDelegate App].myAnonymousLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];

            }else{
                [myMBProgressHUD hide:YES];
                [self enterLoginView:PlayVideo];
                self.view.userInteractionEnabled = YES;
                NSLog(@"1237*********************");
            }
        }else if (request.tag == FAVORITE_DELBYGUID_TYPE || request.tag == FAVORITE_ADD_TYPE)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterContentCollectAction object:nil];
        }
        else if(request.tag == PRODUCT_PLAY_TYPE)
        {
            NSLog(@"1238**********************");
            [myMBProgressHUD hide:YES];
            ProductPlayModel* myProductPlayMode = [[ProductPlayModel alloc]initWithDictionary:dictionary];
            if (myProductPlayMode.errorCode == 0) {
                playURL = nil;
                if ([Commonality isEmpty:myProductPlayMode.URI] && [Commonality isEmpty:myProductPlayMode.catchupURI ]) {
                    [Commonality showErrorMsg:self.view type:0 msg:@"该视频不存在!"];
                    self.view.userInteractionEnabled = YES;
                    return;
                }else{
                    if ([Commonality isEmpty:myProductPlayMode.URI]) {
                        playURL = myProductPlayMode.catchupURI;
                    }else {
                        playURL = myProductPlayMode.URI;
                    }
                    
                    [IVMallPlayer sharedIVMallPlayer].delegate = self;
                    [self setPlayUrlTheRangOfCategory];
                    if (self.presentedViewController == nil) {
                        [[AppDelegate App] play];
                        [[IVMallPlayer sharedIVMallPlayer]IVMallPlayerStart:playURL withVideoName:videoName withConnectionPlayProType:myconnectionPlayProType fromViewController:self startTime:startTime];
                    }else{
                        
                        [[IVMallPlayer sharedIVMallPlayer]IVMallPlayerSetUrl:playURL withConnectionPlayProType:myconnectionPlayProType andVideoName:videoName];
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterPlayVideo object:nil];
                    self.view.userInteractionEnabled = YES;
                }
            }else{
                if ([AppDelegate App].myUserLoginMode.token) {
                    self.view.userInteractionEnabled = YES;
                    if (myProductPlayMode.errorCode == 204 || myProductPlayMode.errorCode == 224) {
                        NSString* copyright=[[NSUserDefaults standardUserDefaults] objectForKey:@"copyright_Ivmall"];
                        if (copyright && [copyright isEqualToString:@"true"] ) {
                            UIAlertView*   alet=[[UIAlertView alloc]initWithTitle:@"会员权限未开通或已过期，请先开通会员！" message:nil delegate:self cancelButtonTitle:@"稍后开通" otherButtonTitles:@"立即开通", nil];
                            alet.tag=110;
                            [alet show];
                        }
                        return;
                    }else{
                        [Commonality showErrorMsg:self.view type:0 msg:myProductPlayMode.errorMessage];
                    }
                }else{
                    if (myProductPlayMode.errorCode == 204 || myProductPlayMode.errorCode == 224) {
//                        NSString* copyright=[[NSUserDefaults standardUserDefaults] objectForKey:@"copyright_Ivmall"];
//                        if (copyright && [copyright isEqualToString:@"true"] ) {
//                            [Commonality showTipsMsgWithView:self.view duration:3.0 msg:@"您的免注册观看已到期" image:[UIImage  imageNamed: @"libao_bg.png"]];
//                            
//                        }
                        
                    }else{
                        [Commonality showErrorMsg:self.view type:0 msg:myProductPlayMode.errorMessage];
                    }
                    [self performSelector:@selector(enterLoginView:) withObject:PlayVideo afterDelay:3.0];

                }

            }

        }
       
    }
}

- (void)getThePackage:(UIButton*)button
{
    [giftView setHidden:YES];
    UserRegisterViewController* myUserRegisterViewController = [[UserRegisterViewController alloc]init];
    myUserRegisterViewController.isFromLoginView = NO;
    [self.navigationController pushViewController:myUserRegisterViewController animated:NO];
}

- (void)setPlayUrlTheRangOfCategory
{
    if (myContentEpisodeItemListModel.list.count == 1) {
        myconnectionPlayProType = VideoNotEpisode;
    }else{
        if (currentPlayIndex == myContentEpisodeItemListModel.list.count-1) {
            myconnectionPlayProType = LastVideoOfEpisode;
            return;
        }else if(currentPlayIndex == 0){
            myconnectionPlayProType = FirstVideoOfEpisode;
            return;
        }else{
            myconnectionPlayProType = MiddleVideoOfEpisode;
        }
    }
}

-(void)PlayerCallBack:(PlayerCallBackEventType)callBackEventType withParameter: (NSMutableDictionary *)callBackInfo
{
    if (callBackEventType == PlayerWillPlaybackEnded) {
        int playEndReson = [[callBackInfo objectForKey:@"playbackEndType"]intValue];
        if (playEndReson == 2 || playEndReson == 4) {

        }else {
            if (currentPlayIndex < myContentEpisodeItemListModel.list.count-1) {
                currentPlayIndex++;
                if (currentPlayIndex>=0 && currentPlayIndex <myContentEpisodeItemListModel.list.count) {
                    ContentItem* tempContentItem = [myContentEpisodeItemListModel.list objectAtIndex:currentPlayIndex];
                    videoName = tempContentItem.contentTitle;
                    contentGuid = tempContentItem.contentGuid;
                    startTime = 0;
                    if ([AppDelegate App].myUserLoginMode.token) {
                        [HttpRequest ProductPlayRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                    }else{
                        [HttpRequest ProductPlayRequestToken:[AppDelegate App].myAnonymousLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                    }

                }
            }
        }
    
        NSString* preferenceKey = [NSString stringWithFormat:@"episode.%@.%@",_episodeGuid,currentLang];
        NSString* preferenceValue = [NSString stringWithFormat:@"%d.%d",currentPlayIndex+1,startTime];
        [self showPlayRecordWithValue:preferenceValue];
         if ([AppDelegate App].myUserLoginMode.token) {
            [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myUserLoginMode.token preferenceKey:preferenceKey preferenceValue:preferenceValue delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
         }else{
             [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myAnonymousLoginMode.token preferenceKey:preferenceKey preferenceValue:preferenceValue delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
         }
    }else if(callBackEventType == PlayerUserExited){
        NSLog(@"callBackInfo=%@",callBackInfo);
        int playTime = [[callBackInfo objectForKey:@"time"]intValue];
        NSString* preferenceKey = [NSString stringWithFormat:@"episode.%@.%@",_episodeGuid,currentLang];
        NSString* preferenceValue = [NSString stringWithFormat:@"%d.%d",currentPlayIndex+1,playTime];
        [self showPlayRecordWithValue:preferenceValue];
        if ([AppDelegate App].myUserLoginMode.token) {
            [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myUserLoginMode.token preferenceKey:preferenceKey preferenceValue:preferenceValue delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        }else{
            [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myAnonymousLoginMode.token preferenceKey:preferenceKey preferenceValue:preferenceValue delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        }
    }else if(callBackEventType == PlayerWillReturnFromDMRPlay)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterExitFromDMC object:@"YES"];
        return;
    }
     [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterExitFromDMC object:@"NO"];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[AppDelegate App]click];
    if (alertView.tag==110) {
        if (buttonIndex==1) {
            //进入购买页面
            
            PurchaseCompletionHandler myCallBack = ^{
                [self playBefoerLoginVideo];
            };
            PurchaseAndRechargeManagerController* purchaseController = [[PurchaseAndRechargeManagerController alloc]initWithNibName:nil bundle:nil mode:ProcessModeEnum_Purchase completionHandler:myCallBack];
            
            PopUpViewController* popUpViewController = [[PopUpViewController shareInstance]initWithNibName:@"PopUpViewController" bundle:nil];
            
            [popUpViewController popViewController:purchaseController fromViewController:self finishViewController:nil blur:YES];
        }
    }
}

-(void)showPlayRecordWithValue:(NSString*)history
{
    NSArray* list = [history componentsSeparatedByString:@"."];
    if (list && list.count>=2) {
        currentPlayIndex = [[list objectAtIndex:0]intValue]-1;
        historyPlayTime = [[list objectAtIndex:1]intValue];
        NSString* timeText = [NSString stringWithFormat:@"上次观看至第%d集%@",currentPlayIndex+1,[self timeToString:historyPlayTime]];
        _tipsLabel.text=timeText;
        
//        [_playButton setTitle:[NSString stringWithFormat:@"第%d集",currentPlayIndex+1] forState:UIControlStateNormal];
        [_playButton setTitle:@"继续播放" forState:UIControlStateNormal];
        _tipsLabel.hidden = NO;
        _tipsView.hidden = NO;
    }else{
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        _tipsLabel.hidden = YES;
        _tipsView.hidden = YES;
    }
    
}

- (NSString*)timeToString:(NSTimeInterval)time
{
    int curTime = time;
//    int curhours = curTime/(60*60);
    int curmin = (curTime)/60;//小时取余再除60秒
    int cursec = curTime%60;
//    NSString *curStr = [NSString stringWithFormat:@"%d时%d分%d秒",curhours,curmin,cursec];
    NSString *curStr = [NSString stringWithFormat:@"%d分%d秒",curmin,cursec];
    
    return curStr;
}

- (void)refreshAllView
{
    isExpanded = NO;
    _titleLabel.text = myContentEpisodeItemListModel.episodeTitle;
    _textView.text = myContentEpisodeItemListModel.episodeDescription;
    _textView.font = [UIFont systemFontOfSize:(iPad?18:12)];
    _headBgView.clipsToBounds = YES;
    _headBgView.layer.masksToBounds = YES;
    if (iPad) {
        _headBgView.layer.cornerRadius = 24;
        _headBgView.layer.borderWidth = 3;
        _headImage.layer.cornerRadius = 18;
    }else{
        _headBgView.layer.cornerRadius = 12;
        _headBgView.layer.borderWidth = 1.5;
        _headImage.layer.cornerRadius = 9;
    }

    _headBgView.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
    _headImage.layer.masksToBounds = YES;
    if ([currentLang isEqualToString:@"zh-cn"] || !firstShow) {
        firstShow = YES;
        [_headImage setImageWithURL:[NSURL URLWithString:myContentEpisodeItemListModel.episodeImg] placeholderImage:[UIImage imageNamed:@"240_320.png"]];
        _playCountLabel.text = [NSString stringWithFormat:@"%d次",myContentEpisodeItemListModel.playCount];
        _collectionCountLabel.text = [NSString stringWithFormat:@"%d次",myContentEpisodeItemListModel.favoriteCount];
        
        favoriteCount = myContentEpisodeItemListModel.favoriteCount;
        if (myContentEpisodeItemListModel.isCollect == 1) {
            isCollected = YES;
        }else{
            isCollected = NO;
        }
        [self setCollectedButton:isCollected];
    }
    
    [self refreshDownView];
}

-(void)setCollectedButton:(BOOL)collected
{
    if (isCollected) {
        [_collectionButton setBackgroundImage:[UIImage imageNamed:@"button_b33.png"] forState:UIControlStateNormal];
        [_collectionButton setBackgroundImage:[UIImage imageNamed:@"button_b11.png"] forState:UIControlStateHighlighted];
    }else
    {
        [_collectionButton setBackgroundImage:[UIImage imageNamed:@"button_b3.png"] forState:UIControlStateNormal];
        [_collectionButton setBackgroundImage:[UIImage imageNamed:@"button_b1.png"] forState:UIControlStateHighlighted];
    }
}

- (void)refreshDownView
{
    [_upView setHidden:NO];
    [_downView setHidden:NO];
    if (myContentEpisodeItemListModel.list.count % 12 == 0) {
        totalPage = myContentEpisodeItemListModel.list.count/12;
    }else{
        totalPage = myContentEpisodeItemListModel.list.count/12 + 1;
    }
    if (_eposideScrollerView) {
        [_eposideScrollerView removeFromSuperview];
        _eposideScrollerView = nil;
    }
    _eposideScrollerView = [[UIScrollView alloc]init];
    if (iPad) {
        _eposideScrollerView.frame = CGRectMake(50, 5, 660, 30);
    }else{
        _eposideScrollerView.frame = CGRectMake(25, 0, 340, 30);
    }
    [_eposideScrollerView setHidden:NO];
    _eposideScrollerView.delegate = self;
    _eposideScrollerView.showsHorizontalScrollIndicator = NO;
    _eposideScrollerView.showsVerticalScrollIndicator = NO;
    _eposideScrollerView.scrollsToTop = NO;
    [_downView addSubview:_eposideScrollerView];
    UIButton *but = nil;
    for (int i=0; i<totalPage; i++) {

        NSString* tempString = [NSString stringWithFormat:@"%d-%d集",i*12+1,MIN((i+1)*12, myContentEpisodeItemListModel.list.count)];
        UIButton* tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (iPad) {
            tempButton.frame = CGRectMake(i*80, 0, 80, 30);
            tempButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        }else{
            tempButton.frame = CGRectMake(i*60, 0, 60, 30);
            tempButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        }
        
        
        tempButton.backgroundColor = [UIColor clearColor];
        tempButton.exclusiveTouch = YES;
        
        tempButton.tag = 1000+i;
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempButton setTitle:tempString forState:UIControlStateNormal];
        [tempButton addTarget:self action:@selector(sortChange:) forControlEvents:UIControlEventTouchUpInside];
        [_eposideScrollerView addSubview:tempButton];
        if (but == nil) {
            but = tempButton;
        }
        
        if (i == 0) {
            selectedButton = tempButton;
            CGSize size = [tempButton.titleLabel.text sizeWithFont:tempButton.titleLabel.font constrainedToSize:CGSizeMake(tempButton.titleLabel.frame.size.width ,MAXFLOAT)];
            tempButton.frame = CGRectMake(0,0, size.width+(iPad?30:20), (iPad?30:30));
        }else{
            CGSize size = [tempButton.titleLabel.text sizeWithFont:tempButton.titleLabel.font constrainedToSize:CGSizeMake(tempButton.titleLabel.frame.size.width ,MAXFLOAT)];
            tempButton.frame = CGRectMake(but.frame.origin.x+but.frame.size.width, 0, size.width+(iPad?30:20), (iPad?30:30));
            but = tempButton;
        }

    }
    if (iPad) {
        [_eposideScrollerView setContentSize:CGSizeMake(but.frame.origin.x+but.frame.size.width+100, 30)];
    }else{
        [_eposideScrollerView setContentSize:CGSizeMake(but.frame.origin.x+but.frame.size.width+100, 30)];
    }
    
    [selectedButton setTitleColor:[Commonality colorFromHexRGB:@"3f8f38"] forState:UIControlStateNormal];
    [_contentCollectionView reloadData];
}

- (void)sortChange:(UIButton*)button
{
    if (selectedButton.tag != button.tag) {
        [[AppDelegate App]click];
        [selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        selectedButton = button;
        [selectedButton setTitleColor:[Commonality colorFromHexRGB:@"3f8f38"] forState:UIControlStateNormal];
        [_contentCollectionView reloadData];
    }
}

- (void)showlangsButton
{
    if (_langs == nil) {
        langsArray = nil;
        [_langButton1 setTitle:@"剧集" forState:UIControlStateNormal];
        [_langButton2 setHidden:YES];
    }else{
        langsArray = [_langs componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        if ([langsArray count] == 2) {
            [_langButton1 setTitle:@"中文剧集" forState:UIControlStateNormal];
            [_langButton2 setTitle:@"英文剧集" forState:UIControlStateNormal];
        }else{
            [_langButton1 setTitle:@"剧集" forState:UIControlStateNormal];
            [_langButton2 setHidden:YES];
        }
    }
    [_langButton1 addTarget:self action:@selector(juji:) forControlEvents:UIControlEventTouchUpInside];
    [_langButton2 addTarget:self action:@selector(juji:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)juji:(UIButton*)sender
{

    if (sender == _langButton1) {
        if (!_langButton1.isSelected) {
            
            [[AppDelegate App]click];
            [_langButton1 setSelected:YES];
            [_langButton2 setSelected:NO];
            [myMBProgressHUD show:YES];
            currentLang = @"zh-cn";
            [HttpRequest ContentEpisodeItemListRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:_episodeGuid lang:currentLang delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            if ([AppDelegate App].myUserLoginMode.token) {
                NSString* preferenceKey = [NSString stringWithFormat:@"episode.%@.%@",_episodeGuid,currentLang];
                [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myUserLoginMode.token preferenceKey: preferenceKey preferenceValue:nil delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }

        }

    }else if(sender == _langButton2){
        if (!_langButton2.isSelected) {
            [[AppDelegate App]click];
            [_langButton1 setSelected:NO];
            [_langButton2 setSelected:YES];
            [myMBProgressHUD show:YES];
            currentLang = @"en-gb";
            [HttpRequest ContentEpisodeItemListRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:_episodeGuid lang:currentLang delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            if ([AppDelegate App].myUserLoginMode.token) {
                NSString* preferenceKey = [NSString stringWithFormat:@"episode.%@.%@",_episodeGuid,currentLang];
                [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myUserLoginMode.token preferenceKey: preferenceKey preferenceValue:nil delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonTouch:(UIButton *)sender
{
    self.view.userInteractionEnabled = NO;
    [[AppDelegate App]click];
    if (currentPlayIndex>=0 && currentPlayIndex <myContentEpisodeItemListModel.list.count) {
        ContentItem* tempContentItem = [myContentEpisodeItemListModel.list objectAtIndex:currentPlayIndex];
        [myMBProgressHUD show:YES];
        videoName = tempContentItem.contentTitle;
        contentGuid = tempContentItem.contentGuid;
        startTime = historyPlayTime;
        if ([AppDelegate App].myUserLoginMode.token) {
            NSLog(@"1234*********************");
            [HttpRequest ProductPlayRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        }else{
            [self anonymousLogin];
        }
    }
}

- (void)anonymousLogin
{
    [myMBProgressHUD show:YES];
    if ([AppDelegate App].myAnonymousLoginMode.token) {
        [HttpRequest AppTipsRequestRequestToken:[AppDelegate App].myAnonymousLoginMode.token key:nil delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }else{
        [HttpRequest AnonymousLoginDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}

- (void)anonymousPlay
{
    [giftView setHidden:YES];
    [myMBProgressHUD show:YES];
    NSLog(@"1233*********************");
    [HttpRequest ProductPlayRequestToken:[AppDelegate App].myAnonymousLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}


- (IBAction)collectionButtonTouch:(UIButton *)sender
{
        [[AppDelegate App]click];
    if ([AppDelegate App].myUserLoginMode.token) {
        if (isCollected) {
            isCollected = NO;
            [HttpRequest FavoriteDelByGuidRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:_episodeGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            [self setCollectedButton:isCollected];
            _collectionCountLabel.text = [NSString stringWithFormat:@"%d次",favoriteCount-1];
            favoriteCount--;
        }else{
            isCollected = YES;
            [HttpRequest FavoriteAddRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:_episodeGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            [self setCollectedButton:isCollected];
            _collectionCountLabel.text = [NSString stringWithFormat:@"%d次",favoriteCount+1];
            favoriteCount++;
        }
    }else{
        [self enterLoginView:UnKnownAction];
    }

}

- (void)enterLoginView:(ActionState)state
{
    self.view.userInteractionEnabled = YES;
    UserLoginViewController* myUserLoginViewController = [[UserLoginViewController alloc]init];
    myUserLoginViewController.myActionState = state;
    [self.navigationController pushViewController:myUserLoginViewController animated:NO];
}

- (IBAction)moreButtonTouch:(UIButton *)sender
{
        [[AppDelegate App]click];
    EpisodeDescriptionViewController* myEpisodeDescriptionViewController = [[EpisodeDescriptionViewController alloc]init];
    myEpisodeDescriptionViewController.episodeTitle = myContentEpisodeItemListModel.episodeTitle;
    myEpisodeDescriptionViewController.episodeDescription = myContentEpisodeItemListModel.episodeDescription;
    [self.navigationController pushViewController:myEpisodeDescriptionViewController animated:NO];
}

- (IBAction)closeButtonTouch:(UIButton *)sender
{
        [[AppDelegate App]click];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterAfterLoginInSuccess object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (myContentEpisodeItemListModel == nil) {
        return 0;
    }
    if (selectedButton.tag-1000 == totalPage -1) {
        return (myContentEpisodeItemListModel.list.count - 12*(totalPage -1));
    }else
    {
        return 12;
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (myContentEpisodeItemListModel == nil) {
        return nil;
    }
    static NSString * CellIdentifier = @"GradientCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
//        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CollectionViewCell" owner:self options:nil];
//        cell = [arrayOfViews objectAtIndex:0];
    }
    UIButton* button = (UIButton*)[cell viewWithTag:501];
    if (button == nil) {
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setBackgroundImage:[UIImage imageNamed:@"button_g2.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_g1.png"] forState:UIControlStateHighlighted];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0,8,0,8)];
        button.exclusiveTouch = YES;
        if (iPad) {
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            button.frame = CGRectMake(0, 0, 156, 50);
        }else{
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
            button.frame = CGRectMake(0, 0, 80, 25);
        }
        button.tag = 501;
        [cell addSubview:button];
        button.userInteractionEnabled = NO;
    }
    int index = (selectedButton.tag-1000)*12+indexPath.row;
    ContentItem* tempContentItem = [myContentEpisodeItemListModel.list objectAtIndex:index];
    NSString* title = [NSString stringWithFormat:@"%d %@",index+1,tempContentItem.contentTitle];
    [button setTitle:title forState:UIControlStateNormal];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.view.userInteractionEnabled = NO;
    [[AppDelegate App]click];
    
    if (currentPlayIndex == (selectedButton.tag-1000)*12+indexPath.row) {
        startTime = historyPlayTime;
    }else{
        startTime = 0;
    }
    currentPlayIndex = (selectedButton.tag-1000)*12+indexPath.row;
    if (currentPlayIndex>=0 && currentPlayIndex <myContentEpisodeItemListModel.list.count) {
        ContentItem* tempContentItem = [myContentEpisodeItemListModel.list objectAtIndex:currentPlayIndex];
        [myMBProgressHUD show:YES];
        videoName = tempContentItem.contentTitle;
        contentGuid = tempContentItem.contentGuid;
        if ([AppDelegate App].myUserLoginMode.token) {
            NSLog(@"1232*********************");
            [HttpRequest ProductPlayRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        }else{
            [self anonymousLogin];
        }

        
    }
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton* tempButton = (UIButton*)[[collectionView cellForItemAtIndexPath:indexPath]viewWithTag:501];
    [tempButton setHighlighted:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton* tempButton = (UIButton*)[[collectionView cellForItemAtIndexPath:indexPath]viewWithTag:501];
    [tempButton setHighlighted:NO];
}
@end
