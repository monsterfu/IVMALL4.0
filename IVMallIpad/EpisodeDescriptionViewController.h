//
//  EpisodeDescriptionViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-24.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxBlurImageViewController.h"
@interface EpisodeDescriptionViewController : BoxBlurImageViewController
@property (nonatomic,strong)NSString* episodeDescription;
@property (nonatomic,strong)NSString* episodeTitle;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic,strong)IBOutlet UILabel* label;
@property (nonatomic,strong)IBOutlet UITextView* textView;
-(IBAction)closeButtonTouch:(id)sender;
@end
