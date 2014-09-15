//
//  ChannelCatContentListView.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ChannelCatContentListView.h"
#import "Macro.h"
#import "HttpRequest.h"
#import "Commonality.h"
#import "AppDelegate.h"
#import "ChannelCatContentListMode.h"
#import "UIImageView+WebCache.h"
#define NumberOfLine 5
@implementation ChannelCatContentListView
{
    UIScrollView*   contentListScrollView;
    UIPageControl*  myPageControl;
    int             totalPage;
    int             currentpage;
    ChannelCatContentListMode* myChannelCatContentListMode;
    NSMutableArray* list;
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
    if (_categoryId == nil) {
        return;
    }
    if (self && self.delegate) {
        [self.delegate hideBottomView];
        [self.delegate showMBProgressHUD];
    }
    currentpage = 0;
    list = nil;
    list = [[NSMutableArray alloc]init];
    [HttpRequest ChannelCatContentListRequestToken:[AppDelegate App].myUserLoginMode.token categoryId:_categoryId index:currentpage*NumberOfLine*2 offset:NumberOfLine*2 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}


-(void)GetErr:(ASIHTTPRequest *)request
{
    if (request.tag%PAGESECTION == CHANNEL_CATCONTENTLIST_TYPE)
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
        if (request.tag%PAGESECTION == CHANNEL_CATCONTENTLIST_TYPE)
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
        if (request.tag%PAGESECTION == CHANNEL_CATCONTENTLIST_TYPE) {
            if (request.tag == CHANNEL_CATCONTENTLIST_TYPE) {
                myChannelCatContentListMode = [[ChannelCatContentListMode alloc]initWithDictionary:dictionary modelList:list startIndex:0];
                if (myChannelCatContentListMode.errorCode == 0) {
                    
                    for (int i=list.count; i< myChannelCatContentListMode.counts; i++) {
                        [list addObject:[[CatContentMode alloc]init]];
                    }
                    if (myChannelCatContentListMode.counts % (NumberOfLine*2) == 0) {
                        totalPage = myChannelCatContentListMode.counts/(NumberOfLine*2);
                    }else{
                        totalPage = myChannelCatContentListMode.counts/(NumberOfLine*2)+1;
                    }
                    [self makePageControl];
                    [self makeContentScrollView];
                    [self makeContentView:0];
                    if ([self.delegate pageState] == PAGE_CATEGORY) {
                        [self.delegate hideBottomView];
                        [self.delegate hideNotWifiView];
                        [self setHidden:NO];
                    }
                }
            }
            else{
                currentpage = request.tag/PAGESECTION;
                myChannelCatContentListMode = [[ChannelCatContentListMode alloc]initWithDictionary:dictionary modelList:list startIndex:currentpage*(NumberOfLine*2)];
                [self makeContentView:currentpage];
            }
        }
    }
}

- (void)makePageControl
{
    myPageControl.numberOfPages = totalPage;
    [myPageControl setCurrentPage:0];

    if (iPad) {
        float pageControlWidth=(totalPage)*20.0f+40.f;
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
    if (contentListScrollView) {
        [contentListScrollView removeFromSuperview];
        contentListScrollView = nil;
    }
    contentListScrollView = [[UIScrollView alloc]init];
    if (iPad) {
        contentListScrollView.frame  = CGRectMake(55, 20, 915, 539);
        [contentListScrollView setContentSize:CGSizeMake(915*totalPage, 539)];
    }else{
        contentListScrollView.frame  = CGRectMake((VIEWHEIGHT-457)/2, 0, 457, 250);
        [contentListScrollView setContentSize:CGSizeMake(457*totalPage, 250)];
    }
    
    contentListScrollView.delegate = self;
    contentListScrollView.pagingEnabled = YES;
    contentListScrollView.showsHorizontalScrollIndicator = NO;
    contentListScrollView.showsVerticalScrollIndicator = NO;
    contentListScrollView.scrollsToTop = NO;
    
    [self addSubview:contentListScrollView];
    for (int i=0; i<totalPage; i++) {
        UIView* tempView;
        if (iPad) {
            tempView = [[UIView alloc]initWithFrame:CGRectMake(915*i, 0, 915, 539)];
        }else{
            tempView = [[UIView alloc]initWithFrame:CGRectMake(457*i, 0, 457, 250)];
        }
        
        tempView.backgroundColor = [UIColor clearColor];
        [tempView setTag:10000+i];
        [contentListScrollView addSubview:tempView];

    }
}
- (void)showPage:(int)number
{
    //zjj
     NSLog(@"number=%d",number);
    currentpage = number;
    CatContentMode* temp = [list objectAtIndex:(number*(NumberOfLine*2))];
    //zjj
//    if (number*(NumberOfLine*2)>=list.count)
    if (temp.contentGuid == nil)
    {
        if (self && self.delegate) {
            [self.delegate showMBProgressHUD];
        }
    [HttpRequest ChannelCatContentListRequestToken:[AppDelegate App].myUserLoginMode.token categoryId:_categoryId index:currentpage*(NumberOfLine*2) offset:(NumberOfLine*2) delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}

- (void)makeContentView:(int)page
{
    UIView* tempContentView = (UIView*)[contentListScrollView viewWithTag:10000+page];
    for (int i=page*(NumberOfLine*2); i<(page+1)*(NumberOfLine*2) && i< list.count; i++) {
        CatContentMode* tempCatContentMode = [list objectAtIndex:i];
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
        longGesture.minimumPressDuration = 0.1;
        [tempView addGestureRecognizer:longGesture];
        
        [tapGesture requireGestureRecognizerToFail:longGesture];
        // add zjj
        
        UIImageView* subImageView = (UIImageView*)[tempView viewWithTag:100];

        subImageView.layer.masksToBounds = YES;
        [subImageView setImageWithURL:[NSURL URLWithString:tempCatContentMode.contentImg] placeholderImage:[UIImage imageNamed:@"icon_75.png"]];
        
        UILabel* subLabel1 = (UILabel*)[tempView viewWithTag:101];
        subLabel1.backgroundColor = [Commonality colorFromHexRGB:@"ff7800"];
        subLabel1.text = [NSString stringWithFormat:@"共%d集",tempCatContentMode.episodeCount];
        
        UILabel* subLabel2 = (UILabel*)[tempView viewWithTag:102];
        
        subLabel2.text = tempCatContentMode.contentTitle;
        
        [tempContentView addSubview:tempView];
        if (iPad) {
            if (i<page*(NumberOfLine*2)+NumberOfLine) {
                tempView.frame = CGRectMake((167+16)*(i-page*(NumberOfLine*2))+8, 0, 167, 242);
            }else{
                tempView.frame = CGRectMake((167+16)*(i-page*(NumberOfLine*2)-NumberOfLine)+8, 287, 167, 242);
            }
            tempView.layer.cornerRadius = 24;
            tempView.layer.borderWidth = 3;
            subImageView.layer.cornerRadius = 18;
        }else{
            if (i<page*(NumberOfLine*2)+NumberOfLine) {
                tempView.frame = CGRectMake((83+8.4)*(i-page*(NumberOfLine*2))+4.2, 0, 83, 120);
            }else{
                tempView.frame = CGRectMake((83+8.4)*(i-page*(NumberOfLine*2)-NumberOfLine)+4.2, 130, 83, 120);
            }
            tempView.layer.cornerRadius = 12;
            tempView.layer.borderWidth = 1.5;
            subImageView.layer.cornerRadius = 9;
        }

    }
}

- (void)pressedView:(UITapGestureRecognizer*)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        [[AppDelegate App]click];
        [self setFcous:sender.view];
        int index = sender.view.tag - 1000;
        if (index>=0 && index<list.count) {
            CatContentMode* tempContentMode = [list objectAtIndex:index];
            ContentEpisodeItemListViewController* myContentEpisodeItemListViewController = [[ContentEpisodeItemListViewController alloc]init];
            myContentEpisodeItemListViewController.episodeGuid = tempContentMode.contentGuid;
            myContentEpisodeItemListViewController.langs = tempContentMode.langs;
            myContentEpisodeItemListViewController.latestPlayLang = nil;
            if (self && self.delegate) {
                [[self.delegate getNavigation] pushViewController:myContentEpisodeItemListViewController animated:NO];
            }
            
        }
        [self blurFcous:sender.view];
    }else if([sender isKindOfClass:[UILongPressGestureRecognizer class]]){
        if (sender.state == UIGestureRecognizerStateBegan) {
            [[AppDelegate App]click];
            [self setFcous:sender.view];
        }else if(sender.state == UIGestureRecognizerStateEnded){
            [self blurFcous:sender.view];
            int index = sender.view.tag - 1000;
            if (index>=0 && index<list.count) {
                CatContentMode* tempContentMode = [list objectAtIndex:index];
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

#pragma scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == contentListScrollView) {
        currentpage = scrollView.contentOffset.x/scrollView.frame.size.width;
        myPageControl.currentPage = currentpage;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentpage = scrollView.contentOffset.x/scrollView.frame.size.width;
    myPageControl.currentPage = currentpage;
        NSLog(@"currentpage=%d",currentpage);
    [self showPage:currentpage];
}
@end
