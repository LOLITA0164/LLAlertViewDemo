//
//  AViewController.m
//  LLAlertView
//
//  Created by 骆亮 on 2018/5/29.
//  Copyright © 2018年 LOLITA0164. All rights reserved.
//

#import "AViewController.h"
#import "LLAlertView.h"
#import "CustomAlertView1.h"

@interface AViewController ()

- (IBAction)alertCtrlAction:(UIButton *)sender;
- (IBAction)alert2CtrlAction:(UIButton *)sender;

- (IBAction)sheetCtrlAction:(UIButton *)sender;
- (IBAction)alertViewAction:(UIButton *)sender;
- (IBAction)sheetViewAction:(UIButton *)sender;

- (IBAction)customViewAction:(UIButton *)sender;

@property (strong ,nonatomic) LLAlertView *alert;
@property (strong ,nonatomic) CustomAlertView1 *tipView;

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(nextPages)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)alertCtrlAction:(UIButton *)sender {
    [LLAlertView showSystemAlertViewMessage:@"alertCtrl提示哦" buttonTitles:@[@"取消",@"弹窗"] clickBlock:^(NSInteger index) {
        NSLog(@"选择了%ld",index);
        if (index==1) {
            [LLAlertView showSystemAlertViewMessage:@"弹窗2" buttonTitles:@[@"确定"] clickBlock:nil];
        }
    }];
}

- (IBAction)alert2CtrlAction:(UIButton *)sender {
    LLAlertMessage *messageBody = [LLAlertMessage newWithStyle:UIAlertControllerStyleAlert title:@"提示" message:@"文件错误！" buttonTitles:@[@"重试",@"跳转"] buttonStyles:@[@(UIAlertActionStyleDefault),@(UIAlertActionStyleDestructive)]];
    [LLAlertView showSystemAlertViewMessageBody:messageBody clickBlock:^(NSInteger index) {
        NSLog(@"选择了%ld",index);
    }];
}

- (IBAction)sheetCtrlAction:(UIButton *)sender {
    LLAlertMessage *messageBody = [LLAlertMessage newWithStyle:UIAlertControllerStyleActionSheet title:@"请选择" message:nil buttonTitles:@[@"选项1",@"选项2",@"取消"] buttonStyles:@[@(UIAlertActionStyleDefault),@(UIAlertActionStyleDestructive),@(UIAlertActionStyleCancel)]];
    [LLAlertView showSystemAlertViewMessageBody:messageBody clickBlock:^(NSInteger index) {
        NSLog(@"选择了%ld",index);
    }];
}



- (IBAction)alertViewAction:(UIButton *)sender {
    NSArray* titles = @[@"Apple",@"Pear",@"Banana",@"Pineapple"];
    [[LLAlertView new] showSystemAlertViewMessage:nil buttonTitles:titles clickBlock:^(NSInteger index) {
        NSLog(@"选择了%ld",index);
        [LLAlertView showSystemAlertViewMessage:[NSString stringWithFormat:@"您选择了：%@",titles[index]] buttonTitles:@[@"确定"] clickBlock:nil];
    }];
}

- (IBAction)sheetViewAction:(UIButton *)sender {
    LLAlertMessage *messageBody = [LLAlertMessage newWithStyle:UIAlertControllerStyleActionSheet title:@"请选择" message:nil buttonTitles:@[@"选项1",@"选项2"] buttonStyles:nil];
    [messageBody addCancelButtonTitle:@"取消" destructiveButtonTitle:@"选项3"];
    [[LLAlertView new] showSystemAlertViewMessageBody:messageBody clickBlock:^(NSInteger index) {
        NSLog(@"选择了%ld",index);
    }];
}


// !!!!: 跳转复杂结构页面
-(void)nextPages{
    UITabBarController *tabCtrl = [[UITabBarController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:[AViewController new]];
    [tabCtrl addChildViewController:navCtrl];
    [self.navigationController presentViewController:tabCtrl animated:YES completion:nil];
}








-(LLAlertView *)alert{
    if (_alert==nil) {
        _alert = [[LLAlertView alloc] initWithContentView:self.tipView];
        _alert.touchBgView = ^(LLAlertView *alertView) {
            
        };
//        _alert.touchToClose = YES;
    }
    return _alert;
}

-(CustomAlertView1 *)tipView{
    if (_tipView==nil) {
        _tipView = [[[NSBundle mainBundle] loadNibNamed:@"CustomAlertView1" owner:nil options:nil] firstObject];
        [_tipView.cancelBtn addTarget:self.alert action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipView;
}


- (IBAction)customViewAction:(UIButton *)sender {
    [self.alert show];
}




@end
