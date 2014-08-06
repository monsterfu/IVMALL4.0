//
//  ConfirmPurchaseViewController.h
//  IVMallHD
//
//  Created by Monster on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "BuyListModel.h"
#import "AppPointsModel.h"

@protocol ConfirmPurchaseViewControllerDelegate <NSObject>

-(void)confirmPurchaseViewBack;
-(void)confirmPurchase:(BuyListModel*)model appPointModel:(AppPointModel*)pointModel;
@end


@interface ConfirmPurchaseViewController : UIViewController

@property(nonatomic, assign)id<ConfirmPurchaseViewControllerDelegate>delegate;

@property(nonatomic, retain)BuyListModel* buyListModel;
@property(nonatomic, retain)AppPointModel* appPointModel;

@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

//购买的产品内容
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
//账号
@property (weak, nonatomic) IBOutlet UILabel *acountLabel;
//余额
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
//产品总价
@property (weak, nonatomic) IBOutlet UILabel *productTotalPriceLabel;
//仍需要付
@property (weak, nonatomic) IBOutlet UILabel *alsoLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;


- (IBAction)backButtonTouch:(UIButton *)sender;
- (IBAction)purchaseButtonTouch:(UIButton *)sender;


@end
