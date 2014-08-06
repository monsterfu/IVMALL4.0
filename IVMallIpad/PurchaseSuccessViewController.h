//
//  PurchaseSuccessViewController.h
//  IVMallHD
//
//  Created by Monster on 14-7-17.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "BuyVipModel.h"

@protocol PurchaseSuccessViewControllerDelegate <NSObject>
-(void)purchaseSuccessViewBack;
-(void)purchaseSuccessViewJump;
@end


@interface PurchaseSuccessViewController : UIViewController
{
    BOOL _jump;
    NSUInteger _countDownNum; //5秒
    NSTimer* _countDownTimer;//跳转倒计时
}
@property(nonatomic,assign)id<PurchaseSuccessViewControllerDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property(nonatomic, retain)BuyVipModel * buyVip;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;

@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

- (IBAction)jumpButtonTouch:(UIButton *)sender;

- (IBAction)backButtonTouch:(UIButton *)sender;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil jump:(BOOL)jump;
@end
