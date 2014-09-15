//
//  AboutUsViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "AboutUsViewController.h"
#import "Macro.h"
#import "Commonality.h"
#import "AppDelegate.h"




@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
{
//    NSURL *trackViewUrl;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _versionLabel.text = [NSString stringWithFormat:@"版本:V%@",IVMALL_VERSION];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
    if ([self.navigationController childViewControllers].count >2) {
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_07-18.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_07-19.png"] forState:UIControlStateHighlighted];
    }else{
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close_sel.png"] forState:UIControlStateHighlighted];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)telephoneButtonTouch:(UIButton *)sender {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",CALLPHONE]]]; //iPhone
        [[AppDelegate App]click];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",CALLPHONE]]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",CALLPHONE]]];
    }else{
        
    }
}

- (IBAction)versionCheckButtonTouch:(UIButton *)sender {
        [[AppDelegate App]click];
    if ([Commonality isEnableWIFI]==0) {
        [Commonality showErrorMsg:self.view type:0 msg:FAIILURE];
        return;
    }
//    [loading startAnimating];
    [sender setEnabled:NO];
    
    NSString* APP_URL = @"http://itunes.apple.com/lookup?id=789621268";
    if (iPad) {
        APP_URL = @"http://itunes.apple.com/lookup?id=848827713";
    }

    ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:APP_URL]];
    asiRequest.tag = CHECKVERSION;
    [asiRequest setUseSessionPersistence:YES];
    [asiRequest setUseCookiePersistence:YES];
    [asiRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [asiRequest setDelegate:self];
    [asiRequest setDidFinishSelector:@selector(GetResult:)];
    [asiRequest setDidFailSelector:@selector(GetErr:)];
    [asiRequest startAsynchronous];
}

- (IBAction)closeButtonTouched:(id)sender {
        [[AppDelegate App]click];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark asirequest delegate

-(void) GetErr:(ASIHTTPRequest *)request{
    [self.versionCheckBtn setEnabled:YES];
//    [loading stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"抱歉，检查升级失败！" delegate:[AppDelegate App] cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    alert.tag = 10002;
    [alert show];
}

-(void) GetResult:(ASIHTTPRequest *)request{
    [self.versionCheckBtn setEnabled:YES];
//    [loading stopAnimating];
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"%@",dictionary);
    if(dictionary!=nil){
        if (request.tag==CHECKVERSION) {
            NSString* currentVersion = IVMALL_VERSION;
            NSArray *infoArray = [dictionary objectForKey:@"results"];
            if (infoArray && infoArray.count>0) {
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                if (releaseInfo) {
                     NSString *lastVersion = [releaseInfo objectForKey:@"version"];
                    if (lastVersion.length > 0) {
                        int version_x = 0,version_y = 0, version_z = 0;
                        int current_x = 0,current_y = 0, current_z = 0;
                        sscanf([lastVersion UTF8String],"%d.%d.%d",&version_x,&version_y,&version_z);
                        sscanf([currentVersion UTF8String],"%d.%d.%d",&current_x,&current_y,&current_z);
                        
                        if((version_x>current_x) || (version_x==current_x && version_y>current_y) || (version_x==current_x && version_y==current_y && version_z>current_z))
                        {
                            [AppDelegate App].trackViewUrl = [NSURL URLWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新版本更新，是否前往更新？" delegate:[AppDelegate App] cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                            alert.tag = 10000;
                            [alert show];
                            return;
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:[AppDelegate App] cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            alert.tag = 10001;
                            [alert show];
                            return;
                        }

                    }
                }
            }
        }
    }
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//        [[AppDelegate App]click];
//    if (alertView.tag==10000) {
//        if (buttonIndex==1) {
//            if ([[UIApplication sharedApplication]canOpenURL:trackViewUrl]) {
//                [[UIApplication sharedApplication]openURL:trackViewUrl];
//            }
//        }
//    }
//}



@end
