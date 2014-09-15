//
//  IndexFeaturedHomeView.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVMallPlayer.h"
#import "UserLoginViewController.h"
#import "UserPreferenceModel.h"
#import "UserRegisterViewController.h"
#import "ProductPlayModel.h"
#import "ContentEpisodeItemListViewController.h"
#import "AppTipsModel.h"
#import "PurchaseAndRechargeManagerController.h"

enum{ //当前页面
	PAGE_INDEX=0,       //推荐页面
	PAGE_CATEGORY,    //分类页面
    PAGE_PERSONAL,
	PAGE_PLAYLIST,      //播放记录
    PAGE_UNKNOWN        //保留值
};
typedef NSInteger PagesStateEnum;

@protocol MainViewDelegate<NSObject>

-(void)buyVip:(PurchaseCompletionHandler)fun;

@optional
- (PagesStateEnum)pageState;
- (void)hideBottomView;
- (void)showMBProgressHUD;
- (void)hideMBProgressHUD;
- (void)showNotWifiView;
- (void)hideNotWifiView;
- (UINavigationController*)getNavigation;
- (UIView*)getMianView;
//-(void)enterViewController:(UIViewController*)newViewController;
@end


@interface IndexFeaturedHomeView : UIView<UIScrollViewDelegate,PlayerCallBackDelegate>

@property (nonatomic,assign)id<MainViewDelegate> delegate;
- (void)playBefoerLoginVideo;

-(void)show;

@end
