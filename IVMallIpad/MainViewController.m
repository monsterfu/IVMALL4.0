//
//  MainViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "MainViewController.h"

#import "Macro.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "HttpRequest.h"
#import "ChannelCategoryListMode.h"
#import "Commonality.h"

#import "ChannelCatContentListView.h"
#import "PlayListView.h"
#import "PersonalCenterView.h"
#import "MBProgressHUD.h"
#import "PopUpViewController.h"
@interface MainViewController ()
{
    ChannelCategoryListMode* myChannelcategoryListMode;
    UIImageView* cloudImageView;
    UIButton* selectedButton;//选中的分类
    
    
    
    //页面
    IndexFeaturedHomeView* myIndexFeaturedHomeView;
    ChannelCatContentListView* myChannelCatContentListView;
    PersonalCenterView* myPersonalCenterView;
    PlayListView* myPlayListView;
    NotWiFiView* myNotWiFiView;
    MBProgressHUD* myMBProgressHUD;
    
    PagesStateEnum myPage;
    
    BOOL statusBarHidder;               //状态条是否隐藏，在iOS7中使用
    
    
//    NSString* selectedCategoryID;
//    CategoryMode* selectedMode;
//    UIButton* sixButton;
//    
//    UIView*      myRemainingCategoryView;
//    UITableView* myRemainingCategoryTableView;
//    UIImageView* currentFlag;
//    UIView* remainningBackGroundView;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afterLogin:) name:NSNotificationCenterAfterLoginInSuccess object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UserImagehadGet:) name:NSNotificationCenterUserImage object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ifShowWifiSetUpButton:) name:NSNotificationCenterExitFromDMC object:nil];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)hideStatubar
{
    if (IOS7)
    {
        statusBarHidder = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterAfterLoginInSuccess object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterUserImage object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterExitFromDMC object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //自定义头像
    if (IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    cloudImageView = [[UIImageView alloc]init];
    _UserDefinedPhotoImageView.layer.masksToBounds = YES;
    if(iPad){
        _UserDefinedPhotoImageView.layer.cornerRadius = 30;
    }else {
        _UserDefinedPhotoImageView.layer.cornerRadius = 15;
        if (iPhone5) {
            _myBackgroundImageView.image = [UIImage imageNamed:@"iphone_bg.png"];
            _UserDefinedPhotoImageView.frame = CGRectMake(9, 10, 40, 40);
            _UserDefinedPhotoImageView.layer.cornerRadius = 20;
            _personalCenterButton.frame = CGRectMake(6, 7, 48, 48);
        }
    }
    _UserDefinedPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _UserDefinedPhotoImageView.layer.borderWidth = 0.0f;
    _UserDefinedPhotoImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _UserDefinedPhotoImageView.layer.shouldRasterize = YES;
    _UserDefinedPhotoImageView.clipsToBounds = YES;
    _UserDefinedPhotoImageView.userInteractionEnabled = YES;
    
    //进入个人中心按钮
    [_personalCenterButton addTarget:self action:@selector(enterPersonalCenterView:) forControlEvents:UIControlEventTouchUpInside];

    //进入wifiSetUp页面
    [_WifiSetupButton addTarget:self action:@selector(enterWifiSetUpView:) forControlEvents:UIControlEventTouchUpInside];
    [_WifiSetupButton setHidden:YES];
    
    
    //显示剩余分类页面
//    [_categoryListButton addTarget:self action:@selector(showRemainingView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    myIndexFeaturedHomeView = [[IndexFeaturedHomeView alloc]init];
    myIndexFeaturedHomeView.delegate = self;
    myChannelCatContentListView = [[ChannelCatContentListView alloc]init];
    myChannelCatContentListView.delegate = self;
    myPersonalCenterView = [[PersonalCenterView alloc]init];
    myPersonalCenterView.delegate = self;

    
    myNotWiFiView = [[NotWiFiView alloc]init];
    [myNotWiFiView setNotWiFiStyle:MainViewNotWiFi];
    if (iPad) {
        myIndexFeaturedHomeView.frame = CGRectMake(0, 107, VIEWHEIGHT, VIEWWIDTH-110);
        myChannelCatContentListView.frame = CGRectMake(0, 107, VIEWHEIGHT, VIEWWIDTH-110);
        myPersonalCenterView.frame = CGRectMake(0, 100, VIEWHEIGHT, VIEWWIDTH-100);
    }else {
        myIndexFeaturedHomeView.frame = CGRectMake(0, 50, VIEWHEIGHT, VIEWWIDTH-50);
        myChannelCatContentListView.frame = CGRectMake(0, 50, VIEWHEIGHT, VIEWWIDTH-50);
        myPersonalCenterView.frame = CGRectMake(0, 50, VIEWHEIGHT, VIEWWIDTH-50);

    }
    myNotWiFiView.delegate = self;
    
    [myIndexFeaturedHomeView setHidden:YES];
    [myChannelCatContentListView setHidden:YES];
    [myPersonalCenterView setHidden:YES];

    [myNotWiFiView setHidden:YES];
    [self.view addSubview:myIndexFeaturedHomeView];
    [self.view addSubview:myChannelCatContentListView];
    [self.view addSubview:myPersonalCenterView];

    [self.view addSubview:myNotWiFiView];
    
    
    myMBProgressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    myMBProgressHUD.labelText = @"正在获取数据";
    [self.view addSubview:myMBProgressHUD];
    
    //分类列表
    [self hideBottomView];
    [myMBProgressHUD show:YES];
    [HttpRequest ChannelCategoryListRequestDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (myChannelcategoryListMode == nil) {
        [self hideBottomView];
        [myMBProgressHUD show:YES];
        [HttpRequest ChannelCategoryListRequestDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        return;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self hideStatubar];
}
-(void)GetErr:(ASIHTTPRequest *)request
{
    if (request.tag == CHANNEL_CATEGORYLIST_TYPE)
    {
        [myMBProgressHUD hide:YES];
        [myNotWiFiView setHidden:NO];
    }
}

-(void)GetResult:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (dictionary==nil)
    {
        if (request.tag == CHANNEL_CATEGORYLIST_TYPE)
        {
            [myMBProgressHUD hide:YES];
            [myNotWiFiView setHidden:NO];
        }
    }else
    {
        if (request.tag == CHANNEL_CATEGORYLIST_TYPE) {
            myChannelcategoryListMode = [[ChannelCategoryListMode alloc]initWithDictionary:dictionary];
            if (myChannelcategoryListMode.errorCode == 0) {
                [self showCategoryView];
                [myMBProgressHUD hide:YES];
            }
        }
    }
}

#pragma mark  自定义头像 NSNotificationCenterUserImage
-(void)UserImagehadGet:(NSNotification*) notification
{
    
    id object = [notification object];
    if ([object isKindOfClass:[NSString class]])
    {
        [_UserDefinedPhotoImageView setImageWithURL:[NSURL URLWithString:object] placeholderImage:[UIImage imageNamed:@"head2.png"]];
    }else if([object isKindOfClass:[UIImage class]])
    {
        [_UserDefinedPhotoImageView setImage:object];
    }
    
}

//个人中心
#pragma mark  个人中心 enterPersonalCenterView

- (void)enterPersonalCenterView:(UIButton*)button
{
    
    [[AppDelegate App]click];
    if ([AppDelegate App].myUserLoginMode.token)
    {
        [self blurScrollViewFocus];
        myPage = PAGE_PERSONAL;
        [myPersonalCenterView show];
        [_personalCenterButton setEnabled:NO];
        
    }else
    {
        UserLoginViewController* myUserLoginViewController = [[UserLoginViewController alloc]init];
        myUserLoginViewController.myActionState = EnterPerson;
        [self.navigationController pushViewController:myUserLoginViewController animated:NO];
    }
    
}

#pragma mark  wifiSetUP enterWifiSetUpView

-(void)ifShowWifiSetUpButton:(NSNotification*) notification
{

    id object = [notification object];
    if ([object isEqualToString:@"YES"]) {
        _WifiSetupButton.hidden = NO;
    }else {
        _WifiSetupButton.hidden = YES;
    }
}


- (void)enterWifiSetUpView:(UIButton*)button
{
    [[AppDelegate App]click];
    [self blurScrollViewFocus];
    [[IVMallPlayer sharedIVMallPlayer]backToDMCControlFromViewController:self];
}

//分类页面
#pragma mark scrollerView
- (void)showCategoryView
{
    cloudImageView.image = [UIImage imageNamed:@"cloud.png"];
    [_SortScrollView addSubview:cloudImageView];
    int count = myChannelcategoryListMode.list.count + 1;
    UIButton *but = nil;
    for (int i=0; i <count /*&& i<=6*/; i++) {
        UIButton* tempButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        if (iPad) {
            tempButton.titleLabel.font = [UIFont systemFontOfSize:21];
        }else{
            tempButton.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        tempButton.backgroundColor = [UIColor clearColor];
        tempButton.exclusiveTouch = YES;
        tempButton.frame = CGRectMake(0, 0, (iPad?90:60), (iPad?43:35));
        if (but == nil) {
            but = tempButton;
        }

        tempButton.tag = 1000+i;
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==0) {
            [tempButton setTitle:@"推荐" forState:UIControlStateNormal];
            selectedButton = tempButton;
            [selectedButton setTitleColor:[Commonality colorFromHexRGB:@"ff7800"] forState:UIControlStateNormal];
            CGSize size = [tempButton.titleLabel.text sizeWithFont:tempButton.titleLabel.font constrainedToSize:CGSizeMake(tempButton.titleLabel.frame.size.width ,MAXFLOAT)];
            tempButton.frame = CGRectMake((iPad?10:5),0, size.width+(iPad?30:30), (iPad?43:35));
            
        }else if(i>0 /*&&i<=5*/){
            CategoryMode* tempCategoryMode = [myChannelcategoryListMode.list objectAtIndex:(i-1)];
            [tempButton setTitle:tempCategoryMode.categoryName forState:UIControlStateNormal];
            CGSize size = [tempButton.titleLabel.text sizeWithFont:tempButton.titleLabel.font constrainedToSize:CGSizeMake(tempButton.titleLabel.frame.size.width ,MAXFLOAT)];
            tempButton.frame = CGRectMake(but.frame.origin.x+but.frame.size.width, 0, size.width+(iPad?30:30), (iPad?43:35));
        }
//        else if(i==6){
//            selectedCategoryID = [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedCategoryID"];
//            if (selectedCategoryID) {
//                selectedMode = [self getSelectedCategory:selectedCategoryID];
//            }else{
//                selectedMode = [myChannelcategoryListMode.list objectAtIndex:5];
//                [[NSUserDefaults standardUserDefaults]setObject:selectedMode.categoryId forKey:@"selectedCategoryID"];
//            }
//            
//            if (selectedMode != nil) {
//                [tempButton setTitle:selectedMode.categoryName forState:UIControlStateNormal];
//                tempButton.frame = CGRectMake(but.frame.origin.x+but.frame.size.width, 0, (iPad?90:60), (iPad?43:35));
//                [_categoryListButton setHidden:NO];
//                sixButton = tempButton;
//            }
//        }
        but = tempButton;
        [tempButton addTarget:self action:@selector(sortChange:) forControlEvents:UIControlEventTouchUpInside];
        [_SortScrollView addSubview:tempButton];
    }
    

    if (iPad) {
        _SortScrollView.contentSize = CGSizeMake(but.frame.origin.x+but.frame.size.width+53, 43);
    }else{
        _SortScrollView.contentSize = CGSizeMake(but.frame.origin.x+but.frame.size.width+35, 35);
    }
    
    if (iPad) {
        cloudImageView.frame = CGRectMake(selectedButton.frame.origin.x+(selectedButton.frame.size.width-75)/2, 29, 75, 14);
    }else{
        cloudImageView.frame = CGRectMake(selectedButton.frame.origin.x+(selectedButton.frame.size.width-68)/2, 26, 68, 9);
    }
    
    myPage =  PAGE_INDEX;
    [myIndexFeaturedHomeView show];
}
- (CategoryMode*)getSelectedCategory:(NSString*)categoryID
{
    for (int i=5; i<myChannelcategoryListMode.list.count; i++)
    {
        CategoryMode* tempCategoryMode = [myChannelcategoryListMode.list objectAtIndex:i];
        if([tempCategoryMode.categoryId isEqualToString:categoryID]){
            return tempCategoryMode;
        }
    }
    if (myChannelcategoryListMode.list.count >=6) {
        return [myChannelcategoryListMode.list objectAtIndex:5];
    }else{
        return nil;
    }
}

- (void)sortChange:(UIButton*)button
{
    if (selectedButton == nil) {
        [[AppDelegate App]click];
        selectedButton = button;
        [selectedButton setTitleColor:[Commonality colorFromHexRGB:@"ff7800"] forState:UIControlStateNormal];
        if (iPad) {
            cloudImageView.frame = CGRectMake(button.frame.origin.x+(button.frame.size.width-75)/2, 29, 75, 14);
        }else{
            cloudImageView.frame = CGRectMake(button.frame.origin.x+(button.frame.size.width-68)/2, 26, 68, 9);
        }
        [cloudImageView setHidden:NO];
        [_personalCenterButton setEnabled:YES];
    }else{
        if (selectedButton.tag != button.tag /*|| button == sixButton*/) {
            [[AppDelegate App]click];
            [selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            selectedButton = button;
            [selectedButton setTitleColor:[Commonality colorFromHexRGB:@"ff7800"] forState:UIControlStateNormal];
            
            if (iPad) {
                cloudImageView.frame = CGRectMake(button.frame.origin.x+(button.frame.size.width-75)/2, 29, 75, 14);
            }else{
                cloudImageView.frame = CGRectMake(button.frame.origin.x+(button.frame.size.width-68)/2, 26, 68, 9);
            }
            
        }else{
            return;
        }
    }
    
     
    int index = button.tag-1000;
    if (index == 0) {
        myPage =  PAGE_INDEX;
        [myIndexFeaturedHomeView show];
    }
//    else if(index == 6)
//    {
//        myPage = PAGE_CATEGORY;
//        myChannelCatContentListView.categoryId = selectedMode.categoryId;
//        [myChannelCatContentListView show];
//    }
    else{
        if (index >= 1 && index <= myChannelcategoryListMode.list.count) {
            myPage = PAGE_CATEGORY;
            CategoryMode* myCategoryMode = [myChannelcategoryListMode.list objectAtIndex:(index-1)];
            myChannelCatContentListView.categoryId = myCategoryMode.categoryId;
            [myChannelCatContentListView show];
        }
        
        
    }
}

- (void)blurScrollViewFocus
{
    [selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectedButton = nil;
    [cloudImageView setHidden:YES];
}

//显示剩余分类页面
//- (void)showRemainingView:(UIButton*)sender
//{
//    if (myRemainingCategoryView == nil) {
//        remainningBackGroundView = [[UIView alloc]init];
//        remainningBackGroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        remainningBackGroundView.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:remainningBackGroundView];
//        
//        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedRemainningBackGroundView:)];
//        [remainningBackGroundView addGestureRecognizer:tapGesture];
//        
//        myRemainingCategoryView = [[UIView alloc]init];
//        myRemainingCategoryView.frame = CGRectMake(_categoryListButton.frame.origin.x-((156-_categoryListButton.frame.size.width)/2), _categoryListButton.frame.origin.y, 156, (55+46*MIN(myChannelcategoryListMode.list.count-5, 10)+27));
//        myRemainingCategoryView.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:myRemainingCategoryView];
//        
//        UIButton* remainingTop = [UIButton buttonWithType:UIButtonTypeCustom];
//        remainingTop.frame = CGRectMake(0, 0, 156, 55);
//        [remainingTop setBackgroundImage:[UIImage imageNamed:@"fenlei_03.png"] forState:UIControlStateNormal];
//        [remainingTop addTarget:self action:@selector(hideRemainingView:) forControlEvents:UIControlEventTouchUpInside];
//        [myRemainingCategoryView addSubview:remainingTop];
//        
//        myRemainingCategoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 55, 156, 46*MIN(myChannelcategoryListMode.list.count-5, 10)) style:UITableViewStylePlain];
//        myRemainingCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//        myRemainingCategoryTableView.frame = CGRectMake(0, 55, 156, 46*MIN(myChannelcategoryListMode.list.count-5, 10));
//        myRemainingCategoryTableView.delegate = self;
//        myRemainingCategoryTableView.dataSource = self;
//        myRemainingCategoryTableView.backgroundColor = [UIColor clearColor];
//        myRemainingCategoryTableView.backgroundView = nil;
//        if (myChannelcategoryListMode.list.count-5>10) {
//            myRemainingCategoryTableView.scrollEnabled = YES;
//        }else{
//            myRemainingCategoryTableView.scrollEnabled = NO;
//        }
//        [myRemainingCategoryView addSubview:myRemainingCategoryTableView];
//
//
//        UIImageView* remainingDown = [[UIImageView alloc]init];
//        remainingDown.frame = CGRectMake(0, 55+46*MIN(myChannelcategoryListMode.list.count-5, 10), 156, 27);
//        remainingDown.image = [UIImage imageNamed:@"fenlei_16.png"];
//        [myRemainingCategoryView addSubview:remainingDown];
//    }
//    [myRemainingCategoryTableView reloadData];
//    remainningBackGroundView.hidden = NO;
//    myRemainingCategoryView.hidden = NO;
//    
//}
//
//- (void)pressedRemainningBackGroundView:(UITapGestureRecognizer*)gestureRecognizer
//{
//    remainningBackGroundView.hidden = YES;
//    myRemainingCategoryView.hidden = YES;
//}
//
//- (void)hideRemainingView:(UIButton*)sender
//{
//    remainningBackGroundView.hidden = YES;
//    myRemainingCategoryView.hidden = YES;
//}
#pragma mark tableView delegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return myChannelcategoryListMode.list.count-5;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.backgroundColor = [UIColor clearColor];
//        UIImageView* tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -0.5, 156, 47)];
//        tempImageView.image = [UIImage imageNamed:@"fenlei_05.png"];
//        [cell addSubview:tempImageView];
//    }
//    
//    CategoryMode* tempCategory = [myChannelcategoryListMode.list objectAtIndex:(indexPath.row+5)];
//    
//    UIImageView* flagView2 = (UIImageView*)[cell viewWithTag:503];
//    if (flagView2 == nil) {
//        flagView2 = [[UIImageView alloc]init];
//        flagView2.tag = 503;
//        flagView2.frame = CGRectMake(12, 2, 128, 42);
//        flagView2.image = [UIImage imageNamed:@"fenlei_07.png"];
//        
//        [cell addSubview:flagView2];
//    }
//    [flagView2 setHidden:YES];
//    
//    UILabel* titleLabel = (UILabel*)[cell viewWithTag:501];
//    if (titleLabel == nil) {
//        titleLabel = [[UILabel alloc]init];
//        titleLabel.tag = 501;
//        titleLabel.backgroundColor = [UIColor clearColor];
//        
//        if (iPad) {
//            titleLabel.font = [UIFont boldSystemFontOfSize:20];
//            titleLabel.frame = CGRectMake(34, 0, 80, 46);
//        }else{
//            
//        }
//        [cell addSubview:titleLabel];
//    }
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.text = tempCategory.categoryName;
//    
//    UIImageView* flagView = (UIImageView*)[cell viewWithTag:502];
//    if (flagView == nil) {
//        flagView = [[UIImageView alloc]init];
//        flagView.tag = 502;
//        flagView.frame = CGRectMake(114, 12, 22, 22);
//        flagView.image = [UIImage imageNamed:@"fenlei2_13.png"];
//        [cell addSubview:flagView];
//    }
//    
//    if ([tempCategory.categoryId isEqualToString:selectedCategoryID]) {
//        [flagView setHidden:NO];
//        currentFlag = flagView;
//    }else{
//        [flagView setHidden:YES];
//    }
//    
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 46;
//}
//
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [currentFlag setHidden:YES];
//    UITableViewCell* tempCell = [tableView cellForRowAtIndexPath:indexPath];
//    UILabel* titleLabel = (UILabel*)[tempCell viewWithTag:501];
//    titleLabel.textColor = [UIColor blackColor];
//    UIImageView* flagView = (UIImageView*)[tempCell viewWithTag:502];
//    flagView.image = [UIImage imageNamed:@"fenlei_13.png"];
//    [flagView setHidden:NO];
//    UIImageView* flagView2 = (UIImageView*)[tempCell viewWithTag:503];
//    [flagView2 setHidden:NO];
//    
//}
//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell* tempCell = [tableView cellForRowAtIndexPath:indexPath];
//    UILabel* titleLabel = (UILabel*)[tempCell viewWithTag:501];
//    titleLabel.textColor = [UIColor whiteColor];
//    UIImageView* flagView = (UIImageView*)[tempCell viewWithTag:502];
//    flagView.image = [UIImage imageNamed:@"fenlei2_13.png"];
//    [flagView  setHidden:YES];
//    UIImageView* flagView2 = (UIImageView*)[tempCell viewWithTag:503];
//    [flagView2 setHidden:YES];
//    [currentFlag setHidden:NO];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    remainningBackGroundView.hidden = YES;
//    myRemainingCategoryView.hidden = YES;
//    CategoryMode* tempCategoryMode = [myChannelcategoryListMode.list objectAtIndex:(5+indexPath.row)];
//    selectedCategoryID = tempCategoryMode.categoryId;
//    selectedMode = tempCategoryMode;
//    [[NSUserDefaults standardUserDefaults]setObject:selectedMode.categoryId forKey:@"selectedCategoryID"];
//    UIButton* tempButton = (UIButton*)[_SortScrollView viewWithTag:(1000+6)];
//    [tempButton removeFromSuperview];
//    [sixButton setTitle:tempCategoryMode.categoryName forState:UIControlStateNormal];
//    [_SortScrollView addSubview:sixButton];
//    [self sortChange:sixButton];
//
//}
//页面切换
#pragma mark 页面切换
-(void)buyVip:(PurchaseCompletionHandler)fun
{
    [[AppDelegate App]click];
    PurchaseAndRechargeManagerController* purchaseController = [[PurchaseAndRechargeManagerController alloc]initWithNibName:nil bundle:nil mode:ProcessModeEnum_Purchase completionHandler:fun];
    
    PopUpViewController* popUpViewController = [[PopUpViewController shareInstance]initWithNibName:@"PopUpViewController" bundle:nil];
    
    [popUpViewController popViewController:purchaseController fromViewController:self finishViewController:nil  blur:YES];
}
-(PagesStateEnum)pageState
{
    return myPage;
}
- (void)hideBottomView
{
    [myIndexFeaturedHomeView setHidden:YES];
    [myChannelCatContentListView setHidden:YES];
    [myPersonalCenterView setHidden:YES];
    [myPlayListView setHidden:YES];
    [myNotWiFiView setHidden:YES];
}
- (void)showMBProgressHUD
{
    [myMBProgressHUD show:YES];
}
- (void)hideMBProgressHUD
{
    [myMBProgressHUD hide:YES];
}

- (void)showNotWifiView
{
    [myNotWiFiView setHidden:NO];
}
- (void)hideNotWifiView
{
    [myNotWiFiView setHidden:YES];
}


- (UINavigationController*)getNavigation
{
    return self.navigationController;
}

- (UIView*)getMianView
{
    return self.view;
}
- (void)refresh
{
    if (myChannelcategoryListMode == nil) {
        [self hideBottomView];
        [myMBProgressHUD show:YES];
        [HttpRequest ChannelCategoryListRequestDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        return;
    }
    if (myPage == PAGE_INDEX)
    {
        [myIndexFeaturedHomeView show];
    }else if(myPage == PAGE_CATEGORY)
    {
        [myChannelCatContentListView show];
    }else if(myPage == PAGE_PLAYLIST)
    {
        [myPlayListView show];
    }
}

- (void)afterLogin:(NSNotification*)notification
{
    NSLog(@"%@",[self.navigationController.childViewControllers lastObject]);
    ActionState temp = [[notification object]integerValue];
    if (temp == EnterPlayList) {
//        [self enterPlayListView:_PlayRecordButton];
        return;
    }else if (temp == EnterPerson){
        [self blurScrollViewFocus];
        myPage = PAGE_PERSONAL;
        [myPersonalCenterView show];
        [_personalCenterButton setEnabled:NO];
        return;
    }else if (temp == IndexPlayVideo)
    {
        [myIndexFeaturedHomeView playBefoerLoginVideo];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
