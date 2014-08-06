//
//  QRCodeReadViewController.m
//  IVMallHD
//
//  Created by SmitJh on 14-7-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "QRCodeReadViewController.h"
#import "ZBarReaderController.h"
#import "Commonality.h"
#import "AppDelegate.h"
#import "Macro.h"

@interface QRCodeReadViewController ()
{
    ZBarReaderView *myreaderView;
    UIImageView *imageView;
    NSURLConnection* aSynConnection;
}

@end

@implementation QRCodeReadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myreaderView = [[ZBarReaderView alloc]init];
    CGRect tempRect;
    if (iPad) {
        tempRect = CGRectMake(0, 0, 760, 548);
//        tempRect = CGRectMake(200, 100, 200, 200);
        
    }else{
        tempRect = CGRectMake(0, 0, 385, 260);
    }
    myreaderView.frame = tempRect;
    [myreaderView willRotateToInterfaceOrientation:self.interfaceOrientation duration:1];
    myreaderView.readerDelegate = self;
    //关闭闪光灯
    myreaderView.torchMode = 0;
    //扫描区域
    //    CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(myreaderView.frame) - 196, 200, 200);
    
    [_bgView addSubview:myreaderView];
    
    //扫描区域计算
    //    myreaderView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:myreaderView.bounds];
    
    
    CGRect tempRect2;
    if (iPad) {
        tempRect2 = CGRectMake(0, 500, 760, 30);
    }else{
        tempRect2 = CGRectMake(0, 220, 385, 20);
    }
    UILabel* label = [[UILabel alloc]initWithFrame:tempRect2];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.text = @"请将TV登录界面的二维码放入框内，即可自动登录";
    label.textColor = [UIColor whiteColor];
    [_bgView addSubview:label];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [myreaderView start];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
    [self.view bringSubviewToFront:_closeBtn];
}


- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"ZBarSymbol =%@", symbol.data);
        if ([symbol.data rangeOfString:@"drmid="].location != NSNotFound) {
            NSString* drmId = [self drmIdGet:symbol.data];
            [self sendMsg:drmId];
            [readerView stop];
        }else{
            if ([symbol.data hasPrefix:@"http://"] || [symbol.data hasPrefix:@"https://"]) {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"是否打开链接？" message:symbol.data delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 10001;
                [alertView show];
                [readerView stop];
            }
        }
        break;
    }
    //    [readerView stop];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:alertView.message]]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:alertView.message]];
        }
        [myreaderView start];
    }else{
        [myreaderView start];
//        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)sendMsg:(NSString*)drmid
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* urlString = [NSString stringWithFormat:@"%@/user/login?content=Ender_Push_Msg:phone:%@:pwd:%@:appVersion:%@&type=3&msgType=0&drmid=%@&userOrigin=ivmall",APPSERVER,[userDefaults objectForKey:@"mobile"],[userDefaults objectForKey:@"password"],IVMALL_VERSION,drmid];
    
    NSLog(@"urlString =%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 30];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    aSynConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    return;
}
#pragma mark- NSURLConnectionDataDelegate 协议方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == aSynConnection) {
        NSLog(@"response=%@",response);
    }
}

-(NSString*)drmIdGet:(NSString*)urlString
{
    
    if ([urlString rangeOfString:@"drmid="].location!= NSNotFound) {
        urlString = [urlString substringFromIndex:[urlString rangeOfString:@"drmid="].location+6];
        if ([urlString rangeOfString:@"&"].location != NSNotFound) {
            urlString = [urlString substringToIndex:[urlString rangeOfString:@"&"].location];
        }
        return urlString;
    }
    return nil;
}

- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    return 0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [myreaderView stop];
            [[AppDelegate App]click];
    [self.navigationController popViewControllerAnimated:NO];
}
@end
