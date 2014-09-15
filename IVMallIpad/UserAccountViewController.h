//
//  UserAccountViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxBlurImageViewController.h"
@interface UserAccountViewController : BoxBlurImageViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UIView* bgView;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *chargeRecordButton;//充值
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;//购买

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) IBOutlet UIView* upView;






- (IBAction)chargeRecordButtonTouch:(UIButton *)sender;

- (IBAction)purchaseButtonTouch:(UIButton *)sender;


- (IBAction)chargeButtonTouch:(UIButton *)sender;//充值

- (IBAction)closeButtonTouch:(UIButton *)sender;
@end
