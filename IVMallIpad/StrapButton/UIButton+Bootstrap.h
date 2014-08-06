//
//  UIButton+Bootstrap.h
//  UIButton+Bootstrap
//
//  Created by Oskar Groth on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
@interface UIButton (Bootstrap)
- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before;
-(void)bootstrapStyle;
-(void)whiteStyle;
-(void)blueStyle;
-(void)greenStyle;
-(void)lightBlueStyle;
-(void)orgineStyle;
-(void)redStyle;
-(void)greyStyle;
-(void)blackToRedStyle;
-(void)pinkStyle;
-(void)vipStyle;
-(void)custemStyle:(UIColor*)color;
-(void)custemGreenBtnStyle:(UIColor *)color;
-(void)custemRedBtnStyle:(UIColor *)color;
-(void)custemGreyBtnStyle:(UIColor *)color;
-(void)custemBlackToRedBtnStyle:(UIColor *)color;
-(void)custemBlueBtnStyle:(UIColor *)color;
-(void)childrenBtnStyleForBtn:(UIButton *)button;
-(void)childrenCircleBtnStyle;
@end
