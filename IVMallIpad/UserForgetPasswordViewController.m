//
//  UserForgetPasswordViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserForgetPasswordViewController.h"
#import "Macro.h"
#import "Commonality.h"
#import "HttpRequest.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "NoDataModel.h"
@interface UserForgetPasswordViewController ()
{
    int seconds;
    NSTimer* myTimer;
    BOOL isPasswordFiledEdting;
    MBProgressHUD* myMBProgressHUD;
    NSString* md5PassWord;
}
@end

@implementation UserForgetPasswordViewController

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
//    _passWord = [_passWord initWithFrame:_passWord.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_passWord setStyle];
    _passWord.delegate = self;
    [_passWord setSecureTextEntry:YES];
    _passWord.keyboardType = UIKeyboardTypeASCIICapable;
//    _confirmPassWord
//    = [_confirmPassWord initWithFrame:_confirmPassWord.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_confirmPassWord setStyle];
    _confirmPassWord.delegate = self;
    [_confirmPassWord setSecureTextEntry:YES];
    _confirmPassWord.keyboardType = UIKeyboardTypeASCIICapable;
//    _securityCode = [_securityCode initWithFrame:_securityCode.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_securityCode setStyle];
    _securityCode.keyboardType = UIKeyboardTypeNumberPad;
    _securityCode.delegate = self;
    seconds = 120;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeViewEdit:)];
    [self.view addGestureRecognizer:tapGesture];
    
    myMBProgressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:myMBProgressHUD];
    

    
    [self setLabelBgColor];
    _lowLabel.layer.cornerRadius = 10;
    _midLabel.layer.cornerRadius = 10;
    _highLabel.layer.cornerRadius = 10;
    
    [_bgView setContentSize:CGSizeMake((iPad?760:380), (iPad?1200:600))];
    _bgView.delegate = self;
    _bgView.pagingEnabled = NO;
    _bgView.showsHorizontalScrollIndicator = NO;
    _bgView.showsVerticalScrollIndicator = NO;
    _bgView.scrollsToTop = YES;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
    
    NSString* mobile = [[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"];
    if (mobile) {
        _userName.text = mobile;
    }
    [self releaseTimer];
}

//如果登陆成功，停止验证码的倒数，
- (void)releaseTimer {
    if (myTimer) {
        [myTimer invalidate];
        myTimer=nil;
    }
    seconds = 120;
    [_securityCode setEnabled:YES];
}
- (IBAction)showPassWordButtonTouch:(UIButton *)sender {
    if (sender.selected == YES) {
        [sender setSelected:NO];
        [_passWord setSecureTextEntry:YES];
        [_confirmPassWord setSecureTextEntry:YES];
    }else{
        [sender setSelected:YES];
        [_passWord setSecureTextEntry:NO];
        [_confirmPassWord setSecureTextEntry:NO];
    }
}

#pragma mark textfield methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if ([textField isKindOfClass:[JYTextField class]]) {
//        [(JYTextField*)textField beginEditing];
//    }
    [textField beginEditing];
    
//    if (textField == _passWord) {
//        isPasswordFiledEdting = YES;
//    }
//    if (textField == _confirmPassWord) {
//        [self setViewFrame:1];
//    }
//    if (textField == _securityCode) {
//        [self setViewFrame:1];
//    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if ([textField isKindOfClass:[JYTextField class]]) {
//        [(JYTextField*)textField endEditing];
//    }
    [textField endEditing];
    
    if (textField == _passWord) {
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
    }else if(textField == _passWord)
    {
        
        if(range.location>19){
            [_passWord showWithError:@"密码不能超过20位字符哦!"];
            return NO;
        }else{
            return YES;
        }
    }else if(textField == _confirmPassWord){
        if(range.location>19){
            [_confirmPassWord showWithError:@"密码不能超过20位字符哦!"];
            return NO;
        }else{
            return YES;
        }
    }else if(textField == _securityCode){
        if(range.location>5){
            [_securityCode showWithError:@"验证码输入不能超过6位!"];
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
        int ret=[Commonality judgePasswordStrength:_passWord.text];
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
        if (_passWord.text.length == 0) {
            _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
            _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
            _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"dedede"];
        }
    }
    
}

-(void)timerFireMethod
{
    if (seconds == 1) {
        [myTimer invalidate];
        seconds = 120;
        myTimer=nil;
        [_securityCodeButton setTitle:@"获取验证码" forState: UIControlStateNormal];
        [_securityCodeButton setEnabled:YES];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"%d秒后重试",seconds];
        [_securityCodeButton setEnabled:NO];
        [_securityCodeButton setTitle:title forState:UIControlStateDisabled];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:NO];
        
    }
}

- (IBAction)securityCodeButtonTouch:(UIButton *)sender {
    
    if (myTimer != nil) {
        return;
    }
    [[AppDelegate App]click];
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
    if (_passWord.text.length == 0) {
        [_passWord showWithError:@"密码不能为空哦!"];
        return;
    }
    if (_passWord.text.length < 6) {
        [_passWord
         showWithError:@"密码不能少于6位哦!"];
        return;
    }
    if (![_passWord.text isEqualToString:_confirmPassWord.text]) {
        [_confirmPassWord showWithError:@"两次密码不一致哦!"];
        return;
    }
    if (_securityCode.text.length == 0) {
        [_securityCode showWithError:@"验证码不能为空哦!"];
        return;
    }
    if (_securityCode.text.length != 6) {
        [_securityCode showWithError:@"验证码不正确!"];
        return;
    }
    
    myMBProgressHUD.labelText = @"找回密码中...";
    [myMBProgressHUD show:YES];
    NSString* mobile = _userName.text;
    NSString* tempStr = [NSString stringWithFormat:@"%@%@%@",[Commonality MD5:_passWord.text],@"$^i@#*Vm!all",mobile];
    md5PassWord = [Commonality MD5:tempStr];
    [HttpRequest UserForgetPasswordRequestMobile:mobile validateCode:_securityCode.text password:md5PassWord delegate:self finishSel:@selector(GetResult:)  failSel:@selector(GetErr:)];

}

- (IBAction)closeButtonTouch:(UIButton *)sender {
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(closeForgetPasswordView)]) {
//        [self.delegate closeForgetPasswordView];
//    }
            [[AppDelegate App]click];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) GetErr:(ASIHTTPRequest *)request
{
    if (request.tag == USER_FORGETPASSWORD_TYPE || request.tag == USER_MOBILE_TYPE || request.tag == USER_SMS_TYPE ) {
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
        if (request.tag == USER_FORGETPASSWORD_TYPE || request.tag == USER_MOBILE_TYPE || request.tag == USER_SMS_TYPE) {
            [myMBProgressHUD hide:YES];
            [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
        }
    }else{
        if (request.tag == USER_MOBILE_TYPE) {
            NoDataModel* tempNoDataModel = [[NoDataModel alloc]initWithDictionary:dictionary];
            if (tempNoDataModel.errorCode == 101) {
                myMBProgressHUD.labelText = @"已请求验证码，请留意短信";
                [myMBProgressHUD show:YES];
                [HttpRequest UserSMSRequestMobile:_userName.text delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }else if(tempNoDataModel.errorCode == 102 || tempNoDataModel.errorCode == 0){
                [Commonality showErrorMsg:self.view type:0 msg:@"该手机号码未注册，请先注册"];
                [myMBProgressHUD hide:YES];
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:tempNoDataModel.errorMessage];
                [myMBProgressHUD hide:YES];
            }
        }else if(request.tag == USER_SMS_TYPE){
            [myMBProgressHUD hide:YES];
            NoDataModel* tempNoDataModel = [[NoDataModel alloc]initWithDictionary:dictionary];
            if (tempNoDataModel.errorCode == 0) {
                myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:NO];
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:tempNoDataModel.errorMessage];
            }
        }else if(request.tag == USER_FORGETPASSWORD_TYPE){
            [myMBProgressHUD hide:YES];
            NoDataModel* temp = [[NoDataModel alloc]initWithDictionary:dictionary];
            if (temp.errorCode == 0) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults]setObject:_userName.text forKey:@"mobile"];
                [self.navigationController popViewControllerAnimated:NO];
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:temp.errorMessage];
            }
        }
    }
    
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
        default:
            break;
    }
}

-(void)setLabelBgColor
{
    _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
    _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
    _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
}


@end
