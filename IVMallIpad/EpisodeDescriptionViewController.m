//
//  EpisodeDescriptionViewController.m
//  IVMallHD
//
//  Created by SMiT on 14-7-24.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "EpisodeDescriptionViewController.h"
#import "Macro.h"

@interface EpisodeDescriptionViewController ()

@end

@implementation EpisodeDescriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _label.text = _episodeTitle;
    _textView.text = _episodeDescription;
    _textView.font = [UIFont systemFontOfSize:(iPad?18:12)];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!iPad) {
        _closeBtn.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
    if ([self.navigationController childViewControllers].count >2) {
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_07-18.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_07-19.png"] forState:UIControlStateHighlighted];
    }else{
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close_sel.png"] forState:UIControlStateHighlighted];
    }
}

- (void)closeButtonTouch:(id)sender
{
        [[AppDelegate App]click];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
