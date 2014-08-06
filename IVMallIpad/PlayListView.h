//
//  PlayListView.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexFeaturedHomeView.h"
@interface PlayListView : UIView<UIScrollViewDelegate,PlayerCallBackDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,assign)id<MainViewDelegate> delegate;
-(void)show;
@end
