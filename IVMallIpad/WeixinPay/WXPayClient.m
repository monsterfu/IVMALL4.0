//
//  WXPayClient.m
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "WXPayClient.h"
#import "ASIHTTPRequest.h"
#import "Commonality.h"

NSString *AccessTokenKey = @"access_token";
NSString *PrePayIdKey = @"prepayid";
NSString *errcodeKey = @"errcode";
NSString *errmsgKey = @"errmsg";
NSString *expiresInKey = @"expires_in";

@interface WXPayClient ()

@property (nonatomic, strong) ASIHTTPRequest *request;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, copy) NSString *traceId;

@end

@implementation WXPayClient

#pragma mark - Public

+ (instancetype)shareInstance 
{
    static WXPayClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[WXPayClient alloc] init];
    });
    return sharedClient;
}

- (void)payProduct:(NSString*) productId price:(double)price view:(UIView*)view
{
    _errBaseView = view;
    _price = price;
    _productId = productId;
    if ([WXApi isWXAppInstalled] == NO) {
        _installAlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您未安装微信，现在安装?" delegate:self cancelButtonTitle:@"不，谢谢" otherButtonTitles:@"好", nil];
        [_installAlertView show];
    }else if(![WXApi isWXAppSupportApi]){
        _UpdateAlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的微信版本太低，现在更新?" delegate:self cancelButtonTitle:@"不，谢谢" otherButtonTitles:@"好", nil];
        [_UpdateAlertView show];
    }else{
        [self getAccessToken];
    }
}

#pragma mark - 生成各种参数

- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 * 注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [Commonality MD5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

/**
 * 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪
 */
- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"crestxu_%@", [self genTimeStamp]];
}

- (NSString *)genOutTradNo
{
    return [Commonality MD5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (NSString *)genPackage
{
    // 构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary]; 
    [params setObject:@"WX" forKey:@"bank_type"];
    [params setObject:@"IVMall充值" forKey:@"body"];
    [params setObject:@"1" forKey:@"fee_type"];
    [params setObject:@"UTF-8" forKey:@"input_charset"];
    [params setObject:@"http://weixin.qq.com" forKey:@"notify_url"];
    [params setObject:[self genOutTradNo] forKey:@"out_trade_no"]; 
    [params setObject:WXPartnerId forKey:@"partner"];
    [params setObject:[Commonality getIPAddress:YES] forKey:@"spbill_create_ip"]; 
    [params setObject:[NSString stringWithFormat:@"%.f",_price*100] forKey:@"total_fee"];    // 1 =＝ ¥0.01 注意这里的价格已经是分了，不要在写成1.0几，这样会有错误
    
    NSArray *keys = [params allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) { 
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成 packageSign
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    
    [package appendString:@"key="];
    [package appendString:WXPartnerKey]; // 注意:不能hardcode在客户端,建议genPackage这个过程都由服务器端完成
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString *packageSign = [[Commonality MD5:[package copy]] uppercaseString]; 
    package = nil;
    
    // 生成 packageParamsString
    NSString *value = nil;  
    package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        value = [params objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];

    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    
    NSLog(@"--- Package: %@", result);
    
    return result;
}

- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) { 
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSString *result = [Commonality sha1:signString];
    NSLog(@"--- Gen sign: %@", result);
    return result;
}

- (NSMutableData *)getProductArgs
{
    self.timeStamp = [self genTimeStamp];
    self.nonceStr = [self genNonceStr]; // traceId 由开发者自定义，可用于订单的查询与跟踪，建议根据支付用户信息生成此id
    self.traceId = [self genTraceId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary]; 
    [params setObject:WXAppId forKey:@"appid"];
    [params setObject:WXAppKey forKey:@"appkey"];
    [params setObject:self.timeStamp forKey:@"noncestr"];
    [params setObject:self.timeStamp forKey:@"timestamp"];
    [params setObject:self.traceId forKey:@"traceid"];
    [params setObject:[self genPackage] forKey:@"package"];
    [params setObject:[self genSign:params] forKey:@"app_signature"];
    [params setObject:@"sha1" forKey:@"sign_method"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    NSLog(@"--- ProductArgs: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    return [NSMutableData dataWithData:jsonData]; 
}

#pragma mark - 主体流程

- (void)getAccessToken
{
#if 1
    [HttpRequest TenPay_AccessToken:[AppDelegate App].myUserLoginMode.token
                           delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
#else
    NSString *getAccessTokenUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%@&secret=%@", WXAppId, WXAppSecret];
    
    NSLog(@"--- GetAccessTokenUrl: %@", getAccessTokenUrl);
    
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:getAccessTokenUrl]];
    
    __weak WXPayClient *weakSelf = self;
    __weak ASIHTTPRequest *weakRequest = self.request;
    
    [self.request setCompletionBlock:^{
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[weakRequest responseData] 
                                                             options:kNilOptions 
                                                               error:&error];
        if (error) {
            [weakSelf showAlertWithTitle:@"错误" msg:@"获取 AccessToken 失败"];
            return;
        } else {
            NSLog(@"--- %@", [weakRequest responseString]);
        }
        
        NSString *accessToken = dict[AccessTokenKey];
        if (accessToken) {
            NSLog(@"--- AccessToken: %@", accessToken);
            
            __strong WXPayClient *strongSelf = weakSelf;
            [strongSelf getPrepayId:accessToken];
        } else {
            NSString *strMsg = [NSString stringWithFormat:@"errcode: %@, errmsg:%@", dict[errcodeKey], dict[errmsgKey]];
            [weakSelf showAlertWithTitle:@"错误" msg:strMsg];
        }
    }];
    
    [self.request setFailedBlock:^{
        [weakSelf showAlertWithTitle:@"错误" msg:@"获取 AccessToken 失败"];
    }];
    [self.request startAsynchronous];
#endif
}
-(void)prepareTenPay:(TenPayPrepareWXPayModel*)model
{
    self.timeStamp = [self genTimeStamp];
    self.nonceStr = [self genNonceStr]; // traceId 由开发者自定义，可用于订单的查询与跟踪，建议根据支付用户信息生成此id
    self.traceId = [self genTraceId];
    
    PayReq *request   = [[PayReq alloc] init];
#if 1
    request.partnerId = WXPartnerId;
    request.prepayId  = model.prepayid;
    request.package   = @"Sign=WXPay";
    request.nonceStr  = model.nonceStr;
    request.timeStamp = [model.timestamp longLongValue];
    request.sign = model.sign;
//    request.partnerId = WXPartnerId;
//    request.prepayId  = @"1101000000140904314ca0536bdee69c";// model.prepayid;
//    request.package   = @"Sign=WXPay";
//    request.nonceStr  = @"615299acbbac3e21302bbc435091ad9f";//model.nonceStr;
//    request.timeStamp = 1409820991;// [model.timestamp floatValue];
//    request.sign = @"cdb9ea6038992a0b660142db83ee000fc21ea27b";//model.sign;
#else
    request.partnerId = WXPartnerId;
    request.prepayId  = model.prepayid;
    request.package   = @"Sign=WXPay";
    request.nonceStr  = self.nonceStr;
    request.timeStamp = [self.timeStamp floatValue];
    request.sign = model.sign;
#endif
    // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:WXAppId forKey:@"appid"];
    [params setObject:WXAppKey forKey:@"appkey"];
    [params setObject:request.nonceStr forKey:@"noncestr"];
    [params setObject:request.package forKey:@"package"];
    [params setObject:request.partnerId forKey:@"partnerid"];
    [params setObject:request.prepayId forKey:@"prepayid"];
    [params setObject:self.timeStamp forKey:@"timestamp"];
//    request.sign = [self genSign:params];
//    request.sign = [self genSign:params];
    [WXApi safeSendReq:request];
}
- (void)getPrepayId:(NSString *)accessToken
{
#if 1
    [HttpRequest TenPayPrepareWXPayToken:[AppDelegate App].myUserLoginMode.token price:_price vipGuid:_productId delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
#else
    NSString *getPrepayIdUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?access_token=%@", accessToken];
    NSLog(@"--- GetPrepayIdUrl: %@", getPrepayIdUrl);
    NSMutableData *postData = [self getProductArgs];
    
    // 文档: 详细的订单数据放在 PostData 中,格式为 json
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:getPrepayIdUrl]];
    [self.request addRequestHeader:@"Content-Type" value:@"application/json"];  
    [self.request addRequestHeader:@"Accept" value:@"application/json"];
    [self.request setRequestMethod:@"POST"];
    [self.request setPostBody:postData];
    
    __weak WXPayClient *weakSelf = self;
    __weak ASIHTTPRequest *weakRequest = self.request;
    
    [self.request setCompletionBlock:^{
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[weakRequest responseData] 
                                                             options:kNilOptions 
                                                               error:&error];
        
        if (error) {
            [weakSelf showAlertWithTitle:@"错误" msg:@"获取 PrePayId 失败"];
            return;
        } else {
            NSLog(@"--- %@", [weakRequest responseString]);
        }
        
        NSString *prePayId = dict[PrePayIdKey];
        if (prePayId) {
            NSLog(@"--- PrePayId: %@", prePayId);
            
            // 调起微信支付
            PayReq *request   = [[PayReq alloc] init];
            request.partnerId = WXPartnerId;
            request.prepayId  = prePayId;
            request.package   = @"Sign=WXPay";      // 文档为 `Request.package = _package;` , 但如果填写上面生成的 `package` 将不能支付成功
            request.nonceStr  = weakSelf.nonceStr;
            request.timeStamp = [weakSelf.timeStamp longLongValue];
            
            // 构造参数列表
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:WXAppId forKey:@"appid"];
            [params setObject:WXAppKey forKey:@"appkey"];
            [params setObject:request.nonceStr forKey:@"noncestr"];
            [params setObject:request.package forKey:@"package"];
            [params setObject:request.partnerId forKey:@"partnerid"];
            [params setObject:request.prepayId forKey:@"prepayid"];
            [params setObject:weakSelf.timeStamp forKey:@"timestamp"];
            request.sign = [weakSelf genSign:params];
            [WXApi safeSendReq:request];
        } else {
            NSString *strMsg = [NSString stringWithFormat:@"errcode: %@, errmsg:%@", dict[errcodeKey], dict[errmsgKey]];
            [weakSelf showAlertWithTitle:@"错误" msg:strMsg];
        }
    }];
    [self.request setFailedBlock:^{
        [weakSelf showAlertWithTitle:@"错误" msg:@"获取 PrePayId 失败"];
    }];
    [self.request startAsynchronous];
#endif
}

#pragma mark - Alert

- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg
{    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
                                                    message:msg 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
    [alert show];
//    [[NSNotificationCenter defaultCenter] postNotificationName:HUDDismissNotification object:nil userInfo:nil];
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess: {
//                if (_delegate && [_delegate respondsToSelector:@selector(PaySuccess)]) {
//                    [_delegate PaySuccess];
//                }
            }
                break;
            default:
            {
//                if (_delegate && [_delegate  respondsToSelector:@selector(PayFail:)]) {
//                    [_delegate PayFail:response.errCode];
//                }
                NSLog(@"onResponResponResponResp");
            }
            break; }
    }
}
#pragma mark - http result

-(void) GetErr:(ASIHTTPRequest *)request
{
    [Commonality showErrorMsg:_errBaseView type:0 msg:LINGKERROR];
}
-(void) GetResult:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    NSLog(@"%@",[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (dictionary==nil) {
        [Commonality showErrorMsg:_errBaseView type:0 msg:@"网络连接异常，请重试"];
    }else{
        if (request.tag == TENPAY_ACCESSTOKEN_TYPE) {
            _accessTokenModel = [[TenPayAccessTokenModel alloc]initWithDictionary:dictionary];
            [self getPrepayId:_accessTokenModel.accessToken];
        }else if(request.tag == TENPAY_PREPAREWXPay_TYPE)
        {
            _prepareWXPayModel = [[TenPayPrepareWXPayModel alloc]initWithDictionary:dictionary];
            if ([_prepareWXPayModel.errorCode isEqualToString:@"0"]) {
                [self prepareTenPay:_prepareWXPayModel];
            }else{
                [Commonality showErrorMsg:_errBaseView type:0 msg:_prepareWXPayModel.errorMessage];
            }
        }else if(request.tag == TENPAY_TRADERESULT_TYPE)
        {
            _tradeResultModel = [[TenPayTradeResultModel alloc]initWithDictionary:dictionary];
        }
    }
}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (1) {
            if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]]) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
            }
        }
    }
    
}
@end
