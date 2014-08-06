//
//  UserInformationViewController.h
//  IVMallHD
//
//  Created by Monster on 14-7-9.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInformationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* _iconArray;
    NSArray* _titleArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;







@property (strong, nonatomic) IBOutlet UITableViewCell *customerCell;

- (IBAction)saveButtonTouch:(UIButton *)sender;
@end
