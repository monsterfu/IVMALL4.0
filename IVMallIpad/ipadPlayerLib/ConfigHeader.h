//  configHeader.h
//  player4IVMall
//
//  Created by SmitJh on 14-7-4.
//  Copyright (c) 2014年 JH. All rights reserved.
//

#import "Macro.h"

#define IVMALLPLAYERVERSION @"2.0.1"

//#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define isPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define LDSCREEN_STATUSBAR_HEIGHT  ([UIApplication sharedApplication].statusBarFrame.size.width)
//#define NAVIGATIONBAR_HEIGHT (44)
//Top View
#define TOPVIEW_HEIGHT (iPad ? 83 : 50)
//Bottom View
#define BOTTOMVIEW_HEIGHT (iPad ? 100 : 50)

#define BTNRATIO (iPad ? 1.0 : 0.6)
#define BTNFRAME_LENGTH 55*BTNRATIO
#define BTN_SIDEGAP 20
#define BTN_TOPGAP 15

#define DEVICELIST_TABLEWIDTH 160*BTNRATIO
#define DEVICELIST_TABLEHEIGHT 240*BTNRATIO
#define DEVICELIST_CELLHEIGHT 60*BTNRATIO

//字体font
//#define FONT_1 34
//#define FONT_2 17
//#define FONT_3 16
//#define FONT_4 14
//#define FONT_5 13
//#define FONT_6 12
//#define FONT_7 10.5
//#define FONT_8 8
#define FONT_9 7