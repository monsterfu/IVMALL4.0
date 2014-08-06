//
//  Toast+UIView.m
//  Toast
//  Version 2.0
//
//  Copyright 2013 Charles Scalesse.
//

#import "Toast+UIView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "Macro.h"
#import "AppDelegate.h"
/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat CSToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat CSToastHorizontalPadding   = 10.0;
static const CGFloat CSToastVerticalPadding     = 10.0;
static const CGFloat CSToastCornerRadius        = 3.0;
static const CGFloat CSToastOpacity             = 0.8;
static const CGFloat CSToastFontSize            = 16.0;
static const CGFloat CSToastMaxTitleLines       = 0;
static const CGFloat CSToastMaxMessageLines     = 0;
static const CGFloat CSToastFadeDuration        = 0.2;

// shadow appearance
static const CGFloat CSToastShadowOpacity       = 0.8;
static const CGFloat CSToastShadowRadius        = 6.0;
static const CGSize  CSToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    CSToastDisplayShadow       = YES;

// display duration and position
static const CGFloat CSToastDefaultDuration     = 3.0;
static const NSString * CSToastDefaultPosition  = @"bottom";

// image view size
static const CGFloat CSToastImageViewWidth      = 80.0;
static const CGFloat CSToastImageViewHeight     = 80.0;

// activity
static const CGFloat CSToastActivityWidth       = 100.0;
static const CGFloat CSToastActivityHeight      = 100.0;
static const NSString * CSToastActivityDefaultPosition = @"center";
static const NSString * CSToastActivityViewKey  = @"CSToastActivityViewKey";


@interface UIView (ToastPrivate)

- (CGPoint)centerPointForPosition:(id)position withToast:(UIView *)toast;
- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;

@end


@implementation UIView (Toast)

#pragma mark - Toast Methods

- (void)makeToast:(NSString *)message {
    [self makeToast:message duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position {
//    UIView *toast = [self viewForMessage:message title:nil image:nil];
    UILabel* toast = [[UILabel alloc]init];

    toast.backgroundColor = [Commonality colorFromHexRGB:@"592b1b"];
    toast.text = message;
    toast.numberOfLines = 0;
    toast.textAlignment = NSTextAlignmentCenter;
    toast.textColor = [UIColor whiteColor];
    toast.font = [UIFont boldSystemFontOfSize:(iPad?20:14)];
    toast.layer.cornerRadius = (iPad?20:14);

    CGSize size = [toast.text sizeWithFont:toast.font constrainedToSize:CGSizeMake(toast.frame.size.width ,MAXFLOAT)];
    
    toast.frame = CGRectMake(0, 0, size.width+(iPad?60:15), iPad?57:39);
    toast.center = self.center;
    toast.alpha = 0.0;
    [self addSubview:toast];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:CSToastFadeDuration
                                               delay:interval
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                          } completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
                                          }];
                     }];
//    UIAlertView *alvIew = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alvIew show];
    
    
//    if ([AppDelegate App].statcAlertView) {
//        [[AppDelegate App].statcAlertView setMessage:message];
//        if ([AppDelegate App].statcAlertView.isVisible == NO) {
//            [[AppDelegate App].statcAlertView show];
//        }
//        
//    }
//    else
//    {
//        [AppDelegate App].statcAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [[AppDelegate App].statcAlertView show];
//    }

}


- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title {
    UIView *toast = [self viewForMessage:message title:title image:nil];
    [self showToast:toast duration:interval position:position];  
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:nil image:image];
    [self showToast:toast duration:interval position:position];  
}

- (void)makeToast:(NSString *)message duration:(CGFloat)interval  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:title image:image];
    [self showToast:toast duration:interval position:position];  
}

- (void)showToast:(UIView *)toast {
    [self showToast:toast duration:CSToastDefaultDuration position:CSToastDefaultPosition];
}

- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point {
    
    
    toast.center = [self centerPointForPosition:point withToast:toast];
    toast.alpha = 0.0;
    [self addSubview:toast];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toast.alpha = 1.0;
                         toast.frame = CGRectMake(70, toast.frame.origin.y + 10, toast.frame.size.width-30, toast.frame.size.height);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:CSToastFadeDuration
                                               delay:interval
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toast.alpha = 0.0;
                                              toast.frame = CGRectMake(70, toast.frame.origin.y - 10, toast.frame.size.width-30, toast.frame.size.height);
                                          } completion:^(BOOL finished) {
                                              [toast removeFromSuperview];
                                          }];
                     }];
}

#pragma mark - Toast Activity Methods

- (void)makeToastActivity {
    [self makeToastActivity:CSToastActivityDefaultPosition];
}

- (void)makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CSToastActivityWidth, CSToastActivityHeight)] autorelease];
    activityView.center = [self centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = CSToastShadowOpacity;
        activityView.layer.shadowRadius = CSToastShadowRadius;
        activityView.layer.shadowOffset = CSToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate ourselves with the activity view
    objc_setAssociatedObject (self, &CSToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:CSToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &CSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Private Methods

- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        // convert string literals @"top", @"bottom", @"center", or any point wrapped in an NSValue object into a CGPoint
        if([point caseInsensitiveCompare:@"top"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - CSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:@"center"] == NSOrderedSame) {
//            if (iPhone5) {
//                return CGPointMake(self.bounds.size.width / 2, 60);
//            }
//            else
//            {
//                return CGPointMake(self.bounds.size.width / 2, 60);
//            }

            return CGPointMake(self.bounds.size.width, self.bounds.size.height/5);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    NSLog(@"Warning: Invalid position for toast.");
    return [self centerPointForPosition:CSToastDefaultPosition withToast:toast];
}

- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;

    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[[UIView alloc] init] autorelease];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    
    if (CSToastDisplayShadow) {
//        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
//        wrapperView.layer.shadowOpacity = CSToastShadowOpacity;
//        wrapperView.layer.shadowRadius = CSToastShadowRadius;
//        wrapperView.layer.shadowOffset = CSToastShadowOffset;
    }

    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:CSToastOpacity];
//    wrapperView.backgroundColor = [[IVMallTools colorFromHexRGB:BTN_HIGHLIGHTGREY_COLOR] colorWithAlphaComponent:CSToastOpacity];
    
    if(image != nil) {
        imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding, CSToastImageViewWidth, CSToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[[UILabel alloc] init] autorelease];
        titleLabel.numberOfLines = CSToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:CSToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth, self.bounds.size.height * CSToastMaxHeight);
        CGSize expectedSizeTitle =[title boundingRectWithSize:maxSizeTitle options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObject:titleLabel.font forKey:NSFontAttributeName] context:nil].size;
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[[UILabel alloc] init] autorelease];
        messageLabel.numberOfLines = CSToastMaxMessageLines;
        messageLabel.font = [UIFont boldSystemFontOfSize:CSToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * CSToastMaxWidth) - imageWidth, self.bounds.size.height * CSToastMaxHeight);
//        CGSize expectedSizeMessage = [message boundingRectWithSize:maxSizeMessage options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObject:messageLabel.font forKey:NSFontAttributeName] context:nil].size;
        CGSize expectedSizeMessage = [message sizeWithFont:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
//        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
        messageLabel.frame = CGRectMake(12, 0.0, 296, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = CSToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;

    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
        messageTop = titleTop + titleHeight + CSToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    

//    CGFloat longerWidth = MAX(titleWidth, messageWidth);
//    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
//    CGFloat wrapperWidth = MAX((imageWidth + (CSToastHorizontalPadding * 2)), (longerLeft + longerWidth + CSToastHorizontalPadding));    
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSToastVerticalPadding), (imageHeight + (CSToastVerticalPadding * 2)));
                         
//    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    wrapperView.frame = CGRectMake(12, 0.0, 296, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
        
    return wrapperView;
}

@end
