//
//  XMGesturePasswordView+BezierPlotter.h
//  XMGesturePassword
//
//  Created by lxumeng on 2024/2/26.
//

#import "XMGesturePasswordView.h"


NS_ASSUME_NONNULL_BEGIN

@interface XMGesturePasswordView (BezierPlotter)

/// 手势方法
/// - Parameter pan: 手势
- (void)panMethod:(UIPanGestureRecognizer *)pan;

/// 重置，清空所有手势
- (void)resetView;

/// 验证错误
- (void)errorPath;

@end

NS_ASSUME_NONNULL_END
