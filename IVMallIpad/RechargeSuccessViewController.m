//
//  RechargeSuccessViewController.m
//  IVMallHD
//
//  Created by Monster on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "RechargeSuccessViewController.h"

@interface RechargeSuccessViewController ()

@end

@implementation RechargeSuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil jump:(BOOL)jump
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _jump = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    _rechargeLabel.text = [NSString stringWithFormat:@"￥%.2f",_payAddModel.points];
    _countDownNum = 10;
    
    if (_jump) {
        _countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDownFuction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_countDownTimer forMode:NSDefaultRunLoopMode];
    }
    
    [HttpRequest UserBalanceRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    // Do any additional setup after loading the view from its nib.
    if (_jump) {
        _reminderLabel.hidden = NO;
        _jumpButton.hidden = NO;
    }else{
        _reminderLabel.hidden = YES;
        _jumpButton.hidden = YES;
    }
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//customer
-(void)countDownFuction
{
    if (_countDownNum > 0) {
        _countDownNum --;
        
        _reminderLabel.text = [NSString stringWithFormat:@"%d秒后自动跳转到购买界面",_countDownNum];
    }else{
        [_countDownTimer invalidate];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(rechargeSuccessJumpToPurchase)]) {
            [self.delegate rechargeSuccessJumpToPurchase];
        }
    }
}
- (IBAction)jumpButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    [_countDownTimer invalidate];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(rechargeSuccessJumpToPurchase)]) {
        [self.delegate rechargeSuccessJumpToPurchase];
    }
}

- (IBAction)backButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    [_countDownTimer invalidate];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(rechargeSuccessViewBack)]) {
        [self.delegate rechargeSuccessViewBack];
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
        
        //充值成功 发通知 其他controller更新model
        [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterUserBalanceChange object:balance userInfo:nil];
    }
}
@end
