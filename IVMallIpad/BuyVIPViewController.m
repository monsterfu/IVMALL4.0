//
//  BuyVIPViewController.m
//  IVMallHD
//
//  Created by Monster on 14-7-10.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "BuyVIPViewController.h"

#define VIPMODEL_KEY  @"vipmodel_key"

@interface BuyVIPViewController ()

@end

@implementation BuyVIPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (!IOS7) {
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _vipArray = [NSMutableArray array];
    self.view.frame = [UIScreen mainScreen].bounds;
    [HttpRequest VipListRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    
    [_oneButton setHidden:YES];
    [_twoButton setHidden:YES];
    _oneButton.exclusiveTouch = YES;
    _twoButton.exclusiveTouch = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)oneButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(purchaseProduct:)]) {
        [self.delegate purchaseProduct:[_vipArray objectAtIndex:0]];
    }
}

- (IBAction)twoButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(purchaseProduct:)]) {
        [self.delegate purchaseProduct:[_vipArray objectAtIndex:1]];
    }
}

- (IBAction)closeButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    [[PopUpViewController shareInstance]dismissAnimated:YES];
}


#pragma mark - http result

-(void) GetErr:(ASIHTTPRequest *)request{
    [Commonality showErrorMsg:self.view type:0 msg:@"网络连接异常！"];
    
    NSDictionary *dictionary = [USER_DEFAULT objectForKey:VIPMODEL_KEY];
    BuyListModel * fm = [[BuyListModel alloc] initWithVipListDictionary:dictionary modelList:_vipArray page:1];
    if (fm.result==0) {
        BuyListModel * payListM  = [_vipArray objectAtIndex:0];
        _productNameLabel.text = payListM.productTitle;
        _productDesLabel.text =  payListM.productDescription;
        payListM  = [_vipArray objectAtIndex:1];
        _productName1Label.text = payListM.productTitle;
        _productDes1Label.text =  payListM.productDescription;
        
        [_oneButton setHidden:NO];
        [_twoButton setHidden:NO];
    }
}

-(void) GetResult:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"error is %@",error);
    
    [_viewOne setHidden:NO];
    [_viewTwo setHidden:NO];
    
    if (dictionary==nil) {
        [Commonality showErrorMsg:self.view type:0 msg:@"网络连接异常！"];
    }else{
        [_vipArray removeAllObjects];
        
        BuyListModel * fm = [[BuyListModel alloc] initWithVipListDictionary:dictionary modelList:_vipArray page:1];
        if (fm.result==0) {
            BuyListModel * payListM  = [_vipArray objectAtIndex:0];
            _productNameLabel.text = payListM.productTitle;
            _productDesLabel.text =  payListM.productDescription;
            payListM  = [_vipArray objectAtIndex:1];
            _productName1Label.text = payListM.productTitle;
            _productDes1Label.text =  payListM.productDescription;
            
            [USER_DEFAULT setObject:dictionary forKey:VIPMODEL_KEY];
            [USER_DEFAULT synchronize];
            
            [_oneButton setHidden:NO];
            [_twoButton setHidden:NO];
        }
        else
        {
            [Commonality showErrorMsg:self.view type:fm.result msg:nil];
        }
    }
}

@end
