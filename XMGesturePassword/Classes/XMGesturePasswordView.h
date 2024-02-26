//
//  XMGesturePasswordView.h
//  XMGesturePassword
//
//  Created by lxumeng on 2021/5/20.
//

#import <UIKit/UIKit.h>

typedef void (^PasswordBlock) (NSString *password);

@interface XMGesturePasswordView : UIView

/// item背景色 默认浅灰色
@property (nonatomic, strong) UIColor *itemBackGoundColor;
/// item中间圆球的颜色 默认灰色
@property (nonatomic, strong) UIColor *itemCenterBallColor;
/// item中间圆球错误颜色 默认灰色
@property (nonatomic, strong) UIColor *itemCenterBallErrorColor;
/// 线条正常状态的颜色 默认灰色
@property (nonatomic, strong) UIColor *lineNormalColor;
/// 线条错误状态的颜色 默认红色
@property (nonatomic, strong) UIColor *lineErrorColor;
/// 连接线宽度
@property (nonatomic, assign) NSInteger lineWidth;

/// 重新输入
- (void)refresh;
/// 错误
- (void)showError;
/// 添加密码回调
/// @param passwordBlock 密码回调
- (void)addPasswordBlock:(PasswordBlock)passwordBlock;

@end
