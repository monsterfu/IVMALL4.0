//
//  PersonalCenterView.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "PersonalCenterView.h"
#import "Macro.h"
#import "HttpRequest.h"
#import "Commonality.h"
#import "UserLoginModel.h"
#import "UserDetailMode.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UserLoginViewController.h"
#import "UserAccountViewController.h"
#import "FavoriteListViewController.h"
#import "UserPlayTimeViewController.h"
#import "WiFiSetUp.h"
#import "BoxBlurImageViewController.h"
#import "AboutUsViewController.h"
#import "UserDetailAndUpdateViewController.h"
#import "QRCodeReadViewController.h"
@implementation PersonalCenterView
{
    UIView* notLoginView;
    UIView* loginView;
    NSArray* titleArray;
    NSArray* imageArray;
//    MBProgressHUD* myMBProgressHUD;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess:) name:NSNotificationCenterLoginInSuccess object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showUserInfo) name:NSNotificationCenterUserInfo object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfo) name:NSNotificationCenterPurchaseSuccessViewJump object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterLoginInSuccess object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterUserInfo object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterPurchaseSuccessViewJump object:nil];
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
    if (self && self.delegate) {
        [self.delegate hideBottomView];
    }
    NSString* charge = [AppDelegate App].charge;
    if (charge && [charge isEqualToString:@"true"]) {
        titleArray = [NSArray arrayWithObjects:@"我的账户",@"我的收藏",@"观看时长",@"爱V猫影棒",@"二维码扫描",@"关于我们", nil];
        imageArray = [NSArray arrayWithObjects:@"icon_69.png", @"icon_69-34.png", @"icon_69-35.png", @"icon_69-36.png", @"icon_69-37.png", @"icon_69-38.png", nil];
    }else{
        titleArray = [NSArray arrayWithObjects:@"我的收藏",@"观看时长",@"爱V猫影棒",@"二维码扫描",@"关于我们", nil];
        imageArray = [NSArray arrayWithObjects:@"icon_69-34.png", @"icon_69-35.png", @"icon_69-36.png", @"icon_69-37.png", @"icon_69-38.png", nil];
    }
    [self makeNotLoginView];
    [self makeLoginView];
//    myMBProgressHUD = [[MBProgressHUD alloc]initWithView:loginView];
//    myMBProgressHUD.labelText = @"正在获取数据";
//    [loginView addSubview:myMBProgressHUD];
    
    if ([AppDelegate App].myUserLoginMode.token) {
        
        [notLoginView setHidden:YES];
        [loginView setHidden:NO];
        if ([AppDelegate App].UserInfo && [AppDelegate App].UserInfo.errorCode == 0)
        {
            [self showUserInfo];
        }else
        {
//            [myMBProgressHUD show:YES];
            [HttpRequest UserDetailRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        }

    }else{
        [notLoginView setHidden:NO];
        [loginView setHidden:YES];
    }
    
    for (int i=0; i<titleArray.count; i++) {
        NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:[NSString xibName:@"PersonalCell"] owner:self options:nil];
        UIView * tempView = [nibViews objectAtIndex:0];
        [tempView setTag:(1000+i)];
        tempView.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
        tempView.layer.masksToBounds = YES;
        tempView.layer.cornerRadius = (iPad?30:18);
        tempView.layer.borderWidth = (iPad?3:1.8f);
        tempView.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
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
        [subImageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]]];
        
        UILabel* subLabel1 = (UILabel*)[tempView viewWithTag:101];
        subLabel1.textColor = [Commonality colorFromHexRGB:@"42843d"];
        subLabel1.text = [titleArray objectAtIndex:i];
        
        if (iPad) {
            if (i < 3) {
                tempView.frame = CGRectMake(280+16+(208+16)*i, 85, 208, 140);
            }else{
                tempView.frame = CGRectMake(280+16+(208+16)*(i-3), 240, 208, 140);
            }
        }else{
            if (i < 3) {
                tempView.frame = CGRectMake((VIEWHEIGHT-120-100*3-10*3)/2+130+(100+10)*i, 45, 100, 80);
            }else{
                tempView.frame = CGRectMake((VIEWHEIGHT-120-100*3-10*3)/2+130+(100+10)*(i-3), 140, 100, 80);
            }
        }
        
        
        [self addSubview:tempView];
    }
    
    if ([self.delegate pageState] == PAGE_PERSONAL) {
        [self.delegate hideBottomView];
        [self setHidden:NO];
    }
    
}


- (void)pressedView:(UITapGestureRecognizer*)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        [[AppDelegate App]click];
        [self setFcous:sender.view];
        [self enterSetting:sender];
        [self blurFcous:sender.view];
    }else if([sender isKindOfClass:[UILongPressGestureRecognizer class]]){
        if (sender.state == UIGestureRecognizerStateBegan) {
            [[AppDelegate App]click];
            [self setFcous:sender.view];
        }else if(sender.state == UIGestureRecognizerStateEnded){
            [self blurFcous:sender.view];
            [self enterSetting:sender];
        }
    }
}
- (void)setFcous:(UIView*)view
{
    view.backgroundColor = [Commonality colorFromHexRGB:@"fff601"];
    view.layer.borderColor = [Commonality colorFromHexRGB:@"fca010"].CGColor;
    view.layer.borderWidth = (iPad?7:3.5);
}

-(void)blurFcous:(UIView*)view
{
    view.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
    view.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
    view.layer.borderWidth = (iPad?3:1.5);
}

- (void)enterSetting:(UITapGestureRecognizer*)sender
{
    int index = sender.view.tag - 1000;
    if ([AppDelegate App].charge && [[AppDelegate App].charge isEqualToString:@"true"]) {
    }else{
        index = index + 1;
    }
        switch (index) {
            case 0:
                if (self && self.delegate) {
                    if ([AppDelegate App].myUserLoginMode.token) {
                        UserAccountViewController* myAccountViewController = [[UserAccountViewController alloc]init];
                        //        [self.delegate enterViewController:myUserLoginViewController];
                        [[self.delegate getNavigation] pushViewController:myAccountViewController animated:NO];
                    }else{
                        [self enterLogin:nil];
                    }
                    
                }
                break;
            case 1:
                if (self && self.delegate) {
                    if (self && self.delegate) {
                        if ([AppDelegate App].myUserLoginMode.token) {
                            FavoriteListViewController* myFavoriteListViewController = [[FavoriteListViewController alloc]initWithNibName:[NSString xibName:@"FavoriteListViewController"] bundle:nil];
                            //        [self.delegate enterViewController:myUserLoginViewController];
                            [[self.delegate getNavigation] pushViewController:myFavoriteListViewController animated:NO];
                        }else{
                            [self enterLogin:nil];
                        }
                        
                    }
                    
                }
                break;
            case 2:
                if (self && self.delegate) {
                    if ([AppDelegate App].myUserLoginMode.token) {
                        UserPlayTimeViewController* myPlayTimeViewController = [[UserPlayTimeViewController alloc]initWithNibName:[NSString xibName:@"UserPlayTimeViewController"] bundle:nil];
                        [[self.delegate getNavigation] pushViewController:myPlayTimeViewController animated:NO];
                    }else{
                        [self enterLogin:nil];
                    }
                    
                }
                break;
            case 3:
                if (self && self.delegate) {
                    [[WiFiSetUp sharedInstance]wifiSetUpStartwithViewController:self.window.rootViewController];
                }
                break;
            case 4:
                if (self && self.delegate) {
                    if ([AppDelegate App].myUserLoginMode.token) {
                        QRCodeReadViewController* myQRCodeReader = [[QRCodeReadViewController alloc]initWithNibName:[NSString xibName:@"QRCodeReadViewController"] bundle:nil];
                        [[self.delegate getNavigation] pushViewController:myQRCodeReader animated:NO];
                    }else{
                        [self enterLogin:nil];
                    }
                    
                }
                break;
            case 5:
                if (self && self.delegate) {
                    AboutUsViewController* aboutUs = [[AboutUsViewController alloc]initWithNibName:[NSString xibName:@"AboutUsViewController"] bundle:nil];
                    //        [self.delegate enterViewController:myUserLoginViewController];
                    [[self.delegate getNavigation] pushViewController:aboutUs animated:NO];
                }
                break;
                
            default:
                break;
        }
    
}
-(void)makeNotLoginView
{
    notLoginView = [[UIView alloc]init];
    if (iPad) {
        notLoginView.frame = CGRectMake(72, 85, 208, 295);
        notLoginView.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
        notLoginView.layer.masksToBounds = YES;
        notLoginView.layer.cornerRadius = 30;
        notLoginView.layer.borderWidth = 3;
        notLoginView.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
    }else{
        notLoginView.frame = CGRectMake((VIEWHEIGHT-120-100*3-10*3)/2, 45, 120, 175);
        notLoginView.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
        notLoginView.layer.masksToBounds = YES;
        notLoginView.layer.cornerRadius = 18;
        notLoginView.layer.borderWidth = 1.8f;
        notLoginView.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
    }
    
    [self addSubview:notLoginView];
    
    UILabel* label1 = [[UILabel alloc]init];
    if (iPad) {
        label1.frame = CGRectMake(0, 80, 208, 30);
    }else{
        label1.frame = CGRectMake(0, 60, 120, 30);
    }
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont boldSystemFontOfSize:(iPad?20:15)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"未登录";
    [notLoginView addSubview:label1];
    
    UIButton* buttton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    buttton1.tag = 504;
    if(iPad){
        buttton1.frame = CGRectMake(35, 240, 130, 40);
    }else{
        buttton1.frame = CGRectMake(20, 135, 80, 30);
    }
    [buttton1 setBackgroundImage:[UIImage imageNamed:@"button_f4.png"] forState:UIControlStateNormal];
    [buttton1 setBackgroundImage:[UIImage imageNamed:@"button_f3.png"] forState:UIControlStateHighlighted];
    [buttton1 setTitle:@"登录" forState:UIControlStateNormal];
    buttton1.titleLabel.font = [UIFont systemFontOfSize:(iPad?20:15)];
    [buttton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttton1 addTarget:self action:@selector(enterLogin:) forControlEvents:UIControlEventTouchUpInside];
    [notLoginView addSubview:buttton1];
}

- (void)enterLogin:(UIButton*)sender
{
    [[AppDelegate App]click];

    if (self && self.delegate) {
        UserLoginViewController* myUserLoginViewController = [[UserLoginViewController alloc]init];
        myUserLoginViewController.myActionState = UnKnownAction;
        [[self.delegate getNavigation] pushViewController:myUserLoginViewController animated:NO];
    }
}
- (void)makeLoginView
{
    loginView = [[UIView alloc]init];
    if (iPad) {
        loginView.frame = CGRectMake(72, 85, 208, 295);
        loginView.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
        loginView.layer.masksToBounds = YES;
        loginView.layer.cornerRadius = 30;
        loginView.layer.borderWidth = 3;
        loginView.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
    }else{
        loginView.frame = CGRectMake((VIEWHEIGHT-120-100*3-10*4)/2, 45, 120, 175);
        loginView.backgroundColor = [Commonality colorFromHexRGB:@"f2ffe5"];
        loginView.layer.masksToBounds = YES;
        loginView.layer.cornerRadius = 18;
        loginView.layer.borderWidth = 1.8f;
        loginView.layer.borderColor = [Commonality colorFromHexRGB:@"42843d"].CGColor;
    }
    
    [self addSubview:loginView];
    
    CGRect tempRect1;
    if (iPad) {
        tempRect1 = CGRectMake(20, 23, 168, 20);
    }else{
        tempRect1 = CGRectMake(10, 15, 100, 15);
    }
    UILabel* label1 = [[UILabel alloc]initWithFrame:tempRect1];
    label1.tag = 501;
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont boldSystemFontOfSize:(iPad?20:15)];
    label1.textAlignment = NSTextAlignmentCenter;
    
    [loginView addSubview:label1];
    
    
    CGRect tempRect2;
    if (iPad) {
        tempRect2 = CGRectMake(20, 53, 168, 20);
    }else{
        tempRect2 = CGRectMake(10, 35, 100, 15);
    }
    UILabel* label2 = [[UILabel alloc]initWithFrame:tempRect2];
    label2.tag = 502;
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont boldSystemFontOfSize:(iPad?15:12)];
    label2.textAlignment = NSTextAlignmentCenter;
    [loginView addSubview:label2];
    
    
    CGRect tempRect3;
    if (iPad) {
        tempRect3 = CGRectMake(20, 83, 168, 20);
    }else{
        tempRect3 = CGRectMake(10, 50, 100, 15);
    }
    UILabel* label3 = [[UILabel alloc]initWithFrame:tempRect3];
    label3.tag = 503;
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    label3.font = [UIFont boldSystemFontOfSize:(iPad?15:12)];
    label3.textAlignment = NSTextAlignmentCenter;
    [label3 setHidden:YES];
    [loginView addSubview:label3];
    
    UIButton* buttton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    if (iPad) {
        buttton1.frame = CGRectMake(39, 109, 130, 40);
    }else{
        buttton1.frame = CGRectMake(20, 76, 80, 20);
    }
    
    [buttton1 setBackgroundImage:[UIImage imageNamed:@"button_d1.png"] forState:UIControlStateNormal];
    [buttton1 setBackgroundImage:[UIImage imageNamed:@"button_d2.png"] forState:UIControlStateHighlighted];
    [buttton1 setTitle:@"开通会员" forState:UIControlStateNormal];
    [buttton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttton1.titleLabel.font = [UIFont systemFontOfSize:(iPad?15:12)];
    [buttton1 addTarget:self action:@selector(enterBuyVip:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:buttton1];
    buttton1.exclusiveTouch = YES;
    [buttton1 setHidden:YES];
    NSString* charge = [AppDelegate App].charge;
    if (charge && [charge isEqualToString:@"true"]) {
        [buttton1 setHidden:NO];
        [label3 setHidden:NO];
    }
   
        
    
    UIButton* editInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (iPad) {
        editInfoBtn.frame = CGRectMake(39, 159, 130, 40);
    }else{
        editInfoBtn.frame = CGRectMake(20, 101, 80, 20);
    }
    editInfoBtn.exclusiveTouch = YES;
    [editInfoBtn setBackgroundImage:[UIImage imageNamed:@"button_d1.png"] forState:UIControlStateNormal];
    [editInfoBtn setBackgroundImage:[UIImage imageNamed:@"button_d2.png"] forState:UIControlStateHighlighted];
    [editInfoBtn setTitle:@"个人设置" forState:UIControlStateNormal];
    [editInfoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    editInfoBtn.titleLabel.font = [UIFont systemFontOfSize:(iPad?15:12)];
    [editInfoBtn addTarget:self action:@selector(enterUserDetail:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:editInfoBtn];
    
    UIButton* logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (iPad) {
        logoutBtn.frame = CGRectMake(39, 233, 130, 40);
    }else{
        logoutBtn.frame = CGRectMake(20, 135, 80, 20);
    }
    logoutBtn.exclusiveTouch = YES;
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"button_d1.png"] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"button_d2.png"] forState:UIControlStateHighlighted];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:(iPad?15:12)];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:logoutBtn];
    
}

-(void)getUserInfo
{
    [HttpRequest UserDetailRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

-(void)showUserInfo
{
    UILabel* temp1 = (UILabel*)[loginView viewWithTag:501];
    temp1.text = [AppDelegate App].UserInfo.nickname;
    
    UILabel* temp2 = (UILabel*)[loginView viewWithTag:502];
    NSString* mobile = [[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"];
    NSRange range= {3,4};
    temp2.text = [mobile stringByReplacingCharactersInRange:range withString:@"****"];
    
    UILabel* temp3 = (UILabel*)[loginView viewWithTag:503];
    UIButton* temp4 = (UIButton*)[loginView viewWithTag:504];
    if ([AppDelegate App].UserInfo.vipLevel == 0)
    {
        temp3.text = @"注册用户";
        [temp4 setTitle:@"开通用户" forState:UIControlStateNormal];
    }else
    {
        NSString*  dateString = [Commonality Date2Str4:[Commonality dateFromString:[AppDelegate App].UserInfo.vipExpiryTime]];
        temp3.text = [NSString stringWithFormat:@"%@ 会员到期",dateString];
        [temp4 setTitle:@"会员续费" forState:UIControlStateNormal];
    }
}

-(void)enterBuyVip:(UIButton*)sender
{
    [[AppDelegate App]click];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(buyVip)]) {
        [self.delegate buyVip];
    }
    
}

-(void)enterUserDetail:(UIButton*)sender
{
    [[AppDelegate App]click];
    if (self && self.delegate) {
        UserDetailAndUpdateViewController* myUserViewController = [[UserDetailAndUpdateViewController alloc]initWithNibName:[NSString xibName:@"UserDetailAndUpdateViewController"] bundle:nil];
        [[self.delegate getNavigation] pushViewController:myUserViewController animated:NO];
    }
}

-(void)logout:(UIButton*)sender
{
//    [[AppDelegate App]click];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults removeObjectForKey:@"mobile"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults removeObjectForKey:@"password2"];
    [userDefaults synchronize];
    [AppDelegate App].myUserLoginMode = nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterUserImage object:[UIImage imageNamed:@"head2.png"]];
    [self show];
    [self enterLogin:nil];
    
    return;
}

-(void)loginSuccess:(NSNotification*)notification
{
    [notLoginView setHidden:YES];
    [loginView setHidden:NO];
}

-(void)GetErr:(ASIHTTPRequest *)request
{
    if (request.tag == USER_DETAIL_TYPE)
    {
//        [myMBProgressHUD hide:YES];
    }
}

-(void)GetResult:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (dictionary==nil)
    {
        if (request.tag == USER_DETAIL_TYPE)
        {
//            [myMBProgressHUD hide:YES];
        }
    }else
    {
        if (request.tag == USER_DETAIL_TYPE) {
            [AppDelegate App].UserInfo = [[UserDetailMode alloc]initWithDictionary:dictionary];
            if ([AppDelegate App].UserInfo.errorCode == 0) {
                [self showUserInfo];
            }
        }
    
    }
}
@end
