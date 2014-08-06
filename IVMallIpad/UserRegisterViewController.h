//
//  UserRegisterViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JYTextField.h"
#import "UITextField+UITextField_JY.h"
#import "BoxBlurImageViewController.h"
@protocol UserRegisterViewControllerDelegate <NSObject>
-(void)closeRegisterView;
@end

@interface UserRegisterViewController : BoxBlurImageViewController<UIScrollViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *bgView;

@property (nonatomic, assign)id<UserRegisterViewControllerDelegate>delegate;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) IBOutlet UILabel *lowLabel;
@property (strong, nonatomic) IBOutlet UILabel *midLabel;
@property (strong, nonatomic) IBOutlet UILabel *highLabel;


@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *checkCode;

@property (strong, nonatomic) IBOutlet UIButton *checkCodeButton;
- (IBAction)checkCodeButtonTouch:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *free;

@property (assign, nonatomic) BOOL isFromLoginView;
@property (strong, nonatomic) IBOutlet UIView* registerSucessView;

- (IBAction)okButtonTouch:(UIButton *)sender;
- (IBAction)closeButtonTouch:(UIButton *)sender;

@end
