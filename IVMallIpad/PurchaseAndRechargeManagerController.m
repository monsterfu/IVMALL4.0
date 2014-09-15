//
//  PurchaseAndRechargeManagerController.m
//  IVMallHD
//
//  Created by Monster on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "PurchaseAndRechargeManagerController.h"

#define XIB_X(X)   (X):(X_IPhone)?(IPad)

@interface PurchaseAndRechargeManagerController ()

@end

@implementation PurchaseAndRechargeManagerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mode:(ProcessModeEnum)mode completionHandler:(PurchaseCompletionHandler)fuc
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.view.frame = [UIScreen mainScreen].bounds;
        _completionHander = fuc;
        _mode = mode;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    NSLog(@"%f,%f,%f,%f",[self.view bounds].origin.x,[self.view bounds].origin.y,[self.view bounds].size.width,[self.view bounds].size.height);
    // Do any additional setup after loading the view.
    self.view.frame = [UIScreen mainScreen].bounds;
    _buyVIPViewController = [[BuyVIPViewController alloc]initWithNibName:[NSString xibName:@"BuyVIPViewController"] bundle:nil];
    _buyVIPViewController.delegate = self;
    _confirmPurchaseViewController = [[ConfirmPurchaseViewController alloc]initWithNibName:[NSString xibName:@"ConfirmPurchaseViewController"] bundle:nil];
    _confirmPurchaseViewController.delegate = self;
    _rechargeModeSelectViewController = [[RechargeModeSelectViewController alloc]initWithNibName:[NSString xibName:@"RechargeModeSelectViewController"] bundle:nil];
    _rechargeModeSelectViewController.delegate = self;
    
    _rechargeSuccessViewController = [[RechargeSuccessViewController alloc]initWithNibName:[NSString xibName:@"RechargeSuccessViewController"] bundle:nil jump:(YES)/*_mode != ProcessModeEnum_Recharge)?YES:NO*/];
    _rechargeSuccessViewController.delegate = self;
    _purchaseSuccessViewController = [[PurchaseSuccessViewController alloc]initWithNibName:[NSString xibName:@"PurchaseSuccessViewController"] bundle:nil jump:(YES)/*_completionHander != nil)?YES:NO*/];
    _purchaseSuccessViewController.delegate = self;
    
    _rechargeViewController = [[RechargeViewController alloc]initWithNibName:[NSString xibName:@"RechargeViewController"] bundle:nil];
    _rechargeViewController.delegate = self;
    
    _twoDimensionViewController = [[twoDimensionDetailViewController alloc]initWithNibName:[NSString xibName:@"twoDimensionDetailViewController"] bundle:nil];
    _twoDimensionViewController.delegate = self;
    
    [self addChildViewController:_rechargeViewController];
    [self addChildViewController:_buyVIPViewController];
    [self addChildViewController:_confirmPurchaseViewController];
    [self addChildViewController:_purchaseSuccessViewController];
    [self addChildViewController:_rechargeModeSelectViewController];
    [self addChildViewController:_rechargeSuccessViewController];
    [self addChildViewController:_twoDimensionViewController];
    
    switch (_mode) {
        case ProcessModeEnum_Purchase:
        {
            [self.view addSubview:_buyVIPViewController.view];
            _currentViewController = _buyVIPViewController;
        }
            break;
        case ProcessModeEnum_Recharge:
        {
            [self.view addSubview:_rechargeViewController.view];
            _currentViewController = _rechargeViewController;
        }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)AipayPaySuccess:(PayAddModel*)model
{
    _rechargeSuccessViewController.payAddModel = model;
    [self transitionFromViewController:_currentViewController toViewController:_rechargeSuccessViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        if (finished) {
            _currentViewController = _rechargeSuccessViewController;
        }else{
            _currentViewController = _rechargeModeSelectViewController;
        }
    }];
}
#pragma mark - BuyVIPViewControllerDelegate

-(void)purchaseProduct:(BuyListModel*)model
{
    _confirmPurchaseViewController.buyListModel = model;
    [self transitionFromViewController:_currentViewController toViewController:_confirmPurchaseViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        if (finished) {
            _currentViewController = _confirmPurchaseViewController;
        }else{
            _currentViewController = _buyVIPViewController;
        }
    }];
}

#pragma mark -ConfirmPurchaseViewControllerDelegate
-(void)confirmPurchaseViewBack
{
    [self transitionFromViewController:_currentViewController toViewController:_buyVIPViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        if (finished) {
            _currentViewController = _buyVIPViewController;
        }else{
            _currentViewController = _confirmPurchaseViewController;
        }
    }];
}
-(void)confirmPurchase:(BuyListModel*)model appPointModel:(AppPointModel*)pointModel
{
    _pointModel = pointModel;
    [HttpRequest BuyVipRequestToken:[AppDelegate App].myUserLoginMode.token vipGuid:model.productId points:model.points delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}
#pragma mark - PurchaseSuccessViewControllerDelegate
-(void)purchaseSuccessViewBack
{
    [[PopUpViewController shareInstance]dismissAnimated:NO];
}
-(void)purchaseSuccessViewJump
{
    [[PopUpViewController shareInstance]dismissAnimated:NO];
    if (_completionHander) {
        _completionHander();
    }
}
#pragma mark - RechargeSuccessViewControllerDelegate
-(void)rechargeSuccessViewBack
{
    if (_mode == ProcessModeEnum_Recharge) {
        [[PopUpViewController shareInstance]dismissAnimated:NO];
    }else{
        [self transitionFromViewController:_currentViewController toViewController:_rechargeViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
        }completion:^(BOOL finished) {
            if (finished) {
                _currentViewController = _rechargeViewController;
            }else{
                _currentViewController = _rechargeSuccessViewController;
            }
        }];
    }
}
-(void)rechargeSuccessJumpToPurchase
{
    [[PopUpViewController shareInstance]dismissAnimated:NO];
    if (_completionHander) {
        _completionHander();
    }
    return;
    if (_mode == ProcessModeEnum_Purchase_From_EpisodeItem) {
        [[PopUpViewController shareInstance]dismissAnimated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterPurchaseSuccessViewJump object:nil];
    }else{
        [self transitionFromViewController:_currentViewController toViewController:_buyVIPViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
        }completion:^(BOOL finished) {
            if (finished) {
                _currentViewController = _buyVIPViewController;
            }else{
                _currentViewController = _rechargeSuccessViewController;
            }
        }];
    }
}
#pragma mark - RechargeViewControllerDelegate
-(void)rechargeViewBack
{
    switch (_mode) {
        case ProcessModeEnum_Purchase:
        {
            [self transitionFromViewController:_currentViewController toViewController:_confirmPurchaseViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
            }completion:^(BOOL finished) {
                if (finished) {
                    _currentViewController = _confirmPurchaseViewController;
                }else{
                    _currentViewController = _rechargeViewController;
                }
            }];
        }
            break;
        case ProcessModeEnum_Recharge:
        {
            [[PopUpViewController shareInstance]dismissAnimated:NO];
        }
            break;
        default:
            break;
    }
}
-(void)rechargeConfirm:(AppPointModel *)model
{
    _rechargeModeSelectViewController.pointModel =  model;
    [self transitionFromViewController:_currentViewController toViewController:_rechargeModeSelectViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        if (finished) {
            _currentViewController = _rechargeModeSelectViewController;
        }else{
            _currentViewController = _rechargeViewController;
        }
    }];
}
-(void)rechargeSuccess:(PayAddModel*)model
{
    _rechargeSuccessViewController.payAddModel = model;
    [self transitionFromViewController:_currentViewController toViewController:_rechargeSuccessViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        if (finished) {
            _currentViewController = _rechargeSuccessViewController;
        }else{
            _currentViewController = _rechargeViewController;
        }
    }];
}
#pragma mark - RechargeModeSelectViewControllerDelegate
-(void)rechargeModeSelectViewBack
{
    if (_mode == ProcessModeEnum_Purchase) {
        [self transitionFromViewController:_currentViewController toViewController:_confirmPurchaseViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
        }completion:^(BOOL finished) {
            if (finished) {
                _currentViewController = _confirmPurchaseViewController;
            }else{
                _currentViewController = _rechargeModeSelectViewController;
            }
        }];
    }else{
        [self transitionFromViewController:_currentViewController toViewController:_rechargeViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
        }completion:^(BOOL finished) {
            if (finished) {
                _currentViewController = _rechargeViewController;
            }else{
                _currentViewController = _rechargeModeSelectViewController;
            }
        }];
    }
}
-(void)rechargeModeSelectAliPaySuccess:(PayAddModel*)model
{
    _rechargeSuccessViewController.payAddModel = model;
    [self transitionFromViewController:_currentViewController toViewController:_rechargeSuccessViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        if (finished) {
            _currentViewController = _rechargeSuccessViewController;
        }else{
            _currentViewController = _rechargeModeSelectViewController;
        }
    }];
}
-(void)rechargeModeSelectTwoDimention:(AppPointModel*)model myAlipay:(AlipayPrepareSecurePayModel*)myAlipay product:(BuyListModel*) buyListModel
{
    
    _twoDimensionViewController.model = model;
    _twoDimensionViewController.myAlipay = myAlipay;
    _twoDimensionViewController.buyListModel = buyListModel;
    [self transitionFromViewController:_currentViewController toViewController:_twoDimensionViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        if (finished) {
            _currentViewController = _twoDimensionViewController;
        }else{
            _currentViewController = _rechargeModeSelectViewController;
        }
    }];
}
#pragma mark - twoDimensionDetailViewControllerDelegate
-(void)twoDimensionDetailViewback
{
    [self transitionFromViewController:_currentViewController toViewController:_rechargeModeSelectViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        if (finished) {
            _currentViewController = _rechargeModeSelectViewController;
        }else{
            _currentViewController = _twoDimensionViewController;
        }
    }];
}
-(void)twoDimensionDetailViewPaySuccess:(PayAddModel*)model
{
    _rechargeSuccessViewController.payAddModel = model;
    [self transitionFromViewController:_currentViewController toViewController:_rechargeSuccessViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        if (finished) {
            _currentViewController = _rechargeSuccessViewController;
        }else{
            _currentViewController = _rechargeViewController;
        }
    }];
}
#pragma mark - UIAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView == _purchaseSuccessAlertView) {
            //支付结果
            
        }else{
            //余额不足，去充值
            [self transitionFromViewController:_currentViewController toViewController:_rechargeViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
            }completion:^(BOOL finished) {
                if (finished) {
                    _currentViewController = _rechargeViewController;
                }else{
                    _currentViewController = _confirmPurchaseViewController;
                }
            }];
        }
    }
}

#pragma mark - http result

-(void) GetErr:(ASIHTTPRequest *)request
{
    [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
}
-(void) GetResult:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    NSLog(@"%@",[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (dictionary==nil) {
        [Commonality showErrorMsg:self.view type:0 msg:@"网络连接异常，请重试"];
    }else{
        
        BuyVipModel * buyVip =[[BuyVipModel alloc] initWithDictionary:dictionary];
        if (buyVip.result == 0) {
            _purchaseSuccessViewController.buyVip = buyVip;
            [self transitionFromViewController:_currentViewController toViewController:_purchaseSuccessViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
                
            }completion:^(BOOL finished) {
                if (finished) {
                    _currentViewController = _purchaseSuccessViewController;
                }else{
                    _currentViewController = _confirmPurchaseViewController;
                }
            }];
            [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterPurchaseSuccessViewJump object:nil];
        }else if(buyVip.result == 107){
            _rechargeModeSelectViewController.pointModel = _pointModel;
            _rechargeModeSelectViewController.buyListModel = _confirmPurchaseViewController.buyListModel;
            [self transitionFromViewController:_currentViewController toViewController:_rechargeModeSelectViewController duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
                
            }completion:^(BOOL finished) {
                if (finished) {
                    _currentViewController = _rechargeModeSelectViewController;
                }else{
                    _currentViewController = _confirmPurchaseViewController;
                }
            }];
        }
        else
        {
            [Commonality showErrorMsg:self.view type:buyVip.result msg:@"网络连接异常，请重试"];
            return;
        }
    }
}
@end
