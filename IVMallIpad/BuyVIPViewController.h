//
//  BuyVIPViewController.h
//  IVMallHD
//
//  Created by Monster on 14-7-10.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "BuyListModel.h"
#import "BuyVIPCell.h"

typedef enum : NSUInteger {
    ProductOne,//后续根据实际产品名字再命名，这里先用123
    ProductTwo,
    ProductThree,
} ProductEnum;


@protocol BuyVIPViewControllerDelegate <NSObject>
-(void)purchaseProduct:(BuyListModel*)model;
@end


@interface BuyVIPViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BuyVIPCellDelegate>
{
    NSMutableArray* _vipArray;
}

@property(nonatomic,assign)id<BuyVIPViewControllerDelegate>delegate;

////////////////
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


- (IBAction)closeButtonTouch:(UIButton *)sender;

@end
