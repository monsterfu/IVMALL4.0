//
//  UIButton+Bootstrap.m
//  UIButton+Bootstrap
//
//  Created by Oskur on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//
#import "UIButton+Bootstrap.h"
#import <QuartzCore/QuartzCore.h>
#import "Commonality.h"
#import "Macro.h"
@implementation UIButton (Bootstrap)

-(void)childrenCircleBtnStyle
{
    self.layer.cornerRadius = 20;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [color_18 CGColor];
    //阴影
    //    self.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    //    self.layer.shadowOffset = CGSizeMake(0, 2.0f); //[水平偏移, 垂直偏移]
    //    self.layer.shadowOpacity = 10.0f; // 0.0 ~ 1.0 的值
    //    self.layer.shadowRadius = 1.0f; // 阴影发散的程度
    
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height );
    newShadow.colors = [NSArray arrayWithObjects:(id)[[[UIColor blackColor] colorWithAlphaComponent:0] CGColor],(id)[[[UIColor blackColor] colorWithAlphaComponent:0] CGColor],(id)[[[UIColor blackColor] colorWithAlphaComponent:0.20] CGColor],(id)[[[UIColor blackColor] colorWithAlphaComponent:0.15] CGColor],nil];
    newShadow.cornerRadius = 20;
    [self.layer addSublayer:newShadow];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithWhite:150 alpha:0.2]] forState:UIControlStateHighlighted];
    [self setAdjustsImageWhenHighlighted:YES];
    self.layer.masksToBounds = YES;
}

-(void)childrenBtnStyleForBtn:(UIButton *)button
{
    self.layer.cornerRadius = button.frame.size.height/2;
    self.layer.borderWidth = 3;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    //阴影
//    self.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
//    self.layer.shadowOffset = CGSizeMake(0, 2.0f); //[水平偏移, 垂直偏移]
//    self.layer.shadowOpacity = 10.0f; // 0.0 ~ 1.0 的值
//    self.layer.shadowRadius = 1.0f; // 阴影发散的程度
    
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height );
    newShadow.colors = [NSArray arrayWithObjects:(id)[[[UIColor blackColor] colorWithAlphaComponent:0] CGColor],(id)[[[UIColor blackColor] colorWithAlphaComponent:0] CGColor],(id)[[[UIColor blackColor] colorWithAlphaComponent:0.15] CGColor],(id)[[[UIColor blackColor] colorWithAlphaComponent:0.25] CGColor],nil];
    newShadow.cornerRadius = button.frame.size.height/2;
    [self.layer addSublayer:newShadow];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithWhite:150 alpha:0.2]] forState:UIControlStateHighlighted];
    [self setAdjustsImageWhenHighlighted:YES];
    self.layer.masksToBounds = YES;
    
}

-(void)bootstrapStyle{
    self.layer.borderWidth = 3.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.cornerRadius = 20.5;
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:color_14 forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:self.titleLabel.font.pointSize]];
    
    
//    self.layer.shadowColor = [UIColor yellowColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, -10);
//    self.layer.shadowRadius = 10;
//    self.layer.shadowOpacity = 0.5;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
}

-(void)whiteStyle{
    [self bootstrapStyle];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
//    self.layer.borderColor = [[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1] CGColor];
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [self.layer setBorderWidth:0];
}


-(void)custemBlueBtnStyle:(UIColor *)color
{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor clearColor];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

-(void)greenStyle{
    [self bootstrapStyle];
    self.backgroundColor=[UIColor greenColor];
}
-(void)greyStyle{
    [self bootstrapStyle];
    self.backgroundColor=[UIColor blackColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor darkGrayColor]] forState:UIControlStateHighlighted];
}

-(void)pinkStyle{
    [self bootstrapStyle];
}

-(void)blueStyle{
    [self bootstrapStyle];
    [self setBackgroundImage:[self buttonImageFromColor:[Commonality colorFromHexRGB:@"0a75cd"]] forState:UIControlStateNormal];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
}

-(void)custemStyle:(UIColor*)color{
    [self bootstrapStyle];
    self.backgroundColor = color;//[UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1];
    self.layer.borderColor = [color CGColor];//[[UIColor colorWithRed:70/255.0 green:184/255.0 blue:218/255.0 alpha:1] CGColor];
//    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:57/255.0 green:180/255.0 blue:211/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[self buttonImageFromColor:color] forState:UIControlStateHighlighted];
}
-(void)lightBlueStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:91/255.0 green:192/255.0 blue:222/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:70/255.0 green:184/255.0 blue:218/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:57/255.0 green:180/255.0 blue:211/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)orgineStyle{
    [self bootstrapStyle];
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:173/255.0 blue:78/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:238/255.0 green:162/255.0 blue:54/255.0 alpha:1] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:237/255.0 green:155/255.0 blue:67/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

-(void)redStyle{
    [self bootstrapStyle];
    
    self.layer.borderWidth = 0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor redColor].CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    self.backgroundColor=[Commonality colorFromHexRGB:@"ef3363"];
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor redColor]] forState:UIControlStateHighlighted];
}

-(void)vipStyle
{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    self.layer.cornerRadius = 11.0;
    self.backgroundColor=[Commonality colorFromHexRGB:@"f1c07b"];
    [self setBackgroundImage:[self buttonImageFromColor:[Commonality colorFromHexRGB:@"c09a62"]] forState:UIControlStateHighlighted];
}

-(void)blackToRedStyle
{
//    [self custemBlackToRedBtnStyle:[IVMallTools colorFromHexRGB:BTN_RED_COLOR]];
    [self.layer setBorderWidth:0];
}

-(void)custemBlackToRedBtnStyle:(UIColor *)color
{
    self.backgroundColor = [UIColor blackColor];
    [self setBackgroundImage:[self buttonImageFromColor:color] forState:UIControlStateHighlighted];
}


-(void)custemGreenBtnStyle:(UIColor *)color
{
    [self bootstrapStyle];
//    self.backgroundColor = [IVMallTools colorFromHexRGB:BTN_GREEN_COLOR];
//    self.layer.borderColor = [[IVMallTools colorFromHexRGB:BTN_GREEN_COLOR] CGColor];
    [self.layer setBorderWidth:0];
    [self setBackgroundImage:[self buttonImageFromColor:color] forState:UIControlStateHighlighted];
}

-(void)custemGreyBtnStyle:(UIColor *)color
{
    [self bootstrapStyle];
//    self.backgroundColor = [IVMallTools colorFromHexRGB:BTN_GREY_COLOR];
//    self.layer.borderColor = [[IVMallTools colorFromHexRGB:BTN_HIGHLIGHTGREY_COLOR] CGColor];
//    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:color] forState:UIControlStateHighlighted];
    [self.layer setBorderWidth:0];
}

-(void)custemRedBtnStyle:(UIColor *)color
{
    [self bootstrapStyle];
//    self.backgroundColor = [IVMallTools colorFromHexRGB:BTN_RED_COLOR];
//    self.layer.borderColor = [[IVMallTools colorFromHexRGB:BTN_RED_COLOR] CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:color] forState:UIControlStateHighlighted];
}

- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before
{
    NSString *iconString = [NSString stringFromAwesomeIcon:icon];
    self.titleLabel.font = [UIFont fontWithName:@"FontAwesome"
                                           size:self.titleLabel.font.pointSize];
    
    NSString *title = [NSString stringWithFormat:@"%@", iconString];
    
    if(self.titleLabel.text) {
        if(before)
            title = [title stringByAppendingFormat:@" %@", self.titleLabel.text];
        else
            title = [NSString stringWithFormat:@"%@  %@", self.titleLabel.text, iconString];
    }
    
    [self setTitle:title forState:UIControlStateNormal];
}

- (UIImage *) buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
