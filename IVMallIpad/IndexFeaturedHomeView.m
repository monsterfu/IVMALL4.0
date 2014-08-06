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
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
         bannerView.userInteractionEnabled = YES;
        if (self && self.delegate)
        {
            [self.delegate hideMBProgressHUD];
            [Commonality showErrorMsg:self type:0 msg:LINGKERROR];
        }
    }
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
             bannerView.userInteractionEnabled = YES;
            if (self && self.delegate)
            {
                [self.delegate hideMBProgressHUD];
            }
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
        }else if (request.tag == USER_PREFERENCE_GET_TYPE)
        {
            if (self && self.delegate)
            {
                [self.delegate hideMBProgressHUD];
            }
             bannerView.userInteractionEnabled = YES;
            UserPreferenceModel* myUserPre = [[UserPreferenceModel alloc]initWithDictionary:dictionary];
            if (myUserPre.errorCode == 0) {
                if([myUserPre.preferenceKey hasPrefix:@"play.positon"]){
                    int startTime = [myUserPre.preferenceValue intValue];
                    [IVMallPlayer sharedIVMallPlayer].delegate = self;
                    [[AppDelegate App] play];
                    [[IVMallPlayer sharedIVMallPlayer]IVMallPlayerStart:playURL withVideoName:videoName fromViewController:[self.delegate getNavigation] startTime:startTime];
                    return;
                    
                }
            }


        }else if (request.tag == APP_TIPS_TYPE){
            if (self && self.delegate)
            {
                [self.delegate hideMBProgressHUD];
            }
            AppTipsModel* temp = [[AppTipsModel alloc]initWithDictionary:dictionary];
            if (temp.errorCode == 0) {
                NSString* copyright=[[NSUserDefaults standardUserDefaults] objectForKey:@"copyright_Ivmall"];
                if (copyright && [copyright isEqualToString:@"true"] ) {
                    [Commonality showTipsMsgWithView:self duration:3 msg:temp.anonymousTips image:[UIImage imageNamed:@"libao_bg.png"]];
                    [self performSelector:@selector(anonymousPlay) withObject:nil afterDelay:3.0];
                }else{
                    [self anonymousPlay];
                }

            }else{
                [Commonality showErrorMsg:self type:0 msg:temp.errorMessage];
                 bannerView.userInteractionEnabled = YES;
            }
        }
        else if(request.tag == ANONYMOUS_LOGIN_TYPE){
            [AppDelegate App].myAnonymousLoginMode = [[AnonymousLoginMode alloc]initWithDictionary:dictionary];
            if ([AppDelegate App].myAnonymousLoginMode.errorCode == 0) {
                [HttpRequest AppTipsRequestDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }else{
                if (self && self.delegate)
                {
                    [self.delegate hideMBProgressHUD];
                }
//                [Commonality showErrorMsg:self type:0 msg:[AppDelegate App].myAnonymousLoginMode.errorMessage];
                [self enterLoginView:PlayVideo];
                 bannerView.userInteractionEnabled = YES;
            }
        }
        else if(request.tag == PRODUCT_PLAY_TYPE){
            ProductPlayModel* myProductPlayMode = [[ProductPlayModel alloc]initWithDictionary:dictionary];
            if (myProductPlayMode.errorCode == 0) {
                playURL = nil;
                if ([Commonality isEmpty:myProductPlayMode.URI] && [Commonality isEmpty:myProductPlayMode.catchupURI ]) {
                    [Commonality showErrorMsg:self type:0 msg:@"该视频不存在!"];
                    if (self && self.delegate)
                    {
                        [self.delegate hideMBProgressHUD];
                    }
                     bannerView.userInteractionEnabled = YES;
                    return;
                }else{
                    if ([Commonality isEmpty:myProductPlayMode.URI]) {
                        playURL = myProductPlayMode.catchupURI;
                    }else {
                        playURL = myProductPlayMode.URI;
                    }
                    NSString* preferenceKey1 = [NSString stringWithFormat:@"play.positon.%@",contentGuid];
                    if ([AppDelegate App].myUserLoginMode.token) {

                        [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myUserLoginMode.token preferenceKey:preferenceKey1 preferenceValue:nil delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                    }else{
                        [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myAnonymousLoginMode.token preferenceKey:preferenceKey1 preferenceValue:nil delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                    }

                }
            }else{
                 bannerView.userInteractionEnabled = YES;
                if (self && self.delegate)
                {
                    [self.delegate hideMBProgressHUD];
                }
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
                    NSString* copyright=[[NSUserDefaults standardUserDefaults] objectForKey:@"copyright_Ivmall"];
                    if (copyright && [copyright isEqualToString:@"true"] ) {
                        [Commonality showTipsMsgWithView:self duration:3.0 msg:@"你的免注册观看已到期" image:[UIImage  imageNamed: @"libao_bg.png"]];
                    }
                    [self performSelector:@selector(enterLoginView:) withObject:PlayVideo afterDelay:3.0];

                }
            }
        }
    }
}

- (void)enterLoginView:(ActionState)state
{
    if (self && self.delegate) {
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
                [self.delegate buyVip];
            }
        }
    }
}

-(void)makeBannerAndRecommandScrollView
{
    if (bannerView) {
        [bannerView removeFromSuperview];
        bannerView = nil;
    }
    //画banner
    bannerView = [[UIView alloc]init];
    bannerView.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
    if (iPad) {
        bannerView.frame = CGRectMake(55, 0, 914, 321);
        bannerView.layer.cornerRadius = 20.0f;
        bannerView.layer.borderWidth = 3;
    }else{
//        bannerView.frame = CGRectMake((VIEWHEIGHT-457)/2, 0, 457, 146);
        bannerView.frame = CGRectMake((VIEWHEIGHT-376)/2, 0, 376, 120);
        bannerView.layer.cornerRadius = 10.0f;
        bannerView.layer.borderWidth = 1.5;
    
    }
    bannerView.layer.masksToBounds = YES;
    bannerView.layer.borderColor = [[Commonality colorFromHexRGB:@"42843d"]CGColor];
    [self addSubview:bannerView];
    
    bannerScrollView = [[UIScrollView alloc]init];
    if (iPad) {
        bannerScrollView.frame  = CGRectMake(10, 10, 894, 272);
    }else{
        bannerScrollView.frame  = CGRectMake(5, 3, 366, 94);
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
//            [imgView setImageWithURL:[NSURL URLWithString:imgURL]];
            [imgView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"banner.png"]];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            if (iPad) {
                imgView.layer.cornerRadius = 10.0f;
                [imgView setFrame:CGRectMake(i*894, 0, 894, 272)];
            }else{
                imgView.layer.cornerRadius = 5.0f;
                [imgView setFrame:CGRectMake(i*366, 0, 366, 94)];
            }

            imgView.tag = 100+i;
            imgView.exclusiveTouch=YES;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [bannerScrollView addSubview:imgView];
        }

        if (iPad) {
            [bannerScrollView setContentSize:CGSizeMake(pageCount*894, 272)];
            [bannerScrollView setContentOffset:CGPointMake(894, 0)];
        }else{
            [bannerScrollView setContentSize:CGSizeMake(pageCount*366, 94)];
            [bannerScrollView setContentOffset:CGPointMake(366, 0)];
        }
        
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
            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((896-pageControlWidth)-20,284, pageControlWidth, pagecontrolHeight)];
        }else{
            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((366-pageControlWidth)-20,97, pageControlWidth, pagecontrolHeight)];
        }

        [pageControl setCurrentPage:0];
        pageControl.numberOfPages=(pageCount-2);
        pageControl.pageIndicatorTintColor=[Commonality colorFromHexRGB:@"96aa79"];
        pageControl.currentPageIndicatorTintColor=[Commonality colorFromHexRGB:@"ff7900"];
        [bannerView addSubview:pageControl];
        
        if (iPad) {
            noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 284, 896-pageControlWidth-10, 33)];
            [noteTitle setFont:[UIFont boldSystemFontOfSize:17]];
        }else{
            noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 97, 366-pageControlWidth-10, 20)];
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
    
    
    if (recommanderScrollView) {
        [recommanderScrollView removeFromSuperview];
        recommanderScrollView = nil;
    }
    //画recommand
    recommanderScrollView = [[UIScrollView alloc]init];
    if (iPad) {
        recommanderScrollView.frame = CGRectMake(55, 338, 914, 242);
    }else{
        recommanderScrollView.frame = CGRectMake((VIEWHEIGHT-457)/2, 130, 457, 120);
    }
    
    recommanderScrollView.delegate = self;
//    recommanderScrollView.pagingEnabled = YES;
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
        [self setHidden:NO];
    }

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
            myContentEpisodeItemListViewController.langs = nil;
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
                myContentEpisodeItemListViewController.langs = nil;
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
            if (iPad) {
                [bannerScrollView setContentOffset:CGPointMake(([bannerArray count]-2)*894 , 0)];
            }else{
                [bannerScrollView setContentOffset:CGPointMake(([bannerArray count]-2)*290 , 0)];
            }
            
//            pageControl.currentPage = pageControl.numberOfPages -1;
        }
        if (currentPageIndex==([bannerArray count]-1)) {
//            pageControl.currentPage = 0;
            if (iPad) {
                [bannerScrollView setContentOffset:CGPointMake(894, 0)];
            }else{
                [bannerScrollView setContentOffset:CGPointMake(366, 0)];
            }
            
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
//        pageControl.currentPage = 0;
        if (iPad) {
            [bannerScrollView scrollRectToVisible:CGRectMake(894*(page+1),0,894,272) animated:NO];
        }else{
            [bannerScrollView scrollRectToVisible:CGRectMake(366*(page+1),0,366,94) animated:NO];
        }
        
    }
    else
    {
        if (iPad) {
            [bannerScrollView scrollRectToVisible:CGRectMake(894*(page+1),0,894,272) animated:YES];
        }else{
            [bannerScrollView scrollRectToVisible:CGRectMake(366*(page+1),0,366,94) animated:YES];
        }
        
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
        [HttpRequest AppTipsRequestDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }else{
        [HttpRequest AnonymousLoginDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}

- (void)anonymousPlay
{
    if (self && self.delegate) {
        [self.delegate showMBProgressHUD];
    }
    [HttpRequest ProductPlayRequestToken:[AppDelegate App].myAnonymousLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

- (void)imagePressed:(UITapGestureRecognizer *)sender{
    
    bannerView.userInteractionEnabled = NO;
    [[AppDelegate App]click];
    int indexAd = sender.view.tag - 100;
    if (indexAd >= bannerArray.count  || indexAd<0) {
        bannerView.userInteractionEnabled = YES;
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
//            if (self && self.delegate) {
//                UserLoginViewController* myUserLoginViewController = [[UserLoginViewController alloc]init];
//                [[self.delegate getNavigation] pushViewController:myUserLoginViewController animated:NO];
//            }
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
        
        bannerView.userInteractionEnabled = YES;
    }
    
     bannerView.userInteractionEnabled = YES;
}

-(void)PlayerCallBack:(PlayerCallBackEventType)callBackEventType withParameter: (NSMutableDictionary *)callBackInfo
{
    [IVMallPlayer sharedIVMallPlayer].delegate=nil;

    if (callBackEventType == PlayerWillPlaybackEnded) {
        
        
    }else if(callBackEventType == PlayerUserExited){
        NSLog(@"callBackInfo=%@",callBackInfo);
        int playTime = [[callBackInfo objectForKey:@"time"]intValue];
        NSString* preferenceKey1 = [NSString stringWithFormat:@"play.positon.%@",contentGuid];
        NSString* preferenceValue1 = [NSString stringWithFormat:@"%d",playTime];
        [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myUserLoginMode.token preferenceKey:preferenceKey1 preferenceValue:preferenceValue1 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }else if(callBackEventType == PlayerWillReturnFromDMRPlay){
        [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterExitFromDMC object:@"YES"];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterExitFromDMC object:@"NO"];
}

- (void)playBefoerLoginVideo
{
    [self imagePressed:playVideoRecord];
}
@end
