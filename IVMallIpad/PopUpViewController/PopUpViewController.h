//
//  PopUpViewController.h
//  IVMallHD
//
//  Created by Monster on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface PopUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) UIViewController* baseViewController;//基础viewController
@property (nonatomic, strong) UIViewController* popViewController; //弹出的viewController
@property (nonatomic, strong) UIViewController* finishViewController;//弹出动作完成后弹出的viewController

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, readonly) UIView *menuView;
@property (nonatomic, strong) UIBezierPath *backgroundPath;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat blurLevel;
@property (nonatomic, strong) UIBezierPath *blurExclusionPath;
@property (nonatomic, assign) CGFloat animationDuration;

// An optional block that gets executed before the PopUpViewController gets dismissed
@property (nonatomic, copy) dispatch_block_t dismissAction;

// Determine whether or not to bounce in the animation
// default YES
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) BOOL  blur;//是否背景模糊
// Show the popup
- (void)popViewController:(UIViewController *)popViewController fromViewController:(UIViewController *)baseViewController finishViewController:(UIViewController*)finishViewController blur:(BOOL)blur;

// Dismiss the menu
// This is called when the window is tapped. If tapped inside the view an item will be selected.
// If tapped outside the view, the menu is simply dismissed.
- (void)dismissAnimated:(BOOL)animated;

+ (instancetype)shareInstance;
@end
