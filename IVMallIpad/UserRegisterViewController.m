//
//  UserRegisterViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "Macro.h"
#import "Commonality.h"
#import "HttpRequest.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "NoDataModel.h"
#import "UserRegisterModel.h"
@interface UserRegisterViewController ()
{
    int seconds;
    NSTimer* myTimer;
    BOOL isPasswordFiledEdting;
    MBProgressHUD* myMBProgressHUD;
    NSString* md5PassWord;
}

@end

@implementation UserRegisterViewController

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
    // Do any additional setup after loading the view from its nib.
    isPasswordFiledEdting = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boxValueChanged) name:UITextFieldTextDidChangeNotification object:nil];
//    _userName = [_userName initWithFrame:_userName.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_userName setStyle];
    _userName.delegate = self;
    _userName.keyboardType = UIKeyboardTypeNumberPad;
//    _password = [_password initWithFrame:_password.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_password setStyle];
    _password.delegate = self;
    [_password setSecureTextEntry:YES];
//    _confirmPassword = [_confirmPassword initWithFrame:_confirmPassword.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_confirmPassword setStyle];
    _confirmPassword.delegate = self;
    [_confirmPassword setSecureTextEntry:YES];
//    _checkCode = [_checkCode initWithFrame:_checkCode.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_checkCode setStyle];
    _checkCode.delegate = self;
    _checkCode.keyboardType = UIKeyboardTypeNumberPad;
//    _free = [_free initWithFrame:_free.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_free setStyle];
    _free.delegate = self;
    
    if ([AppDelegate App].charge && [[AppDelegate App].charge isEqualToString:@"true"]) {
        [_free setHidden:NO];
    }else{
        [_free setHidden:YES];
    }
    seconds = 120;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeViewEdit:)];
    [self.view addGestureRecognizer:tapGesture];
    
    myMBProgressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:myMBProgressHUD];
    
    
    _lowLabel.layer.cornerRadius = (iPad?10:5);
    _midLabel.layer.cornerRadius = (iPad?10:5);
    _highLabel.layer.cornerRadius = (iPad?10:5);
    _lowLabel.font = [UIFont systemFontOfSize:(iPad?16:12)];
    _midLabel.font = [UIFont systemFontOfSize:(iPad?16:12)];
    _highLabel.font = [UIFont systemFontOfSize:(iPad?16:12)];
    
    [_bgView setContentSize:CGSizeMake((iPad?760:380), (iPad?800:450))];
    _bgView.delegate = self;
    _bgView.pagingEnabled = NO;
    _bgView.showsHorizontalScrollIndicator = NO;
    _bgView.showsVerticalScrollIndicator = NO;
    _bgView.scrollsToTop = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self releaseTimer];

    _free.text = [AppDelegate App].couponCode;
    
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
    if ([self.navigationController childViewControllers].count >2) {
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_07-18.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_07-19.png"] forState:UIControlStateHighlighted];
    }else{
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close_sel.png"] forState:UIControlStateHighlighted];
    }
    
    
}

//如果登陆成功，停止验证码的倒数，
- (void)releaseTimer {
    if (myTimer) {
        [myTimer invalidate];
        myTimer=nil;
    }
    seconds = 120;
    [_checkCodeButton setEnabled:YES];
    
}
#pragma mark textfield methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if ([textField isKindOfClass:[JYTextField class]]) {
//        [(JYTextField*)textField beginEditing];
//    }
    [textField beginEditing];
    
    if (textField == _password) {
        isPasswordFiledEdting = YES;
    }
//    if (textField == _confirmPassword) {
//        [self setViewFrame:1];
//    }
//    if (textField == _checkCode) {
//        [self setViewFrame:2];
//    }
//    if (textField == _free) {
//        [self setViewFrame:3];
//    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if ([textField isKindOfClass:[JYTextField class]]) {
//        [(JYTextField*)textField endEditing];
//    }
    [textField endEditing];
    if (textField == _password) {
        isPasswordFiledEdting = NO;
    }
//    [self setViewFrame:0];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _userName)
    {
        if (range.location>10)
        {

            [_userName showWithError:@"手机号码只有11位哦!"];
            return  NO;
        }
        else
        {
            return YES;
        }
    }else if(textField == _password)
    {
        
        if(range.location>19){
            [_password showWithError:@"密码不能超过20位字符哦!"];
            return NO;
        }else{
            return YES;
        }
    }else if(textField == _confirmPassword){
        if(range.location>19){
            [_confirmPassword showWithError:@"密码不能超过20位字符哦!"];
            return NO;
        }else{
            return YES;
        }
    }else if(textField == _checkCode){
        if(range.location>5){
            [_checkCode showWithError:@"验证码输入不能超过6位!"];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

-(void)boxValueChanged
{
    if (isPasswordFiledEdting) {
        int ret=[Commonality judgePasswordStrength:_password.text];
        switch (ret) {
            case 0:
                _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"eeaaab"];
                _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
                _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
                break;
            case 1:
                _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
                _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"efd0a1"];
                _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
                
                break;
            case 2:
                _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
                _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
                _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"b1eeab"];
                
                break;
            default:
                break;
        }
        if (_password.text.length == 0) {
            _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
            _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
            _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
        }
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeViewEdit:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)checkCodeButtonTouch:(UIButton *)sender {
    
    if (myTimer != nil) {
        return;
    }
    [[AppDelegate App]click];
    [self.view endEditing:YES];
    if (_userName.text.length == 0) {
        [_userName showWithError:@"手机号码不能为空哦!"];
        return;
    }
    if (_userName.text.length != 11) {
        [_userName showWithError:@"手机号码格式不正确哦!"];
        return;
    }

    if ([Commonality isEnableWIFI] == 0) {
        [Commonality showErrorMsg:self.view type:0 msg:FAIILURE];
        return;
    }
    
    [myMBProgressHUD show:YES];
    [HttpRequest UserMobileRequestMobile:_userName.text delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    
}
- (IBAction)okButtonTouch:(UIButton *)sender {
    
    [[AppDelegate App]click];
    [self.view endEditing:YES];
    
    if ([Commonality isEnableWIFI] == 0) {
        [Commonality showErrorMsg:self.view type:0 msg:FAIILURE];
        return;
    }
    
    if (_userName.text.length == 0) {
        [_userName showWithError:@"手机号码不能为空哦!"];
        return;
    }
    if (_userName.text.length != 11) {
        [_userName showWithError:@"手机号码格式不正确哦!"];
        return;
    }
    if (_password.text.length == 0) {
        [_password showWithError:@"密码不能为空哦!"];
        return;
    }
    if (_password.text.length < 6) {
        [_password showWithError:@"密码不能少于6位字符哦!"];
        return;
    }
    if (![_password.text isEqualToString:_confirmPassword.text]) {
        [_confirmPassword showWithError:@"两次密码不一致哦!"];
        return;
    }
    if (_checkCode.text.length == 0) {
        [_checkCode showWithError:@"验证码不能为空哦!"];
        return;
    }
    if (_checkCode.text.length != 6) {
        [_checkCode showWithError:@"验证码不正确"];
        return;
    }
   
    myMBProgressHUD.labelText = @"注册中...";
    [myMBProgressHUD show:YES];
    NSString* mobile = _userName.text;
    NSString* tempStr = [NSString stringWithFormat:@"%@%@%@",[Commonality MD5:_password.text],@"$^i@#*Vm!all",mobile];
    md5PassWord = [Commonality MD5:tempStr];
    if ([Commonality isEmpty:_free.text]) {
        [HttpRequest UserRegisterRequestMobile:mobile password:md5PassWord checkcode:_checkCode.text couponcode:nil delegate:self finishSel:@selector(GetResult:)  failSel:@selector(GetErr:)];
    }else{
        [HttpRequest UserRegisterRequestMobile:mobile password:md5PassWord checkcode:_checkCode.text couponcode:_free.text delegate:self finishSel:@selector(GetResult:)  failSel:@selector(GetErr:)];
    }
   
}

-(void)timerFireMethod
{
    if (seconds == 1) {
        [myTimer invalidate];
        seconds = 120;
        myTimer=nil;
        [_checkCodeButton setTitle:@"获取验证码" forState: UIControlStateNormal];
        [_checkCodeButton setEnabled:YES];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"%d秒后重试",seconds];
        [_checkCodeButton setEnabled:NO];
        [_checkCodeButton setTitle:title forState:UIControlStateDisabled];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:NO];
        
    }
}

-(void) GetErr:(ASIHTTPRequest *)request
{
    if (request.tag == USER_REGISTER_TYPE || request.tag == USER_MOBILE_TYPE || request.tag == USER_SMS_TYPE ) {
        [myMBProgressHUD hide:YES];
        [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
    }
}

-(void) GetResult:(ASIHTTPRequest *)request{
    //成功  这里怎么写
    NSData *responseData = [request responseData];
    NSLog(@"%@",[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if(dictionary==nil){
        if (request.tag == USER_REGISTER_TYPE || request.tag == USER_MOBILE_TYPE || request.tag == USER_SMS_TYPE) {
            [myMBProgressHUD hide:YES];
            [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
        }
    }else{
        if (request.tag == USER_MOBILE_TYPE) {
            NoDataModel* tempNoDataModel = [[NoDataModel alloc]initWithDictionary:dictionary];
            if (tempNoDataModel.errorCode == 101) {
                [Commonality showErrorMsg:self.view type:0 msg:@"该手机号码已注册过哦！"];
                [myMBProgressHUD hide:YES];
                
            }else if(tempNoDataModel.errorCode == 232 || tempNoDataModel.errorCode == 233 || tempNoDataModel.errorCode == 234){
                [Commonality showErrorMsg:self.view type:0 msg:tempNoDataModel.errorMessage];
                [myMBProgressHUD hide:YES];
            }else{
                myMBProgressHUD.labelText = @"已请求验证码，请留意短信";
                [myMBProgressHUD show:YES];
                [HttpRequest UserSMSRequestMobile:_userName.text delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }
        }else if(request.tag == USER_SMS_TYPE){
             [myMBProgressHUD hide:YES];
            NoDataModel* tempNoDataModel = [[NoDataModel alloc]initWithDictionary:dictionary];
            if (tempNoDataModel.errorCode == 0) {
                myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:NO];
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:tempNoDataModel.errorMessage];
            }
        }else if(request.tag == USER_REGISTER_TYPE){
            [myMBProgressHUD hide:YES];
            UserRegisterModel* temp = [[UserRegisterModel alloc]initWithDictionary:dictionary];
            if (temp.result == 0) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_userName.text forKey:@"mobile"];
                [userDefaults setObject:md5PassWord forKey:@"password"];
                [userDefaults setObject:_password.text forKey:@"password2"];
                [userDefaults synchronize];
                if (_isFromLoginView) {
                    [_registerSucessView setHidden:NO];
                    [self performSelector:@selector(registerSuccess) withObject:nil afterDelay:2.0];
                }else{
                    [Commonality showErrorMsg:self.view type:0 msg:@"注册成功！"];
//                    [self.navigationController popViewControllerAnimated:NO];
                    [self performSelector:@selector(sleepThread) withObject:nil afterDelay:3.0];
//                    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//                    NSString* mobile = [userDefaultes stringForKey:@"mobile"];
//                    NSString* password = [userDefaultes stringForKey:@"password"];
//                    if (![Commonality isEmpty:mobile]&&![Commonality isEmpty:password]) {
//                        [HttpRequest UserLoginRequestMobile:mobile password:password delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
//                    }
                }
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:temp.errorMessage];
            }
        }else if (request.tag == USER_LOGIN_TYPE) {
            [myMBProgressHUD hide:YES];
            [AppDelegate App].myUserLoginMode = [[UserLoginModel alloc]initWithDictionary:dictionary];
            if ([AppDelegate App].myUserLoginMode.errorCode == 0) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_userName.text forKey:@"mobile"];
                [userDefaults setObject:md5PassWord forKey:@"password"];
                [userDefaults setObject:_password.text forKey:@"password2"];
                [userDefaults synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterLoginInSuccess object:nil];
                [HttpRequest UserDetailRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
                [HttpRequest DevicesBindRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
//                [self afterLoginSucces];
                [self.navigationController popViewControllerAnimated:NO];
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

- (void)sleepThread
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString* mobile = [userDefaultes stringForKey:@"mobile"];
    NSString* password = [userDefaultes stringForKey:@"password"];
    if (![Commonality isEmpty:mobile]&&![Commonality isEmpty:password]) {
        [HttpRequest UserLoginRequestMobile:mobile password:password delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}


- (void)registerSuccess
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterRegisterInSuccess object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)closeButtonTouch:(UIButton *)sender {
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(closeRegisterView)]) {
//        [self.delegate closeRegisterView];
//    }
    [[AppDelegate App]click];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)setViewFrame:(NSInteger)forInput//
{
    switch (forInput) {
        case 0:
        {
            if (iPad) {
                _bgView.frame = CGRectMake(0, 0, 760, 548);
            }else{
                _bgView.frame = CGRectMake(0, 0, 385, 260);
            }
            break;
        }
        case 1:
        {
            if (iPad) {
                _bgView.frame = CGRectMake(0, -100, 760, 548);
            }else{
                _bgView.frame = CGRectMake(0, 0, 385, 260);
            }
            break;
        }
        case 2:
        {
            if (iPad) {
                _bgView.frame = CGRectMake(0, -100, 760, 548);
            }else{
                _bgView.frame = CGRectMake(0, 0, 385, 260);
            }
            break;
        }
        case 3:
        {
            if (iPad) {
                _bgView.frame = CGRectMake(0, -200, 760, 548);
            }else{
                _bgView.frame = CGRectMake(0, 0, 385, 260);
            }
            break;
        }
        default:
            break;
    }
}

@end
