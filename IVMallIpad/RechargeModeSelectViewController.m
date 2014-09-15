//
//  RechargeModeSelectViewController.m
//  IVMallHD
//
//  Created by Monster on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "RechargeModeSelectViewController.h"

#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlipayPrepareSecurePayModel.h"
#import "AlixLibService.h"
#import "UIImageView+WebCache.h"



@interface RechargeModeSelectViewController ()

@end

@implementation RechargeModeSelectViewController

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
    _totalLabel.text = [NSString stringWithFormat:@"￥%.2f",_pointModel.points];
    [HttpRequest AlipayPrepareSecurePayRequestToken:[AppDelegate App].myUserLoginMode.token price:_pointModel.price vipGuid:_buyListModel.productId delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];    
    [_twoDimensionButton setHidden:YES];
    _twoDimensionButton.exclusiveTouch = YES;
    [_alipayButton setHidden:YES];
    _alipayButton.exclusiveTouch = YES;
    [_weixinButton setHidden:YES];
    _weixinButton.exclusiveTouch = YES;
    [_activityIndicatorView startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PayAlipayResultNoticeProcess:) name:NSNotificationCenterPayAlipayResult object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PayAlipayResultNoticeProcess:) name:NSNotificationCenterTencentPayResult object:nil];
    
    _alipayButton.exclusiveTouch = YES;
    _weixinButton.exclusiveTouch = YES;
    _twoDimensionButton.exclusiveTouch = YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterPayAlipayResult object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCenterTencentPayResult object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(rechargeModeSelectViewBack)]) {
        [self.delegate rechargeModeSelectViewBack];
    }
}

- (IBAction)alipayButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    if (_pointModel.price) {
        if (_myAlipay.errorCode == 0) {
            
            [AppDelegate App].totalFee = _myAlipay.totalFee;
            [AppDelegate App].outTradeNo = _myAlipay.outTradeNo;
            [self prepareSecurePay];
        }
    }else{
        [Commonality showErrorMsg:self.view type:0 msg:@"请输入有效金额"];
    }
}

- (IBAction)twoDimensionButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    if (_pointModel.price) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(rechargeModeSelectTwoDimention:myAlipay:product: )]) {
            [self.delegate rechargeModeSelectTwoDimention:_pointModel myAlipay:_myAlipay product:_buyListModel];
        }
    }else{
        [Commonality showErrorMsg:self.view type:0 msg:@"请输入有效金额"];
    }
}


#pragma -mark http
-(void) GetErr:(ASIHTTPRequest *)request
{
    [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
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
        if (request.tag == ALIPAY_PREPARESECUREPAY_TYPE)
        {
            _myAlipay = [[AlipayPrepareSecurePayModel alloc]initWithDictionary:dictionary];
            [_twoDimensionButton setHidden:NO];
            [_alipayButton setHidden:NO];
            [_weixinButton setHidden:NO];
            [_activityIndicatorView stopAnimating];
        }
        else if (request.tag == ALIPAY_TRADERESULT_TYPE)
        {
            if ([[dictionary objectForKey:@"errorCode"] intValue] == 0) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterPayAlipayResult object:nil userInfo:dictionary];
            }
            else
            {
                [Commonality showErrorMsg:nil type:0 msg:LINGKERROR];
                return;
            }
            
        }
        else if (request.tag == TWODIMENSION_CODE_TYPE)
        {
            _twoDimensionModel = [[AppTwoDimensionPayModel alloc]initWithDictionary:dictionary];
            [_twoDimensionImageView setImageWithURL:[NSURL URLWithString:_twoDimensionModel.qrcodeImgURL]];
        }else if(request.tag == ALIPAY_QRCODETRADERESULT_TYPE)
        {
            _tradeResultModel = [[TradeResultModel alloc]initWithDictionary:dictionary];
            
            if (_tradeResultModel.result == 0&&[_tradeResultModel.tradeResult isEqualToString:@"true"]) {
                PayAddModel *lm=[[PayAddModel alloc]init];
                lm.points = _tradeResultModel.points;
                [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationCenterPayAlipayResult object:nil userInfo:dictionary];
            }
            
        }else{
//                if (lm.result == 221) {
//                    [Commonality showErrorMsg:self type:0 msg:@"您已经使用过此次活动赠送的充值卡进行充值"];
//                    return;
//                }
//                [Commonality showErrorMsg:self type:lm.result msg:nil];
        }
    }
}
#pragma mark - 微信支付
-(void)TencentPayResultNoticeProcess:(NSNotification*)notification
{
    NSDictionary* dic = [notification userInfo];
    TradeResultModel* _tradeResultModel = [[TradeResultModel alloc]initWithDictionary:dic];
    
    if (_tradeResultModel.result == 0&&[_tradeResultModel.tradeResult isEqualToString:@"true"]) {
        PayAddModel *lm=[[PayAddModel alloc]init];
        lm.points = _tradeResultModel.points;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(rechargeModeSelectAliPaySuccess:)]){
            [self.delegate rechargeModeSelectAliPaySuccess:lm];
        }
    }
}

#pragma mark - 支付宝
-(void)PayAlipayResultNoticeProcess:(NSNotification*)notification
{
    NSDictionary* dic = [notification userInfo];
    TradeResultModel* _tradeResultModel = [[TradeResultModel alloc]initWithDictionary:dic];
    
    if (_tradeResultModel.result == 0&&[_tradeResultModel.tradeResult isEqualToString:@"true"]) {
        PayAddModel *lm=[[PayAddModel alloc]init];
        lm.points = _tradeResultModel.points;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(rechargeModeSelectAliPaySuccess:)]){
            [self.delegate rechargeModeSelectAliPaySuccess:lm];
        }
    }
}


//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            //            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
            //			id<DataVerifier> verifier;
            //            verifier = CreateRSADataVerifier(key);
            //
            //			if ([verifier verifyString:result.resultString withSign:result.signString])
            //            {
            //                //验证签名成功，交易结果无篡改
            //			}
            
//    [HttpRequest AlipayTradeResultRequestToken:[AppDelegate App].myUserLoginMode.token outTradeNo:_myAlipay.outTradeNo totalFee:_myAlipay.totalFee delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            [HttpRequest AlipayQRCODETradeResultRequestToken:[AppDelegate App].myUserLoginMode.token outTradeNo:_myAlipay.outTradeNo delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

//支付宝
-(void)prepareSecurePay
{
    NSString *appScheme = @"ivmalliPadApp";
    NSString* orderInfo = [self getOrderInfo];
    NSString* signedStr = [self doRsa:orderInfo];
    
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
	
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
}

-(NSString*)getOrderInfo
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = _myAlipay.outTradeNo; //订单ID（由商家自行制定）
	order.productName = _myAlipay.subject; //商品标题
	order.productDescription = _myAlipay.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",_myAlipay.totalFee]; //商品价格
	order.notifyURL =  [BASE stringByAppendingString:_myAlipay.notifyURL]; //回调URL
    
//    [AppDelegate App].outTradeNo = myAlipay.outTradeNo;
//    [AppDelegate App].totalFee = myAlipay.totalFee;
    
	NSLog(@"order=%@",order);
	return [order description];
    
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}
- (IBAction)weixinButtonTouch:(UIButton *)sender {
    [[WXPayClient shareInstance]payProduct:_buyListModel.productId price:_pointModel.price view:self.view];
}
@end
