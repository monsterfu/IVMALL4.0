//
//  IndexFeaturedHomeView.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "IndexFeaturedHomeView.h"
#import "Macro.h"
#import "Commonality.h"
#import "HttpRequest.h"
#import "AppDelegate.h"
#import "IndexFeaturedHomeModel.h"
#import "UIImageView+WebCache.h"
#import "Commonality.h"
#import "MainViewController.h"
#import "SMPageControl.h"
#import "PlayEpisodeListMode.h"
#import "PlayEpisodeListViewController.h"
@implementation IndexFeaturedHomeView
{
    UIView* bannerView;
    UIScrollView* bannerScrollView;//图片980*420
    UIScrollView* recommanderScrollView;
    IndexFeaturedHomeModel* myIndexFeaturedHomeModel;
    
    NSMutableArray* bannerArray;
    UIPageControl *pageControl;//banner栏滑动控制
    UILabel *noteTitle;//banner标题
    NSTimer* turnPageTimer;//banner滑动计时器
    int currentPageIndex;//当前banner页
    
    NSMutableArray* recommandArray;
    
    NSString* videoName;
    NSString* contentGuid;
    NSString* playURL;
    
    UITapGestureRecognizer* playVideoRecord;
    UIView* giftView;
    
    
    UIView* noPlayRecord;
    UIView* notLogin;
    UIView* downloadFailedView;
    UIView* playListView;
    
    PlayEpisodeListMode* myPlayEpisodeListMode;
}

#define BannerImageWidth    (iPad?687:232)
#define BannerImageHeight   (iPad?287:97)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afterLogin:) name:NSNotificationCenterLoginInSuccess object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afterLogin:) name:NSNotificationCenterPlayVideo object:nil];
    }
    return self;
}

- (void)afterLogin:(NSNotification*)notification
{
    if ([AppDelegate App].myUserLoginMode.token) {
        [HttpRequest PlayEpisodeListRequestToken:[AppDelegate App].myUserLoginMode.token page:1 rows:1 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterLoginInSuccess object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterPlayVideo object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)show
{
    if (self && self.delegate)
    {
        [self.delegate hideBottomView];
        [self.delegate showMBProgressHUD];
    }
    [HttpRequest IndexFeaturedHomeRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

-(void)GetErr:(ASIHTTPRequest *)request
{
    if (request.tag == INDEX_FEATUREDHOME_TYPE)
    {
        if (self && self.delegate)
        {
            [self.delegate hideMBProgressHUD];
            [self.delegate showNotWifiView];
        }
    }else if (request.tag == USER_PREFERENCE_GET_TYPE || request.tag == PRODUCT_PLAY_TYPE || request.tag == APP_TIPS_TYPE || request.tag == ANONYMOUS_LOGIN_TYPE)
    {
         [self.delegate getMianView].userInteractionEnabled = YES;
        if (self && self.delegate)
        {
            [self.delegate hideMBProgressHUD];
            [Commonality showErrorMsg:self type:0 msg:LINGKERROR];
        }
    }else if (request.tag == PLAY_EPISODELIST_TYPE)
    {
        [self hidePlayRecordView];
        [self makeDownloadFailedView];
        [downloadFailedView setHidden:NO];
    }
}

-(void)makeDownloadFailedView
{
    if (downloadFailedView == nil) {
        if (iPad) {
            downloadFailedView = [[[NSBundle mainBundle] loadNibNamed:@"downloadFailedView" owner:self options:nil]objectAtIndex:0];
            downloadFailedView.frame = CGRectMake(BannerImageWidth+30, 0, 193, 355);
        }else{
            downloadFailedView = [[[NSBundle mainBundle] loadNibNamed:@"downloadFailedViewForiPhone" owner:self options:nil]objectAtIndex:0];
            downloadFailedView.frame = CGRectMake(BannerImageWidth+30, 0, 193, 355);
        }

        
        UIButton* button1 = (UIButton*)[downloadFailedView viewWithTag:101];
        [bannerView addSubview:downloadFailedView];
        button1.layer.cornerRadius = (iPad?16:10);
        [button1 addTarget:self action:@selector(refreshPlayRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)makeNoPlayRecorder
{
    if (noPlayRecord == nil) {
        if (iPad) {
            noPlayRecord = [[[NSBundle mainBundle] loadNibNamed:@"NoPlayRecorder" owner:self options:nil]objectAtIndex:0];
            noPlayRecord.frame = CGRectMake(BannerImageWidth+30, 0, 193, 355);
        }else{
            noPlayRecord = [[[NSBundle mainBundle] loadNibNamed:@"NoPlayRecorderForiPhone" owner:self options:nil]objectAtIndex:0];
            noPlayRecord.frame = CGRectMake(BannerImageWidth+30, 0, 193, 355);
        }

        
        [bannerView addSubview:noPlayRecord];
    }
}

-(void)makeplayRecorderView
{
    if (playListView == nil) {
        if (iPad) {
            playListView = [[[NSBundle mainBundle] loadNibNamed:@"playRecordView" owner:self options:nil]objectAtIndex:0];
            playListView.frame = CGRectMake(BannerImageWidth+30, 0, 193, 355);
        }else{
            playListView = [[[NSBundle mainBundle] loadNibNamed:@"playRecordViewForiPhone" owner:self options:nil]objectAtIndex:0];
            playListView.frame = CGRectMake(BannerImageWidth+10, 0, 85, 120);
        }

        
        UIImageView* imageView = (UIImageView*)[playListView viewWithTag:101];
        imageView.layer.cornerRadius = (iPad?20:10);
        imageView.clipsToBounds = YES;
        
        [bannerView addSubview:playListView];
//        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterContentEpisodeItemListView:)];
//        [imageView addGestureRecognizer:tapGesture];
        
        UIButton* button = (UIButton*)[playListView viewWithTag:105];
        UIImage* tempImage = [Commonality createImageWithColor:[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.2]];
        [button setBackgroundImage:tempImage forState:UIControlStateHighlighted];
        button.layer.cornerRadius = (iPad?20:10);
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(enterContentEpisodeItemListView:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* button1 = (UIButton*)[playListView viewWithTag:103];
        [button1 addTarget:self action:@selector(enterPlayListView:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)enterPlayListView:(UIButton*)sender
{
    [[AppDelegate App]click];
    PlayEpisodeListViewController* myPlayEpisodeListViewController = [[PlayEpisodeListViewController alloc]init];
    if (self && self.delegate) {
        [[self.delegate getNavigation] pushViewController:myPlayEpisodeListViewController animated:NO];
    }

}
- (void)refreshPlayRecord:(UIButton*)sender
{
    [HttpRequest PlayEpisodeListRequestToken:[AppDelegate App].myUserLoginMode.token page:1 rows:1 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

-(void)GetResult:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (dictionary==nil)
    {
        if (request.tag == INDEX_FEATUREDHOME_TYPE)
        {
            if (self && self.delegate)
            {
                [self.delegate hideMBProgressHUD];
                [self.delegate showNotWifiView];
            }
        }else if (request.tag == USER_PREFERENCE_GET_TYPE || request.tag == PRODUCT_PLAY_TYPE || request.tag == APP_TIPS_TYPE || request.tag == ANONYMOUS_LOGIN_TYPE)
        {
             [self.delegate getMianView].userInteractionEnabled = YES;
            if (self && self.delegate)
            {
                [self.delegate hideMBProgressHUD];
            }
        }
        else if (request.tag == PLAY_EPISODELIST_TYPE)
        {
            [self hidePlayRecordView];
            [self makeDownloadFailedView];
            [downloadFailedView setHidden:NO];
        }
    }else
    {
        if (request.tag == INDEX_FEATUREDHOME_TYPE) {
            myIndexFeaturedHomeModel = [[IndexFeaturedHomeModel alloc]initWithDictionary:dictionary];
            if (myIndexFeaturedHomeModel.errorCode == 0) {
                [self makeBannerAndRecommandScrollView];
                if (self && self.delegate)
                {
                    [self.delegate hideMBProgressHUD];
                }
            }
        }else if (request.tag == APP_TIPS_TYPE){
            if (self && self.delegate)
            {
                [self.delegate hideMBProgressHUD];
            }
            AppTipsModel* temp = [[AppTipsModel alloc]initWithDictionary:dictionary];
            if (temp.errorCode == 0) {
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
                                [self addSubview:giftView];
                                giftView.frame = CGRectMake(0, -110, 1024, 768);
                                
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
                            [self.delegate getMianView].userInteractionEnabled = YES;
                            
                        }else{
                            [self anonymousPlay];
                        }
                    }else{
                        [self enterLoginView:IndexPlayVideo];
                    }


                }else{
                    [Commonality showErrorMsg:self type:0 msg:temp.errorMessage];
                     [self.delegate getMianView].userInteractionEnabled = YES;
                }
            }
        }
        else if(request.tag == ANONYMOUS_LOGIN_TYPE){
            [AppDelegate App].myAnonymousLoginMode = [[AnonymousLoginMode alloc]initWithDictionary:dictionary];
            if ([AppDelegate App].myAnonymousLoginMode.errorCode == 0) {
                [HttpRequest AppTipsRequestRequestToken:[AppDelegate App].myAnonymousLoginMode.token key:nil delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                [HttpRequest DevicesBindRequestToken:[AppDelegate App].myAnonymousLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }else{
                if (self && self.delegate)
                {
                    [self.delegate hideMBProgressHUD];
                }
                [self enterLoginView:IndexPlayVideo];
                 [self.delegate getMianView].userInteractionEnabled = YES;
            }
        }
        else if (request.tag == PLAY_EPISODELIST_TYPE)
        {
            myPlayEpisodeListMode = [[PlayEpisodeListMode alloc]initWithDictionary:dictionary];
            if (myPlayEpisodeListMode.errorCode == 0) {
                if (myPlayEpisodeListMode.list.count == 0) {
                    [self hidePlayRecordView];
                    [self makeNoPlayRecorder];
                    [noPlayRecord setHidden:NO];
                }else {
                    [self hidePlayRecordView];
                    [self makeplayRecorderView];
                    EpisodeMode* tempEpisodeMode = [myPlayEpisodeListMode.list objectAtIndex:0];
                    
                    UIImageView* imageView = (UIImageView*)[playListView viewWithTag:101];
                    [imageView setImageWithURL:[NSURL URLWithString:tempEpisodeMode.contentImg] placeholderImage:[UIImage imageNamed:@"icon_75.png"]];
                    
                    UILabel* label = (UILabel*)[playListView viewWithTag:102];
                    label.text = tempEpisodeMode.contentTitle;
                    
                    UILabel* label2 = (UILabel*)[playListView viewWithTag:104];
                    label2.text = [NSString stringWithFormat:@"观看至第%d集",tempEpisodeMode.latestPlayEpisode];
                    
                    [playListView setHidden:NO];
                }
            }
        }
        else if(request.tag == PRODUCT_PLAY_TYPE){
            [self.delegate getMianView].userInteractionEnabled = YES;
            if (self && self.delegate)
            {
                [self.delegate hideMBProgressHUD];
            }
            ProductPlayModel* myProductPlayMode = [[ProductPlayModel alloc]initWithDictionary:dictionary];
            if (myProductPlayMode.errorCode == 0) {
                playURL = nil;
                if ([Commonality isEmpty:myProductPlayMode.URI] && [Commonality isEmpty:myProductPlayMode.catchupURI ]) {
                    [Commonality showErrorMsg:self type:0 msg:@"该视频不存在!"];
                    if (self && self.delegate)
                    {
                        [self.delegate hideMBProgressHUD];
                    }
                     [self.delegate getMianView].userInteractionEnabled = YES;
                    return;
                }else{
                    if ([Commonality isEmpty:myProductPlayMode.URI]) {
                        playURL = myProductPlayMode.catchupURI;
                    }else {
                        playURL = myProductPlayMode.URI;
                    }


                    [IVMallPlayer sharedIVMallPlayer].delegate = self;
                    [[AppDelegate App] play];
                    [[IVMallPlayer sharedIVMallPlayer]IVMallPlayerStart:playURL withVideoName:videoName withConnectionPlayProType:VideoNotEpisode fromViewController:[self.delegate getNavigation] startTime:0];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterPlayVideo object:nil];
                    return;
                }
            }else{

                if ([AppDelegate App].myUserLoginMode.token) {
                    if (myProductPlayMode.errorCode == 204 || myProductPlayMode.errorCode == 224) {
                        NSString* copyright=[[NSUserDefaults standardUserDefaults] objectForKey:@"copyright_Ivmall"];
                        if (copyright && [copyright isEqualToString:@"true"] ) {
                            UIAlertView*   alet=[[UIAlertView alloc]initWithTitle:@"会员权限未开通或已过期，请先开通会员！" message:nil delegate:self cancelButtonTitle:@"稍后开通" otherButtonTitles:@"立即开通", nil];
                            alet.tag=110;
                            [alet show];
                        }
                        return;
                    }else{
                        [Commonality showErrorMsg:self type:0 msg:myProductPlayMode.errorMessage];
                    }
                }else{
                    if (myProductPlayMode.errorCode == 204 || myProductPlayMode.errorCode == 224) {
//                        NSString* copyright=[[NSUserDefaults standardUserDefaults] objectForKey:@"copyright_Ivmall"];
//                        if (copyright && [copyright isEqualToString:@"true"] ) {
//                            [Commonality showTipsMsgWithView:self duration:3.0 msg:@"您的免注册观看已到期" image:[UIImage  imageNamed: @"libao_bg.png"]];
//                            
//                        }
                        
                    }else{
                        [Commonality showErrorMsg:self type:0 msg:myProductPlayMode.errorMessage];
                    }
//                    [self performSelector:@selector(enterLoginView:) withObject:PlayVideo afterDelay:3.0];
                    [self enterLoginView:IndexPlayVideo];

                    }
                }
            }
        
    }
}

- (void)getThePackage:(UIButton*)button
{
    [giftView setHidden:YES];
    [[AppDelegate App]click];
    UserRegisterViewController* myUserRegisterViewController = [[UserRegisterViewController alloc]init];
    myUserRegisterViewController.isFromLoginView = NO;
    [[self.delegate getNavigation] pushViewController:myUserRegisterViewController animated:NO];
}
- (void)enterLoginView:(ActionState)state
{
    if (self && self.delegate) {
        [[AppDelegate App]click];
        UserLoginViewController* myUserLoginViewController = [[UserLoginViewController alloc]init];
        myUserLoginViewController.myActionState = state;
        [[self.delegate getNavigation] pushViewController:myUserLoginViewController animated:NO];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==110) {
        if (buttonIndex==1) {
            //进入购买页面
            if (self && self.delegate) {
                [[AppDelegate App]click];
                PurchaseCompletionHandler myCallBack = ^{
                    [self playBefoerLoginVideo];
                };
                [self.delegate buyVip:myCallBack];
            }
        }
    }
}

-(void)makeBannerAndRecommandScrollView
{
    if (bannerView) {
        [bannerView removeFromSuperview];
        noPlayRecord = nil;
        notLogin = nil;
        downloadFailedView = nil;
        playListView = nil;
        bannerView = nil;
    }
    //画banner
    bannerView = [[UIView alloc]init];
    bannerView.backgroundColor = [Commonality colorFromHexRGB:@"5cbe59"];
    if (iPad) {
        bannerView.frame = CGRectMake(57, 0, 910, 355);
        bannerView.layer.cornerRadius = 20.0f;
        bannerView.layer.borderWidth = 3;
    }else{
        bannerView.frame = CGRectMake((VIEWHEIGHT-328)/2, 0, 328, 120);
        bannerView.layer.cornerRadius = 10.0f;
        bannerView.layer.borderWidth = 1.5;
    
    }
    bannerView.layer.masksToBounds = YES;
    bannerView.layer.borderColor = [[Commonality colorFromHexRGB:@"42843d"]CGColor];
    [self addSubview:bannerView];
    
    
    UIView* bannerScrollerBackgroundView = [[UIView alloc]init];
    bannerScrollerBackgroundView.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
    if (iPad) {
        bannerScrollerBackgroundView.frame = CGRectMake(0, 0, 717, 355);
        bannerScrollerBackgroundView.layer.cornerRadius = 20.0f;
    }else{
        bannerScrollerBackgroundView.frame = CGRectMake(0, 0, 242, 120);
        bannerScrollerBackgroundView.layer.cornerRadius = 10.0f;
    }
    
    [bannerView addSubview:bannerScrollerBackgroundView];
    
    UIImageView* bannerRightImageView = [[UIImageView alloc]init];
    if (iPad) {
        bannerRightImageView.frame = CGRectMake(702, 0, 52,355);
        bannerRightImageView.image = [UIImage imageNamed:@"banner_right.png"];
    }else{
        bannerRightImageView.frame = CGRectMake(237, 0, 17,120);
        bannerRightImageView.image = [UIImage imageNamed:@"banner_right.png"];
    }
    [bannerView addSubview:bannerRightImageView];
    
    bannerScrollView = [[UIScrollView alloc]init];
    if (iPad) {
        bannerScrollView.frame  = CGRectMake(15, 15, BannerImageWidth, BannerImageHeight);
    }else{
        bannerScrollView.frame  = CGRectMake(5, 5, BannerImageWidth, BannerImageHeight);
    }
    
    bannerScrollView.delegate = self;
    bannerScrollView.pagingEnabled = YES;
    bannerScrollView.showsHorizontalScrollIndicator = NO;
    bannerScrollView.showsVerticalScrollIndicator = NO;
    bannerScrollView.scrollsToTop = NO;
    [bannerView addSubview:bannerScrollView];
    
    bannerArray = [[NSMutableArray alloc]initWithArray:myIndexFeaturedHomeModel.ads];
    if ([myIndexFeaturedHomeModel.ads count]>=1) {
        [bannerArray insertObject:[myIndexFeaturedHomeModel.ads objectAtIndex:([myIndexFeaturedHomeModel.ads count]-1)] atIndex:0];
        [bannerArray addObject:[myIndexFeaturedHomeModel.ads objectAtIndex:0]];
        NSUInteger pageCount = [bannerArray count];
        for (int i=0; i<pageCount; i++) {
            adModel* temp = [bannerArray objectAtIndex:i];
            NSString* imgURL = temp.adImg ;
            UIImageView *imgView=[[UIImageView alloc] init];
            [imgView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"banner.png"]];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            if (iPad) {
                imgView.layer.cornerRadius = 10.0f;
            }else{
                imgView.layer.cornerRadius = 5.0f;
                
            }
            [imgView setFrame:CGRectMake(i*BannerImageWidth, 0, BannerImageWidth, BannerImageHeight)];
            imgView.tag = 100+i;
            imgView.exclusiveTouch=YES;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
       
            [bannerScrollView addSubview:imgView];
        }

        [bannerScrollView setContentSize:CGSizeMake(pageCount*BannerImageWidth, BannerImageHeight)];
        [bannerScrollView setContentOffset:CGPointMake(BannerImageWidth, 0)];

     
        float pageControlWidth;
        float pagecontrolHeight;
        if (iPad) {
            pageControlWidth = (pageCount-2)*10.0f+40.f;
            pagecontrolHeight = 33.0f;
        }else{
            pageControlWidth = (pageCount-2)*10.0f+20.f;
            pagecontrolHeight = 20;
        }
        if (iPad) {
            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((BannerImageWidth-pageControlWidth)-20,312, pageControlWidth, pagecontrolHeight)];
        }else{
            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((BannerImageWidth-pageControlWidth)-20,100, pageControlWidth, pagecontrolHeight)];
        }
        
        [pageControl setCurrentPage:0];
        pageControl.numberOfPages=(pageCount-2);
        pageControl.pageIndicatorTintColor=[Commonality colorFromHexRGB:@"96aa79"];
        pageControl.currentPageIndicatorTintColor=[Commonality colorFromHexRGB:@"ff7900"];
        [bannerView addSubview:pageControl];
        
        if (iPad) {
            noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(15, 312, BannerImageWidth, 33)];
            [noteTitle setFont:[UIFont boldSystemFontOfSize:19]];
        }else{
            noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 100, BannerImageWidth, 20)];
            [noteTitle setFont:[UIFont boldSystemFontOfSize:13]];
        }
        
        adModel* temp;
        if ([myIndexFeaturedHomeModel.ads count] > 1) {
            temp = [bannerArray objectAtIndex:1];
            [noteTitle setText:temp.adTitle];
        }
        [noteTitle setBackgroundColor:[UIColor clearColor]];
        [noteTitle setTextColor:[UIColor blackColor]];
        [bannerView addSubview:noteTitle];
        
        if (turnPageTimer == nil) {
            turnPageTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        }else{
            [turnPageTimer invalidate];
            turnPageTimer = nil;
            turnPageTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        }
    }
    if ([AppDelegate App].myUserLoginMode.token) {
        [HttpRequest PlayEpisodeListRequestToken:[AppDelegate App].myUserLoginMode.token page:1 rows:1 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }else{
        [self hidePlayRecordView];
        NSString* copyright=[[NSUserDefaults standardUserDefaults] objectForKey:@"copyright_Ivmall"];
        if (copyright && [copyright isEqualToString:@"true"] ) {
            if (notLogin == nil) {
                if (iPad) {
                    notLogin = [[[NSBundle mainBundle] loadNibNamed:@"NotLogin" owner:self options:nil]objectAtIndex:0];
                    notLogin.frame = CGRectMake(BannerImageWidth+30, 0, 193, 355);
                }else{
                    notLogin = [[[NSBundle mainBundle] loadNibNamed:@"NotLoginForiPhone" owner:self options:nil]objectAtIndex:0];
                    notLogin.frame = CGRectMake(BannerImageWidth+10, 0, 85, 120);
                }
                [bannerView addSubview:notLogin];
                UIButton* button1 = (UIButton*)[notLogin viewWithTag:101];
                button1.exclusiveTouch = YES;
                [button1 addTarget:self action:@selector(enterRegisterView:) forControlEvents:UIControlEventTouchUpInside];
                UIButton* button2 = (UIButton*)[notLogin viewWithTag:102];
                button2.exclusiveTouch = YES;
                [button2 addTarget:self action:@selector(oTherEnterLoginView:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [notLogin setHidden:NO];
        }else{
            [self hidePlayRecordView];
            [self makeNoPlayRecorder];
            [noPlayRecord setHidden:NO];
        }
    }
    
    if (recommanderScrollView) {
        [recommanderScrollView removeFromSuperview];
        recommanderScrollView = nil;
    }
    //画recommand
    recommanderScrollView = [[UIScrollView alloc]init];
    if (iPad) {
        recommanderScrollView.frame = CGRectMake(55, 383, 914, 242);
    }else{
        recommanderScrollView.frame = CGRectMake((VIEWHEIGHT-457)/2, 130, 457, 120);
    }
    
    recommanderScrollView.delegate = self;
    recommanderScrollView.showsHorizontalScrollIndicator = NO;
    recommanderScrollView.showsVerticalScrollIndicator = NO;
    recommanderScrollView.scrollsToTop = NO;
    [self addSubview:recommanderScrollView];
    
    recommandArray = myIndexFeaturedHomeModel.childrenList;
    for (int i=0 ; i<recommandArray.count; i++) {
        
        contentModel* tempContentModel = [recommandArray objectAtIndex:i];
        NSArray *nibViews;
        if (iPad) {
            nibViews=[[NSBundle mainBundle] loadNibNamed:@"ProgramView" owner:self options:nil];
        }else{
            nibViews=[[NSBundle mainBundle] loadNibNamed:@"ProgramViewForiPhone" owner:self options:nil];
        }
        UIView* tempView = [nibViews objectAtIndex:0];
        [tempView setTag:(1000+i)];
        

        
        tempView.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
        tempView.layer.masksToBounds = YES;
        tempView.exclusiveTouch = YES;
        tempView.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedView:)];
        [tempView addGestureRecognizer:tapGesture];
        
        // add zjj
        UILongPressGestureRecognizer* longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressedView:)];
        [tempView addGestureRecognizer:longGesture];
         longGesture.minimumPressDuration = 0.1;
        
        [tapGesture requireGestureRecognizerToFail:longGesture];
        // add zjj
        
        UIImageView* subImageView = (UIImageView*)[tempView viewWithTag:100];

        subImageView.layer.masksToBounds = YES;
        [subImageView setImageWithURL:[NSURL URLWithString:tempContentModel.contentImg] placeholderImage:[UIImage imageNamed:@"icon_75.png"]];
        
        UILabel* subLabel1 = (UILabel*)[tempView viewWithTag:101];
        subLabel1.backgroundColor = [Commonality colorFromHexRGB:@"ff7800"];
        subLabel1.text = [NSString stringWithFormat:@"共%d集",tempContentModel.episodeCount];
        
        UILabel* subLabel2 = (UILabel*)[tempView viewWithTag:102];

        subLabel2.text = tempContentModel.contentTitle;
        
        
        if (iPad) {
            tempView.frame = CGRectMake((167+20)*i, 0, 167, 242);
            tempView.layer.cornerRadius = 24;
            tempView.layer.borderWidth = 3;
            subImageView.layer.cornerRadius = 18;
            
        }else{
            tempView.frame = CGRectMake((83+10)*i, 0, 83, 120);
            tempView.layer.cornerRadius = 12;
            tempView.layer.borderWidth = 1.5;
            subImageView.layer.cornerRadius = 9;
        }
        [recommanderScrollView addSubview:tempView];
    }
    if (iPad) {
        [recommanderScrollView setContentSize:CGSizeMake((167+20)*recommandArray.count-10, 242)];
    }else{
        [recommanderScrollView setContentSize:CGSizeMake((83+10)*recommandArray.count-10, 120)];
    }

    if ([self.delegate pageState] == PAGE_INDEX) {
        [self.delegate hideBottomView];
        [self.delegate hideNotWifiView];
        [self setHidden:NO];
    }

}

- (void)enterContentEpisodeItemListView:(UIButton*)sender/*(UITapGestureRecognizer*)sender*/
{
    
    [[AppDelegate App]click];
    EpisodeMode* tempContentMode = [myPlayEpisodeListMode.list objectAtIndex:0];
    ContentEpisodeItemListViewController* myContentEpisodeItemListViewController = [[ContentEpisodeItemListViewController alloc]init];
    myContentEpisodeItemListViewController.episodeGuid = tempContentMode.contentGuid;
    myContentEpisodeItemListViewController.langs = tempContentMode.langs;
    myContentEpisodeItemListViewController.latestPlayLang = tempContentMode.latestPlayLang;
    if (self && self.delegate) {
        [[self.delegate getNavigation] pushViewController:myContentEpisodeItemListViewController animated:NO];
    }
}

- (void)enterRegisterView:(UIButton*)sender
{
    UserRegisterViewController* myUserRegisterViewController = [[UserRegisterViewController alloc]init];
    myUserRegisterViewController.isFromLoginView = NO;
    [[self.delegate getNavigation] pushViewController:myUserRegisterViewController animated:NO];
}
- (void)oTherEnterLoginView:(UIButton*)sender
{
    [self enterLoginView:UnKnownAction];
}
- (void)hidePlayRecordView
{
    [noPlayRecord setHidden:YES];
    [notLogin setHidden:YES];
    [downloadFailedView setHidden:YES];
    [playListView setHidden:YES];
}
- (void)pressedView:(UITapGestureRecognizer*)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        [[AppDelegate App]click];
        int index = sender.view.tag - 1000;
        if (index>=0 && index<recommandArray.count) {
            contentModel* tempContentMode = [recommandArray objectAtIndex:index];
            ContentEpisodeItemListViewController* myContentEpisodeItemListViewController = [[ContentEpisodeItemListViewController alloc]init];
            myContentEpisodeItemListViewController.episodeGuid = tempContentMode.contentGuid;
            myContentEpisodeItemListViewController.langs = tempContentMode.langs;
            myContentEpisodeItemListViewController.latestPlayLang = nil;
            if (self && self.delegate) {
                [[self.delegate getNavigation] pushViewController:myContentEpisodeItemListViewController animated:NO];
            }
            
        }

    }else if([sender isKindOfClass:[UILongPressGestureRecognizer class]]){
        
        if (sender.state == UIGestureRecognizerStateBegan) {
            [[AppDelegate App]click];
            [self setFcous:sender.view];
        }else if(sender.state == UIGestureRecognizerStateEnded){
            [self blurFcous:sender.view];
            int index = sender.view.tag - 1000;
            if (index>=0 && index<recommandArray.count) {
                contentModel* tempContentMode = [recommandArray objectAtIndex:index];
                ContentEpisodeItemListViewController* myContentEpisodeItemListViewController = [[ContentEpisodeItemListViewController alloc]init];
                myContentEpisodeItemListViewController.episodeGuid = tempContentMode.contentGuid;
                myContentEpisodeItemListViewController.langs = tempContentMode.langs;
                myContentEpisodeItemListViewController.latestPlayLang = nil;
                if (self && self.delegate) {
                    [[self.delegate getNavigation] pushViewController:myContentEpisodeItemListViewController animated:NO];
                }
                
            }
        }

    }
}

- (void)setFcous:(UIView*)view
{
    view.backgroundColor = [Commonality colorFromHexRGB:@"fff601"];
    view.layer.borderColor = [Commonality colorFromHexRGB:@"fca010"].CGColor;
    view.layer.borderWidth = (iPad?7:3.5);
    
    UIImageView* subImageView = (UIImageView*)[view viewWithTag:100];
    subImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    subImageView.layer.borderWidth = (iPad?2.5:1);
}

-(void)blurFcous:(UIView*)view
{
    view.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
    view.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
    view.layer.borderWidth = (iPad?3:1.5);
    
    UIImageView* subImageView = (UIImageView*)[view viewWithTag:100];
    subImageView.layer.borderWidth = 0;
}

#pragma mark --
#pragma scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == bannerScrollView) {
        CGFloat pageWidth = bannerScrollView.frame.size.width;
        int page = floor((bannerScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        currentPageIndex=page;
        pageControl.currentPage=(page-1);
        if (page>=bannerArray.count ||page<0) {
            return;
        }
        adModel* temp = [bannerArray objectAtIndex:page];
        [noteTitle setText:temp.adTitle];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == bannerScrollView) {
        if (currentPageIndex==0) {
            [bannerScrollView setContentOffset:CGPointMake(([bannerArray count]-2)*BannerImageWidth , 0)];
        }
        if (currentPageIndex==([bannerArray count]-1)) {
            [bannerScrollView setContentOffset:CGPointMake(BannerImageWidth, 0)];
        }
    }
}

//将要开始拖拽，手指已经放在view上并准备拖动的那一刻
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == bannerScrollView) {
        if (turnPageTimer!=nil) {
            [turnPageTimer invalidate];
            turnPageTimer = nil;
        }
    }
}

//已经结束拖拽，手指刚离开view的那一刻
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == bannerScrollView) {
        if (turnPageTimer == nil) {
            turnPageTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        }
    }

}


- (void)turnPage{
    int page = pageControl.currentPage;
    if (page == 0) {
        [bannerScrollView scrollRectToVisible:CGRectMake(BannerImageWidth*(page+1),0,BannerImageWidth,BannerImageHeight) animated:NO];
    }
    else
    {
        [bannerScrollView scrollRectToVisible:CGRectMake(BannerImageWidth*(page+1),0,BannerImageWidth,BannerImageHeight) animated:YES];
    }
}

- (void)runTimePage{
    int page = pageControl.currentPage;
    page++;
    page = page > [bannerArray count]-3 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}

- (void)anonymousLogin
{
    if (self && self.delegate) {
        [self.delegate showMBProgressHUD];
    }
    if ([AppDelegate App].myAnonymousLoginMode.token) {
        [HttpRequest AppTipsRequestRequestToken:[AppDelegate App].myAnonymousLoginMode.token key:nil delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }else{
        [HttpRequest AnonymousLoginDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}

- (void)anonymousPlay
{
    [giftView setHidden:YES];
    if (self && self.delegate) {
        [self.delegate showMBProgressHUD];
    }
    [HttpRequest ProductPlayRequestToken:[AppDelegate App].myAnonymousLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

- (void)imagePressedWithOutSound:(UITapGestureRecognizer *)sender
{
    [self.delegate getMianView].userInteractionEnabled = NO;
    
    int indexAd = sender.view.tag - 100;
    if (indexAd >= bannerArray.count  || indexAd<0) {
        [self.delegate getMianView].userInteractionEnabled = YES;
        return;
    }
    adModel* im = [bannerArray objectAtIndex:indexAd];
    
    if ([im.adType isEqualToString:@"content"])
    {
        if ([AppDelegate App].myUserLoginMode.token) {
            if (self && self.delegate) {
                [self.delegate showMBProgressHUD];
            }
            contentGuid = im.adGuid;
            videoName = im.adTitle;
            [HttpRequest ProductPlayRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            return;
            
        }else{
            playVideoRecord = sender;
            contentGuid = im.adGuid;
            videoName = im.adTitle;
            [self anonymousLogin];
            return;
        }
    }else if ([im.adType isEqualToString:@"image"])
    {
        if ([AppDelegate App].myUserLoginMode.token == nil) {
            if ([im.adGuid isEqualToString:@"LOGIN"]) {
                if (self && self.delegate) {
                    [self enterLoginView:UnKnownAction];
                }
            }else if([im.adGuid isEqualToString:@"REGISTER"]){
                UserRegisterViewController* myUserRegisterViewController = [[UserRegisterViewController alloc]init];
                myUserRegisterViewController.isFromLoginView = NO;
                [[self.delegate getNavigation] pushViewController:myUserRegisterViewController animated:NO];
            }
        }
        if ([im.adGuid isEqualToString:@"POSTER"]) {
            
            if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:im.adAnchor]]) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:im.adAnchor]];
            }
        }
        
        [self.delegate getMianView].userInteractionEnabled = YES;
    }
    
    [self.delegate getMianView].userInteractionEnabled = YES;

}

- (void)imagePressed:(UITapGestureRecognizer *)sender{
    
    [[AppDelegate App]click];
    [self imagePressedWithOutSound:sender];
    
}

-(void)PlayerCallBack:(PlayerCallBackEventType)callBackEventType withParameter: (NSMutableDictionary *)callBackInfo
{
    if (callBackEventType == PlayerWillPlaybackEnded) {
        
        
    }else if(callBackEventType == PlayerUserExited){

    }else if(callBackEventType == PlayerWillReturnFromDMRPlay){
        [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterExitFromDMC object:@"YES"];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterExitFromDMC object:@"NO"];
}

- (void)playBefoerLoginVideo
{
    [self imagePressedWithOutSound:playVideoRecord];
}
@end