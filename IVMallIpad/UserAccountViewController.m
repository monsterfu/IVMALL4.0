//
//  UserAccountViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserAccountViewController.h"
#import "Macro.h"
#import "PurchaseAndRechargeManagerController.h"
#import "UserBalanceModel.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "PayListModel.h"
#import "BuyListModel.h"
#import "NotWiFiView.h"
#import "PayAddModel.h"
@interface UserAccountViewController ()<MJRefreshBaseViewDelegate,ASIHTTPRequestDelegate,MainViewRefershDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSMutableArray* chargePayList;
    NSMutableArray* buyList;
    int payPage;
    int buyPage;
    MBProgressHUD* myMBprogressHUD;
    
    NotWiFiView* AllNotWifiView;
    NotWiFiView* downNotWifiView;
    BOOL hadBalance;
}

@end

@implementation UserAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(balanceChange:) name:NSNotificationCenterUserBalanceChange object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSNotificationCenterUserBalanceChange object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if ([AppDelegate App].myUserLoginMode.token) {
//        [HttpRequest UserBalanceRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
//    }
    hadBalance = NO;
    
    AllNotWifiView = [[NotWiFiView alloc]init];
    [AllNotWifiView setNotWiFiStyle:Dialog1NotWiFi];
    AllNotWifiView.delegate = self;
    [_bgView addSubview:AllNotWifiView];
    [AllNotWifiView setHidden:YES];
    
    downNotWifiView = [[NotWiFiView alloc]init];
    [downNotWifiView setNotWiFiStyle:Area2NotWiFi];
    downNotWifiView.delegate = self;
    [_bgView addSubview:downNotWifiView];
    [downNotWifiView setHidden:YES];
    
    _chargeRecordButton.selected = YES;
    _purchaseButton.selected = NO;
    payPage = 1 ;
    buyPage = 1;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.opaque = NO;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    
    chargePayList = [[NSMutableArray alloc]init];
    buyList = [[NSMutableArray alloc]init];
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.delegate = self;
    
    // 4.3行集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    _footer.delegate=self;
    
    myMBprogressHUD = [[MBProgressHUD alloc]initWithView:_tableView];
    [_tableView addSubview:myMBprogressHUD];
    myMBprogressHUD.labelText = @"正在请求数据";
    

    [HttpRequest PayListRequestToken:[AppDelegate App].myUserLoginMode.token page:payPage rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
//    [self.view bringSubviewToFront:_closeBtn];
    [super viewWillAppear:animated];
    [HttpRequest UserBalanceRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}
#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header) { // 下拉刷新
     
        if (_chargeRecordButton.selected) {
            payPage = 1;
            [HttpRequest PayListRequestToken:[AppDelegate App].myUserLoginMode.token page:payPage rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        }else{
            buyPage = 1;
            [HttpRequest BuyListRequestToken:[AppDelegate App].myUserLoginMode.token page:buyPage rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        }
    }else {
        if (_chargeRecordButton.selected) {
            if (chargePayList.count == 0) {
                payPage = 1;
                [HttpRequest PayListRequestToken:[AppDelegate App].myUserLoginMode.token page:payPage rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }else{
                [HttpRequest PayListRequestToken:[AppDelegate App].myUserLoginMode.token page:payPage+1 rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }
        }else{
            if (buyList.count == 0) {
                buyPage = 1;
                [HttpRequest BuyListRequestToken:[AppDelegate App].myUserLoginMode.token page:buyPage rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }else{
                [HttpRequest BuyListRequestToken:[AppDelegate App].myUserLoginMode.token page:buyPage+1 rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
            }
        }

    }
}
#pragma mark 刷新
- (void)reloadDeals
{
    // 结束刷新状态
    NSLog(@"reloadDeals");
    [_header endRefreshing];
    [_footer endRefreshing];
}
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(iPad){
        return 55;
    }else{
        return 20;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (_chargeRecordButton.selected) {
        return chargePayList.count;
    }else{
        return buyList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier3 = @"MainCell3";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel* line = [[UILabel alloc]init];
        if (iPad) {
            line.frame = CGRectMake(0, 54, 683, 1);
        }else {
            line.frame = CGRectMake(0, 19, 340, 1);
        }

        line.backgroundColor = [Commonality colorFromHexRGB:@"e3e3e3"];
        [cell addSubview:line];
    }
    UILabel* label1 = (UILabel*)[cell viewWithTag:500];
    if (label1== nil) {
        label1 = [[UILabel alloc]init];
        if (iPad) {
            label1.frame  = CGRectMake(16, 0, 149, 55);
            label1.font = [UIFont boldSystemFontOfSize:19];
        }else{
            label1.frame  = CGRectMake(8, 0, 75, 20);
            label1.font = [UIFont boldSystemFontOfSize:10];
        }

        label1.backgroundColor = [UIColor clearColor];
        [label1 setTag:500];
        [label1 setTextAlignment:NSTextAlignmentCenter];
        
        label1.textColor = [UIColor blackColor];
        [cell addSubview:label1];
    }
    if (_chargeRecordButton.selected) {
        PayListModel* temp = [chargePayList objectAtIndex:indexPath.row];
        if ([temp.type isEqualToString:@"alipay"]) {
            label1.text = @"支付宝充值";
        }else if ([temp.type isEqualToString:@"voucher"]){
            label1.text = @"点卡充值";
        }else if ([temp.type isEqualToString:@"gift"]){
            label1.text = @"赠送";
        }else {
            label1.text = @"应用内支付";
        }
    }else{
        BuyListModel* temp = [buyList objectAtIndex:indexPath.row];
        label1.text = temp.productTitle;
    }
    
    UILabel* label2 = (UILabel*)[cell viewWithTag:501];
    if (label2== nil) {
        label2 = [[UILabel alloc]init];
          if (iPad) {
              label2.frame  = CGRectMake(188, 0, 307, 55);
              label2.font = [UIFont boldSystemFontOfSize:19];
          }else{
              label2.frame  = CGRectMake(94, 0, 153, 20);
              label2.font = [UIFont boldSystemFontOfSize:10];
          }
        label2.backgroundColor = [UIColor clearColor];
        [label2 setTag:501];
        [label2 setTextAlignment:NSTextAlignmentCenter];
        label2.textColor = [UIColor blackColor];
        [cell addSubview:label2];
    }
    if (_chargeRecordButton.selected) {
        [label2 setHidden:YES];
    }else{
        [label2 setHidden:NO];
        BuyListModel* temp = [buyList objectAtIndex:indexPath.row];
        NSString* dateString = [Commonality Date2Str1:[Commonality dateFromString:temp.buyTime]];
        label2.text = dateString;
    }
    
    UILabel* label3 = (UILabel*)[cell viewWithTag:502];
    if (label3== nil) {
        label3 = [[UILabel alloc]init];
        
        if (iPad) {
            label3.frame  = CGRectMake(467, 0, 149, 55);
            label3.font = [UIFont boldSystemFontOfSize:19];
        }else{
            label3.frame  = CGRectMake(233, 0, 75, 20);
            label3.font = [UIFont boldSystemFontOfSize:10];
        }
        label3.backgroundColor = [UIColor clearColor];
        [label3 setTag:502];
        [label3 setTextAlignment:NSTextAlignmentCenter];
        label3.textColor = [UIColor blackColor];
        [cell addSubview:label3];
    }
    
    if (_chargeRecordButton.selected) {
        PayListModel* temp = [chargePayList objectAtIndex:indexPath.row];
        [label3 setText:[NSString stringWithFormat:@"%.2f猫币",temp.points]];
    }else{
        BuyListModel* temp = [buyList objectAtIndex:indexPath.row];

        label3.text = [NSString stringWithFormat:@"%.2f猫币",temp.points];
    }
    
    return cell;
    
    
}
-(void) GetErr:(ASIHTTPRequest *)request
{
    [self reloadDeals];
    [myMBprogressHUD hide:YES];

    if (request.tag == USER_BALANCE_TYPE || (request.tag%PAGESECTION) == PAY_LIST_TYPE || (request.tag%PAGESECTION) == BUY_LIST_TYPE) {
        //        [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
        if (hadBalance) {
            if ((request.tag%PAGESECTION) == BUY_LIST_TYPE || (request.tag%PAGESECTION) == PAY_LIST_TYPE) {
                [downNotWifiView setHidden:NO];
            }
        }else{
            [AllNotWifiView setHidden:NO];
            [_bgView setBackgroundColor:[Commonality colorFromHexRGB:@"eeeeee"]];
        }
    }
}

-(void) GetResult:(ASIHTTPRequest *)request
{
    //成功  这里怎么写
    [self reloadDeals];
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    [myMBprogressHUD hide:YES];
    if(dictionary==nil){
        if (request.tag == USER_BALANCE_TYPE || (request.tag%PAGESECTION) == PAY_LIST_TYPE || (request.tag%PAGESECTION) == BUY_LIST_TYPE) {
            [myMBprogressHUD hide:YES];
//            [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
            if (hadBalance) {
                if ((request.tag%PAGESECTION) == BUY_LIST_TYPE || (request.tag%PAGESECTION) == PAY_LIST_TYPE) {
                    [downNotWifiView setHidden:NO];
                }
            }else{
                [AllNotWifiView setHidden:NO];
                [_bgView setBackgroundColor:[Commonality colorFromHexRGB:@"eeeeee"]];
            }
        }
    }else{
        if (request.tag == USER_BALANCE_TYPE) {
            UserBalanceModel* tempUserBalanceModel = [[UserBalanceModel alloc]initWithDictionary:dictionary];
            if (tempUserBalanceModel.result == 0) {
                hadBalance = YES;
                _balanceLabel.text = [NSString stringWithFormat:@"%.2f",tempUserBalanceModel.balance];
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:tempUserBalanceModel.errorMessage];
                [AllNotWifiView setHidden:NO];
                [_bgView setBackgroundColor:[Commonality colorFromHexRGB:@"eeeeee"]];
            }
        }else if((request.tag%PAGESECTION) == PAY_LIST_TYPE)
        {
            int tempPage = request.tag / PAGESECTION;

            PayListModel* temp = [[PayListModel alloc]initWithDictionary:dictionary modelList:chargePayList page:tempPage];
            if (temp.result == 0) {
                payPage = tempPage;
                [_tableView reloadData];
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:temp.errorMessage];
            }
            
        }else if((request.tag%PAGESECTION) == BUY_LIST_TYPE){
            int tempPage = request.tag / PAGESECTION;
            BuyListModel* temp = [[BuyListModel alloc]initWithVipDictionary:dictionary modelList:buyList page:tempPage];
            if (temp.result == 0) {
                buyPage = tempPage;
                [_tableView reloadData];
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:temp.errorMessage];
            }
        }

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chargeRecordButtonTouch:(UIButton *)sender {
    if (sender.selected == NO) {
            [[AppDelegate App]click];
        sender.selected = YES;
        _purchaseButton.selected = NO;
        payPage = 1;
        [myMBprogressHUD show:YES];
        [HttpRequest PayListRequestToken:[AppDelegate App].myUserLoginMode.token page:payPage rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        
    }
}

- (IBAction)purchaseButtonTouch:(UIButton *)sender {
    if (sender.selected == NO) {
            [[AppDelegate App]click];
        sender.selected = YES;
        _chargeRecordButton.selected = NO;
        buyPage = 1;
        [myMBprogressHUD show:YES];
        [HttpRequest BuyListRequestToken:[AppDelegate App].myUserLoginMode.token page:buyPage rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}

- (IBAction)chargeButtonTouch:(UIButton *)sender {
        [[AppDelegate App]click];
    PurchaseAndRechargeManagerController* purchaseController = [[PurchaseAndRechargeManagerController alloc]initWithNibName:nil bundle:nil mode:ProcessModeEnum_Recharge completionHandler:nil];
    
    PopUpViewController* popUpViewController = [[PopUpViewController shareInstance]initWithNibName:@"PopUpViewController" bundle:nil];
    
    [popUpViewController popViewController:purchaseController fromViewController:self finishViewController:nil];
}

- (IBAction)closeButtonTouch:(UIButton *)sender
{
        [[AppDelegate App]click];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)balanceChange:(NSNotification*)notification
{
    NSString* balance = [notification object];
    _balanceLabel.text =  balance;

}

- (void)refresh
{
    if (!hadBalance) {
        if (iPad) {
            [_bgView setBackgroundColor:[Commonality colorFromHexRGB:@"f1ffe5"]];
        }else{
            [_bgView setBackgroundColor:[UIColor whiteColor]];
        }
         [myMBprogressHUD show:YES];
            [HttpRequest UserBalanceRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
        _chargeRecordButton.selected = YES;
        _purchaseButton.selected = NO;
        payPage = 1 ;
        buyPage = 1;
        [HttpRequest PayListRequestToken:[AppDelegate App].myUserLoginMode.token page:payPage rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }else{
        [myMBprogressHUD show:YES];
        _chargeRecordButton.selected = YES;
        _purchaseButton.selected = NO;
        payPage = 1 ;
        buyPage = 1;
        [HttpRequest PayListRequestToken:[AppDelegate App].myUserLoginMode.token page:payPage rows:10 delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    }
}
@end
