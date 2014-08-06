//
//  UserDetailAndUpdateViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxBlurImageViewController.h"
//#import "JYTextField.h"
#import "UITextField+UITextField_JY.h"
#import "MBProgressHUD.h"
#import "NotWiFiView.h"

@interface UserDetailAndUpdateViewController : BoxBlurImageViewController<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate,MainViewRefershDelegate,UIScrollViewDelegate>
{
    BOOL _isPasswordFiledEdting;
    MBProgressHUD* myMBProgressHUD;
}

@property (strong, nonatomic) NSString * md5Password, *password;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

- (IBAction)showUserInfoView:(id)sender;
- (IBAction)showResetPasswordView:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBg;
@property (weak, nonatomic) IBOutlet UIButton *userInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordBtn;

@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (strong, nonatomic) IBOutlet UIButton *saveUserInfoBtn;

@property (strong, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (strong, nonatomic) IBOutlet UITextView *addressInputTextView;

@property (strong, nonatomic) IBOutlet UITableViewCell *genderCell;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gender;

@property (strong, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (strong, nonatomic) IBOutlet UITextField *emailInputField;

@property (strong, nonatomic) IBOutlet UITableViewCell *nickNameCell;
@property (strong, nonatomic) IBOutlet UITextField *nickNameInputField;

@property (strong, nonatomic) IBOutlet UITableViewCell *birthdayCell;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UIView *dataPickView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)doSaveUserInfo:(id)sender;
- (IBAction)datePickDone:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *resetPasswordView;
//@property (strong, nonatomic) IBOutlet JYTextField *oldPasswordTextField;
//@property (strong, nonatomic) IBOutlet JYTextField *myNewPasswordTextField;
//@property (strong, nonatomic) IBOutlet JYTextField *verifyNewPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *myNewPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *verifyNewPasswordTextField;

@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordBtn;

- (IBAction)showPasswordBtnTouched:(id)sender;

- (IBAction)doResetPasswd:(id)sender;

- (IBAction)close:(id)sender;
@end
