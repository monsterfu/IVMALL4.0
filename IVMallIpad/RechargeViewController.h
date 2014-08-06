//
//  RechargeViewController.h
//  IVMallHD
//
//  Created by Monster on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "AppPointsModel.h"
#import "PayAddModel.h"

@protocol RechargeViewControllerDelegate <NSObject>
-(void)rechargeViewBack;
-(void)rechargeConfirm:(AppPointModel*)model;
-(void)rechargeSuccess:(PayAddModel*)model;
@end


@interface RechargeViewController : UIViewController<UITextFieldDelegate>
{
    UITapGestureRecognizer* _tapGestureRecognizer;
    AppPointsModel* _pointsModel;
    AppPointModel* _pointModel;
    UIAlertView* _cardRechargeFailedAlertView;
}
@property(nonatomic,assign)id<RechargeViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)backButtonTouch:(UIButton *)sender;



//选择猫币、点卡充值
@property (weak, nonatomic) IBOutlet UIButton *mbButton;
@property (weak, nonatomic) IBOutlet UIButton *cardButton;

- (IBAction)mbButtonTouch:(UIButton *)sender;
- (IBAction)cardButtonTouch:(UIButton *)sender;

//选择猫币的VIEW
@property (weak, nonatomic) IBOutlet UIView *mbView;

//点卡充值的VIEW
@property (weak, nonatomic) IBOutlet UIView *cardView;


//猫币按钮：50、80、300、自定义

@property (weak, nonatomic) IBOutlet UIButton *mbOneButton;
@property (weak, nonatomic) IBOutlet UIButton *mbTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *mbThreeButton;
//@property (strong, nonatomic) IBOutlet JYTextField *mbCustomTextField;
@property (strong, nonatomic) IBOutlet UITextField *mbCustomTextField;

- (IBAction)mbOneButtonTouch:(UIButton *)sender;
- (IBAction)mbTwoButtonTouch:(UIButton *)sender;
- (IBAction)mbThreeButtonTouch:(UIButton *)sender;

//共需支付

@property (weak, nonatomic) IBOutlet UILabel *totalRechargeLabel;

//确认购买
- (IBAction)confirmRecharge:(UIButton *)sender;



//点卡充值
//@property (strong, nonatomic) IBOutlet JYTextField *cardTextField;
@property (strong, nonatomic) IBOutlet UITextField *cardTextField;
- (IBAction)cardConfirmButtonTouch:(UIButton *)sender;



//用于电机取消键盘的VIEW层
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end
