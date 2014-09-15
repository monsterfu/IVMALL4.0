//
//  PlayEpisodeListViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-8-28.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "PlayEpisodeListViewController.h"
#import "Macro.h"
#import "HttpRequest.h"
#import "Commonality.h"
#import "AppDelegate.h"
#import "PlayListModel.h"
#import "UIImageView+WebCache.h"

#import "PlayEpisodeListMode.h"
#import "MBProgressHUD.h"
#import "NotWiFiView.h"
#import "ContentEpisodeItemListViewController.h"
#define NumberOfLine 4
@interface PlayEpisodeListViewController ()<UIScrollViewDelegate,MainViewRefershDelegate>

@end

@implementation PlayEpisodeListViewController
{
    UIScrollView*   playListScrollView;
    UIPageControl*  myPageControl;
    int             totalPage;
    int             currentpage;
    
    NSDate* judgeDate;
    int categoryTimeState;//0 今天,1 昨天,2 前天, 3更早以前,4不处理
    

    
    PlayEpisodeListMode* myPlayEpisodeListMode;
    
    MBProgressHUD* myMBProgressHUD;
    NotWiFiView* myNotWiFiView;
    UIView* oFavoriteView;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:NSNotificationCenterPlayVideo object:nil];
    }
    return self;
}

- (void)refresh
{
    if ([AppDelegate App].myUserLoginMode.token)
    {
        currentpage = 0;
        myPlayEpisodeListMode = nil;
        judgeDate = [Commonality Date2day:[NSDate date]];
        categoryTimeState = 0;
        [HttpRequest PlayEpisodeListRequestToken:[AppDelegate App].myUserLoginMode.token page:1 rows:20 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        [myMBProgressHUD show:YES];
    }
    
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterPlayVideo object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    myPageControl = [[UIPageControl alloc]init];
    myPageControl.pageIndicatorTintColor=[Commonality colorFromHexRGB:@"96aa79"];
    myPageControl.currentPageIndicatorTintColor=[Commonality colorFromHexRGB:@"ff7900"];
    [_bgView addSubview:myPageControl];
    [myPageControl setHidden:YES];
    
    myNotWiFiView = [[NotWiFiView alloc]init];
    [myNotWiFiView setNotWiFiStyle:Dialog1NotWiFi];
    myNotWiFiView.delegate = self;
    [myNotWiFiView setHidden:YES];
    [_bgView addSubview:myNotWiFiView];
    
    
    myMBProgressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:myMBProgressHUD];
    myMBProgressHUD.labelText = @"正在获取数据";
    
    if ([AppDelegate App].myUserLoginMode.token)
    {
        currentpage = 0;
        myPlayEpisodeListMode = nil;
        judgeDate = [Commonality Date2day:[NSDate date]];
        categoryTimeState = 0;
        [HttpRequest PlayEpisodeListRequestToken:[AppDelegate App].myUserLoginMode.token page:1 rows:20 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        [myMBProgressHUD show:YES];
    }

}

-(void)makeOFavoriteView
{

    oFavoriteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 385, 260)];
    [_bgView addSubview:oFavoriteView];
    
    UIImageView* noRecordImageView = [[UIImageView alloc]init];
    noRecordImageView.image = [UIImage imageNamed:@"time_.png"];
    [oFavoriteView addSubview:noRecordImageView];
    
    UILabel* noRecordLabel = [[UILabel alloc]init];
    noRecordLabel.backgroundColor = [UIColor clearColor];
    noRecordLabel.text = @"您还没有观看记录";
    noRecordLabel.textColor = [UIColor whiteColor];
    noRecordLabel.textAlignment = NSTextAlignmentCenter;
    [oFavoriteView addSubview:noRecordLabel];
    

}
-(void)removeOFavoriteView
{
    [oFavoriteView removeFromSuperview];
    oFavoriteView = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
    [self.view bringSubviewToFront:_closeBtn];
    if ([self.navigationController childViewControllers].count >2) {
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_07-18.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_07-19.png"] forState:UIControlStateHighlighted];
    }else{
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close_sel.png"] forState:UIControlStateHighlighted];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)GetErr:(ASIHTTPRequest *)request
{
    if (request.tag == PLAY_EPISODELIST_TYPE)
    {
        [myMBProgressHUD hide:YES];
        
        _bgView.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
        myNotWiFiView.hidden = NO;
        [_bgView bringSubviewToFront:myNotWiFiView];
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
            [myMBProgressHUD hide:YES];
            
            _bgView.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
            myNotWiFiView.hidden = NO;
            [_bgView bringSubviewToFront:myNotWiFiView];
        }
    }else {
        [myMBProgressHUD hide:YES];
        if (request.tag == PLAY_EPISODELIST_TYPE)
        {
            NSLog(@"Dic=%@",dictionary);
            
            myPlayEpisodeListMode = [[PlayEpisodeListMode alloc]initWithDictionary:dictionary];
            if (myPlayEpisodeListMode.errorCode == 0) {
                if (myPlayEpisodeListMode.pages == 0 && myPlayEpisodeListMode.counts == 0) {
                    [self makeOFavoriteView];
                }else{
                    [self removeOFavoriteView];
                }
                
                if (myPlayEpisodeListMode.list.count%8 == 0) {
                    totalPage = myPlayEpisodeListMode.list.count/8;
                }else{
                    totalPage = myPlayEpisodeListMode.list.count/8+1;
                }
                
                [self makePageControl];
                [self makeContentScrollView];

                [_bgView setHidden:NO];
            }
            
        }
        
    }
}

- (void)makePageControl
{
    myPageControl.numberOfPages = totalPage;
    [myPageControl setCurrentPage:0];
    if (iPad) {
        float pageControlWidth=(totalPage)*10.0f+40.f;
        float pagecontrolHeight=33.0f;
        myPageControl.frame = CGRectMake((760-pageControlWidth)/2, 500, pageControlWidth, pagecontrolHeight);
    }else{
        float pageControlWidth=(totalPage)*10.0f+20.f;
        float pagecontrolHeight=20.0f;
        myPageControl.frame = CGRectMake((385-pageControlWidth)/2, 240, pageControlWidth, pagecontrolHeight);
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
        playListScrollView.frame  = CGRectMake(30, 75, 700, 430);
        [playListScrollView setContentSize:CGSizeMake(700*totalPage, 430)];
    }else{
        playListScrollView.frame  = CGRectMake((VIEWHEIGHT-457)/2, 0, 457, 255);
        [playListScrollView setContentSize:CGSizeMake(457*totalPage, 255)];
    }

    playListScrollView.delegate = self;
    playListScrollView.pagingEnabled = YES;
    playListScrollView.showsHorizontalScrollIndicator = NO;
    playListScrollView.showsVerticalScrollIndicator = NO;
    playListScrollView.scrollsToTop = NO;
    
    [_bgView addSubview:playListScrollView];
    
    for (int i=0; i<totalPage; i++) {
        UIView* tempView;
        if (iPad) {
            tempView  = [[UIView alloc]initWithFrame:CGRectMake(700*i, 0, 700, 430)];
        }else{
            tempView  = [[UIView alloc]initWithFrame:CGRectMake(350*i, 0, 350, 305)];
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
    for (int i=page*(NumberOfLine*2); i<(page+1)*(NumberOfLine*2) && i< myPlayEpisodeListMode.list.count; i++) {
        NSLog(@"i=%d",i);
        EpisodeMode* tempEpisodeMode = [myPlayEpisodeListMode.list objectAtIndex:i];
        
        NSDate* createTime = [Commonality dateFromString:(tempEpisodeMode.latestPlayTime)];
        
        NSArray *nibViews;
        if (iPad) {
            nibViews=[[NSBundle mainBundle] loadNibNamed:@"FavoriteCell" owner:self options:nil];
        }else{
            nibViews=[[NSBundle mainBundle] loadNibNamed:@"FavoriteCell_IPhone" owner:self options:nil];
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
        [subImageView setImageWithURL:[NSURL URLWithString:tempEpisodeMode.contentImg] placeholderImage:[UIImage imageNamed:@"icon_250_352.png"]];
        
        UILabel* subLabel1 = (UILabel*)[tempView viewWithTag:102];
        [subLabel1 setHidden:NO];
        
        UILabel* subLabel3 = (UILabel*)[tempView viewWithTag:103];
        [subLabel3 setHidden:NO];
        subLabel3.text = [NSString stringWithFormat:@"观看至第%d集",tempEpisodeMode.latestPlayEpisode];
        
        
        
        UILabel* subLabel2 = (UILabel*)[tempView viewWithTag:101];
        
        //        subLabel2.text = tempContentMode.contentTitle;
        subLabel2.text = tempEpisodeMode.contentTitle;
        
        [tempContentView addSubview:tempView];
        
        if (iPad) {
            if (i<page*(NumberOfLine*2)+NumberOfLine) {
                tempView.frame = CGRectMake((135+48)*(i-page*(NumberOfLine*2))+8, 10, 135, 176);
            }else{
                tempView.frame = CGRectMake((135+48)*(i-page*(NumberOfLine*2)-NumberOfLine)+8, 220, 135, 176);
            }
            tempView.layer.cornerRadius = 24;
            tempView.layer.borderWidth = 3;
            subImageView.layer.cornerRadius = 18;
        }else{
            if (i<page*(NumberOfLine*2)+NumberOfLine) {
                tempView.frame = CGRectMake((63 + 18)*(i-page*(NumberOfLine*2))+22, 5, 63, 84);
            }else{
                tempView.frame = CGRectMake((63 + 18)*(i-page*(NumberOfLine*2)-NumberOfLine)+22, 105, 63, 84);
            }
            tempView.layer.cornerRadius = 12;
            tempView.layer.borderWidth = 1.8;
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
    [superView addSubview:imageView];
    
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [imageView addSubview:titleLabel];
    if (iPad) {
        imageView.frame = CGRectMake(view.frame.origin.x-5, view.frame.origin.y-6, 95, 40);
        titleLabel.frame = CGRectMake(27, 4, 70, 22);
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
        [self enterContentEpisodeItemListView:index];
        [self blurFcous:sender.view];
    }else if([sender isKindOfClass:[UILongPressGestureRecognizer class]]){
        if (sender.state == UIGestureRecognizerStateBegan) {
            [[AppDelegate App]click];
            [self setFcous:sender.view];
        }else if(sender.state == UIGestureRecognizerStateEnded){
            [self blurFcous:sender.view];
            int index = sender.view.tag - 1000;
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
    [self.navigationController pushViewController:myContentEpisodeItemListViewController animated:NO];
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

- (IBAction)close:(id)sender {
    [[AppDelegate App]click];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterPlayVideo object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == playListScrollView) {
        currentpage = scrollView.contentOffset.x/scrollView.frame.size.width;
        myPageControl.currentPage = currentpage;
    }
    
}

@end
