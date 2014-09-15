//
//  BuyVIPCell.m
//  IVMallHD
//
//  Created by Monster on 14-8-12.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "BuyVIPCell.h"

@implementation BuyVIPCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buyButtonTouch:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(buyButtonTouchWithTag:)]) {
        [self.delegate buyButtonTouchWithTag:self.tag];
    }
}
@end
