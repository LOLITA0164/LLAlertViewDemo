//
//  UIApplication+CurrentCtrl.h
//  GuDaShi
//
//  Created by 骆亮 on 2018/5/16.
//  Copyright © 2018年 CXKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (CurrentCtrl)

/**
 获取当前页面
 
 @return 当前页面
 */
-(UIViewController*)currentViewController;

@end
