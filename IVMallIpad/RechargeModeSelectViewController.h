//
//  RechargeModeSelectViewController.h
//  IVMallHD
//
//  Created by Monster on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "AppPointsModel.h"
#import "AlipayPrepareSecurePayModel.h"
#import "AppTwoDimensionPayModel.h"
#import "BuyListModel.h"
#import "TradeResultModel.h"
#import "PayAddModel.h"

@protocol RechargeModeSelectViewControllerDelegate <NSObject>
-(void)rechargeModeSelectViewBack;
-(void)rechargeModeSelectAliPaySuccess:(PayAddModel*)model;
-(void)rechargeModeSelectTwoDimention:(AppPointModel*)model myAlipay:(AlipayPrepareSecurePayModel*)myAlipay product:(BuyListModel*) buyListModel;
@end

@interface RechargeModeSelectViewController : UIViewController
{
    AlipayPrepareSecurePayModel* _myAlipay;
    AppTwoDimensionPayModel* _twoDimensionModel;
    TradeResultModel* _tradeResultModel;
}
@property (nonatomic, assign)id<RechargeModeSelectViewControllerDelegate>delegate;
@property (nonatomic, retain)AppPointModel* pointModel;
@property (nonatomic, retain)BuyListModel* buyListModel;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UIImageView *twoDimensionImageView;



- (IBAction)backButtonTouch:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
- (IBAction)alipayButtonTouch:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *twoDimensionButton;
- (IBAction)twoDimensionButtonTouch:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
- (IBAction)weixinButtonTouch:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end
