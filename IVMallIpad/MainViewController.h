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


@interface MainViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MainViewRefershDelegate,MainViewDelegate>

@property (nonatomic,strong)IBOutlet  UIImageView*  blurImage;
@property (nonatomic,strong)IBOutlet  UIImageView*  myBackgroundImageView;
@property (nonatomic,strong)IBOutlet  UIImageView*  UserDefinedPhotoImageView;//用户自定义头像
@property (nonatomic,strong)IBOutlet  UIScrollView* SortScrollView;//分类集合
@property (nonatomic,strong)IBOutlet  UIButton*     PersonalCenterButton;//个人中心按钮
@property (nonatomic,strong)IBOutlet  UIButton*     PlayRecordButton;//播放记录按钮
@property (nonatomic,strong)IBOutlet  UIButton*     WifiSetupButton;//WiFi设置按钮
@property (nonatomic,strong)IBOutlet  UIImageView*  cloudImageView2;


//- (IBAction)testButtonTouch:(UIButton *)sender;

@end
