//
//  XMGesturePasswordView+BezierPlotter.m
//  XMGesturePassword
//
//  Created by xixi on 2024/2/26.
//

#import "XMGesturePasswordView+BezierPlotter.h"
#import "XMGesturePasswordCell.h"
#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Wprotocol"

@implementation XMGesturePasswordView (BezierPlotter)

//报错
- (void)showError {
    self.isShowError = YES;
    [self.collectionView reloadData];
    self.gestrueLayer.strokeColor = self.lineErrorColor.CGColor;
    [self _earthquake:self];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self refresh];
    });
}
//重置
- (void)refresh {
    self.isShowError = NO;
    //刷新列表
    [self.passwordIndexPathArr removeAllObjects];
    [self.collectionView reloadData];
    //更新路径
    [self.path removeAllPoints];
    self.gestrueLayer.path = self.path.CGPath;
    self.gestrueLayer.strokeColor = self.lineNormalColor.CGColor;
}

- (void)_earthquake:(UIView*)itemView {
    CGFloat t = 4.0;
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0); //水平晃动
    itemView.transform = leftQuake;  // starting point
    [UIView beginAnimations:@"earthquake" context:(__bridge void *)(itemView)];
    [UIView setAnimationRepeatAutoreverses:YES]; // 如果不加这一句 整个动画感觉不连贯
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:0.04];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(_earthquakeEnded:finished:context:)];
    itemView.transform = rightQuake; // end here & auto-reverse
    [UIView commitAnimations];
}

- (void)_earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([finished boolValue]) {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

- (void)_panMethod:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.collectionView];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            [self _gestureBegan];
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

//手势开始
- (void)_gestureBegan {
    [self refresh];
}

//手势变化
- (void)_gestureChanged:(CGPoint)point {
    [self _updatePasswordIndexPathArr:point];
    [self _updateGesturePath:point];
}

//更新路径上的indexPath
- (void)_updatePasswordIndexPathArr:(CGPoint)point {
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        XMGesturePasswordCell *cell = (XMGesturePasswordCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (CGRectContainsPoint(cell.frame, point)) {
            if (![self.passwordIndexPathArr containsObject:indexPath]) {
                [self.passwordIndexPathArr addObject:indexPath];
                [self setCell:cell isSelected:YES];
            }
        }
    }
}

//绘制手势路径
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

//更新手势路径
- (void)_updateGesturePath:(CGPoint)point {
    [self _configGesturePath];
    [self.path addLineToPoint:point];
    self.gestrueLayer.path = self.path.CGPath;
}

//手势结束
- (void)_gestureEnded {
    //显示手势路径
    [self _configGesturePath];
    NSString *password = @"";
    for (NSIndexPath *indexPath in self.passwordIndexPathArr) {
        password = [NSString stringWithFormat:@"%@%zd",password,indexPath.row];
    }
    if ([self.delegate respondsToSelector:@selector(xmGestureResultPassword:)]) {
        [self.delegate xmGestureResultPassword:password];
    }
}

#pragma mark - Setter




@end
