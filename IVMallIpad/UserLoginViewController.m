//
//  UserLoginViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserLoginViewController.h"
#import "UserForgetPasswordViewController.h"
#import "UserRegisterViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
#import "IVMallPlayer.h"
#import "Commonality.h"
#import "AppDelegate.h"
@interface UserLoginViewController ()
{
    NSString* md5Password;
}

@end

@implementation UserLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _myActionState = UnKnownAction;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoLogin:) name:NSNotificationCenterPushAutoLogin object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerSuccess:) name:NSNotificationCenterRegisterInSuccess object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterPushAutoLogin object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterRegisterInSuccess object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _username = [_username initWithFrame:_username.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_username setStyle];
    
    _username.delegate = self;
    _username.keyboardType = UIKeyboardTypeNumberPad;
    
//    _password = [_password initWithFrame:_username.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_password setStyle];
    _password.delegate = self;
    _password.keyboardType = UIKeyboardTypeASCIICapable;
    [_password setSecureTextEntry:YES];
    [_showPassWordButton setSelected:NO];
    
//    NSString* deviceDRMId = [[[IVMallPlayer sharedIVMallPlayer] IVMallPlayerGetLocalInfo]objectForKey:@"deviceDRMId"];
//    NSString* QRString = [NSString stringWithFormat:@"http://api.ivmall.com/IvmallPushServer/login.jsp?drmid=%@",deviceDRMId];
//    _QRImageView.image = [QRCodeGenerator qrImageForString:QRString imageSize:_QRImageView.bounds.size.width];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeViewEdit:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [_telephoneButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    
    _versionLabel.text = [NSString stringWithFormat:@"版本:V%@",IVMALL_VERSION];
    myMBProgressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:myMBProgressHUD];
    myMBProgressHUD.labelText = @"登录中...";
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSString* mobile = [[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"];
    if (mobile) {
        _username.text = mobile;
    }
}

- (void)call:(UIButton*)sender
{
            [[AppDelegate App]click];
    NSString* telephoneString = [NSString stringWithFormat:@"telprompt://%@",CALLPHONE];
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:telephoneString]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:telephoneString]];
    }

}
//
- (void)closeViewEdit:(id)sender
{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPassWordButtonTouch:(UIButton *)sender {
            [[AppDelegate App]click];
    if (sender.selected == YES) {
        [sender setSelected:NO];
        [_password setSecureTextEntry:YES];
    }else{
        [sender setSelected:YES];
        [_password setSecureTextEntry:NO];
    }
}

- (IBAction)forgetPasswordButtonTouch:(UIButton *)sender {
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(forgetPasswordEnter)]) {
//        [self.delegate forgetPasswordEnter];
//    }
            [[AppDelegate App]click];
    UserForgetPasswordViewController* myUserForgetPasswordView = [[UserForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:myUserForgetPasswordView animated:NO];
}

- (IBAction)loginButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    [self.view endEditing:YES];
    if ([Commonality isEnableWIFI] == 0) {
        [Commonality showErrorMsg:self.view type:0 msg:FAIILURE];
        return;
    }
    
    if (_username.text.length == 0) {
        [_username showWithError:@"手机号码不能为空哦!"];
        return;
    }
    if (_username.text.length != 11) {
        [_username showWithError:@"手机号码格式不正确哦！"];
        return;
    }
    if (_password.text.length == 0) {
        [_password showWithError:@"密码不能为空哦!"];
        return;
    }
    if (_password.text.length <6) {
        [_password showWithError:@"密码至少要6位哦！"];
        return;
    }
    
    [self.view endEditing:YES];
    [myMBProgressHUD show:YES];
    NSString* mobile = _username.text;
    NSMutableString* tempPassword = [NSMutableString stringWithFormat:@"%@%@%@",[Commonality MD5:_password.text],@"$^i@#*Vm!all",mobile];
    md5Password = [Commonality MD5:tempPassword];
    
    [HttpRequest UserLoginRequestMobile:mobile password:md5Password delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

- (IBAction)registerButtonTouch:(UIButton *)sender {
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(registerEnter)]) {
//        [self.delegate registerEnter];
//    }
            [[AppDelegate App]click];
    UserRegisterViewController* myUserRegisterViewController = [[UserRegisterViewController alloc]init];
    myUserRegisterViewController.isFromLoginView = YES;
    [self.navigationController pushViewController:myUserRegisterViewController animated:NO];
}

- (IBAction)closeButtonTouch:(UIButton *)sender {
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(closeLoginView)]) {
//        [self.delegate closeLoginView];
//    }
            [[AppDelegate App]click];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark textfield methods

//-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
//{
//    if (textField == _username) {
//        if (textField.text.length != 11) {
//            //            [IVMallTools showErrorMsg:self.view type:0 msg:@"请输入正确的手机格式！"];
//            [_username showWithError:@"请输入正确的手机格式！"];
//            
//            return  YES;
//        }
//    }
//    else if (textField == _password)
//    {
//        if (textField.text.length < 6) {
//            //            [IVMallTools showErrorMsg:self.view type:0 msg:@"密码至少要6位哦"];
////            [IVMallTools showErrorMsg:self.view  type:0 msg:@"密码至少要6位哦" ];
//            [_password showWithError:@"密码至少要6位哦！"];
//            return YES;
//        }
//    }
//    return YES;
//}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if ([textField isKindOfClass:[JYTextField class]]) {
//        [(JYTextField*)textField beginEditing];
//    }
    [textField beginEditing];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if ([textField isKindOfClass:[JYTextField class]]) {
//        [(JYTextField*)textField endEditing];
//    }
    [textField endEditing];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    if (textField == _password) {
        [self loginButtonTouch:nil];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _username){
        if (range.location>10)
        {
            [_username showWithError:@"手机号码只有11位哦！"];
            return  NO;
        }
        else
        {
            return YES;
        }
    }else if(textField == _password){
        if(range.location>19){
            [_password showWithError:@"密码不能超过20位字符哦"];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

#pragma mark  - http delegate

-(void) GetErr:(ASIHTTPRequest *)request{
    if (request.tag == USER_LOGIN_TYPE) {
        [myMBProgressHUD hide:YES];
        [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
    }
}

-(void) GetResult:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (dictionary==nil) {
        if (request.tag == USER_LOGIN_TYPE) {
            [myMBProgressHUD hide:YES];
            [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
        }
    }else{
        if (request.tag == USER_LOGIN_TYPE) {
            [myMBProgressHUD hide:YES];
            [AppDelegate App].myUserLoginMode = [[UserLoginModel alloc]initWithDictionary:dictionary];
            if ([AppDelegate App].myUserLoginMode.errorCode == 0) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_username.text forKey:@"mobile"];
                [userDefaults setObject:md5Password forKey:@"password"];
                [userDefaults setObject:_password.text forKey:@"password2"];
                [userDefaults synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterLoginInSuccess object:nil];
                [HttpRequest UserDetailRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                [HttpRequest DevicesBindRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                [self afterLoginSucces];
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:[AppDelegate App].myUserLoginMode.errorMessage];
            }

        }else if (request.tag == USER_DETAIL_TYPE)
        {
            [AppDelegate App].UserInfo = [[UserDetailMode alloc]initWithDictionary:dictionary];
            if ([AppDelegate App].UserInfo.errorCode == 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterUserInfo object:nil];
                if (![Commonality isEmpty:[AppDelegate App].UserInfo.userImg]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterUserImage object:[AppDelegate App].UserInfo.userImg];
                }

            }
        }
    }
}

-(void)autoLogin:(NSNotification*)notification
{
    NSArray* loginInfo = (NSArray*)[notification object];
    if (loginInfo.count == 7) {
        _username.text = [loginInfo objectAtIndex:2];
        md5Password = [loginInfo objectAtIndex:4];
        [HttpRequest UserLoginRequestMobile:_username.text password:md5Password delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}

-(void)registerSuccess:(NSNotification*)notification
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString* mobile = [userDefaultes stringForKey:@"mobile"];
    NSString* password = [userDefaultes stringForKey:@"password"];
    if (![Commonality isEmpty:mobile]&&![Commonality isEmpty:password]) {
        [HttpRequest UserLoginRequestMobile:mobile password:password delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}

-(void)afterLoginSucces
{
    if (_myActionState == UnKnownAction) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }else {
        [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterAfterLoginInSuccess object:[NSNumber numberWithInteger: _myActionState]];
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
}

@end
