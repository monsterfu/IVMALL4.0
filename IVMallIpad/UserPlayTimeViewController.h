//
//  UserPlayTimeViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxBlurImageViewController.h"
#import "ASIHTTPRequest.h"

@interface UserPlayTimeViewController : BoxBlurImageViewController<ASIHTTPRequestDelegate>




@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutlet UIView *bottomHalfView;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMinLabel;


@property (weak, nonatomic) IBOutlet UILabel *oneDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevenDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneMonthLabel;

- (IBAction)closeButtonTouched:(id)sender;
@end
