//
//  ChannelCatContentListView.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexFeaturedHomeView.h"
@interface ChannelCatContentListView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)NSString* categoryId;
@property (nonatomic,assign)id<MainViewDelegate> delegate;
-(void)show;
@end
