//
//  RechargeSuccessViewController.h
//  IVMallHD
//
//  Created by Monster on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayAddModel.h"
#import "Macro.h"

@protocol RechargeSuccessViewControllerDelegate <NSObject>

-(void)rechargeSuccessViewBack;
-(void)rechargeSuccessJumpToPurchase;
@end

@interface RechargeSuccessViewController : UIViewController
{
    BOOL _jump;
    NSUInteger _countDownNum; //5秒
    NSTimer* _countDownTimer;//跳转倒计时
}

@property(nonatomic,assign)id<RechargeSuccessViewControllerDelegate>delegate;


@property(nonatomic,retain)PayAddModel* payAddModel;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

//支付成功、支付失败的标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//实际支付金额
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;
//账户余额
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;
- (IBAction)jumpButtonTouch:(UIButton *)sender;
- (IBAction)backButtonTouch:(UIButton *)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil jump:(BOOL)jump;
@end
