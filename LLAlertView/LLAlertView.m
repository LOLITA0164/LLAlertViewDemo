//
//  LLAlertView.m
//  LLAlertView
//
//  Created by 骆亮 on 2018/5/29.
//  Copyright © 2018年 LOLITA0164. All rights reserved.
//

#import "LLAlertView.h"
#import "UIApplication+CurrentCtrl.h"

@interface LLAlertView ()<UIAlertViewDelegate,UIActionSheetDelegate,CAAnimationDelegate>
@property (strong ,nonatomic) id object;    // 用于循环引用
@property (strong, nonatomic) UIView *backgroundView;   // 背景视图
@property (strong ,nonatomic) CAAnimation *animation;   // 传入自定义动画
@property (strong ,nonatomic) CABasicAnimation *showHideAnimation;
@property (strong ,nonatomic) CABasicAnimation *showHideAnimation_contentView;
@property (strong ,nonatomic) NSTimer *timer;
@end

static float duration = 0.25f;

@implementation LLAlertView
#pragma mark - <************************** 显示系统弹窗 **************************>
// !!!!: 显示系统弹窗AlertViewController
+(UIAlertController*)showSystemAlertViewMessageBody:(LLAlertMessage *)body clickBlock:(LLAlertViewBlock)block{
    if (body==nil) {
        return nil;
    }
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:body.title message:body.message preferredStyle:body.style];
    for (int i=0; i<body.bts.count; i++) {
        NSString *title = body.bts[i];
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (body.bss.count==body.bts.count) {
            style = [body.bss[i] integerValue];
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(i);
            }
        }];
        [alertCtrl addAction:action];
    }
    // 遍历，找出当前视图
    UIViewController *currentCtrl = [[UIApplication sharedApplication] currentViewController];
    [currentCtrl presentViewController:alertCtrl animated:YES completion:nil];
    return alertCtrl;
}
+(UIAlertController *)showSystemAlertViewMessage:(NSString *)message buttonTitles:(NSArray *)bts clickBlock:(LLAlertViewBlock)block{
    LLAlertMessage *messageBody = [LLAlertMessage newAlertViewWithTitle:@"提示" message:message buttonTitles:bts];
    return [self showSystemAlertViewMessageBody:messageBody clickBlock:block];
}



// !!!!: 显示系统弹窗AlertView
/**
 UIAlertView，弹窗信息体，可选
 */
-(id)showSystemAlertViewMessageBody:(LLAlertMessage*)body clickBlock:(LLAlertViewBlock)block{
    if (body==nil) {
        return nil;
    }
    if (body.style==UIAlertControllerStyleAlert) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:body.title message:body.message delegate:self cancelButtonTitle:body.cancelTitle otherButtonTitles:nil];
        for (NSString *title in body.bts) {
            [alertView addButtonWithTitle:title];
        }
        [alertView show];
        self.block = block; // 记录当前block，用于传递点击事件
        self.object = self; // 采用循环引用避免被系统提前释放
        return alertView;
    }
    else{
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:body.title delegate:self cancelButtonTitle:body.cancelTitle destructiveButtonTitle:body.destructiveTitle otherButtonTitles:nil, nil];
        for (NSString *title in body.bts) {
            [sheet addButtonWithTitle:title];
        }
        [sheet showInView:[[[UIApplication sharedApplication] currentViewController] view]];
        self.block = block; // 记录当前block，用于传递点击事件
        self.object = self; // 采用循环引用避免被系统提前释放
        return sheet;
    }
}
-(UIAlertView *)showSystemAlertViewMessage:(NSString *)message buttonTitles:(NSArray *)bts clickBlock:(LLAlertViewBlock)block{
    LLAlertMessage *messageBody = [LLAlertMessage newAlertViewWithTitle:@"提示" message:message buttonTitles:bts];
    return [self showSystemAlertViewMessageBody:messageBody clickBlock:block];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.block) {
        self.block(buttonIndex);
        self.object = nil;  // 断掉强引用，让系统释放该对象self
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.block) {
        self.block(buttonIndex);
        self.object = nil;  // 断掉强引用，让系统释放该对象self
    }
}






#pragma mark - <************************** 显示自定义弹窗 **************************>
-(instancetype)initWithContentView:(UIView *)view{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self addSubview:self.backgroundView];
        self.contentView = view;
        // 监听屏幕旋转
        //设备旋转通知
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil
         ];
    }
    return self;
}
-(UIView *)backgroundView{
    if (_backgroundView==nil) {
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
    }
    return _backgroundView;
}

-(void)setContentView:(UIView *)contentView{
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    _contentView.center = self.center;
    [self addSubview:_contentView];
}

-(CAAnimation *)animation{
    if (_animation==nil) {
        CAKeyframeAnimation * animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = duration;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        _animation = animation;
    }
    return _animation;
}

-(CABasicAnimation *)showHideAnimation{
    if (_showHideAnimation==nil) {
        _showHideAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _showHideAnimation.duration = duration;
        _showHideAnimation.removedOnCompletion = NO;
        _showHideAnimation.fillMode = kCAFillModeForwards;
        _showHideAnimation.delegate = self;
    }
    return _showHideAnimation;
}

-(CABasicAnimation *)showHideAnimation_contentView{
    if (_showHideAnimation_contentView==nil) {
        _showHideAnimation_contentView = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _showHideAnimation_contentView.duration = duration;
        _showHideAnimation_contentView.removedOnCompletion = NO;
        _showHideAnimation_contentView.fillMode = kCAFillModeForwards;
    }
    return _showHideAnimation_contentView;
}

// !!!!: 显示/隐藏方法
-(void)show{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [self showBackground];
    [self.contentView.layer addAnimation:self.animation forKey:@"animation"];
}

-(void)hide{
    [self hideCompletion:nil];
}

-(void)hideCompletion:(void (^)())block{
    [self hideBackgorund];
    if (block) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            [self.timer invalidate];
            self.timer = nil;
            block();
        });
    }
    else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            [self.timer invalidate];
            self.timer = nil;
        });
    }
}


- (void)showBackground{
    self.showHideAnimation.fromValue = @(0);
    self.showHideAnimation.toValue = @(0.5);
    [self.backgroundView.layer addAnimation:self.showHideAnimation forKey:@"opacity"];
    
    self.showHideAnimation_contentView.fromValue = @(0.8);
    self.showHideAnimation_contentView.toValue = @(1.0);
    [self.contentView.layer addAnimation:self.showHideAnimation_contentView forKey:@"opacity"];
    [self prohibitAnyTouchEvent];
}

- (void)hideBackgorund{
    self.showHideAnimation.fromValue = @(0.5);
    self.showHideAnimation.toValue = @(0);
    [self.backgroundView.layer addAnimation:self.showHideAnimation forKey:@"opacity"];
    
    self.showHideAnimation_contentView.fromValue = @(1.0);
    self.showHideAnimation_contentView.toValue = @(0);
    [self.contentView.layer addAnimation:self.showHideAnimation_contentView forKey:@"opacity"];
    [self prohibitAnyTouchEvent];
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchToClose) {
        [self hide];
    }
    if (self.touchBgView) {
        __weak __typeof(&*self)weakSelf = self;
        self.touchBgView(weakSelf);
        NSLog(@"点击了背景视图");
    }
}


-(void)prohibitAnyTouchEvent{
    if (self.touchToClose||self.touchBgView) {
        self.userInteractionEnabled = NO;
        [[[[UIApplication sharedApplication] currentViewController] view] setUserInteractionEnabled:NO];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:duration repeats:NO block:^(NSTimer * _Nonnull timer) {
            self.userInteractionEnabled = YES;
            [[[[UIApplication sharedApplication] currentViewController] view] setUserInteractionEnabled:YES];
        }];
    }
}


// !!!: 屏幕旋转方向
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = [UIScreen mainScreen].bounds;
        [self layoutIfNeeded];
    }];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    self.contentView.center = self.center;
}


@end














#pragma mark - <************************** 弹窗信息类 **************************>
@implementation LLAlertMessage
+(instancetype)newAlertViewWithTitle:(NSString *)title message:(NSString *)msg buttonTitles:(NSArray *)bts{
    return [self newWithStyle:UIAlertControllerStyleAlert title:title message:msg buttonTitles:bts buttonStyles:nil];
}
+(instancetype)newActionSheetWithTitle:(NSString *)title message:(NSString *)msg buttonTitles:(NSArray *)bts{
    return [self newWithStyle:UIAlertControllerStyleActionSheet title:title message:msg buttonTitles:bts buttonStyles:nil];
}
+(instancetype)newWithStyle:(UIAlertControllerStyle)style title:(NSString*)title message:(NSString*)msg buttonTitles:(NSArray *)bts buttonStyles:(NSArray<NSNumber *> *)bss{
    LLAlertMessage *body = [LLAlertMessage new];
    body.style = style;
    body.title = title;
    body.message = msg;
    body.bts = bts;
    body.bss = bss;
    return body;
}
-(void)addCancelButtonTitle:(NSString *)cancel destructiveButtonTitle:(NSString *)destructive{
    self.cancelTitle = cancel;
    self.destructiveTitle = destructive;
}
@end


