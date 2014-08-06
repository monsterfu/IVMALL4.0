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

typedef enum : NSUInteger {
    ProductOne,//后续根据实际产品名字再命名，这里先用123
    ProductTwo,
    ProductThree,
} ProductEnum;


@protocol BuyVIPViewControllerDelegate <NSObject>
-(void)purchaseProduct:(BuyListModel*)model;
@end


@interface BuyVIPViewController : UIViewController
{
    NSMutableArray* _vipArray;
}

@property(nonatomic,assign)id<BuyVIPViewControllerDelegate>delegate;

////////////////
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDesLabel;

@property (weak, nonatomic) IBOutlet UILabel *productName1Label;
@property (weak, nonatomic) IBOutlet UILabel *productDes1Label;


@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;

////////////////
- (IBAction)oneButtonTouch:(UIButton *)sender;
- (IBAction)twoButtonTouch:(UIButton *)sender;


- (IBAction)closeButtonTouch:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;

@end
