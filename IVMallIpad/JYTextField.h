//
//  JYUITextField.h
//  IVMallHD
//
//  Created by SMiT on 14-8-1.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYTextField : UITextField
{
	CGFloat _cornerRadio;
	UIColor *_borderColor;
	CGFloat _borderWidth;
	UIColor *_lightColor;
	CGFloat _lightSize;
	UIColor *_lightBorderColor;
}
//- (id)initWithFrame:(CGRect)frame
//		cornerRadio:(CGFloat)radio
//		borderColor:(UIColor*)bColor
//		borderWidth:(CGFloat)bWidth
//		 lightColor:(UIColor*)lColor
//		  lightSize:(CGFloat)lSize
//   lightBorderColor:(UIColor*)lbColor;
//-(void)beginEditing;
//-(void)endEditing;
//
//-(void)showWithError:(NSString*)error;
////add by monster
//-(NSString *)getCardNum;
@end
