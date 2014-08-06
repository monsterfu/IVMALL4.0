//
//  QRCodeReadViewController.h
//  IVMallHD
//
//  Created by SmitJh on 14-7-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxBlurImageViewController.h"
#import "ZBarSDK.h"

@interface QRCodeReadViewController : BoxBlurImageViewController<ZBarReaderViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

- (IBAction)close:(id)sender;
@end
