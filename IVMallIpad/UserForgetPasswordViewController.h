//
//  UserForgetPasswordViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JYTextField.h"
#import "UITextField+UITextField_JY.h"
#import "BoxBlurImageViewController.h"
@protocol UserForgetPasswordViewControllerDelegate <NSObject>
-(void)closeForgetPasswordView;
@end

@interface UserForgetPasswordViewController : BoxBlurImageViewController<UIScrollViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic,assign)id<UserForgetPasswordViewControllerDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *lowLabel;
@property (strong, nonatomic) IBOutlet UILabel *midLabel;
@property (strong, nonatomic) IBOutlet UILabel *highLabel;

//@property (strong, nonatomic) IBOutlet JYTextField *userName;
//
//@property (strong, nonatomic) IBOutlet JYTextField *passWord;
//@property (strong, nonatomic) IBOutlet JYTextField *confirmPassWord;
//@property (strong, nonatomic) IBOutlet JYTextField *securityCode;

@property (strong, nonatomic) IBOutlet UITextField *userName;

@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassWord;
@property (strong, nonatomic) IBOutlet UITextField *securityCode;

@property (strong, nonatomic) IBOutlet UIButton *showPassWordButton;
@property (strong, nonatomic) IBOutlet UIButton *securityCodeButton;



- (IBAction)showPassWordButtonTouch:(UIButton *)sender;

- (IBAction)securityCodeButtonTouch:(UIButton *)sender;
- (IBAction)okButtonTouch:(UIButton *)sender;

- (IBAction)closeButtonTouch:(UIButton *)sender;
@end
