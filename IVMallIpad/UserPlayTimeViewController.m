//
//  UserPlayTimeViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserPlayTimeViewController.h"
#import "AppDelegate.h"
#import "PlayTimeModel.h"
#import "Commonality.h"
#import "Macro.h"
#import "NotWiFiView.h"
@interface UserPlayTimeViewController ()<MainViewRefershDelegate>

@end

@implementation UserPlayTimeViewController
{
    PlayTimeModel *myPlayTime;
    NotWiFiView* myNotWiFiView;
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

    
    myNotWiFiView = [[NotWiFiView alloc]init];
    [myNotWiFiView setNotWiFiStyle:Dialog1NotWiFi];
    myNotWiFiView.delegate = self;
    [myNotWiFiView setHidden:YES];
    myNotWiFiView.opaque = NO;
    [_bgView addSubview:myNotWiFiView];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)show
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString* tempName = [NSString stringWithFormat:@"%@",[userDefaultes stringForKey:@"mobile"]];
    NSString* string1, *string2, *string3;
    string1 = [tempName substringToIndex:3];
    string2 = [tempName substringFromIndex:7];
    string3 = [NSString stringWithFormat:@"%@%@%@",string1,@"****",string2];
    _userInfoLabel.text = string3;
    
    _totalHourLabel.text = [NSString stringWithFormat:@"%d",myPlayTime.total/3600];
    _totalMinLabel.text = [NSString stringWithFormat:@"%d",myPlayTime.total%60];
    
    _oneDayLabel.text = [NSString stringWithFormat:@"您总共观看了\n%@",[Commonality timeToString:myPlayTime.day]];
    _sevenDayLabel.text = [NSString stringWithFormat:@"您总共观看了\n%@",[Commonality timeToString:myPlayTime.week]];
    _oneMonthLabel.text = [NSString stringWithFormat:@"您总共观看了\n%@",[Commonality timeToString:myPlayTime.month]];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
    [self.view bringSubviewToFront:_closeBtn];
    if ([self.navigationController childViewControllers].count >2) {
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_07-18.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_07-19.png"] forState:UIControlStateHighlighted];
    }else{
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close_sel.png"] forState:UIControlStateHighlighted];
    }
    myPlayTime = nil;
    [HttpRequest UserPlayTimeRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

-(void)GetErr:(ASIHTTPRequest *)request
{
//    [loading stopAnimating];
    if ([Commonality isEnableWIFI]==0) {
//        [Commonality showErrorMsg:self.view type:0 msg:FAIILURE];
        
        
        _bgView.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
        myNotWiFiView.hidden = NO;
        [_bgView bringSubviewToFront:myNotWiFiView];
        
    }else{
//        [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
        
        _bgView.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
        myNotWiFiView.hidden = NO;
        [_bgView bringSubviewToFront:myNotWiFiView];
    }
}

-(void) GetResult:(ASIHTTPRequest *)request{
//    [loading stopAnimating];
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (dictionary==nil) {
        [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
        
        myNotWiFiView.hidden = NO;
        [_bgView bringSubviewToFront:myNotWiFiView];
        
    }else{
        if(request.tag == USER_PLAYTIME_TYPE){
            myPlayTime = [[PlayTimeModel alloc]initWithDictionary:dictionary];
            if (myPlayTime.errorCode == 0) {
                [self show];
            }
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonTouched:(id)sender {
        [[AppDelegate App]click];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)refresh
{
    _bgView.backgroundColor = [Commonality colorFromHexRGB:@"f6f6f6"];
    
    myPlayTime = nil;
    [HttpRequest UserPlayTimeRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    return;
}
@end
