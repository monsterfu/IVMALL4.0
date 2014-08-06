//
//  PersonalCenterView.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//
//@protocol PersonalCenterViewDelegate <NSObject>
//
//-(void)tempsss;
//
//@end

#import <UIKit/UIKit.h>
#import "IndexFeaturedHomeView.h"
@interface PersonalCenterView : UIView
@property (nonatomic,assign)id<MainViewDelegate> delegate;
//@property (nonatomic,assign)id<PersonalCenterViewDelegate> tempDelegate;
- (void)show;
@end
