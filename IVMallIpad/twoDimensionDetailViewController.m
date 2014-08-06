//
//  twoDimensionDetailViewController.m
//  IVMallHD
//
//  Created by Monster on 14-7-28.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "twoDimensionDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface twoDimensionDetailViewController ()

@end

@implementation twoDimensionDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    _totalLabel.text = [NSString stringWithFormat:@"￥%.2f",_model.points];
    [HttpRequest AppTwoDimensionPayToken:[AppDelegate App].myUserLoginMode.token price:_model.price vipGuid:_buyListModel.productId points:_model.points delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    
    
    _checkTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(checkTradeResult) userInfo:nil repeats:YES];
    _outTimer = [NSTimer timerWithTimeInterval:60*10 target:self selector:@selector(outProcess) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:_outTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop]addTimer:_checkTimer forMode:NSRunLoopCommonModes];
    [_imgeView setHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_checkTimer invalidate];
    [_outTimer invalidate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark 
-(void)checkTradeResult
{
    if (_twoDimensionModel.outTradeNo) {
        [HttpRequest AlipayQRCODETradeResultRequestToken:[AppDelegate App].myUserLoginMode.token outTradeNo:_twoDimensionModel.outTradeNo delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
    
}

-(void)outProcess
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(twoDimensionDetailViewback)]) {
        [self.delegate twoDimensionDetailViewback];
    }
}
#pragma -mark http
-(void) GetErr:(ASIHTTPRequest *)request
{
    if(request.tag != ALIPAY_QRCODETRADERESULT_TYPE)
    {
        [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
    }
    
}

-(void) GetResult:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"dic is %@",dictionary);
    if(dictionary==nil){
        [Commonality showErrorMsg:nil type:0 msg:LINGKERROR];
    }else{
        if (request.tag == TWODIMENSION_CODE_TYPE)
        {
            _twoDimensionModel = [[AppTwoDimensionPayModel alloc]initWithDictionary:dictionary];
            [_imgeView setImageWithURL:[NSURL URLWithString:_twoDimensionModel.qrcodeImgURL]];
            [_imgeView setHidden:NO];
        }else if(request.tag == ALIPAY_QRCODETRADERESULT_TYPE)
        {
            _tradeResultModel = [[TradeResultModel alloc]initWithDictionary:dictionary];
            
            if (_tradeResultModel.result == 0&&[_tradeResultModel.tradeResult isEqualToString:@"true"]) {
                PayAddModel *lm=[[PayAddModel alloc]init];
                lm.points = _tradeResultModel.points;
                if (self.delegate&&[self.delegate respondsToSelector:@selector(twoDimensionDetailViewPaySuccess:)]){
                    [self.delegate twoDimensionDetailViewPaySuccess:lm];
                    [_checkTimer invalidate];
                    [_outTimer invalidate];
                }
            }
            
        }else{
            NSLog(@"TWODIMENSION_CODE_ACTIONTWODIMENSION_CODE_ACTION");
        }
    }
}

- (IBAction)backButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(twoDimensionDetailViewback)]) {
        [self.delegate twoDimensionDetailViewback];
    }
}
@end
