//
//  FavoriteListViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxBlurImageViewController.h"
#import "IndexFeaturedHomeView.h"
#import "MBProgressHUD.h"
#import "NotWiFiView.h"


@interface FavoriteListViewController : BoxBlurImageViewController<UIScrollViewDelegate,MBProgressHUDDelegate,MainViewRefershDelegate>
{
    MBProgressHUD* myMBProgressHUD;
}
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (strong, nonatomic) IBOutlet UIView *bgView;

- (IBAction)deleteSelectedItems:(id)sender;
- (IBAction)deleteAllItems:(id)sender;
- (IBAction)close:(id)sender;
@end
