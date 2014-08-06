//
//  UITextField+UITextField_JY.h
//  IVMallHD
//
//  Created by SMiT on 14-8-2.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (UITextField_JY)
- (id)setStyle;

-(void)beginEditing;

-(void)showWithError:(NSString*)error;
-(void)endEditing;


-(NSString *)getCardNum;
@end
