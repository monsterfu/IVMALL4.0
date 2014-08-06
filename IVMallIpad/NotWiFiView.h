//
//  NotWiFiView.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewRefershDelegate <NSObject>

-(void)refresh;

@end

enum{ //当前页面
	MainViewNotWiFi=0,//首页
	DialogNotWiFi,//剧集页面
    Dialog1NotWiFi,//有标题页面
    Dialog2NotWiFi,//修改密码页面
    AreaNotWiFi,//剧集页面下方
    AreaUserInfoWithoutWifi,//个人设置页面右侧
    Area2NotWiFi,//账户页面下方
};
typedef NSInteger NotWiFiStyle;

@interface NotWiFiView : UIView


@property (nonatomic,strong)id<MainViewRefershDelegate> delegate;

-(void)setNotWiFiStyle:(NotWiFiStyle)style;

@end
