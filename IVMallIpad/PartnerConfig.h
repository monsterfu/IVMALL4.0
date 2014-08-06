//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088111275328321"
//收款支付宝账号
#define SellerID  @"pay@ivmall.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @""

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAIrWQIiJcXCyKfc2zaJ+TDUabnefnKIba05ZDLBJWe7Lfokmf+JrRwScpSzPlcK7H9HNl7Nld/bZDIpKARRt8ig0dcaWEhHeE+HS6NdAM1CydlleGnftTY3VmIpld781lt4lZDY28m0Io4GmpJVgOPXUn/J3q6DVwDHz8oqTdIFhAgMBAAECgYAS8XTQrGAsDkMnlfSszSq8vCSCcea/P5p+kCvpCbkZme5j7Drau+RuvqjS2mgGr92BlNm0Ao5Bwg+x9rL7BJ1bpuooa3uJb3G7a50omq2JXtbhOqXLkBrMSG1zhcpZuDt2X9XQ4vZY2279xZJEz01siGykrqo3bcDUQKOYXqdgoQJBANxR9KDM6ZeXZ6yKkI7mSNstj+04E0A2nnKnMrR8gPSAVQCGAskcNhsm9LBLfBKveusojl0ueze0ITAcFCQ4wh0CQQChUiksETK5toMLJ3le2HPC5LK5HU474WNMcrCFICGbztTb6n2c7LjaI0BHI0P45zdLdUxN0s1TmsCBMaVDqtkVAkEAr55kcQjl6oA1k8OgF0hZKtzWrTDVp4niI2JDeLsFz9+74f7wmX5zYpFa2mxRKlPWlzxsvroeXfinu8GmDHlxwQJAfmHOrZ5fngy1RzTKqhprPoFK3yltVA40a/zh+7l7ewQj0JI5jIoMG6FIRzMCmmoR8MTZXZLLlzcCn3RUY9niLQJANJkOuC4oUKkdGQG4bQpzE7tixjRaUweEzLM85zGaYKWyJpU2WfOGn8C0LfyUF8tHM03U6jYpkkoFp/nSRnHo9Q=="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
