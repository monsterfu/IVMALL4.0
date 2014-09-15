//
//  BuyVIPViewController.m
//  IVMallHD
//
//  Created by Monster on 14-7-10.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "BuyVIPViewController.h"

#define VIPMODEL_KEY  @"vipmodel_key"

#define PRODUCT_HEIGHT   (iPad?140:78)
#define PRODUCT_CELL   (iPad?(@"BuyVIPCell"):(@"BuyVIPCell_IPhone"))

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
    
    UIView* view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:view];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    _vipArray = [NSMutableArray array];
    self.view.frame = [UIScreen mainScreen].bounds;
    [HttpRequest VipListRequestToken:[AppDelegate App].myUserLoginMode.token delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
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

- (IBAction)closeButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    [[PopUpViewController shareInstance]dismissAnimated:NO];
}


#pragma mark - http result

-(void) GetErr:(ASIHTTPRequest *)request{
    [Commonality showErrorMsg:self.view type:0 msg:@"网络连接异常！"];
    
    NSDictionary *dictionary = [USER_DEFAULT objectForKey:VIPMODEL_KEY];
    BuyListModel * fm = [[BuyListModel alloc] initWithVipListDictionary:dictionary modelList:_vipArray page:1];
    if (fm.result==0) {
        [_activityIndicatorView stopAnimating];
        [_tableView reloadData];
    }
}

-(void) GetResult:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"error is %@",error);
    
    if (dictionary==nil) {
        [Commonality showErrorMsg:self.view type:0 msg:@"网络连接异常！"];
    }else{
        [_vipArray removeAllObjects];
        
        BuyListModel * fm = [[BuyListModel alloc] initWithVipListDictionary:dictionary modelList:_vipArray page:1];
        if (fm.result==0) {
            [_activityIndicatorView stopAnimating];
            [_tableView reloadData];
            [USER_DEFAULT setObject:dictionary forKey:VIPMODEL_KEY];
            [USER_DEFAULT synchronize];
        }
        else
        {
            [Commonality showErrorMsg:self.view type:fm.result msg:nil];
        }
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PRODUCT_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_vipArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib* cellNib = [UINib nibWithNibName:PRODUCT_CELL bundle:[NSBundle mainBundle]];
    [tableView registerNib:cellNib forCellReuseIdentifier:@"buyVipCellIdentifier"];
    BuyVIPCell* cell = [tableView dequeueReusableCellWithIdentifier:@"buyVipCellIdentifier" forIndexPath:indexPath];
    BuyListModel * payListM  = [_vipArray objectAtIndex:indexPath.row];
    cell.productName.text = payListM.productTitle;
    cell.productDetail.text = payListM.productDescription;
    cell.delegate = self;
    cell.buyButton.exclusiveTouch = YES;
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = indexPath.row;
    return cell;
}

#pragma mark -BuyVIPCellDelegate
-(void)buyButtonTouchWithTag:(NSUInteger)index
{
    [[AppDelegate App]click];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(purchaseProduct:)]) {
        [self.delegate purchaseProduct:[_vipArray objectAtIndex:index]];
    }
}
@end
