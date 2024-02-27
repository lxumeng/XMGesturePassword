//
//  XMGesturePasswordView+BezierPlotter.m
//  XMGesturePassword
//
//  Created by lxumeng on 2024/2/26.
//

#import "XMGesturePasswordView+BezierPlotter.h"
#import "XMGesturePasswordCell.h"

@interface XMGesturePasswordView () <XMGesturePasswordViewProtocol>

@end

@implementation XMGesturePasswordView (BezierPlotter)

#pragma mark - Public

- (void)resetView {
    self.showError = NO;
    [self.passwordIndexPathArr removeAllObjects];
    [self.collectionView reloadData];
    [self.path removeAllPoints];
    self.gestrueLayer.path = self.path.CGPath;
    self.gestrueLayer.strokeColor = self.normalColor.CGColor;
}

- (void)errorPath {
    self.showError = YES;
    [self.collectionView reloadData];
    self.gestrueLayer.strokeColor = self.errorColor.CGColor;
    [self _earthquake:self];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self reset];
    });
}

- (void)panMethod:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.collectionView];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            [self reset];
            break;
        case UIGestureRecognizerStateChanged:
            [self _gestureChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self _gestureEnded];
            break;
        default:
            break;
    }
}

#pragma mark - Private

/// 水平晃动
/// - Parameter itemView: 晃动View
- (void)_earthquake:(UIView*)itemView {
    CGFloat t = 4.0;
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0);
    itemView.transform = leftQuake;
    [UIView beginAnimations:@"earthquake" context:(__bridge void *)(itemView)];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:0.04];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(_earthquakeEnded:finished:context:)];
    itemView.transform = rightQuake;
    [UIView commitAnimations];
}

- (void)_earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([finished boolValue]) {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

/// 手势变化
- (void)_gestureChanged:(CGPoint)point {
    // 更新数组
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        XMGesturePasswordCell *cell = (XMGesturePasswordCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (CGRectContainsPoint(cell.frame, point)) {
            if (![self.passwordIndexPathArr containsObject:indexPath]) {
                [self.passwordIndexPathArr addObject:indexPath];
                [self setCell:cell isSelected:YES];
            }
        }
    }
    // 绘制路径
    [self _configGesturePath];
    [self.path addLineToPoint:point];
    self.gestrueLayer.path = self.path.CGPath;
}

/// 绘制手势路径
- (void)_configGesturePath {
    [self.path removeAllPoints];
    for (NSInteger i = 0; i < self.passwordIndexPathArr.count; i++) {
        NSIndexPath *indexPath  = self.passwordIndexPathArr[i];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (i == 0) {
            [self.path moveToPoint:cell.center];
        }else {
            [self.path addLineToPoint:cell.center];
        }
    }
    self.gestrueLayer.path = self.path.CGPath;
}

/// 手势结束
- (void)_gestureEnded {
    //显示手势路径
    [self _configGesturePath];
    NSString *password = @"";
    for (NSIndexPath *indexPath in self.passwordIndexPathArr) {
        password = [NSString stringWithFormat:@"%@%zd",password,indexPath.row];
    }
    if ([self.delegate respondsToSelector:@selector(xmGesturePassword:result:)]) {
        [self.delegate xmGesturePassword:self result:password];
    }
}

@end
