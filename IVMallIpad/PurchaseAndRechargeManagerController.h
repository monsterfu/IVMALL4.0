//
//  PurchaseAndRechargeManagerController.h
//  IVMallHD
//
//  Created by Monster on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Macro.h"
#import "BuyVIPViewController.h"
#import "ConfirmPurchaseViewController.h"
#import "RechargeModeSelectViewController.h"
#import "RechargeSuccessViewController.h"
#import "PurchaseSuccessViewController.h"
#import "RechargeViewController.h"
#import "twoDimensionDetailViewController.h"

#import "BuyVipModel.h"
//  token  @"%27%3F**%235%17%7E%7Ec%7Br%159%3E%2B%2B%3C%24%19%7B%7Ex%19%7Bdxs%7Ei%7E%7Fzayw%7F"


//由于购买产品与充值放入此管理类，使用者需要单使用充值或购买产品作为区分

typedef enum : NSUInteger {
    ProcessModeEnum_Purchase,//购买
    ProcessModeEnum_Recharge,//充值
    ProcessModeEnum_Purchase_From_EpisodeItem,//从剧集进入，需要走完整个流程后消失
    ProcessModeEnum_Max
} ProcessModeEnum;


typedef void(^PurchaseCompletionHandler)(void);


@interface PurchaseAndRechargeManagerController : UIViewController<BuyVIPViewControllerDelegate,ConfirmPurchaseViewControllerDelegate,RechargeSuccessViewControllerDelegate,RechargeViewControllerDelegate,RechargeModeSelectViewControllerDelegate,PurchaseSuccessViewControllerDelegate,twoDimensionDetailViewControllerDelegate,UIAlertViewDelegate>
{
    BuyVIPViewController* _buyVIPViewController;
    ConfirmPurchaseViewController* _confirmPurchaseViewController;
    RechargeModeSelectViewController* _rechargeModeSelectViewController;
    PurchaseSuccessViewController* _purchaseSuccessViewController;
    RechargeSuccessViewController* _rechargeSuccessViewController;
    RechargeViewController* _rechargeViewController;
    twoDimensionDetailViewController* _twoDimensionViewController;
    
    UIViewController* _currentViewController;
    PurchaseCompletionHandler _completionHander;
    ProcessModeEnum _mode;
    //////////////////
    UIAlertView * _purchaseSuccessAlertView;
    UIAlertView * _purchaseFailedAlertView;
    AppPointModel* _pointModel;
}

//NSNotificationCenterPurchaseSuccessViewJump
//参数Fuc为计费成功后完成的动作、比如：播放, 无需跳转则 nil
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mode:(ProcessModeEnum)mode completionHandler:(PurchaseCompletionHandler)fuc;
@end
