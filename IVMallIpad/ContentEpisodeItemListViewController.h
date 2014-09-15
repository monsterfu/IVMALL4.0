//
//  ContentEpisodeItemListViewController.h
//  IVMallHD
//
//  Created by SMiT on 14-7-8.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxBlurImageViewController.h"
#import "NotWiFiView.h"
#import "IVMallPlayer.h"
@interface ContentEpisodeItemListViewController : BoxBlurImageViewController<MainViewRefershDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PlayerCallBackDelegate>
//zjj
@property (strong,nonatomic) NSString* episodeGuid;
@property (strong,nonatomic) NSString* langs;
@property (strong,nonatomic) NSString* latestPlayLang;

//zjj
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@property (strong, nonatomic) IBOutlet UIView *upView;
@property (strong, nonatomic) IBOutlet UIView *downView;

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray* expandViews;

//头像相关的三层VIEW   底图 1 绿色   2 白色  3 头像  4 集数 在这里引入为了转圆角

@property (strong, nonatomic) IBOutlet UIView *headBgView;

@property (strong, nonatomic) IBOutlet UIImageView *headImage;
//@property (strong, nonatomic) IBOutlet UILabel *totalLabel;

//剧集按钮
@property (strong, nonatomic) IBOutlet UIButton* langButton1;
@property (strong, nonatomic) IBOutlet UIButton* langButton2;
@property (strong, nonatomic) IBOutlet UIImageView* cloudImageView;

//播放次数 收藏次数
@property (strong, nonatomic) IBOutlet UILabel *playCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *collectionCountLabel;

//播放按钮 收藏按钮
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *collectionButton;
@property (strong, nonatomic) IBOutlet UIImageView* tipsView;
@property (strong, nonatomic) IBOutlet UILabel* tipsLabel;
- (IBAction)playButtonTouch:(UIButton *)sender;
- (IBAction)collectionButtonTouch:(UIButton *)sender;
- (IBAction)moreButtonTouch:(UIButton *)sender;
- (IBAction)closeButtonTouch:(UIButton *)sender;

//剧集内容

//@property (strong, nonatomic) IBOutlet UISegmentedControl* eposideSegmentedControler;
@property (strong, nonatomic) IBOutlet UIScrollView* eposideScrollerView;
@property (strong, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@property (strong, nonatomic) IBOutlet UIImageView* TVBackgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton* exitButton;

@end
