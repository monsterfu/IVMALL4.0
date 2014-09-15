//
//  twoDimensionDetailViewController.h
//  IVMallHD
//
//  Created by Monster on 14-7-28.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "AppPointsModel.h"
#import "AppTwoDimensionPayModel.h"
#import "AlipayPrepareSecurePayModel.h"
#import "TradeResultModel.h"
#import "PayAddModel.h"
#import "BuyListModel.h"

@protocol twoDimensionDetailViewControllerDelegate <NSObject>
-(void)twoDimensionDetailViewback;
-(void)twoDimensionDetailViewPaySuccess:(PayAddModel*)model;
@end


@interface twoDimensionDetailViewController : UIViewController
{
    AppTwoDimensionPayModel* _twoDimensionModel;
    TradeResultModel* _tradeResultModel;
    NSTimer* _checkTimer;  
    NSTimer* _outTimer;
}

@property (nonatomic, assign)id<twoDimensionDetailViewControllerDelegate>delegate;
@property (nonatomic, retain)AppPointModel* model;
@property (nonatomic, retain)AlipayPrepareSecurePayModel* myAlipay;
@property (nonatomic, retain)BuyListModel* buyListModel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgeView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (IBAction)backButtonTouch:(UIButton *)sender;

@end
