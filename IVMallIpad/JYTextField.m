//
//  JYUITextField.m
//  IVMallHD
//
//  Created by SMiT on 14-8-1.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "JYTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "Macro.h"
#import "Commonality.h"
#import "SKInnerShadowLayer.h"

@implementation JYTextField
{
    UIView* errorView;
    UILabel* errorLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//
//- (id)initWithFrame:(CGRect)frame
//		cornerRadio:(CGFloat)radio
//		borderColor:(UIColor*)bColor
//		borderWidth:(CGFloat)bWidth
//		 lightColor:(UIColor*)lColor
//		  lightSize:(CGFloat)lSize
//   lightBorderColor:(UIColor*)lbColor
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _borderColor = bColor;
//		_cornerRadio = radio;
//		_borderWidth = bWidth;
//		_lightColor = lColor;
//		_lightSize = lSize;
//		_lightBorderColor = lbColor;
//        
//        if (iPad) {
//            _cornerRadio = 10;
//            [self.layer setCornerRadius:10];
//        }else{
//            _cornerRadio = 5;
//            [self.layer setCornerRadius:5];
//        }
//		[self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//		[self setBackgroundColor:[UIColor whiteColor]];
//        self.alpha = 1;
//		[self.layer setMasksToBounds:NO];
//        
//    }
//    
//    errorView = [[UIView alloc]initWithFrame:CGRectMake(3, -49, 268, 49)];
//    errorView.backgroundColor = [UIColor clearColor];
//    [self addSubview:errorView];
//    
//    UIImageView* imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 268, 49)];
//    imageView1.image = [UIImage imageNamed:@"Bubble.png"];
//    imageView1.alpha = 0.96;
//    [errorView addSubview:imageView1];
//    
//    errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 238, 39)];
//    errorLabel.backgroundColor = [UIColor clearColor];
//    errorLabel.textAlignment = NSTextAlignmentLeft;
//    errorLabel.textColor = [UIColor blackColor];
//    errorLabel.font = [UIFont boldSystemFontOfSize:15];
//    [errorView addSubview:errorLabel];
//    
//    [errorView setHidden:YES];
//    
//    return self;
//}
//
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    if (menuController) {
//        [UIMenuController sharedMenuController].menuVisible = NO;
//    }
//    return NO;
//}
//
//-(void)beginEditing
//{
//    [self.layer setBorderColor:_lightColor.CGColor];
//    [self.layer setBorderWidth:3];
//    [errorView setHidden:YES];
//}
//
//-(void)showWithError:(NSString*)error
//{
//    [self.layer setBorderColor:[UIColor redColor].CGColor];
//    [self.layer setBorderWidth:3];
//    [errorView setHidden:NO];
//    errorLabel.text = error;
//}
//-(void)endEditing
//{
//    [self.layer setBorderWidth:0];
//	[self.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [errorView setHidden:YES];
//}
//
//
//- (CGRect)textRectForBounds:(CGRect)bounds
//{
//	CGRect inset = CGRectMake(bounds.origin.x + _cornerRadio*2,
//							  bounds.origin.y,
//							  bounds.size.width - _cornerRadio*2,
//							  bounds.size.height);
//    return inset;
//}
//
//- (CGRect)editingRectForBounds:(CGRect)bounds
//{
//	CGRect inset = CGRectMake(bounds.origin.x + _cornerRadio*2,
//							  bounds.origin.y,
//							  bounds.size.width - _cornerRadio*2,
//							  bounds.size.height);
//    return inset;
//}
//
//#pragma mark - extern fuction
//-(NSString *)getCardNum
//{
//    NSString * str;
//    if (self.text.length == 19 || self.text.length == 20 ) {
//        str = [NSString stringWithFormat:@"%@%@%@%@",[self.text substringWithRange:NSMakeRange(0, 4)],[self.text substringWithRange:NSMakeRange(5, 4)],[self.text substringWithRange:NSMakeRange(10, 4)],[self.text substringWithRange:NSMakeRange(15, 4)]];
//    }
//    else if (self.text.length == 24)
//    {
//        str = [NSString stringWithFormat:@"%@%@%@%@%@",[self.text substringWithRange:NSMakeRange(0, 4)],[self.text substringWithRange:NSMakeRange(5, 4)],[self.text substringWithRange:NSMakeRange(10, 4)],[self.text substringWithRange:NSMakeRange(15, 4)],[self.text substringWithRange:NSMakeRange(20, 4)]];
//    }
//    else
//    {
//        return self.text;
//    }
//    return str;
//}
//
//
@end
