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
    NSUInteger interfaceOrientations;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        interfaceOrientations = UIInterfaceOrientationMaskLandscape;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afterLogin:) name:NSNotificationCenterAfterLoginInSuccess object:nil];

    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleBlackTranslucent;
}

- (BOOL)prefersStatusBarHidden
{
    return statusBarHidder;
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
        [self hideStatubar];
        _UserDefinedPhotoImageView.layer.cornerRadius = 15;
//        _WifiSetupButton.frame = CGRectMake(VIEWHEIGHT-30, 10, 25, 25);
//        _PlayRecordButton.frame = CGRectMake(VIEWHEIGHT-30-35, 10, 25, 25);
//        _PersonalCenterButton.frame = CGRectMake(VIEWHEIGHT-30-35-35, 10, 25, 25);
//        _SortScrollView.frame = CGRectMake(60, 10, VIEWHEIGHT-30-35-35-10-60, 25);
        if (iPhone5) {
            _myBackgroundImageView.image = [UIImage imageNamed:@"iphone_bg.png"];
            _UserDefinedPhotoImageView.frame = CGRectMake(10, 10, 40, 40);
            _UserDefinedPhotoImageView.layer.cornerRadius = 20;
        }
    }
    _UserDefinedPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _UserDefinedPhotoImageView.layer.borderWidth = 0.0f;
    _UserDefinedPhotoImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _UserDefinedPhotoImageView.layer.shouldRasterize = YES;
    _UserDefinedPhotoImageView.clipsToBounds = YES;
    _UserDefinedPhotoImageView.userInteractionEnabled = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UserImagehadGet:) name:NSNotificationCenterUserImage object:nil];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePicture:)];
    [_UserDefinedPhotoImageView addGestureRecognizer:tapGesture];
    _cloudImageView2 = [[UIImageView alloc]init];
    _cloudImageView2.image = [UIImage imageNamed:@"cloud.png"];
    [self.view addSubview:_cloudImageView2];
    [_cloudImageView2 setHidden:YES];
    
    //个人中心
//    [_PersonalCenterButton setImage:[UIImage imageNamed:@"individual2.png"] forState:UIControlStateHighlighted];
    [_PersonalCenterButton addTarget:self action:@selector(enterPersonalCenterView:) forControlEvents:UIControlEventTouchUpInside];
    
    //播放列表
//    [_PlayRecordButton setImage:[UIImage imageNamed:@"historical2.png"] forState:UIControlStateHighlighted];
    [_PlayRecordButton addTarget:self action:@selector(enterPlayListView:) forControlEvents:UIControlEventTouchUpInside];
    
    //进入wifiSetUp页面
//    [_WifiSetupButton setImage:[UIImage imageNamed:@"Remote2.png"] forState:UIControlStateHighlighted];
    [_WifiSetupButton addTarget:self action:@selector(enterWifiSetUpView:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ifShowWifiSetUpButton:) name:NSNotificationCenterExitFromDMC object:nil];
    [_WifiSetupButton setHidden:YES];
    
    myIndexFeaturedHomeView = [[IndexFeaturedHomeView alloc]init];
    myIndexFeaturedHomeView.delegate = self;
    myChannelCatContentListView = [[ChannelCatContentListView alloc]init];
    myChannelCatContentListView.delegate = self;
    myPersonalCenterView = [[PersonalCenterView alloc]init];
    myPersonalCenterView.delegate = self;
    myPlayListView = [[PlayListView alloc]init];
    myPlayListView.delegate = self;
    
    myNotWiFiView = [[NotWiFiView alloc]init];
    [myNotWiFiView setNotWiFiStyle:MainViewNotWiFi];
    if (iPad) {
        myIndexFeaturedHomeView.frame = CGRectMake(0, 130, VIEWHEIGHT, VIEWWIDTH-150);
        myChannelCatContentListView.frame = CGRectMake(0, 140, VIEWHEIGHT, VIEWWIDTH-160);
        myPersonalCenterView.frame = CGRectMake(0, 100, VIEWHEIGHT, VIEWWIDTH-100);
        myPlayListView.frame = CGRectMake(0, 130, VIEWHEIGHT, VIEWWIDTH-150);
    }else {
        myIndexFeaturedHomeView.frame = CGRectMake(0, 50, VIEWHEIGHT, VIEWWIDTH-50);
        myChannelCatContentListView.frame = CGRectMake(0, 50, VIEWHEIGHT, VIEWWIDTH-50);
        myPersonalCenterView.frame = CGRectMake(0, 50, VIEWHEIGHT, VIEWWIDTH-50);
        myPlayListView.frame = CGRectMake(0, 50, VIEWHEIGHT, VIEWWIDTH-50);
    }
    myNotWiFiView.delegate = self;
    [myIndexFeaturedHomeView setHidden:YES];
    [myChannelCatContentListView setHidden:YES];
    [myPersonalCenterView setHidden:YES];
    [myPlayListView setHidden:YES];
    [myNotWiFiView setHidden:YES];
    [self.view addSubview:myIndexFeaturedHomeView];
    [self.view addSubview:myChannelCatContentListView];
    [self.view addSubview:myPersonalCenterView];
    [self.view addSubview:myPlayListView];
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

//自定义头像
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

-(void)changePicture:(UITapGestureRecognizer*)sender
{
    [[AppDelegate App]click];
    if([AppDelegate App].myUserLoginMode.token)//登录
    {
        UIActionSheet*action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择本地图片", nil];
        [action showInView:self.view];
    }else{
        UserLoginViewController* myUserLoginViewController = [[UserLoginViewController alloc]init];
        myUserLoginViewController.myActionState = UnKnownAction;
        [self.navigationController pushViewController:myUserLoginViewController animated:NO];
    }
}

#pragma mark -UIActionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[AppDelegate App]click];
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            interfaceOrientations = UIInterfaceOrientationMaskAll;
        }];
        
    }else if (buttonIndex==1){
        [[AppDelegate App]click];
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            interfaceOrientations = UIInterfaceOrientationMaskAll;
        }];
    }else if (buttonIndex==2){
        
    }
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"从1");
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage* newImg = [self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 300)];
    if (newImg) {
        [NSThread detachNewThreadSelector:@selector(postData:) toTarget:self withObject:newImg];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterUserImage object:newImg];
    [self dismissViewControllerAnimated:YES completion:^{
        interfaceOrientations = UIInterfaceOrientationMaskLandscape;
    }];
}

-(void)postData:(UIImage*)image
{
    NSString* url = [NSString stringWithFormat:@"%@/user/updateAvatar.action?token=%@",BASE,[AppDelegate App].myUserLoginMode.token];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        data = UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    NSMutableString *body=[[NSMutableString alloc]init];
    [body appendFormat:@"%@\r\n",MPboundary];
    
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",@"file",@"file"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/png\r\n\r\n"];
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData appendData:data];
    
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    NSLog(@"返回结果=====%@,urlResponese statusCode=%d",result,[urlResponese statusCode]);
    if([urlResponese statusCode] ==200){
//        [[ivmallAppDelegate App].viewController.leftMenuViewController.tabelView reloadData];
    }
    
}

-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"从取消");
    [self dismissViewControllerAnimated:YES completion:^{
        interfaceOrientations = UIInterfaceOrientationMaskLandscape;
    }];
    
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

        [_PersonalCenterButton setEnabled:NO];
        [_WifiSetupButton setEnabled:YES];
        [_PlayRecordButton setEnabled:YES];
        [myPersonalCenterView show];
        [_cloudImageView2 setHidden:NO];
        if (iPad) {
            _cloudImageView2.frame = CGRectMake(836, 49, 75, 14);
        }else{
            _cloudImageView2.frame = CGRectMake(_PersonalCenterButton.frame.origin.x+(_PersonalCenterButton.frame.size.width-40)/2, 32, 40, 9);
        }
        [self.view insertSubview:_cloudImageView2 belowSubview:_PersonalCenterButton];
    }else
    {
        UserLoginViewController* myUserLoginViewController = [[UserLoginViewController alloc]init];
        myUserLoginViewController.myActionState = EnterPerson;
        [self.navigationController pushViewController:myUserLoginViewController animated:NO];
    }
    
}
//播放记录
#pragma mark  播放记录 enterPlayListView

- (void)enterPlayListView:(UIButton*)button
{
    [[AppDelegate App]click];
    if ([AppDelegate App].myUserLoginMode.token) {
        [self blurScrollViewFocus];
        myPage = PAGE_PLAYLIST;

        [_PersonalCenterButton setEnabled:YES];
        [_WifiSetupButton setEnabled:YES];
        [_PlayRecordButton setEnabled:NO];
        [myPlayListView show];
        [_cloudImageView2 setHidden:NO];
        if (iPad) {
            _cloudImageView2.frame = CGRectMake(896, 49, 75, 14);
        }else{
            _cloudImageView2.frame = CGRectMake(_PlayRecordButton.frame.origin.x+(_PlayRecordButton.frame.size.width-40)/2, 32, 40, 9);
        }
        [self.view insertSubview:_cloudImageView2 belowSubview:_PlayRecordButton];
    }else{
        UserLoginViewController* myUserLoginViewController = [[UserLoginViewController alloc]init];
        myUserLoginViewController.myActionState = EnterPlayList;
        [self.navigationController pushViewController:myUserLoginViewController animated:NO];
    }
    
}
//wifiSetUP
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
    for (int i=0; i < count; i++) {
        UIButton* tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (iPad) {
            tempButton.titleLabel.font = [UIFont systemFontOfSize:17];
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
//            [self setColor:[Commonality colorFromHexRGB:@"ff7800"] forButton:selectedButton AndTitle:@"推荐"];
            CGSize size = [tempButton.titleLabel.text sizeWithFont:tempButton.titleLabel.font constrainedToSize:CGSizeMake(tempButton.titleLabel.frame.size.width ,MAXFLOAT)];
            tempButton.frame = CGRectMake(10,0, size.width+(iPad?30:30), (iPad?43:35));
            
        }else{
            CategoryMode* tempCategoryMode = [myChannelcategoryListMode.list objectAtIndex:(i-1)];
            [tempButton setTitle:tempCategoryMode.categoryName forState:UIControlStateNormal];
//            [self setColor:[UIColor blackColor] forButton:tempButton AndTitle:tempCategoryMode.categoryName];
            CGSize size = [tempButton.titleLabel.text sizeWithFont:tempButton.titleLabel.font constrainedToSize:CGSizeMake(tempButton.titleLabel.frame.size.width ,MAXFLOAT)];
            tempButton.frame = CGRectMake(but.frame.origin.x+but.frame.size.width, 0, size.width+(iPad?30:30), (iPad?43:35));
        }
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
        cloudImageView.frame = CGRectMake(selectedButton.frame.origin.x+(selectedButton.frame.size.width-54)/2, 26, 54, 9);
    }
    
    
    if (iPad) {
        _blurImage.frame = CGRectMake(_SortScrollView.frame.origin.x+_SortScrollView.frame.size.width-_SortScrollView.frame.size.height, _SortScrollView.frame.origin.y
                                      , _SortScrollView.frame.size.height, _SortScrollView.frame.size.height);
        [_blurImage setHidden:NO];
    }
    myPage =  PAGE_INDEX;
    [myIndexFeaturedHomeView show];
}


- (void)sortChange:(UIButton*)button
{
    if (selectedButton == nil) {
        [[AppDelegate App]click];
        selectedButton = button;
        [selectedButton setTitleColor:[Commonality colorFromHexRGB:@"ff7800"] forState:UIControlStateNormal];
//        [self setColor:[Commonality colorFromHexRGB:@"ff7800"] forButton:selectedButton AndTitle:nil];
        if (iPad) {
            cloudImageView.frame = CGRectMake(button.frame.origin.x+(button.frame.size.width-75)/2, 29, 75, 14);
        }else{
            cloudImageView.frame = CGRectMake(button.frame.origin.x+(button.frame.size.width-54)/2, 26, 54, 9);
        }
        [cloudImageView setHidden:NO];
        [_PersonalCenterButton setEnabled:YES];
        [_PlayRecordButton setEnabled:YES];
        [_WifiSetupButton setEnabled:YES];
        [_cloudImageView2 setHidden:YES];
        
    }else{
        if (selectedButton.tag != button.tag) {
            [[AppDelegate App]click];
            [selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [self setColor:[UIColor blackColor] forButton:selectedButton AndTitle:nil];
            
            selectedButton = button;
            [selectedButton setTitleColor:[Commonality colorFromHexRGB:@"ff7800"] forState:UIControlStateNormal];
//            [self setColor:[Commonality colorFromHexRGB:@"ff7800"] forButton:selectedButton AndTitle:nil];
            
            if (iPad) {
                cloudImageView.frame = CGRectMake(button.frame.origin.x+(button.frame.size.width-75)/2, 29, 75, 14);
            }else{
                cloudImageView.frame = CGRectMake(button.frame.origin.x+(button.frame.size.width-54)/2, 26, 54, 9);
            }
            
        }else{
            return;
        }
    }
    
     
    int index = button.tag-1000;
    if (index == 0) {
        myPage =  PAGE_INDEX;
        [myIndexFeaturedHomeView show];
    }else{
        if (index >= 1 && index <= myChannelcategoryListMode.list.count) {
            myPage = PAGE_CATEGORY;
            CategoryMode* myCategoryMode = [myChannelcategoryListMode.list objectAtIndex:(index-1)];
            myChannelCatContentListView.categoryId = myCategoryMode.categoryId;
            [myChannelCatContentListView show];
        }
        
        
    }
}

- (void)setColor:(UIColor*)color forButton:(UIButton*)button AndTitle:(NSString*)title
{
    if (title == nil) {
        title = button.titleLabel.text;
    }
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:title
                                    attributes:@{
                                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:iPad?20:13],
                                                 NSStrokeWidthAttributeName: [NSNumber numberWithInt:-3.5],
                                                 NSStrokeColorAttributeName: [UIColor  whiteColor],
                                                 NSForegroundColorAttributeName:color }];
    [button setAttributedTitle:attributedText forState:UIControlStateNormal];

}
- (void)blurScrollViewFocus
{
    [selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectedButton = nil;
    [cloudImageView setHidden:YES];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

//页面切换
#pragma mark 页面切换
-(void)buyVip
{
    [[AppDelegate App]click];
    PurchaseAndRechargeManagerController* purchaseController = [[PurchaseAndRechargeManagerController alloc]initWithNibName:nil bundle:nil mode:ProcessModeEnum_Purchase completionHandler:nil];
    
    PopUpViewController* popUpViewController = [[PopUpViewController shareInstance]initWithNibName:@"PopUpViewController" bundle:nil];
    
    [popUpViewController popViewController:purchaseController fromViewController:self finishViewController:nil];
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

//-(void)enterViewController:(UIViewController*)newViewController
//{
//    PopUpViewController* popupViewController = [[PopUpViewController alloc]initWithViewController:newViewController];
//    
//    [popupViewController popViewController:newViewController fromViewController:self center:self.view.center];
//}

- (UINavigationController*)getNavigation
{
    return self.navigationController;
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
    ActionState temp = [[notification object]integerValue];
    if (temp == EnterPlayList) {
        [self enterPlayListView:_PlayRecordButton];
        return;
    }else if (temp == EnterPerson){
        [self enterPersonalCenterView:_PersonalCenterButton];
        return;
    }else if (temp == PlayVideo)
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
//    return UIInterfaceOrientationMaskLandscape;
    return interfaceOrientations;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
