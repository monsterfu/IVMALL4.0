//
//  BuyVIPCell.h
//  IVMallHD
//
//  Created by Monster on 14-8-12.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuyVIPCellDelegate <NSObject>
-(void)buyButtonTouchWithTag:(NSUInteger)index;
@end

@interface BuyVIPCell : UITableViewCell

@property (weak, nonatomic)id<BuyVIPCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productDetail;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;


- (IBAction)buyButtonTouch:(UIButton *)sender;

@end
