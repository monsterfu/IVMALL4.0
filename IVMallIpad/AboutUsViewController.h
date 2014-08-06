//
//  AboutUsViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxBlurImageViewController.h"
#import "ASIHTTPRequest.h"

@interface AboutUsViewController : BoxBlurImageViewController<ASIHTTPRequestDelegate>


@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *versionCheckBtn;

- (IBAction)telephoneButtonTouch:(UIButton *)sender;

- (IBAction)versionCheckButtonTouch:(UIButton *)sender;
- (IBAction)closeButtonTouched:(id)sender;
@end
