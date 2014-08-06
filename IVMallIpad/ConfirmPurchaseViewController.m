//
//  ConfirmPurchaseViewController.m
//  IVMallHD
//
//  Created by Monster on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "ConfirmPurchaseViewController.h"

@interface ConfirmPurchaseViewController ()

@end

@implementation ConfirmPurchaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    _productTitleLabel.text = _buyListModel.productTitle;
    _acountLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"];//[AppDelegate App].UserInfo.nickname;
    
    _productTotalPriceLabel.text = [NSString stringWithFormat:@"%.2f猫币",_buyListModel.points];
    _alsoLabel.hidden = YES;
    _distanceLabel.hidden = YES;
    _balanceLabel.text = @"0猫币";
    _purchaseButton.hidden = YES;
    [HttpRequest UserBalanceRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
    _appPointModel = [[AppPointModel alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(confirmPurchaseViewBack)]) {
        [self.delegate confirmPurchaseViewBack];
    }
    
}

- (IBAction)purchaseButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    [sender setEnabled:NO];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(confirmPurchase:appPointModel:)]) {
        [self.delegate confirmPurchase:_buyListModel appPointModel:_appPointModel];
    }
}

#pragma mark - http result

-(void) GetErr:(ASIHTTPRequest *)request{
    [Commonality showErrorMsg:self.view type:0 msg:@"网络连接异常！"];
}

-(void) GetResult:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"error is %@",error);
    if (dictionary==nil) {
        [Commonality showErrorMsg:self.view type:0 msg:@"网络连接异常！"];
    }else{
        NSString* balance = [[dictionary objectForKey:@"data"] objectForKey:@"balance"];
        _balanceLabel.text = [NSString stringWithFormat:@"%@猫币",balance];
        CGFloat balanceValue = [balance integerValue];
        if (_buyListModel.points > balanceValue) {
            [_distanceLabel setText:[NSString stringWithFormat:@"%.2f猫币",(_buyListModel.points - balanceValue)]];
            _appPointModel.points = _buyListModel.points - balanceValue;
            _appPointModel.price = _buyListModel.points - balanceValue;
            _alsoLabel.hidden = NO;
            _distanceLabel.hidden = NO;
        }
        _purchaseButton.hidden = NO;
        _purchaseButton.enabled = YES;
    }
}
@end
