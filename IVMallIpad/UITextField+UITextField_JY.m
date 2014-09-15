//
//  UITextField+UITextField_JY.m
//  IVMallHD
//
//  Created by SMiT on 14-8-2.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UITextField+UITextField_JY.h"
#import "Macro.h"
@implementation UITextField (UITextField_JY)

- (id)setStyle
{
    if (iPad) {
        [self.layer setCornerRadius:10];
    }else{

        [self.layer setCornerRadius:5];
    }
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.alpha = 1;
    [self.layer setMasksToBounds:NO];
        
    
    
    UIView* errorView = [[UIView alloc]initWithFrame:CGRectMake(3, iPad?-49:-49*0.6, iPad?268:268*0.6, iPad?49:49*0.6)];
    [errorView setTag:100];
    errorView.backgroundColor = [UIColor clearColor];
    [self addSubview:errorView];
    
    UIImageView* imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iPad?268:268*0.6, iPad?49:49*0.6)];
    imageView1.image = [UIImage imageNamed:@"Bubble.png"];
    imageView1.alpha = 0.96;
    [errorView addSubview:imageView1];
    
    UILabel* errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(iPad?30:18, 0, iPad?238:238*0.6, iPad?39:39*0.6)];
    [errorLabel setTag:101];
    errorLabel.backgroundColor = [UIColor clearColor];
    errorLabel.textAlignment = NSTextAlignmentLeft;
    errorLabel.textColor = [UIColor blackColor];
    if (iPad) {
        errorLabel.font = [UIFont boldSystemFontOfSize:15];
    }else{
        errorLabel.font = [UIFont boldSystemFontOfSize:10];
    }
    
    
    [errorView addSubview:errorLabel];
    
    [errorView setHidden:YES];
    
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

-(void)beginEditing
{
    [self.layer setBorderColor:[Commonality colorFromHexRGB:@"ffd500"].CGColor];
    [self.layer setBorderWidth:3];
    UIView* errorView = [self viewWithTag:100];
    [errorView setHidden:YES];
}

-(void)showWithError:(NSString*)error
{
    [self.layer setBorderColor:[UIColor redColor].CGColor];
    [self.layer setBorderWidth:3];
    UIView* errorView = [self viewWithTag:100];
    [errorView setHidden:NO];
    UILabel* errorLabel = (UILabel*)[self viewWithTag:101];
    errorLabel.text = error;
}
-(void)endEditing
{
    [self.layer setBorderWidth:0];
	[self.layer setBorderColor:[UIColor whiteColor].CGColor];
    UIView* errorView = [self viewWithTag:100];
    [errorView setHidden:YES];
}


- (CGRect)textRectForBounds:(CGRect)bounds
{
	CGRect inset = CGRectMake(bounds.origin.x + (iPad?10:5)*2,
							  bounds.origin.y,
							  bounds.size.width - (iPad?10:5)*2,
							  bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	CGRect inset = CGRectMake(bounds.origin.x + (iPad?10:5)*2,
							  bounds.origin.y,
							  bounds.size.width - (iPad?10:5)*2,
							  bounds.size.height);
    return inset;
}

#pragma mark - extern fuction
-(NSString *)getCardNum
{
    NSString * str;
    if (self.text.length == 19 || self.text.length == 20 ) {
        str = [NSString stringWithFormat:@"%@%@%@%@",[self.text substringWithRange:NSMakeRange(0, 4)],[self.text substringWithRange:NSMakeRange(5, 4)],[self.text substringWithRange:NSMakeRange(10, 4)],[self.text substringWithRange:NSMakeRange(15, 4)]];
    }
    else if (self.text.length == 24)
    {
        str = [NSString stringWithFormat:@"%@%@%@%@%@",[self.text substringWithRange:NSMakeRange(0, 4)],[self.text substringWithRange:NSMakeRange(5, 4)],[self.text substringWithRange:NSMakeRange(10, 4)],[self.text substringWithRange:NSMakeRange(15, 4)],[self.text substringWithRange:NSMakeRange(20, 4)]];
    }
    else
    {
        return self.text;
    }
    return str;
}
@end
