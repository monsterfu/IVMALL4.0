//
//  MainViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotWiFiView.h"
#import "IndexFeaturedHomeView.h"
#import "PurchaseAndRechargeManagerController.h"
#import "Macro.h"


@interface MainViewController : UIViewController<UIScrollViewDelegate,MainViewRefershDelegate,MainViewDelegate/*,UITableViewDataSource,UITableViewDelegate*/>

@property (nonatomic,strong)IBOutlet  UIImageView*      myBackgroundImageView;//首页背景图片
@property (nonatomic,strong)IBOutlet  UIImageView*      UserDefinedPhotoImageView;//用户自定义头像
@property (nonatomic,strong)IBOutlet  UIButton*         personalCenterButton;//进入个人中心按钮
@property (nonatomic,strong)IBOutlet  UIScrollView*     SortScrollView;//分类集合
@property (nonatomic,strong)IBOutlet  UIButton*         categoryListButton;//显示剩余分类列表按钮
@property (nonatomic,strong)IBOutlet  UIButton*         WifiSetupButton;//进入投屏页面按钮


@end
