//
//  NotWiFiView.m
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "NotWiFiView.h"
#import "Macro.h"
@implementation NotWiFiView
{
    UIImageView*    myImageView;
    UILabel*        myLabel;
    UIButton*       myButton;
    float           height;
    float           width;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        myImageView = [[UIImageView alloc]init];
        myImageView.image = [UIImage imageNamed:@"icon_144.png"];
        [self addSubview:myImageView];
        
        myLabel = [[UILabel alloc]init];
        myLabel.text = @"糟糕！连不上网络";
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:myLabel];
        
        myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.backgroundColor = [Commonality colorFromHexRGB:@"b0c86e"];
        [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:myButton];
        [myButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
//        [myButton setBackgroundImage:[UIImage imageNamed:@"button_shuaxin.png"] forState:UIControlStateNormal];
//        [myButton setBackgroundImage:[UIImage imageNamed:@"button_shuaxin2.png"] forState:UIControlStateHighlighted];
    }
    return self;
}

-(void)setNotWiFiStyle:(NotWiFiStyle)style
{
    
    if (style == MainViewNotWiFi) {
        if (iPad) {
            self.frame = CGRectMake(0, 100, VIEWHEIGHT, VIEWWIDTH-100);
        }else{
            self.frame = CGRectMake(0, 50, VIEWHEIGHT, VIEWWIDTH-50);
        }
        self.backgroundColor = [UIColor clearColor];
        height = self.frame.size.height;
        width = self.frame.size.width;
        
        if (iPad) {
            myImageView.frame = CGRectMake((width-168)/2, (height-250)/2, 168, 124);
            myLabel.frame = CGRectMake((width-200)/2, (height-250)/2+147, 200, 30);
            myButton.frame = CGRectMake((width-130)/2, (height-250)/2+205, 130, 32);
        }else{
            myImageView.frame = CGRectMake((width-84)/2, (height-150)/2, 84, 62);
            myLabel.frame = CGRectMake((width-200)/2, (height-150)/2+73, 200, 20);
            myButton.frame = CGRectMake((width-120)/2, (height-150)/2+110, 120, 20);
            myButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        }
        
        myLabel.textColor = [UIColor whiteColor];
        [myButton setTitle:@"点击屏幕刷新" forState:UIControlStateNormal];
        myButton.layer.cornerRadius =  (iPad?16:10);
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refresh:)];
        [self addGestureRecognizer:tapGesture];
        return;
        
    }else if(style == DialogNotWiFi)
    {
        if (iPad) {
            self.frame = CGRectMake(0, 0, 756, 560);
        }else{
            self.frame = CGRectMake(0, 0, 390, 260);
        }
        self.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
        height = self.frame.size.height;
        width = self.frame.size.width;
        
        if (iPad) {
            myImageView.frame = CGRectMake((width-168)/2, (height-250)/2, 168, 124);
            myLabel.frame = CGRectMake((width-200)/2, (height-250)/2+147, 200, 30);
            myButton.frame = CGRectMake((width-130)/2, (height-250)/2+205, 130, 32);
        }else{
            myImageView.frame = CGRectMake((width-84)/2, (height-150)/2, 84, 62);
            myLabel.frame = CGRectMake((width-200)/2, (height-150)/2+73, 200, 20);
            myButton.frame = CGRectMake((width-80)/2, (height-150)/2+100, 80, 20);
        }
        
        myLabel.textColor = [UIColor blackColor];
        [myButton setTitle:@"重试" forState:UIControlStateNormal];
        myButton.layer.cornerRadius =  (iPad?16:10);
        return;
        
    }else if(style == Dialog1NotWiFi)
    {
        if (iPad) {
            self.frame = CGRectMake(0, 71, 756, 477);
        }else{
            self.frame = CGRectMake(0, 35, 385, 225);
        }
        self.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
        height = self.frame.size.height;
        width = self.frame.size.width;
        
        if (iPad) {
            myImageView.frame = CGRectMake((width-168)/2, (height-250)/2, 168, 124);
            myLabel.frame = CGRectMake((width-200)/2, (height-250)/2+147, 200, 30);
            myButton.frame = CGRectMake((width-130)/2, (height-250)/2+205, 130, 32);
        }else{
            myImageView.frame = CGRectMake((width-84)/2, (height-150)/2, 84, 62);
            myLabel.frame = CGRectMake((width-200)/2, (height-150)/2+73, 200, 20);
            myButton.frame = CGRectMake((width-80)/2, (height-150)/2+100, 80, 20);
        }
        
        myLabel.textColor = [UIColor blackColor];
        [myButton setTitle:@"重试" forState:UIControlStateNormal];
        myButton.layer.cornerRadius =  (iPad?16:10);
        return;
        
    }else if (style == AreaNotWiFi){
        if (iPad) {
            self.frame = CGRectMake(0, 0, 760, 300);
        }else{
            self.frame = CGRectMake(0, 0, 390, 110);
        }
        self.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
        height = self.frame.size.height;
        width = self.frame.size.width;
        [myImageView setHidden:YES];
        if (iPad) {
            myLabel.frame = CGRectMake((width-200)/2, (height-300)/2+50, 200, 30);
            myButton.frame = CGRectMake((width-130)/2, (height-300)/2+108, 130, 32);
        }else{

            myLabel.frame = CGRectMake((width-200)/2, (height-110)/2+31, 200, 20);
            myButton.frame = CGRectMake((width-80)/2, (height-110)/2+58, 80, 20);
        }
        
        myLabel.textColor = [UIColor blackColor];
        [myButton setTitle:@"重试" forState:UIControlStateNormal];
        myButton.layer.cornerRadius =  (iPad?16:10);
        return;

    }else if (style == AreaUserInfoWithoutWifi){
        
        if (iPad) {
            self.frame = CGRectMake(0, 0, 558, 548);
        }else{
            self.frame = CGRectMake(0, 0, 289, 260);
        }
        self.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
        height = self.frame.size.height;
        width = self.frame.size.width;
        
        if (iPad) {
            myImageView.frame = CGRectMake((width-168)/2, (height-250)/2, 168, 124);
            myLabel.frame = CGRectMake((width-200)/2, (height-250)/2+147, 200, 30);
            myButton.frame = CGRectMake((width-130)/2, (height-250)/2+205, 130, 32);
        }else{
            myImageView.frame = CGRectMake((width-84)/2, (height-150)/2, 84, 62);
            myLabel.frame = CGRectMake((width-200)/2, (height-150)/2+73, 200, 20);
            myButton.frame = CGRectMake((width-80)/2, (height-150)/2+100, 80, 20);
        }
        
        myLabel.textColor = [UIColor whiteColor];
        [myButton setTitle:@"重试" forState:UIControlStateNormal];
        myButton.layer.cornerRadius =  (iPad?16:10);
        
        return;
    }else if (style == Area2NotWiFi){
        if (iPad) {
            self.frame = CGRectMake(0, 340, 760, 208);
        }else{
            self.frame = CGRectMake(0, 170, 385, 110);
        }
        self.backgroundColor = [Commonality colorFromHexRGB:@"eeeeee"];
        height = self.frame.size.height;
        width = self.frame.size.width;
        [myImageView setHidden:YES];
        if (iPad) {
            myLabel.frame = CGRectMake((width-200)/2, (height-208)/2+30, 200, 30);
            myButton.frame = CGRectMake((width-130)/2, (height-208)/2+88, 130, 32);
        }else{
            
            myLabel.frame = CGRectMake((width-200)/2, (height-110)/2+31, 200, 20);
            myButton.frame = CGRectMake((width-80)/2, (height-110)/2+58, 80, 20);
        }
        
        myLabel.textColor = [UIColor blackColor];
        [myButton setTitle:@"重试" forState:UIControlStateNormal];
        myButton.layer.cornerRadius =  (iPad?16:10);
        return;
        
    }
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}
*/

-(void)refresh:(id)sender
{
    [[AppDelegate App]click];
    if (self && self.delegate) {
        [self setHidden:YES];
        [self.delegate refresh];
    }
}

@end
