//
//  UserDetailAndUpdateViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserDetailAndUpdateViewController.h"
#import "AppDelegate.h"
#import "Commonality.h"
#import "ASIClasses/ASIHTTPRequest.h"
#import "Macro.h"
#import "UIImageView+WebCache.h"

@interface UserDetailAndUpdateViewController ()

@end

@implementation UserDetailAndUpdateViewController
{
    BOOL checkFlag;
    UITapGestureRecognizer* tapForFocusOff;
    NotWiFiView* myNotWiFiView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UserImagehadGet:) name:NSNotificationCenterUserImage object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boxValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterUserImage object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(iPad){
        _UserDefinedPhotoImageView.layer.cornerRadius = 50;
    }else {
//        _UserDefinedPhotoImageView.layer.cornerRadius = 15;
    }
    _UserDefinedPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _UserDefinedPhotoImageView.layer.borderWidth = 0.0f;
    _UserDefinedPhotoImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _UserDefinedPhotoImageView.layer.shouldRasterize = YES;
    _UserDefinedPhotoImageView.clipsToBounds = YES;
    _UserDefinedPhotoImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePicture:)];
//    [_UserDefinedPhotoImageView addGestureRecognizer:tapGesture];
    UIImage* tempImage = [Commonality createImageWithColor:[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.2]];
    [_userDefinedPhotoButton setBackgroundImage:tempImage forState:UIControlStateHighlighted];
    _userDefinedPhotoButton.layer.cornerRadius = (iPad?50:15);
    _userDefinedPhotoButton.clipsToBounds = YES;
    [_userDefinedPhotoButton addTarget:self action:@selector(changePicture:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addResetPasswordView];
    [self addUserInfoView];
    
    myNotWiFiView = [[NotWiFiView alloc]init];
    [myNotWiFiView setNotWiFiStyle:AreaUserInfoWithoutWifi];
    myNotWiFiView.delegate = self;
    [myNotWiFiView setHidden:YES];
    myNotWiFiView.opaque = NO;
    [_userInfoView addSubview:myNotWiFiView];
        
    

    
    tapForFocusOff = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusChanged:)];
    [self.view addGestureRecognizer:tapForFocusOff];
    
    
    myMBProgressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:myMBProgressHUD];
    myMBProgressHUD.labelText = @"正在请求";
    
    _lowLabel.layer.cornerRadius = (iPad?10:5);
    _midLabel.layer.cornerRadius = (iPad?10:5);
    _highLabel.layer.cornerRadius = (iPad?10:5);
    
    
    _UserInfoScrollViewBg.delegate = self;
    if (iPad) {
        _UserInfoScrollViewBg.contentSize = CGSizeMake(500, 330);
    }else{
        _UserInfoScrollViewBg.contentSize = CGSizeMake(250, 250);
    }
    if (iPad) {
        _resetPasswordScrollViewBg.contentSize = CGSizeMake(500, 370);
    }else{
        _resetPasswordScrollViewBg.contentSize = CGSizeMake(250, 250);
    }
    _UserInfoScrollViewBg.scrollEnabled = YES;
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

-(void)changePicture:(UIButton*)sender
{
    [[AppDelegate App]click];
    if([AppDelegate App].myUserLoginMode.token)//登录
    {
        UIActionSheet*action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择本地图片", nil];
        [action showInView:self.view];
    }else{
//        UserLoginViewController* myUserLoginViewController = [[UserLoginViewController alloc]init];
//        myUserLoginViewController.myActionState = UnKnownAction;
//        [self.navigationController pushViewController:myUserLoginViewController animated:NO];
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

        }];
        
    }else if (buttonIndex==1){
        [[AppDelegate App]click];
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:^{

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
        
    }];
    
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

-(void)setIndividualInfo
{
    _nickNameInputField.text = [AppDelegate App].UserInfo.nickname;
    _emailInputField.text = [AppDelegate App].UserInfo.email;
    _gender.selectedSegmentIndex = [[AppDelegate App].UserInfo.gender isEqualToString:@"male"]?0:1;
    _birthdayLabel.text = [AppDelegate App].UserInfo.birthday;
    _addressInputTextView.text = [AppDelegate App].UserInfo.address;
    [_UserDefinedPhotoImageView setImageWithURL:[NSURL URLWithString:[AppDelegate App].UserInfo.userImg] placeholderImage:[UIImage imageNamed:@"head2.png"]];
}

-(void)addUserInfoView
{
    UITapGestureRecognizer* birthdayCellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBirthday)];
    [_birthdayCell addGestureRecognizer:birthdayCellTap];
    
    
    _nickNameInputField.tag = 2011;
    _emailInputField.tag = 2012;
    _addressInputTextView.tag = 2013;
    
    _nickNameInputField.delegate = self;
    _emailInputField.delegate = self;
    _addressInputTextView.delegate = self;
    
    [self setCellBackGroundColor];
    
    NSDate *tempDate=[[NSDate alloc]init];
    if ([[AppDelegate App].UserInfo.birthday isEqualToString:@""]||[AppDelegate App].UserInfo.birthday == nil||[[AppDelegate App].UserInfo.birthday isEqualToString:@"(null)"]){
        
        tempDate=[NSDate date];
    }else{
        //        tempDate = [Commonality dateFromString:[AppDelegate App].UserInfo.birthday];
    }
    
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    // 设置当前显示时间
    [_datePicker setDate:tempDate animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [_datePicker setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    
//    _gender.segmentedControlStyle = UISegmentedControlStyleBar;

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont boldSystemFontOfSize:(iPad?18:15)],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [_gender setTitleTextAttributes:dic forState:UIControlStateSelected];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[Commonality colorFromHexRGB:@"dddddd"],UITextAttributeTextColor,  [UIFont systemFontOfSize:(iPad?15:13)],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [_gender setTitleTextAttributes:dic2 forState:UIControlStateNormal];

    _gender.layer.masksToBounds = YES;
    _gender.layer.borderWidth = 1.5f;
    _gender.layer.cornerRadius = 4;
    _gender.layer.borderColor = [Commonality colorFromHexRGB:@"69a029"].CGColor;
//    _gender.backgroundColor = [Commonality colorFromHexRGB:@"69a029"];
//    [_gender setTintColor:[UIColor whiteColor]];
    [_gender setTintColor:[Commonality colorFromHexRGB:@"69a029"]];

//    [_gender setWidth:(iPad?58:27) forSegmentAtIndex:_gender.selectedSegmentIndex];

    if (iPad) {
        _gender.frame = CGRectMake(357, 7, 123, 36);
    }else{
        _gender.frame = CGRectMake(185, 5, 60, 20);
    }
    
    [_gender addTarget:self action:@selector(genderSelected:) forControlEvents:UIControlEventValueChanged];
    
    [_gender setBackgroundImage:[UIImage imageNamed:@"gender_bg@2x"] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhonePrompt];
    
    
    
    _resetPasswordBtn.titleLabel.textColor = [UIColor blackColor];
    
    [HttpRequest UserDetailRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

-(void)genderSelected:(UISegmentedControl *)seg
{
//    [_gender setImage:[UIImage imageNamed:@"gender_bg@2x"] forSegmentAtIndex:seg.selectedSegmentIndex];
//    [_gender setWidth:(iPad?50:27) forSegmentAtIndex:seg.selectedSegmentIndex];
}


-(void)addResetPasswordView
{
//    _oldPasswordTextField = [_oldPasswordTextField initWithFrame:_oldPasswordTextField.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_oldPasswordTextField setStyle];
    _oldPasswordTextField.delegate = self;
    _oldPasswordTextField.layer.cornerRadius = (iPad?10:5);
    _oldPasswordTextField.secureTextEntry = YES;
    _oldPasswordTextField.tag = 2001;
    _oldPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
//    _myNewPasswordTextField = [_myNewPasswordTextField initWithFrame:_myNewPasswordTextField.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_myNewPasswordTextField setStyle];
    _myNewPasswordTextField.delegate = self;
    _myNewPasswordTextField.layer.cornerRadius = (iPad?10:5);
    _myNewPasswordTextField.secureTextEntry = YES;
    _myNewPasswordTextField.tag = 2002;
    _myNewPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
//    _verifyNewPasswordTextField = [_verifyNewPasswordTextField initWithFrame:_verifyNewPasswordTextField.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_verifyNewPasswordTextField setStyle];
    _verifyNewPasswordTextField.delegate = self;
    _verifyNewPasswordTextField.layer.cornerRadius = (iPad?10:5);
    _verifyNewPasswordTextField.secureTextEntry = YES;
    _verifyNewPasswordTextField.tag = 2003;
    _verifyNewPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    
    _doResetPasswordBtn.layer.cornerRadius = 5;
}

-(void)selectBirthday
{
    if (_dataPickView.hidden) {
        _dataPickView.hidden = NO;
        _saveUserInfoBtn.hidden = YES;
        
        [self focusChanged:nil];
    }else{
        _dataPickView.hidden = YES;
        _saveUserInfoBtn.hidden = NO;
    }
}
- (IBAction)datePickDone:(id)sender {

//    [HttpRequest UserUpdateRequestToken:[AppDelegate App].myUserLoginMode.token nickName:@"" email:@"" birthday:[NSString stringWithFormat:@"%@",[Commonality Date2Str3:_datePicker.date]] gender:@"" address:@"" delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            [[AppDelegate App]click];
    NSLog(@"%@",_datePicker.date);
    _birthdayLabel.text = [NSString stringWithFormat:@"%@",[Commonality Date2Str3:_datePicker.date]];
    _dataPickView.hidden = YES;
    _saveUserInfoBtn.hidden = NO;
}


- (IBAction)showPasswordBtnTouched:(id)sender {
            [[AppDelegate App]click];
    BOOL showKeyboard = [_myNewPasswordTextField isFirstResponder];
    _myNewPasswordTextField.enabled = NO;
    if (_myNewPasswordTextField.secureTextEntry) {
        [_showPasswordBtn setBackgroundImage:[UIImage imageNamed:@"icon_130"] forState:UIControlStateNormal];
        _myNewPasswordTextField.secureTextEntry = NO;
        _verifyNewPasswordTextField.secureTextEntry = NO;
        _oldPasswordTextField.secureTextEntry = NO;
    }else{
        [_showPasswordBtn setBackgroundImage:[UIImage imageNamed:@"icon_132"] forState:UIControlStateNormal];
        _myNewPasswordTextField.secureTextEntry = YES;
        _verifyNewPasswordTextField.secureTextEntry = YES;
        _oldPasswordTextField.secureTextEntry = YES;
    }
    
    _myNewPasswordTextField.enabled = YES;
    if (showKeyboard) {
        [_myNewPasswordTextField becomeFirstResponder];
    }
}

- (IBAction)doResetPasswd:(id)sender {//buttonTouched
            [[AppDelegate App]click];
    if ([Commonality isEnableWIFI] == 0) {
        [Commonality showErrorMsg:self.view type:0 msg:FAIILURE];
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (_oldPasswordTextField.text.length == 0) {
        [_oldPasswordTextField showWithError:@"旧密码输入不能为空"];
        return;
    }
    if (_myNewPasswordTextField.text.length == 0) {
        [_myNewPasswordTextField showWithError:@"密码输入不能为空"];
        return;
    }
    if (_verifyNewPasswordTextField.text.length == 0) {
        [_verifyNewPasswordTextField showWithError:@"密码输入不能为空"];
        return;
    }
    if (_myNewPasswordTextField.text.length < 6) {
        [_myNewPasswordTextField showWithError:@"密码输入不能少于6位"];
        return;
    }
    if (_verifyNewPasswordTextField.text.length < 6) {
        [_verifyNewPasswordTextField showWithError:@"密码输入不能少于6位"];
        return;
    }
    if ([_oldPasswordTextField.text isEqualToString:[userDefaults objectForKey:@"password2"]] == NO) {
        [_oldPasswordTextField showWithError:@"旧密码输入错误"];
        return;
    }
    if ([_myNewPasswordTextField.text isEqualToString:_verifyNewPasswordTextField.text] == NO) {
        [_verifyNewPasswordTextField showWithError: @"两次密码不一致哦!"];
        return;
    }
//    if ([_myNewPasswordTextField.text isEqualToString:[userDefaults objectForKey:@"password2"]] == YES) {
//        [_myNewPasswordTextField showWithError:@"新密码与旧密码相同！"];
//        return;
//    }
    
    NSMutableString *str1=[NSMutableString stringWithString:_myNewPasswordTextField.text];
    NSMutableString *tempStr1 = [NSMutableString stringWithFormat:@"%@%@%@",[Commonality MD5:str1],@"$^i@#*Vm!all",[[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"]];
    
    self.md5Password = [Commonality MD5: tempStr1];
    self.password = _myNewPasswordTextField.text;
    
    
    NSMutableString *str2 = [NSMutableString stringWithString:_oldPasswordTextField.text];
    NSMutableString *tempStr2 = [NSMutableString stringWithFormat:@"%@%@%@",[Commonality MD5:str2],@"$^i@#*Vm!all",[[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"]];
    NSString *old = [Commonality MD5:tempStr2];
    
    [HttpRequest UserUpdatePasswordRequestToken:[AppDelegate App].myUserLoginMode.token oldPassword:old onewPassword:self.md5Password delegate: self finishSel: @selector(GetResult:) failSel:@selector(GetErr:)];
    
    [_oldPasswordTextField resignFirstResponder];
    [_myNewPasswordTextField resignFirstResponder];
    [_verifyNewPasswordTextField resignFirstResponder];
    
    [self clearAllTextField];
    [self setLabelBgColor];
}

- (IBAction)doSaveUserInfo:(id)sender {
    
    
    [[AppDelegate App]click];
    if (![self isValidateEmail:_emailInputField.text]) {
        [Commonality showErrorMsg:self.view type:0 msg:@"请输入正确的邮箱地址"];
        return;
    }
    
    if (_nickNameInputField.text == nil || [_nickNameInputField.text isEqualToString:@""]) {
        [Commonality showErrorMsg:self.view type:0 msg:@"昵称不能为空哦！"];
        return;
    }
    
    [HttpRequest UserUpdateRequestToken:[AppDelegate App].myUserLoginMode.token nickName:_nickNameInputField.text email:_emailInputField.text birthday:_birthdayLabel.text gender:(_gender.selectedSegmentIndex == 0?@"male":@"female") address:_addressInputTextView.text delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    [myMBProgressHUD show:YES];
}


- (IBAction)showUserInfoView:(id)sender {//userInfoBtnTouched
            [[AppDelegate App]click];
    _userInfoView.hidden = NO;
    _resetPasswordView.hidden = YES;
    [_resetPasswordBtn setBackgroundImage:nil forState:UIControlStateNormal];
    _resetPasswordBtn.titleLabel.textColor = [Commonality colorFromHexRGB:@"000000"];
    
    [_userInfoBtn setBackgroundImage:[UIImage imageNamed:@"button_bg0"] forState:UIControlStateNormal];
    _userInfoBtn.titleLabel.textColor = [Commonality colorFromHexRGB:@"69a029"];
    
    [self focusChanged:nil];
}

- (IBAction)showResetPasswordView:(id)sender {//resetPasswordBtnTouched
            [[AppDelegate App]click];
    _userInfoView.hidden = YES;
    _resetPasswordView.hidden = NO;
    [_userInfoBtn setBackgroundImage:nil forState:UIControlStateNormal];
    _userInfoBtn.titleLabel.textColor = [Commonality colorFromHexRGB:@"000000"];
    
    _resetPasswordBtn.titleLabel.textColor = [Commonality colorFromHexRGB:@"69a029"];
    [_resetPasswordBtn setBackgroundImage:[UIImage imageNamed:@"button_bg0"] forState:UIControlStateNormal];
    
    [self focusChanged:nil];
}

- (IBAction)close:(id)sender {
            [[AppDelegate App]click];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterUserImage object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)focusChanged:(id)sender
{
    [self setUserInfoViewFrame:NO];
    
    [self setCellBackGroundColor];
    
//    if (_dataPickView.hidden == NO) {
//        _dataPickView.hidden = YES;
//    }
    
    [_addressInputTextView resignFirstResponder];
    [_emailInputField resignFirstResponder];
    [_nickNameInputField resignFirstResponder];
    [_oldPasswordTextField resignFirstResponder];
    [_myNewPasswordTextField resignFirstResponder];
    [_verifyNewPasswordTextField resignFirstResponder];
}

#pragma mark gesture delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == tapForFocusOff) {
        if ([touch.view isKindOfClass:[UITextView class]]) {
            return NO;
        }
        return YES;
    }
    return YES;
}



#pragma mark request delegate
-(void) GetErr:(ASIHTTPRequest *)request
{
    if (request.tag == USER_UPDATE_TYPE || request.tag == USER_DETAIL_TYPE) {
        [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
        [myMBProgressHUD hide:YES];
        
        myNotWiFiView.hidden = NO;
        [_userInfoView bringSubviewToFront:myNotWiFiView];
    }
}

-(void) GetResult:(ASIHTTPRequest *)request
{
    //成功  这里怎么写

    NSData *responseData = [request responseData];
    //NSLog(@"%@",[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);xiuagi
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if(dictionary==nil){
        [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
        myNotWiFiView.hidden = NO;
        [_userInfoView bringSubviewToFront:myNotWiFiView];
        
    }else{
        if (request.tag == USER_UPDATEPASSWORD_TYPE) {
            if ([[dictionary objectForKey:@"errorCode"]isEqualToString:@"0"]) {
                [Commonality showErrorMsg:self.view type:0 msg:@"修改密码成功!"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:self.md5Password forKey:@"password"];
                [userDefaults setObject:self.password forKey:@"password2"];
                [userDefaults synchronize];
//                [self performSelector:@selector(back) withObject:self afterDelay:0.6];
            }
        }else if(request.tag == USER_DETAIL_TYPE){
            if ([[dictionary objectForKey:@"errorCode"]isEqualToString:@"0"]) {
                [AppDelegate App].UserInfo = [[UserDetailMode alloc]initWithDictionary:dictionary];
                [self setIndividualInfo];
            }
        }else if (request.tag == USER_UPDATE_TYPE){
            [myMBProgressHUD hide:YES];
            [Commonality showErrorMsg:self.view type:0 msg:@"修改成功"];
        }
    }
}


#pragma mark textfield delegate methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 2002)
    {
        if (textField.text.length < 6) {
            [_myNewPasswordTextField showWithError: @"密码至少要6位哦"];
            return YES;
        }
    }
    else if (textField.tag == 2003)
    {
        if ([_verifyNewPasswordTextField.text isEqualToString:_myNewPasswordTextField.text]==NO && _verifyNewPasswordTextField.text.length != 0 && _myNewPasswordTextField.text.length != 0){
            [_verifyNewPasswordTextField showWithError: @"两次密码不一致哦!"];
            return YES;
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _nickNameInputField) {
        _nickNameInputField.textAlignment = NSTextAlignmentLeft;
        _nickNameCell.backgroundColor = [UIColor whiteColor];
        _emailCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
        _addressCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
    }else if (textField == _emailInputField){
        _emailInputField.textAlignment = NSTextAlignmentLeft;
        _nickNameCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
        _emailCell.backgroundColor = [UIColor whiteColor];
        _addressCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
    }
    
    if (textField.tag == 2002) {
        _isPasswordFiledEdting = YES;
    }
    if (textField.tag == 2013) {
        [self setUserInfoViewFrame:YES];
    }
    if (textField == _verifyNewPasswordTextField) {
//        [self setResetPasswordViewFrame:YES];
    }

    if (textField == _oldPasswordTextField || textField == _myNewPasswordTextField || textField == _verifyNewPasswordTextField) {
        [textField beginEditing];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField ==_nickNameInputField) {
        _nickNameInputField.textAlignment = NSTextAlignmentRight;
    }
    if (textField == _emailInputField) {
        _emailInputField.textAlignment = NSTextAlignmentRight;
    }
    
    if (textField.tag == 2002) {
        _isPasswordFiledEdting = NO;
    }
    if (textField.tag == 2013) {
        [self setUserInfoViewFrame:NO];
    }
    if (textField == _verifyNewPasswordTextField) {
//        [self setResetPasswordViewFrame:NO];
    }

    if (textField == _oldPasswordTextField || textField == _myNewPasswordTextField || textField == _verifyNewPasswordTextField) {
        [textField endEditing];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    placeholderlabel.hidden=YES;
    if (textField == _nickNameInputField && textField.text.length >= 1) {
        unichar temp = [textField.text characterAtIndex:0];
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
        if([doNotWant characterIsMember:temp])
        {
            [Commonality showErrorMsg:self.view type:0 msg:@"禁用非法字符！"];
//                return NO;
        }
    }
    
    
    if(textField == _nickNameInputField){
        if (range.location>14 && ![textField.text isEqualToString:@""]) {
            [Commonality showErrorMsg:self.view type:0 msg:@"昵称不能超过15位！"];
            return NO;
        }else{
            return YES;
        }
    }
    if (textField == _oldPasswordTextField) {
        if (range.location > 19 && ![textField.text isEqualToString:@""]) {
            [_oldPasswordTextField showWithError:@"密码不能超过20位！"];
            return NO;
        }
    }
    if (textField == _myNewPasswordTextField) {
        if (range.location > 19 && ![textField.text isEqualToString:@""]) {
            [_myNewPasswordTextField showWithError:@"密码不能超过20位！"];
            return NO;
        }
    }
    if (textField == _verifyNewPasswordTextField) {
        if (range.location > 19 && ![textField.text isEqualToString:@""]) {
            [_verifyNewPasswordTextField showWithError:@"密码不能超过20位！"];
            return NO;
        }
    }
    
    if ([textField.text isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField.tag == 2002) {
        [self setLabelBgColor];
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //    if (textField.tag == 2003) {
    [self.view endEditing:YES];
    //    }
    
    return YES;
}

-(void)boxValueChanged:(UITextField *)textField
{
    if (_isPasswordFiledEdting) {
        UITextField * NewtextField = (UITextField *)[self.view viewWithTag:2002];
  
            int ret=[Commonality judgePasswordStrength:NewtextField.text];
            
            switch (ret) {
                case 0:
                    _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"eeaaaa"];
                    _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
                    _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
                    
                    break;
                case 1:
                    _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
                    _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"eed0a1"];
                    _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
                    break;
                case 2:
                    _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
                    _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
                    _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"b0eeaa"];
                    break;
                default:
                    break;
            }
            if (NewtextField.text.length == 0) {
                _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
                _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
                _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
            }
        }
    
}


#pragma mark textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    placeholderlabel.hidden=YES;
    if (text.length>=1) {
        unichar temp = [text characterAtIndex:0];
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
        if([doNotWant characterIsMember:temp])
        {
            [Commonality showErrorMsg:self.view type:0 msg:@"禁用非法字符！"];
            return NO;
        }
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    if(textView == _addressInputTextView){
        
        int temp = 120 - range.location;
        if (temp <= 0) {
            temp = 0;
        }
//        textfieldlabel.text=[NSString stringWithFormat:@"%d",temp];
        
        if (range.location>29) {
            [Commonality showErrorMsg:self.view type:0 msg:@"地址不能超过30位！"];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _addressInputTextView.textAlignment = NSTextAlignmentLeft;
    _nickNameCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
    _emailCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
    _addressCell.backgroundColor = [UIColor whiteColor];

    if (iPad) {
        _UserInfoScrollViewBg.frame = CGRectMake(25, 0, 500, 250);
    }else{
//        _UserInfoScrollViewBg.frame = CGRectMake(15, -50, 250, 150);
    }
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    _addressInputTextView.textAlignment = NSTextAlignmentRight;
    if (iPad) {
        _UserInfoScrollViewBg.frame = CGRectMake(25, 50, 500, 250);
    }else{
//        _UserInfoScrollViewBg.frame = CGRectMake(15, 20, 250, 150);
    }
    
    return YES;
}


#pragma mark local methods

-(void)clearAllTextField
{
    _oldPasswordTextField.text = nil;
    _myNewPasswordTextField.text = nil;
    _verifyNewPasswordTextField.text = nil;
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(void)setUserInfoViewFrame:(BOOL)forInput
{
    if (forInput) {
        if (iPad) {
            _userInfoView.frame = CGRectMake(202, -60, 558, 548);
        }else{
            _userInfoView.frame = CGRectMake(91, -100, 289, 260);
        }
    }else{
        if (iPad) {
            _userInfoView.frame = CGRectMake(202, 0, 558, 548);
        }else{
            _userInfoView.frame = CGRectMake(91, 0, 289, 260);
        }
    }
}

-(void)setResetPasswordViewFrame:(BOOL)forInput//YES for input
{
    if (forInput) {
        if (iPad) {
            _resetPasswordView.frame = CGRectMake(202, -50, 558, 548);
        }else{
            _resetPasswordView.frame = CGRectMake(91, -80, 289, 260);
        }
    }else{
        if (iPad) {
            _resetPasswordView.frame = CGRectMake(202, 0, 558, 548);
        }else{
            _resetPasswordView.frame = CGRectMake(91, 0, 289, 260);
        }
    }
}

-(void)setLabelBgColor
{
    _lowLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
    _midLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
    _highLabel.backgroundColor=[Commonality colorFromHexRGB:@"dfdfdf"];
}

-(void)setCellBackGroundColor
{
    _nickNameCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
    _emailCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
    _genderCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
    _birthdayCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
    _addressCell.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
}


#pragma mark UIScrollViewDelegate
// 触摸屏幕来滚动画面还是其他的方法使得画面滚动，皆触发该函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"Scrolling...");
}
// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging  -  End of Scrolling.");
}
// 滚动停止时，触发该函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating  -   End of Scrolling.");
}
// 调用以下函数，来自动滚动到想要的位置，此过程中设置有动画效果，停止时，触发该函数
// UIScrollView的setContentOffset:animated:
// UIScrollView的scrollRectToVisible:animated:
// UITableView的scrollToRowAtIndexPath:atScrollPosition:animated:
// UITableView的selectRowAtIndexPath:animated:scrollPosition:
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation  -   End of Scrolling.");
}


#pragma mark refresh delegate
-(void)refresh
{
    [HttpRequest UserDetailRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}
@end
