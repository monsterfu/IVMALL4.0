//
//  MJRefreshHeaderView.h
//  weibo
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

#import "MJRefreshBaseView.h"

// 类
@protocol MJRefreshShouldshowDelegate <NSObject>
- (void)refreshViewShouldBeginRefreshing;
@end

@interface MJRefreshHeaderView : MJRefreshBaseView
{
//    __weak id<MJRefreshShouldshowDelegate> _HeaderDelegate;
}
@property (nonatomic, assign) id<MJRefreshShouldshowDelegate> headerDelegate;
+ (id)header;
@end