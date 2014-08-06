//
//  UserInformationViewController.m
//  IVMallHD
//
//  Created by Monster on 14-7-9.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "UserInformationViewController.h"

@interface UserInformationViewController ()

@end

@implementation UserInformationViewController

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
    
    _iconArray = @[@"icon_06.png",@"icon_06-06.png",@"icon_06-10.png",@"icon_06-14.png",@"icon_06-20.png"];
    _titleArray = @[@"昵称",@"邮箱",@"性别",@"生日",@"地址"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonTouch:(UIButton *)sender {
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_iconArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
