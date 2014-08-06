//
//  UserUpdatePasswordViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JYTextField.h"
#import "UITextField+UITextField_JY.h"

@interface UserUpdatePasswordViewController : UIViewController



//@property (weak, nonatomic) IBOutlet JYTextField *oldPasswordTextField;
//
//@property (weak, nonatomic) IBOutlet JYTextField *comfirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *comfirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;



@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;

- (IBAction)showPasswordButtonTouch:(UIButton *)sender;

- (IBAction)okButtonTouch:(UIButton *)sender;



@end
