//
//  PlayEpisodeListViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-8-28.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxBlurImageViewController.h"
@interface PlayEpisodeListViewController : BoxBlurImageViewController<UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@end
