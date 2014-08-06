//
//  BoxBlurImageViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "BoxBlurImageViewController.h"
#import "Macro.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

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
        CGContextRef context = CGBitmapContextCreate(nil, maskLayer.bounds.size.width, maskLayer.bounds.size.height, 8, 0, colorSpace, kCGBitmapAlphaInfoMask);
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
                                             kCGBitmapAlphaInfoMask);
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

#pragma mark - BoxBlurImageViewController

@interface BoxBlurImageViewController ()
{
    BOOL statusBarHidder;
}
@end

@implementation BoxBlurImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.blurLevel = 0.19;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return statusBarHidder;
}

- (void)hideStatubar
{
    if (IOS7)
    {
        statusBarHidder = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createScreenshotAndLayoutWithScreenshotCompletion];
    if (!iPad) {
        [self hideStatubar];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createScreenshotAndLayoutWithScreenshotCompletion
{
    if (self.blurLevel > 0.f) {
        self.view.alpha = 0.f;
        UIImage *screenshot = [self.parentViewController.view rn_screenshot];
        self.view.alpha = 1.f;
        UIImage *blur = [screenshot rn_boxblurImageWithBlur:self.blurLevel exclusionPath:nil];
        self.view.layer.contents = (id)blur.CGImage;
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L), ^{
//            UIImage *blur = [screenshot rn_boxblurImageWithBlur:self.blurLevel exclusionPath:self.blurExclusionPath];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                CATransition *transition = [CATransition animation];
//                
//                transition.duration = 0.1;
//                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                transition.type = kCATransitionFade;
//                
//                [self.view.layer addAnimation:transition forKey:nil];
//                self.view.layer.contents = (id)blur.CGImage;
//                
//                [self.view setNeedsLayout];
//                [self.view layoutIfNeeded];
//            });
//        });
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    }
    return NO;
}

//为了支持iOS6
-(BOOL)shouldAutorotate
{
    return YES;
}

//为了支持iOS6
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
