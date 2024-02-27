//
//  XMGesturePasswordView.h
//  XMGesturePassword
//
//  Created by lxumeng on 2021/5/20.
//

#import <UIKit/UIKit.h>
#import "XMGesturePasswordViewProtocol.h"

@class XMGesturePasswordView;

@protocol XMGesturePasswordViewDelegate <NSObject>
/// 密码结果回调
/// - Parameter password: 密码
- (void)xmGesturePassword:(XMGesturePasswordView *)passwordView result:(NSString *)password;

@end

@interface XMGesturePasswordView : UIView 

@property (nonatomic, weak) id<XMGesturePasswordViewDelegate> delegate;

/// 圆圈直径,默认70
@property (nonatomic) CGFloat diameter;

/// 连接线宽度，默认20
@property (nonatomic) NSInteger lineWidth;

/// 正常连线颜色，默认灰色
@property (nonatomic, strong) UIColor *normalColor;

/// 错误连线颜色，默认红色
@property (nonatomic, strong) UIColor *errorColor;

/// 重置，清空所有手势
- (void)reset;

/// 展示错误
- (void)showError;

@end


