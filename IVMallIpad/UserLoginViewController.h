//
//  UserLoginViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JYTextField.h"
#import "UITextField+UITextField_JY.h"
#import "Macro.h"
#import "UserLoginModel.h"
#import "BoxBlurImageViewController.h"
#import "MBProgressHUD.h"

//@protocol UserLoginViewControllerDelegate <NSObject>
//
//-(void)forgetPasswordEnter;
//-(void)registerEnter;
//-(void)closeLoginView;
//@end

enum{
	PlayVideo=0,
	EnterPerson,
    EnterPlayList,
    UnKnownAction,
};
typedef NSInteger ActionState;

@interface UserLoginViewController : BoxBlurImageViewController <MBProgressHUDDelegate,UITextFieldDelegate>
{
    MBProgressHUD* myMBProgressHUD;
}

@property (assign,nonatomic)ActionState myActionState;


//@property(nonatomic, assign)id<UserLoginViewControllerDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;


@property (strong, nonatomic) IBOutlet UIView *testView;

//@property (strong, nonatomic) IBOutlet JYTextField *username;
//@property (strong, nonatomic) IBOutlet JYTextField *password;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
//@property (strong, nonatomic) IBOutlet UIImageView* QRImageView;
@property (strong, nonatomic) IBOutlet UIButton *showPassWordButton;
@property (strong, nonatomic) IBOutlet UIButton* telephoneButton;
@property (strong, nonatomic) IBOutlet UILabel* versionLabel;

- (IBAction)showPassWordButtonTouch:(UIButton *)sender;
- (IBAction)forgetPasswordButtonTouch:(UIButton *)sender;
- (IBAction)loginButtonTouch:(UIButton *)sender;
- (IBAction)registerButtonTouch:(UIButton *)sender;
- (IBAction)closeButtonTouch:(UIButton *)sender;


@end
