//
//  PopUpViewController.m
//  IVMallHD
//
//  Created by Monster on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "PopUpViewController.h"




#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

CGFloat const kRNGridMenuDefaultDuration = 0.25f;
CGFloat const kRNGridMenuDefaultBlur = 0.19f;
CGFloat const kRNGridMenuDefaultWidth = 280;

#define POPUP_X             (iPad ?(130):(iPhone5 ?(60):(60)))
#define POPUP_Y             (iPad ?(111):(iPhone5 ?(48):(48)))
#define POPUP_WIDTH         (iPad ?(760):(iPhone5 ?(453):(365)))
#define POPUP_HEIGHT        (iPad ?(548):(iPhone5 ?(224):(224)))

#pragma mark - Functions

CGPoint RNCentroidOfTouchesInView(NSSet *touches, UIView *view) {
    CGFloat sumX = 0.f;
    CGFloat sumY = 0.f;
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:view];
        sumX += location.x;
        sumY += location.y;
    }
    
    return CGPointMake((CGFloat)round(sumX / touches.count), (CGFloat)round(sumY / touches.count));
}

#pragma mark - Categories

@implementation UIView (Screenshot)

- (UIImage *)rn_screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
    
}

@end


@implementation UIImage (Blur)

-(UIImage *)rn_boxblurImageWithBlur:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    // create unchanged copy of the area inside the exclusionPath
    UIImage *unblurredImage = nil;
    if (exclusionPath != nil) {
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.frame = (CGRect){CGPointZero, self.size};
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        maskLayer.path = exclusionPath.CGPath;
        
        // create grayscale image to mask context
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef context = CGBitmapContextCreate(nil, maskLayer.bounds.size.width, maskLayer.bounds.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
        CGContextTranslateCTM(context, 0, maskLayer.bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        [maskLayer renderInContext:context];
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage *maskImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        
        UIGraphicsBeginImageContext(self.size);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, maskLayer.bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        CGContextClipToMask(context, maskLayer.bounds, maskImage.CGImage);
        CGContextDrawImage(context, maskLayer.bounds, self.CGImage);
        unblurredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    // overlay images?
    if (unblurredImage != nil) {
        UIGraphicsBeginImageContext(returnImage.size);
        [returnImage drawAtPoint:CGPointZero];
        [unblurredImage drawAtPoint:CGPointZero];
        
        returnImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end

#pragma mark - PopUpViewController

@interface PopUpViewController ()

@property (nonatomic, assign) CGPoint menuCenter;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, strong) UIView *blurView;
@property (nonatomic, assign) BOOL parentViewCouldScroll;

@end

static PopUpViewController *single_PopUpViewController = nil;

@implementation PopUpViewController

#pragma mark - Lifecycle

+ (instancetype)shareInstance {
    if (single_PopUpViewController == nil) {
        single_PopUpViewController = [[PopUpViewController alloc]initWithNibName:@"PopUpViewController" bundle:nil];
    }
    return single_PopUpViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cornerRadius = 8.f;
        _blurLevel = kRNGridMenuDefaultBlur;
        _animationDuration = kRNGridMenuDefaultDuration;
        _backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _bounces = YES;
    }
    return self;
}


#pragma mark - UIResponder
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = RNCentroidOfTouchesInView(touches, self.menuView);
    if (point.x <= POPUP_X || point.x >= POPUP_WIDTH + POPUP_X ||point.y <= POPUP_Y||point.y >= POPUP_HEIGHT + POPUP_Y) {
        NSLog(@"POPUP_X:%d,POPUP_WIDTH:%d,POPUP_Y:%d,POPUP_HEIGHT:%d,point.x:%f,point.y:%f",POPUP_X,POPUP_WIDTH,POPUP_Y,POPUP_HEIGHT,point.x,point.y);
        //[self dismissAnimated:YES];
    }
}


#pragma mark - UIViewController
//
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!IOS7) {
        self.view.frame = [UIScreen mainScreen].bounds;
    }
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    self.menuView.backgroundColor = self.backgroundColor;
    self.menuView.opaque = NO;
    self.menuView.clipsToBounds = YES;
    
    CGFloat m34 = 1 / 300.f;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = m34;
    self.menuView.layer.transform = transform;
    
    if (self.backgroundPath != nil) {
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.frame = self.menuView.frame;
        maskLayer.transform = self.menuView.layer.transform;
        maskLayer.path = self.backgroundPath.CGPath;
        self.menuView.layer.mask = maskLayer;
    } else {
        self.menuView.layer.cornerRadius = self.cornerRadius;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if ([self isViewLoaded] && self.view.window != nil) {
        [self createScreenshotAndLayoutWithScreenshotCompletion:nil];
    }
}

- (void)createScreenshotAndLayoutWithScreenshotCompletion:(dispatch_block_t)screenshotCompletion {
    if (self.blurLevel > 0.f) {
        self.blurView.alpha = 0.f;
        
        self.menuView.alpha = 0.f;
        UIImage *screenshot = [self.parentViewController.view rn_screenshot];
        self.menuView.alpha = 1.f;
        self.blurView.alpha = 1.f;
        self.blurView.layer.contents = (id)screenshot.CGImage;
        
        if (screenshotCompletion != nil) {
            screenshotCompletion();
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L), ^{
            UIImage *blur = [screenshot rn_boxblurImageWithBlur:self.blurLevel exclusionPath:self.blurExclusionPath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CATransition *transition = [CATransition animation];
                
                transition.duration = 0.1;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                
                [self.blurView.layer addAnimation:transition forKey:nil];
                self.blurView.layer.contents = (id)blur.CGImage;
                
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            });
        });
    }
}

#pragma mark - Animations

- (void)popViewController:(UIViewController *)popViewController fromViewController:(UIViewController *)baseViewController finishViewController:(UIViewController*)finishViewController{
    
    NSParameterAssert(baseViewController != nil);
    NSParameterAssert(popViewController != nil);
    
    _baseViewController = baseViewController;
    _popViewController = popViewController;
    _finishViewController = finishViewController;
    
    _menuView = popViewController.view;
    
    [self rn_addToParentViewController:baseViewController callingAppearanceMethods:NO];
    popViewController.view.center = baseViewController.view.center;
    popViewController.view.frame = baseViewController.view.bounds;
    
    [self showAnimated:YES];
}

- (void)showAnimated:(BOOL)animated {
    
    self.blurView = [[UIView alloc] initWithFrame:self.parentViewController.view.bounds];
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.blurView];
    [self.view addSubview:self.menuView];
    
    [self createScreenshotAndLayoutWithScreenshotCompletion:^{
        if (animated) {
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.fromValue = @0.;
            opacityAnimation.toValue = @1.;
            opacityAnimation.duration = self.animationDuration * 0.5f;
            
            CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            
            CATransform3D startingScale = CATransform3DScale(self.menuView.layer.transform, 0, 0, 0);
            CATransform3D overshootScale = CATransform3DScale(self.menuView.layer.transform, 1.05, 1.05, 1.0);
            CATransform3D undershootScale = CATransform3DScale(self.menuView.layer.transform, 0.98, 0.98, 1.0);
            CATransform3D endingScale = self.menuView.layer.transform;
            
            NSMutableArray *scaleValues = [NSMutableArray arrayWithObject:[NSValue valueWithCATransform3D:startingScale]];
            NSMutableArray *keyTimes = [NSMutableArray arrayWithObject:@0.0f];
            NSMutableArray *timingFunctions = [NSMutableArray arrayWithObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
            if (self.bounces) {
                [scaleValues addObjectsFromArray:@[[NSValue valueWithCATransform3D:overshootScale], [NSValue valueWithCATransform3D:undershootScale]]];
                [keyTimes addObjectsFromArray:@[@0.5f, @0.85f]];
                [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            }
            
            [scaleValues addObject:[NSValue valueWithCATransform3D:endingScale]];
            [keyTimes addObject:@1.0f];
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            
            scaleAnimation.values = scaleValues;
            scaleAnimation.keyTimes = keyTimes;
            scaleAnimation.timingFunctions = timingFunctions;
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            animationGroup.animations = @[scaleAnimation, opacityAnimation];
            animationGroup.duration = self.animationDuration;
            
            [self.menuView.layer addAnimation:animationGroup forKey:nil];
        }
    }];
}

- (void)dismissAnimated:(BOOL)animated {
    if (self.dismissAction != nil) {
        self.dismissAction();
    }
    
    if (animated) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @1.;
        opacityAnimation.toValue = @0.;
        opacityAnimation.duration = self.animationDuration;
        [self.blurView.layer addAnimation:opacityAnimation forKey:nil];
        
        CATransform3D transform = CATransform3DScale(self.menuView.layer.transform, 0, 0, 0);
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:self.menuView.layer.transform];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:transform];
        scaleAnimation.duration = self.animationDuration;
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[opacityAnimation, scaleAnimation];
        animationGroup.duration = self.animationDuration;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.menuView.layer addAnimation:animationGroup forKey:nil];
        
        self.blurView.layer.opacity = 0;
        self.menuView.layer.transform = transform;
        [self performSelector:@selector(cleanupGridMenu) withObject:nil afterDelay:self.animationDuration];
    } else {
        _popViewController.view.hidden = YES;
        [self cleanupGridMenu];
    }
    
    if (_finishViewController) {
        [self popViewController:_finishViewController fromViewController:_baseViewController finishViewController:nil];
    }
}

- (void)cleanupGridMenu {
    [self rn_removeFromParentViewControllerCallingAppearanceMethods:YES];
}

#pragma mark - Private

- (void)rn_addToParentViewController:(UIViewController *)parentViewController callingAppearanceMethods:(BOOL)callAppearanceMethods {
    if (self.parentViewController != nil) {
        [self rn_removeFromParentViewControllerCallingAppearanceMethods:callAppearanceMethods];
    }
    
    if (callAppearanceMethods)
        [self beginAppearanceTransition:YES animated:YES];
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:self];
    if (callAppearanceMethods)
        [self endAppearanceTransition];
    
    if ([parentViewController.view respondsToSelector:@selector(setScrollEnabled:)] && [(UIScrollView *)parentViewController.view isScrollEnabled])
    {
        self.parentViewCouldScroll = YES;
        [(UIScrollView *)parentViewController.view setScrollEnabled:NO];
    }
}

- (void)rn_removeFromParentViewControllerCallingAppearanceMethods:(BOOL)callAppearanceMethods {
    if (self.parentViewCouldScroll) {
        [(UIScrollView *)self.parentViewController.view setScrollEnabled:YES];
        self.parentViewCouldScroll = NO;
    }
    
    if (callAppearanceMethods)
        [self beginAppearanceTransition:NO animated:NO];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (callAppearanceMethods)
        [self endAppearanceTransition];
    
    [self.menuView removeFromSuperview];
}

- (CGRect)menuFrameWithWidth:(CGFloat)width height:(CGFloat)height center:(CGPoint)center headerOffset:(CGFloat)headerOffset {
    height += headerOffset;
    
    CGRect frame = CGRectMake(center.x - width/2.f, center.y - height/2.f, width, height);
    
    CGFloat offsetX = 0.f;
    CGFloat offsetY = 0.f;
    
    // make sure frame doesn't exceed views bounds
    {
        CGFloat tempOffset = CGRectGetMinX(frame) - CGRectGetMinX(self.view.bounds);
        if (tempOffset < 0.f) {
            offsetX = -tempOffset;
        } else {
            tempOffset = CGRectGetMaxX(frame) - CGRectGetMaxX(self.view.bounds);
            if (tempOffset > 0.f) {
                offsetX = -tempOffset;
            }
        }
        
        tempOffset = CGRectGetMinY(frame) - CGRectGetMinY(self.view.bounds);
        if (tempOffset < 0.f) {
            offsetY = -tempOffset;
        } else {
            tempOffset = CGRectGetMaxY(frame) - CGRectGetMaxY(self.view.bounds);
            if (tempOffset > 0.f) {
                offsetY = -tempOffset;
            }
        }
        
        frame = CGRectOffset(frame, offsetX, offsetY);
    }
    
    return CGRectIntegral(frame);
}

@end
