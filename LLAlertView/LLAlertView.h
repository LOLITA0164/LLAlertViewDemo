//
//  LLAlertView.h
//  LLAlertView
//
//  Created by 骆亮 on 2018/5/29.
//  Copyright © 2018年 LOLITA0164. All rights reserved.
//

#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import <UIKit/UIKit.h>
@class LLAlertMessage;
typedef void(^LLAlertViewBlock)(NSInteger index);

@interface LLAlertView : UIView
#pragma mark - <************************** 显示系统弹窗 **************************>
@property (copy ,nonatomic) LLAlertViewBlock block;
// !!!!: 显示系统弹窗AlertViewController
/**
 UIAlertViewController，标题数组
 */
+(UIAlertController*)showSystemAlertViewMessage:(NSString*)message buttonTitles:(NSArray *)bts clickBlock:(LLAlertViewBlock)block;
/**
 UIAlertViewController，弹窗信息体，可选
 */
+(UIAlertController*)showSystemAlertViewMessageBody:(LLAlertMessage*)body clickBlock:(LLAlertViewBlock)block;


// !!!!: 显示系统弹窗AlertView
/**
 UIAlertView，标题数组
 */
-(UIAlertView*)showSystemAlertViewMessage:(NSString*)message buttonTitles:(NSArray *)bts clickBlock:(LLAlertViewBlock)block;
/**
 UIAlertView，弹窗信息体，可选
 */
-(id)showSystemAlertViewMessageBody:(LLAlertMessage*)body clickBlock:(LLAlertViewBlock)block;


#pragma mark - <************************** 显示自定义弹窗 **************************>
@property (strong, nonatomic) UIView *contentView;      // 内容视图
@property (assign ,nonatomic) BOOL touchToClose;        // 是否点击背景关闭，默认不需要
@property (nonatomic,copy) void(^touchBgView)(LLAlertView*alertView);   // 点击背景视图回调

// 初始化
-(instancetype)initWithContentView:(UIView*)view;

-(void)show;

-(void)hide;

-(void)hideCompletion:(void(^)())block;

@end












#pragma mark - <************************** 弹窗信息类 **************************>
@interface LLAlertMessage : NSObject
@property (assign ,nonatomic) UIAlertControllerStyle style;
@property (copy ,nonatomic) NSString *title;
@property (copy ,nonatomic) NSString *message;
@property (copy ,nonatomic) NSArray *bts;   // 按钮的标题数组
@property (copy ,nonatomic) NSArray *bss;   // 按钮的样式数组，只对UIAlertController有效
@property (copy ,nonatomic) NSString *cancelTitle;  // 只对UIAlertView有效
@property (copy ,nonatomic) NSString *destructiveTitle; // 只对UIAlertView有效
+(instancetype)newAlertViewWithTitle:(NSString*)title message:(NSString*)msg buttonTitles:(NSArray*)bts;
+(instancetype)newActionSheetWithTitle:(NSString*)title message:(NSString*)msg buttonTitles:(NSArray*)bts;
+(instancetype)newWithStyle:(UIAlertControllerStyle)style title:(NSString*)title message:(NSString*)msg buttonTitles:(NSArray*)bts buttonStyles:(NSArray<NSNumber*>*)bss;
/**
 只对UIAlertView有效，会占据最前的索引
 */
-(void)addCancelButtonTitle:(NSString*)cancel destructiveButtonTitle:(NSString*)title;
@end


