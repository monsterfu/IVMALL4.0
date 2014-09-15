//
//  PlayListView.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "PlayListView.h"
#import "Macro.h"
#import "HttpRequest.h"
#import "Commonality.h"
#import "AppDelegate.h"
#import "PlayListModel.h"
#import "UIImageView+WebCache.h"

#import "PlayEpisodeListMode.h"
#define NumberOfLine 5
@implementation PlayListView
{
    UIScrollView*   playListScrollView;
    UIPageControl*  myPageControl;
    int             totalPage;
    int             currentpage;
    
//    PlayListModel* myPlayListMode;
    NSDate* judgeDate;
    int categoryTimeState;//0 今天,1 昨天,2 前天, 3更早以前,4不处理
    
//    NSString* videoName;
//    NSString* contentGuid;
//    NSString* playURL;
    
    PlayEpisodeListMode* myPlayEpisodeListMode;
    
    UIImageView* noRecordImageView;
    UILabel*     noRecordLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        myPageControl = [[UIPageControl alloc]init];
        myPageControl.pageIndicatorTintColor=[Commonality colorFromHexRGB:@"96aa79"];
        myPageControl.currentPageIndicatorTintColor=[Commonality colorFromHexRGB:@"ff7900"];
        [self addSubview:myPageControl];
        [myPageControl setHidden:YES];
        
        noRecordImageView = [[UIImageView alloc]init];
        noRecordImageView.image = [UIImage imageNamed:@"time_.png"];
        [self addSubview:noRecordImageView];
        [noRecordImageView setHidden:YES];
        
        noRecordLabel = [[UILabel alloc]init];
        noRecordLabel.backgroundColor = [UIColor clearColor];
        noRecordLabel.text = @"您还没有观看记录";
        noRecordLabel.textColor = [UIColor whiteColor];
        noRecordLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:noRecordLabel];
        [noRecordLabel setHidden:YES];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPlayList) name:NSNotificationCenterPlayVideo object:nil];
    }
    return self;
}

- (void)refreshPlayList
{
    if ([AppDelegate App].myUserLoginMode.token)
    {
        currentpage = 0;
        myPlayEpisodeListMode = nil;
        judgeDate = [Commonality Date2day:[NSDate date]];
        categoryTimeState = 0;
        [HttpRequest PlayEpisodeListRequestToken:[AppDelegate App].myUserLoginMode.token page:1 rows:20 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }

}

- (void)dealloc
{
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
    if ([AppDelegate App].myUserLoginMode.token)
    {
        
        noRecordImageView.frame = CGRectMake((self.frame.size.width-78)/2, (self.frame.size.height-118)/2, 78, 78);
        noRecordLabel.frame = CGRectMake((self.frame.size.width-200)/2, (self.frame.size.height-118)/2+88, 200, 30);
        if(self && self.delegate)
        {
            [self.delegate hideBottomView];
            [self.delegate hideNotWifiView];
            [self.delegate showMBProgressHUD];
        }
        currentpage = 0;
        
        myPlayEpisodeListMode = nil;
        judgeDate = [Commonality Date2day:[NSDate date]];
        categoryTimeState = 0;
        [HttpRequest PlayEpisodeListRequestToken:[AppDelegate App].myUserLoginMode.token page:1 rows:20 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }

}

-(void)GetErr:(ASIHTTPRequest *)request
{
    if (request.tag == PLAY_EPISODELIST_TYPE)
    {
        if (self && self.delegate)
        {
            [self.delegate hideMBProgressHUD];
            [self.delegate showNotWifiView];
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
        if (request.tag == PLAY_EPISODELIST_TYPE)
        {
            if (self && self.delegate)
            {
                [self.delegate hideMBProgressHUD];
                [self.delegate showNotWifiView];
            }
        }
    }else {
        if (self && self.delegate) {
            [self.delegate hideMBProgressHUD];
        }
        if (request.tag == PLAY_EPISODELIST_TYPE)
        {
            NSLog(@"Dic=%@",dictionary);

            myPlayEpisodeListMode = [[PlayEpisodeListMode alloc]initWithDictionary:dictionary];
            if (myPlayEpisodeListMode.errorCode == 0) {
                if (myPlayEpisodeListMode.pages == 0 && myPlayEpisodeListMode.counts == 0) {
                    [noRecordLabel setHidden:NO];
                    [noRecordImageView setHidden:NO];
                }else{
                    [noRecordLabel setHidden:YES];
                    [noRecordImageView setHidden:YES];
                }
                
                if (myPlayEpisodeListMode.counts>10) {
                    totalPage = 2;
                }else if(myPlayEpisodeListMode.counts<=10 && myPlayEpisodeListMode.counts >0){
                    totalPage = 1;
                }else if (myPlayEpisodeListMode.counts <= 0){
                    totalPage = 0;
                }
                
                [self makePageControl];
                [self makeContentScrollView];
                if ([self.delegate pageState] == PAGE_PLAYLIST) {
                    [self.delegate hideBottomView];
                    [self setHidden:NO];
                }
                
            }
            
        }

    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag==110) {
//        if (buttonIndex==1) {
//            //进入购买页面
//            if (self && self.delegate) {
//                [self.delegate buyVip];
//            }
//        }
//    }
//}

- (void)makePageControl
{
    myPageControl.numberOfPages = totalPage;
    [myPageControl setCurrentPage:0];
    if (iPad) {
        float pageControlWidth=(totalPage)*10.0f+40.f;
        float pagecontrolHeight=33.0f;
        myPageControl.frame = CGRectMake((VIEWHEIGHT-pageControlWidth)/2,600, pageControlWidth, pagecontrolHeight);
    }else{
        float pageControlWidth=(totalPage)*10.0f+20.f;
        float pagecontrolHeight=20.0f;
        myPageControl.frame = CGRectMake((VIEWHEIGHT-pageControlWidth)/2,250, pageControlWidth, pagecontrolHeight);
    }

    [myPageControl setHidden:NO];
}

- (void)makeContentScrollView
{
    if (playListScrollView) {
        [playListScrollView removeFromSuperview];
        playListScrollView = nil;
    }
    playListScrollView = [[UIScrollView alloc]init];
    if (iPad) {
        playListScrollView.frame  = CGRectMake(55, 20, 915, 549);
//        playListScrollView.backgroundColor = [UIColor blackColor];
        [playListScrollView setContentSize:CGSizeMake(915*totalPage, 549)];
    }else{
        playListScrollView.frame  = CGRectMake((VIEWHEIGHT-457)/2, 0, 457, 255);
        [playListScrollView setContentSize:CGSizeMake(457*totalPage, 255)];
    }
    
//    playListScrollView.clipsToBounds = NO;
    playListScrollView.delegate = self;
    playListScrollView.pagingEnabled = YES;
    playListScrollView.showsHorizontalScrollIndicator = NO;
    playListScrollView.showsVerticalScrollIndicator = NO;
    playListScrollView.scrollsToTop = NO;
    
    [self addSubview:playListScrollView];
    
    for (int i=0; i<totalPage; i++) {
        UIView* tempView;
        if (iPad) {
            tempView  = [[UIView alloc]initWithFrame:CGRectMake(915*i, 0, 915, 549)];
        }else{
            tempView  = [[UIView alloc]initWithFrame:CGRectMake(457*i, 0, 457, 255)];
        }
        
        tempView.backgroundColor = [UIColor clearColor];
        [tempView setTag:10000+i];
        [playListScrollView addSubview:tempView];
        [self makeContentView:i];
    }
}

- (void)makeContentView:(int)page
{
    UIView* tempContentView = (UIView*)[playListScrollView viewWithTag:10000+page];
    for (int i=page*(NumberOfLine*2); i<(page+1)*(NumberOfLine*2) && i< myPlayEpisodeListMode.list.count/*myPlayListMode.list.count*/; i++) {
        NSLog(@"i=%d",i);
//        ContentMode* tempContentMode = [myPlayListMode.list objectAtIndex:i];
        EpisodeMode* tempEpisodeMode = [myPlayEpisodeListMode.list objectAtIndex:i];
        
        NSDate* createTime = [Commonality dateFromString:(tempEpisodeMode.latestPlayTime)];

        NSArray *nibViews;
        if (iPad) {
            nibViews=[[NSBundle mainBundle] loadNibNamed:@"PlayListProgramView" owner:self options:nil];
        }else{
            nibViews=[[NSBundle mainBundle] loadNibNamed:@"PlayListProgramViewForiPhone" owner:self options:nil];
        }
        UIView* tempView = [nibViews objectAtIndex:0];
        [tempView setTag:(1000+i)];
        tempView.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
        tempView.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
        tempView.clipsToBounds = NO;
         tempView.exclusiveTouch = YES;

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
//        [subImageView setImageWithURL:[NSURL URLWithString:tempContentMode.contentImg] placeholderImage:[UIImage imageNamed:@"icon_75.png"]];
        [subImageView setImageWithURL:[NSURL URLWithString:tempEpisodeMode.contentImg] placeholderImage:[UIImage imageNamed:@"icon_75.png"]];
        
        UILabel* subLabel1 = (UILabel*)[tempView viewWithTag:101];
        subLabel1.text = [NSString stringWithFormat:@"观看到%d集",tempEpisodeMode.latestPlayEpisode];
        
        
        
        UILabel* subLabel2 = (UILabel*)[tempView viewWithTag:102];
        
//        subLabel2.text = tempContentMode.contentTitle;
        subLabel2.text = tempEpisodeMode.contentTitle;
        
        [tempContentView addSubview:tempView];
        
        if (iPad) {
            if (i<page*(NumberOfLine*2)+NumberOfLine) {
                tempView.frame = CGRectMake((167+16)*(i-page*(NumberOfLine*2))+8, 10, 167, 242);
            }else{
                tempView.frame = CGRectMake((167+16)*(i-page*(NumberOfLine*2)-NumberOfLine)+8, 297, 167, 242);
            }
            tempView.layer.cornerRadius = 24;
            tempView.layer.borderWidth = 3;
            subImageView.layer.cornerRadius = 18;
        }else{
            if (i<page*(NumberOfLine*2)+NumberOfLine) {
                tempView.frame = CGRectMake((83+8.4)*(i-page*(NumberOfLine*2))+4.2, 5, 83, 120);
            }else{
                tempView.frame = CGRectMake((83+8.4)*(i-page*(NumberOfLine*2)-NumberOfLine)+4.2, 135, 83, 120);
            }
            tempView.layer.cornerRadius = 12;
            tempView.layer.borderWidth = 1.5;
            subImageView.layer.cornerRadius = 9;
        }

        
        if ([createTime timeIntervalSinceDate:judgeDate]>=24*60*60) {
            
        }else{
            while (!(([createTime timeIntervalSinceDate:judgeDate]>0 && [createTime timeIntervalSinceDate:judgeDate]<24*60*60) || categoryTimeState == 4)) {
                categoryTimeState++;
                if (categoryTimeState == 4) {

                    UILabel* titleLabel = [self addTimeLabel:tempView withSuperView:tempContentView];
                    titleLabel.text = @"更早以前";
                    break;
                }else{
                    judgeDate = [judgeDate dateByAddingTimeInterval:(-24*60*60)];
                }
                
            }
            if (categoryTimeState < 4) {

                UILabel* titleLabel = [self addTimeLabel:tempView withSuperView:tempContentView];
                if (categoryTimeState == 0) {
                    titleLabel.text = @"今天";
                    judgeDate = [judgeDate dateByAddingTimeInterval:(-24*60*60)];
                    categoryTimeState = 1;
                }else if(categoryTimeState == 1){
                    titleLabel.text = @"昨天";
                    judgeDate = [judgeDate dateByAddingTimeInterval:(-24*60*60)];
                    categoryTimeState = 2;
                }else if(categoryTimeState == 2){
                    titleLabel.text = @"前天";
                    judgeDate = [judgeDate dateByAddingTimeInterval:(-24*60*60)];
                    categoryTimeState = 3;
                }else if(categoryTimeState == 3){
                    titleLabel.text = @"更早以前";
                    judgeDate = [judgeDate dateByAddingTimeInterval:(-24*60*60)];
                    categoryTimeState = 4;
                }
            }

        }

    }
}

- (UILabel*)addTimeLabel:(UIView*)view withSuperView:(UIView*)superView
{
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_03.png"];
//    [view.layer addSublayer:imageView.layer];
    [superView addSubview:imageView];
    
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 6, 70, 22)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [imageView addSubview:titleLabel];
    if (iPad) {
        imageView.frame = CGRectMake(view.frame.origin.x-4, view.frame.origin.y-6, 109, 34);
        titleLabel.frame = CGRectMake(30, 6, 70, 22);
        titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }else{
        imageView.frame = CGRectMake(view.frame.origin.x-2, view.frame.origin.y-3, 55, 17);
        titleLabel.frame = CGRectMake(15, 3, 35, 11);
        titleLabel.font = [UIFont boldSystemFontOfSize:7];
    }
    return titleLabel;
}

- (void)pressedView:(UIGestureRecognizer*)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        [[AppDelegate App]click];
        [self setFcous:sender.view];
        int index = sender.view.tag - 1000;
//        if (index >= 0 && index < myPlayListMode.list.count) {
//            if (self && self.delegate) {
//                [self.delegate showMBProgressHUD];
//            }
//            ContentMode* tempContentMode = [myPlayListMode.list objectAtIndex:index];
//            videoName = tempContentMode.contentTitle;
//            contentGuid = tempContentMode.contentGuid;
//            [HttpRequest ProductPlayRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
//        }
        [self enterContentEpisodeItemListView:index];
        [self blurFcous:sender.view];
    }else if([sender isKindOfClass:[UILongPressGestureRecognizer class]]){
        if (sender.state == UIGestureRecognizerStateBegan) {
            [[AppDelegate App]click];
            [self setFcous:sender.view];
        }else if(sender.state == UIGestureRecognizerStateEnded){
            [self blurFcous:sender.view];
            int index = sender.view.tag - 1000;
//            if (index >= 0 && index < myPlayListMode.list.count) {
//                if (self && self.delegate) {
//                    [self.delegate showMBProgressHUD];
//                }
//                ContentMode* tempContentMode = [myPlayListMode.list objectAtIndex:index];
//                videoName = tempContentMode.contentTitle;
//                contentGuid = tempContentMode.contentGuid;
//                [HttpRequest ProductPlayRequestToken:[AppDelegate App].myUserLoginMode.token contentGuid:contentGuid delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
//            }
            [self enterContentEpisodeItemListView:index];
        }
    
    }
}

- (void)enterContentEpisodeItemListView:(int)index
{
    EpisodeMode* tempContentMode = [myPlayEpisodeListMode.list objectAtIndex:index];
    ContentEpisodeItemListViewController* myContentEpisodeItemListViewController = [[ContentEpisodeItemListViewController alloc]init];
    myContentEpisodeItemListViewController.episodeGuid = tempContentMode.contentGuid;
    myContentEpisodeItemListViewController.langs = tempContentMode.langs;
    myContentEpisodeItemListViewController.latestPlayLang = tempContentMode.latestPlayLang;
    if (self && self.delegate) {
        [[self.delegate getNavigation] pushViewController:myContentEpisodeItemListViewController animated:NO];
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
//-(void)PlayerCallBack:(PlayerCallBackEventType)callBackEventType withParameter: (NSMutableDictionary *)callBackInfo
//{
//    [IVMallPlayer sharedIVMallPlayer].delegate=nil;
//    if (callBackEventType == PlayerWillPlaybackEnded) {
//        
//        
//    }else if(callBackEventType == PlayerUserExited){
//        NSLog(@"callBackInfo=%@",callBackInfo);
//        int playTime = [[callBackInfo objectForKey:@"time"]intValue];
//        NSString* preferenceKey1 = [NSString stringWithFormat:@"play.positon.%@",contentGuid];
//        NSString* preferenceValue1 = [NSString stringWithFormat:@"%d",playTime];
//        [HttpRequest UserPreferenceRequestToken:[AppDelegate App].myUserLoginMode.token preferenceKey:preferenceKey1 preferenceValue:preferenceValue1 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
//    }else if(callBackEventType == PlayerWillReturnFromDMRPlay){
//        [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterExitFromDMC object:@"YES"];
//        return;
//    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterExitFromDMC object:@"NO"];
//    [self show];
//}


#pragma scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == playListScrollView) {
        currentpage = scrollView.contentOffset.x/scrollView.frame.size.width;
        myPageControl.currentPage = currentpage;
    }
    
}

@end
