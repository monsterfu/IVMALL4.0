//
//  RechargeViewController.m
//  IVMallHD
//
//  Created by Monster on 14-7-15.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "RechargeViewController.h"
#define POINTSMODEL_KEY  @"pointsmodel_key"


@interface RechargeViewController ()

@end

@implementation RechargeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //请求猫币充值个数详情
    [_mbOneButton setSelected:YES];
    [_mbTwoButton setSelected:NO];
    [_mbThreeButton setSelected:NO];
    _mbCustomTextField.text = @"";
    [HttpRequest AppPointsDelegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    // Do any additional setup after loading the view from its nib.
    
    [_mbOneButton setSelected:YES];
    
//    _mbCustomTextField = [_mbCustomTextField initWithFrame:_mbCustomTextField.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_mbCustomTextField setStyle];
    
//    _cardTextField = [_cardTextField initWithFrame:_cardTextField.frame cornerRadio:10.0 borderColor:[UIColor grayColor] borderWidth:0.0 lightColor:[Commonality colorFromHexRGB:@"ffd500"] lightSize:3.9f lightBorderColor:[UIColor greenColor]];
    [_cardTextField setStyle];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_baseView addGestureRecognizer:_tapGestureRecognizer];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_mbView addGestureRecognizer:_tapGestureRecognizer];
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_cardView addGestureRecognizer:_tapGestureRecognizer];
    
    _mbCustomTextField.delegate = self;
    _cardTextField.delegate = self;
    
    
    if (!iPad) {
        _backButton.frame = CGRectMake((iPhone5?89:46), 32, 30, 30);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tap
{
    [_mbCustomTextField resignFirstResponder];
    [_cardTextField resignFirstResponder];
}


- (IBAction)backButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(rechargeViewBack)]) {
        [self.delegate rechargeViewBack];
    }
}
- (IBAction)mbButtonTouch:(UIButton *)sender {
    if (_mbButton.isSelected) {
        return;
    }
    [[AppDelegate App]click];
    [_mbButton setSelected:YES];
    [_cardButton setSelected:NO];
    
    [_mbView setHidden:NO];
    [_cardView setHidden:YES];
    
}

- (IBAction)cardButtonTouch:(UIButton *)sender {
    if (_cardButton.isSelected) {
        return;
    }
    [[AppDelegate App]click];
    [_mbButton setSelected:NO];
    [_cardButton setSelected:YES];
    
    [_mbView setHidden:YES];
    [_cardView setHidden:NO];
}
- (IBAction)mbOneButtonTouch:(UIButton *)sender {
    [_mbOneButton setSelected:YES];
    [_mbTwoButton setSelected:NO];
    [_mbThreeButton setSelected:NO];
    [[AppDelegate App]click];
    _pointModel = [_pointsModel.list objectAtIndex:0];
    [_totalRechargeLabel setText:[NSString stringWithFormat:@"￥%.2f",_pointModel.points]];
    _mbCustomTextField.text = [NSString stringWithFormat:@"%.0f",_pointModel.points];
}

- (IBAction)mbTwoButtonTouch:(UIButton *)sender {
    [_mbOneButton setSelected:NO];
    [_mbTwoButton setSelected:YES];
    [_mbThreeButton setSelected:NO];
    [[AppDelegate App]click];
    _pointModel = [_pointsModel.list objectAtIndex:1];
    [_totalRechargeLabel setText:[NSString stringWithFormat:@"￥%.2f",_pointModel.points]];
    _mbCustomTextField.text = [NSString stringWithFormat:@"%.0f",_pointModel.points];
}

- (IBAction)mbThreeButtonTouch:(UIButton *)sender {
    [_mbOneButton setSelected:NO];
    [_mbTwoButton setSelected:NO];
    [_mbThreeButton setSelected:YES];
    [[AppDelegate App]click];
    _pointModel = [_pointsModel.list objectAtIndex:2];
    [_totalRechargeLabel setText:[NSString stringWithFormat:@"￥%.2f",_pointModel.points]];
    _mbCustomTextField.text = [NSString stringWithFormat:@"%.0f",_pointModel.points];
}
- (IBAction)confirmRecharge:(UIButton *)sender {
    NSString* valueStr = [_totalRechargeLabel.text substringFromIndex:1];
    [[AppDelegate App]click];
    AppPointModel* model = [[AppPointModel alloc]init];
    model.price = [valueStr doubleValue];
    model.points = [valueStr doubleValue];
    
    if (![valueStr floatValue]) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入有效金额" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(rechargeConfirm:)]) {
        [self.delegate rechargeConfirm:model];
    }
}
- (IBAction)cardConfirmButtonTouch:(UIButton *)sender {
    [[AppDelegate App]click];
    if ([Commonality isEmpty:_cardTextField.text]) {
        [Commonality showErrorMsg:self.view type:0 msg:@"点卡密码不能为空哦!"];
        return;
    }
//    [HttpRequest PayRequest:AppDelegate.App.myUserLoginMode.token points:[_cardTextField getCardNum] fee:@"" password:AppDelegate.App.myUserLoginMode.password delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
    [HttpRequest PayAddRequestToken:AppDelegate.App.myUserLoginMode.token voucherCode:[_cardTextField getCardNum] password:[USER_DEFAULT objectForKey:@"password"] delegate:self finishSel:@selector(GetResult:) failSel:@selector(GetErr:)];
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if ([textField isKindOfClass:[JYTextField class]]) {
//        [(JYTextField*)textField beginEditing];
//    }
    [textField beginEditing];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if ([textField isKindOfClass:[JYTextField class]]) {
//        [(JYTextField*)textField endEditing];
//    }
    [textField endEditing];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_mbOneButton setSelected:NO];
    [_mbTwoButton setSelected:NO];
    [_mbThreeButton setSelected:NO];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _mbCustomTextField) {
        if (_mbOneButton.selected||_mbTwoButton.selected||_mbThreeButton.selected) {
            _mbCustomTextField.text = [NSString stringWithFormat:@""];
            return YES;
        }
        _totalRechargeLabel.text = [NSString stringWithFormat:@"￥%.2f",[textField.text floatValue]];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _mbCustomTextField) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet]; //invertedSet 方法是去反字符,把所有的除了数字的字符都找出来
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];  //componentsSeparatedByCharactersInSet 方法是把输入框输入的字符string 根据cs中字符一个一个去除cs字符并分割成单字符并转化为 NSArray, 然后componentsJoinedByString 是把NSArray 的字符通过 ""无间隔连接成一个NSString字符 赋给filtered.就是只剩数字了.
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            return NO;
        }
        // Add any predicate testing here
        if(range.location>3){
            return NO;
        }
        [_mbOneButton setSelected:NO];
        [_mbTwoButton setSelected:NO];
        [_mbThreeButton setSelected:NO];
        
        _totalRechargeLabel.text = [NSString stringWithFormat:@"￥%.2f",[[textField.text stringByAppendingString:string] floatValue]];
        return basicTest;
    }else{
        if (range.location == 4 || range.location == 9 || range.location == 14 || range.location == 19) {
            if (![string isEqualToString:@""]) {
                textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
            }
        }
        
        if(range.location>23){
            return NO;
        }else{
            return YES;
        }
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _cardTextField) {
        [_cardTextField resignFirstResponder];
        [self cardConfirmButtonTouch:nil];
    }else if (textField == _mbCustomTextField)
    {
        [_mbCustomTextField resignFirstResponder];
        [self confirmRecharge:nil];
    }
    return YES;
}
-(void)reloadPointsContent
{
   AppPointModel* model = [_pointsModel.list objectAtIndex:0];
    [_mbOneButton setTitle:[NSString stringWithFormat:@"%.0f猫币",model.points] forState:UIControlStateNormal];
    [_mbOneButton setTitle:[NSString stringWithFormat:@"%.0f猫币",model.points] forState:UIControlStateSelected];
    model = [_pointsModel.list objectAtIndex:1];
    [_mbTwoButton setTitle:[NSString stringWithFormat:@"%.0f猫币",model.points] forState:UIControlStateNormal];
    
    model = [_pointsModel.list objectAtIndex:2];
    [_mbThreeButton setTitle:[NSString stringWithFormat:@"%.0f猫币",model.points] forState:UIControlStateNormal];
    
    _pointModel = [_pointsModel.list objectAtIndex:0];
    [_totalRechargeLabel setText:[NSString stringWithFormat:@"￥%.2f",_pointModel.points]];
}
#pragma mark - http
-(void) GetErr:(ASIHTTPRequest *)request
{
    [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
    if (request.tag == APP_POINTS_TYPE)
    {
        NSDictionary *dictionary = [USER_DEFAULT objectForKey:POINTSMODEL_KEY];
        _pointsModel = [[AppPointsModel alloc] initWithDictionary:dictionary];
        [self reloadPointsContent];
    }
}
-(void) GetResult:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"dic is %@",dictionary);
    if(dictionary==nil){
        [Commonality showErrorMsg:self.view type:0 msg:LINGKERROR];
    }else{
        if (request.tag == APP_POINTS_TYPE) {
            _pointsModel = [[AppPointsModel alloc] initWithDictionary:dictionary];
            [USER_DEFAULT setObject:dictionary forKey:POINTSMODEL_KEY];
            [USER_DEFAULT synchronize];
            [self reloadPointsContent];
        }else if (request.tag == PAY_ADD_TYPE){
            PayAddModel *lm=[[PayAddModel alloc]initWithDictionary:dictionary];
            if (lm.result==0) {
                if (self.delegate&&[self.delegate respondsToSelector:@selector(rechargeSuccess:)]) {
                    [self.delegate rechargeSuccess:lm];
                }
            }else{
                [Commonality showErrorMsg:self.view type:0 msg:lm.errorMessage];
            }

        }
        
    }
}
@end
