//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
#import "UIImageView+WebCache.h"
#import "Macro.h"
#import "Commonality.h"

@implementation EScrollerView
@synthesize delegate;

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr VipArray:(NSArray*)vipArr{
   _timer =  [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    
	if ((self=[super initWithFrame:rect])) {
        self.userInteractionEnabled=YES;
        if (vipArr!=nil) {
            vipImageArray=vipArr;
        }else{
            vipImageArray=nil;
        }
        
        titleArray=titArr;
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        CHECK_RETURN_CELL(tempArray.count > 0, self);
        CHECK_RETURN_CELL(imgArr.count > (imgArr.count-1), self);
        CHECK_RETURN_CELL([imgArr objectAtIndex:(imgArr.count-1)], self);
        if ([imgArr objectAtIndex:([imgArr count]-1)] == nil) {
            return self;
        }
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
		imageArray=[NSArray arrayWithArray:tempArray];
		viewSize=rect;
        NSUInteger pageCount=[imageArray count];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        for (int i=0; i<pageCount; i++) {
            CHECK_RETURN_CELL(imageArray.count > i, self);
            NSString *imgURL=[imageArray objectAtIndex:i];
            UIImageView *imgView=[[UIImageView alloc] init];
            if ([imgURL hasPrefix:@"http://"]) {
                [imgView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"正在加载图片.png"]];
            }else{
                UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
                [imgView setImage:img];
            }
            
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];

            imgView.tag=i;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];

            [scrollView addSubview:imgView];

        }

        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];

        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height,self.bounds.size.width,40)];
        
//        CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
//        CGRect newShadowFrame = CGRectMake(0, 0, self.bounds.size.width, 40);
//        newShadow.frame = newShadowFrame;
//
//        newShadow.colors = [NSArray arrayWithObjects:(id)[[[UIColor clearColor] colorWithAlphaComponent:0] CGColor],(id)[[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor],(id)[[[UIColor blackColor] colorWithAlphaComponent:0.4] CGColor],(id)[[[UIColor blackColor] colorWithAlphaComponent:0.8] CGColor],nil];
////
//        [noteView.layer addSublayer:newShadow];
//        noteView.backgroundColor = [UIColor clearColor];
        
        float pageControlWidth=(pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=20.0f;
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth)-7,5, pageControlWidth + 5, pagecontrolHeight)];
        pageControl.currentPage=0;
        pageControl.numberOfPages=(pageCount-2);
        pageControl.pageIndicatorTintColor=color_23;
        pageControl.currentPageIndicatorTintColor=color_2;
        [noteView addSubview:pageControl];

        
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-pageControlWidth-15, 27.5)];
        [noteTitle setText:[titleArray objectAtIndex:0]];
        [noteTitle setBackgroundColor:[UIColor clearColor]];
        [noteTitle setFont:font_4];
        [noteTitle setTextColor:color_2];
        [noteView addSubview:noteTitle];

        
        [self addSubview:noteView];
        [self bringSubviewToFront:noteView];
	}
	return self;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer =  [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    CGFloat pageWidth = scrollView.frame.size.width;

    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
       
    pageControl.currentPage=(page-1);
    int titleIndex=page-1;
    if (titleIndex==[titleArray count]) {
        titleIndex=0;
    }
    if (titleIndex<0) {
        titleIndex=[titleArray count]-1;
    }
    if (titleIndex > titleArray.count) {
        titleIndex = 0;
    }
    [noteTitle setText:[titleArray objectAtIndex:titleIndex]];
//    if (_timer) {
//        [_timer invalidate];
//        _timer = nil;
//    }
//    [self performSelector:@selector(runTimePage) withObject:nil afterDelay:4];
//    [_timer fire];
//    _timer =  [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView{
    if (currentPageIndex==0) {
        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width , 0)];
    }
   if (currentPageIndex==([imageArray count]-1)) {
       [_scrollView setContentOffset:CGPointMake(viewSize.size.width , 0)];
    }
}

- (void)turnPage{
    int page = pageControl.currentPage;
    if (page == 0) {
         [scrollView scrollRectToVisible:CGRectMake(viewSize.size.width*(page+1),0,viewSize.size.width,viewSize.size.height) animated:NO];
    }
    else
    {
         [scrollView scrollRectToVisible:CGRectMake(viewSize.size.width*(page+1),0,viewSize.size.width,viewSize.size.height) animated:YES];
    }

}

- (void)runTimePage{
    int page = pageControl.currentPage;
    page++;
    page = page > [titleArray count]-1 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}

- (void)imagePressed:(UITapGestureRecognizer *)sender{
    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
//        [_timer setFireDate:[NSDate distantFuture]];//暂停
//        [myTimer setFireDate:[NSDate distantPast]];//重启
        [delegate EScrollerViewDidClicked:sender.view.tag-1];
    }
}

@end
