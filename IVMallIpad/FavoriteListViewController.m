//
//  FavoriteListViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "FavoriteListViewController.h"
#import "FavoriteListModel.h"
#import "HttpRequest.h"
#import "AppDelegate.h"
#import "Macro.h"
#import "Commonality.h"
#import "UIImageView+WebCache.h"

#define NumberOfLine 4

@interface FavoriteListViewController ()
{
    UIScrollView*   contentListScrollView;
    UIPageControl*  myPageControl;
    int             totalPage;
    int             currentpage;
    FavoriteListModel* myFavoriteListModel;
    NSMutableArray* list;

    UIView* oFavoriteView;
    NotWiFiView* myNotWiFiView;
}

@end

@implementation FavoriteListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self installNotificationObserver];
    
    myNotWiFiView = [[NotWiFiView alloc]init];
    [myNotWiFiView setNotWiFiStyle:Dialog1NotWiFi];
    myNotWiFiView.delegate = self;
    [myNotWiFiView setHidden:YES];
    [_bgView addSubview:myNotWiFiView];
    
    
    myMBProgressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:myMBProgressHUD];
    myMBProgressHUD.labelText = @"正在获取数据";
    
    currentpage = 0;
    list = nil;
    list = [[NSMutableArray alloc]init];
    [HttpRequest FavoriteListRequestToken:[AppDelegate App].myUserLoginMode.token page:currentpage rows:8 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    [myMBProgressHUD show:YES];

    // Do any additional setup after loading the view from its nib.
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

-(void)GetErr:(ASIHTTPRequest *)request
{
    if (request.tag%PAGESECTION == FAVORITE_LIST_TYPE)
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
        if (request.tag%PAGESECTION == FAVORITE_LIST_TYPE)
        {
            [myMBProgressHUD hide:YES];
            _bgView.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
            myNotWiFiView.hidden = NO;
             [_bgView bringSubviewToFront:myNotWiFiView];
        }
    }else {
        [myMBProgressHUD hide:YES];
        if (request.tag%PAGESECTION == FAVORITE_LIST_TYPE) {
            if (request.tag == FAVORITE_LIST_TYPE) {//第一页
                myFavoriteListModel = [[FavoriteListModel alloc]initWithDictionary:dictionary modelList:list page:1];
                if (list.count == 0) {
                    [self makeOFavoriteView];
                }else{
                    if (oFavoriteView) {
                        [self removeOFavoriteView];
                    }
                    if (myFavoriteListModel.result == 0) {
                        totalPage = myFavoriteListModel.pages;
                        
                        for (int i=list.count; i< myFavoriteListModel.counts; i++) {
                            [list addObject:[[FavoriteListModel alloc]init]];
                        }
                        
                        [self makeContentScrollView];
                        [self makeContentView:0];
                        [self makePageControl];
                        
                        [_bgView setHidden:NO];
                    }
                }
            }else{
                currentpage = request.tag/PAGESECTION;
                myFavoriteListModel = [[FavoriteListModel alloc]initWithDictionary:dictionary modelList:list page:currentpage + 1];
                [self makeContentView:currentpage];
            }
        }
    }
}
-(void)makeOFavoriteView
{
    oFavoriteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 385, 260)];
    [_bgView addSubview:oFavoriteView];
    
    UIImageView* oFavoriteImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shoucang_.png"]];
    oFavoriteImgView.frame = CGRectMake((_bgView.frame.size.width - 178/2.0)/2.0, (_bgView.frame.size.height - 154/2.0)/2.0, 178/2.0, 154/2.0);
    [oFavoriteView addSubview:oFavoriteImgView];

    UILabel* oFavoriteLabel = [[UILabel alloc]initWithFrame:CGRectMake((_bgView.frame.size.width - 200)/2.0, (_bgView.frame.size.height + 154/2.0)/2.0 + 15, 200, 20)];
    oFavoriteLabel.textAlignment = NSTextAlignmentCenter;
    oFavoriteLabel.font = [UIFont systemFontOfSize:(iPad?20:15)];
    oFavoriteLabel.text = @"您还没有收藏任何视频";
    [oFavoriteView addSubview:oFavoriteLabel];
}
-(void)removeOFavoriteView
{
    [oFavoriteView removeFromSuperview];
    oFavoriteView = nil;
}

- (void)makePageControl
{
    myPageControl = [[UIPageControl alloc]init];
    myPageControl.pageIndicatorTintColor=[Commonality colorFromHexRGB:@"96aa76"];
    myPageControl.currentPageIndicatorTintColor=[Commonality colorFromHexRGB:@"ff7900"];
    myPageControl.numberOfPages = totalPage;
    [myPageControl setCurrentPage:0];
    
    float pageControlWidth=(iPad?(totalPage)*10.0f + 40.f:(totalPage)*60.0f + 20.f);
    float pagecontrolHeight=(iPad?33.0f:15.0f);
    if (iPad) {
        myPageControl.frame = CGRectMake((760-pageControlWidth)/2, 500, pageControlWidth, pagecontrolHeight);
    }else{
        myPageControl.frame = CGRectMake((385-pageControlWidth)/2, 240, pageControlWidth, pagecontrolHeight);
    }
    [myPageControl setHidden:NO];
    
    [_bgView addSubview:myPageControl];

}

- (void)makeContentScrollView
{
    if (contentListScrollView) {
        [contentListScrollView removeFromSuperview];
        contentListScrollView = nil;
    }
    
    if (iPad) {
        contentListScrollView = [[UIScrollView alloc]init];
        contentListScrollView.frame  = CGRectMake(30, 75, 700, 430);
        [contentListScrollView setContentSize:CGSizeMake(700*totalPage, 430)];
        
    }else{
        contentListScrollView = [[UIScrollView alloc]init];
        contentListScrollView.frame  = CGRectMake(20, 40, 350, 205);
        [contentListScrollView setContentSize:CGSizeMake((350)*totalPage, 205)];
    }
    contentListScrollView.delegate = self;
    contentListScrollView.pagingEnabled = YES;
    contentListScrollView.showsHorizontalScrollIndicator = NO;
    contentListScrollView.showsVerticalScrollIndicator = NO;
    contentListScrollView.scrollsToTop = NO;
    
    [_bgView addSubview:contentListScrollView];
    
    for (int i=0; i<totalPage; i++) {
        UIView* tempView = [[UIView alloc]initWithFrame:CGRectMake((iPad?700:350)*i, 0, (iPad?700:350), (iPad?430:205))];
        tempView.backgroundColor = [UIColor clearColor];
        [tempView setTag:10000+i];
        [contentListScrollView addSubview:tempView];
    }
}
- (void)showPage:(int)number
{
    NSLog(@"number=%d",number);
    currentpage = number;
    FavoriteListModel* temp = [list objectAtIndex:(number*(NumberOfLine*2))];
    
//    if (number*(NumberOfLine*2)>=list.count) {
    if (temp.favID == nil) {
        
        [myMBProgressHUD show:YES];
        [HttpRequest FavoriteListRequestToken:[AppDelegate App].myUserLoginMode.token page:currentpage rows:8 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}

- (void)makeContentView:(int)page
{
    UIView* tempContentView = (UIView*)[contentListScrollView viewWithTag:10000+page];
    for (int i=page*(NumberOfLine*2); i<(page+1)*(NumberOfLine*2) && i< list.count; i++) {
        FavoriteListModel* tempFavoMod = [list objectAtIndex:i];
        NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:[NSString xibName:@"FavoriteCell"] owner:self options:nil];
        
        UIView* tempView = [nibViews objectAtIndex:0];
        [tempView setTag:(1000+i)];
        tempView.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
        tempView.layer.cornerRadius = (iPad?24:9);
        tempView.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
        tempView.layer.borderWidth = (iPad?3:1.8);
         tempView.exclusiveTouch = YES;
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedView:)];
        [tempView addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer* longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressedView:)];
        [tempView addGestureRecognizer:longGesture];
        
        [tapGesture requireGestureRecognizerToFail:longGesture];

        
        UIImageView* subImageView = (UIImageView*)[tempView viewWithTag:100];
        subImageView.layer.cornerRadius = (iPad?18:9);
        subImageView.layer.masksToBounds = YES;
        [subImageView setImageWithURL:[NSURL URLWithString:tempFavoMod.contentImg] placeholderImage:[UIImage imageNamed:@"icon_250*352.png"]];
        if (iPad) {
        }
        
        UILabel* subLabel = (UILabel*)[tempView viewWithTag:101];
        subLabel.text = tempFavoMod.contentTitle;
        
        [tempContentView addSubview:tempView];
        if (iPad) {
            if (i<page*(NumberOfLine*2)+NumberOfLine) {
                tempView.frame = CGRectMake((135+48)*(i-page*(NumberOfLine*2))+8, 0, 135, 176);
            }else{
                tempView.frame = CGRectMake((135+48)*(i-page*(NumberOfLine*2)-NumberOfLine)+8, 220, 135, 176);
            }
        }else{
            if (i<page*(NumberOfLine*2)+NumberOfLine) {
                tempView.frame = CGRectMake((63 + 18)*(i-page*(NumberOfLine*2))+22, 0, 63, 84);
            }else{
                tempView.frame = CGRectMake((63 + 18)*(i-page*(NumberOfLine*2)-NumberOfLine)+22, 105, 63, 84);
            }
        }
    }
}

- (void)pressedView:(UITapGestureRecognizer*)sender
{

    int index = sender.view.tag - 1000;
    
    
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        if (index>=0 && index<list.count) {
            [[AppDelegate App]click];
            FavoriteListModel* tempFavoMod = [list objectAtIndex:index];
            ContentEpisodeItemListViewController* myContentEpisodeItemListViewController = [[ContentEpisodeItemListViewController alloc]init];
            myContentEpisodeItemListViewController.episodeGuid = tempFavoMod.contentGuid;
            myContentEpisodeItemListViewController.langs = tempFavoMod.langs;
            [self.navigationController pushViewController:myContentEpisodeItemListViewController animated:NO];
        }
    }else if([sender isKindOfClass:[UILongPressGestureRecognizer class]]){
        if (sender.state == UIGestureRecognizerStateBegan) {
            [[AppDelegate App]click];
            [self setFcous:sender.view];
        }else if(sender.state == UIGestureRecognizerStateEnded){
            [self blurFcous:sender.view];
            int index = sender.view.tag - 1000;
            if (index>=0 && index<list.count) {
                [[AppDelegate App]click];
                FavoriteListModel* tempFavoMod = [list objectAtIndex:index];
                ContentEpisodeItemListViewController* myContentEpisodeItemListViewController = [[ContentEpisodeItemListViewController alloc]init];
                myContentEpisodeItemListViewController.episodeGuid = tempFavoMod.contentGuid;
                myContentEpisodeItemListViewController.langs = tempFavoMod.langs;
                [self.navigationController pushViewController:myContentEpisodeItemListViewController animated:NO];
            }
        }
    }
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
    [self showPage:currentpage];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteSelectedItems:(id)sender {
}

- (IBAction)deleteAllItems:(id)sender {
}

- (IBAction)close:(id)sender {
        [[AppDelegate App]click];
        [self uninstallNotificationObserver];
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)refresh
{
    
    _bgView.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
    
    currentpage = 0;
    list = nil;
    list = [[NSMutableArray alloc]init];
    [HttpRequest FavoriteListRequestToken:[AppDelegate App].myUserLoginMode.token page:currentpage rows:8 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    [myMBProgressHUD show:YES];
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

-(void)dealloc
{
//    [self uninstallNotificationObserver];
}

#pragma mark observer
-(void)installNotificationObserver
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doSth) name:NSNotificationCenterContentCollectAction object:nil];
}
-(void)uninstallNotificationObserver
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)doSth
{
    currentpage = 0;
    list = nil;
    list = [[NSMutableArray alloc]init];
    [HttpRequest FavoriteListRequestToken:[AppDelegate App].myUserLoginMode.token page:currentpage rows:8 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    [myMBProgressHUD show:YES];

}
@end
