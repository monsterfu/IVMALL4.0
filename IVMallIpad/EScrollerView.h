//
//  EScrollerView.h
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import <UIKit/UIKit.h>

@protocol EScrollerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(NSUInteger)index;
@end

@interface EScrollerView : UIView<UIScrollViewDelegate> {
	CGRect viewSize;
	UIScrollView *scrollView;
	NSArray *imageArray;
    NSArray *titleArray;
    NSArray *vipImageArray;
    UIPageControl *pageControl;
    id<EScrollerViewDelegate> delegate;
    int currentPageIndex;
    UILabel *noteTitle;
    UIImageView* vipImage;
}
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)id<EScrollerViewDelegate> delegate;
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr VipArray:(NSArray*)vipArr;
@end
