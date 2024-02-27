//
//  XMGesturePasswordView+BezierPlotter.h
//  XMGesturePassword
//
//  Created by xixi on 2024/2/26.
//

#import "XMGesturePasswordView.h"
#import "XMGesturePasswordViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMGesturePasswordView (BezierPlotter) <XMGesturePasswordViewProtocol>


- (void)_earthquake:(UIView*)itemView;

- (void)_panMethod:(UIPanGestureRecognizer *)pan;

@end

NS_ASSUME_NONNULL_END
