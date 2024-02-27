//
//  XLGestureCell.m
//  XMGesturePassword
//
//  Created by lxumeng on 2021/5/20.
//

#import "XMGesturePasswordCell.h"

static const CGFloat borderWidth = 1.0f; // 边宽
static const CGFloat coefficient = 0.45f; // 中心圆圈的缩小系数
/// border颜色
FOUNDATION_STATIC_INLINE CGColorRef XM_BORDER_COLOR(void) {
    return [UIColor colorWithRed:187/255.0f green:192/255.0f blue:207/255.0f alpha:1].CGColor;
}

@implementation XMGesturePasswordCell

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.bounds.size.height/2.0f;
        self.layer.masksToBounds = true;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = XM_BORDER_COLOR();
        [self addSubview:self.centerBall];
    }
    return self;
}

- (void)setXmSelected:(BOOL)xmSelected {
    _xmSelected = xmSelected;
    self.centerBall.hidden = !_xmSelected;
    if (_xmSelected) {
        return;
    }
    self.layer.borderColor = XM_BORDER_COLOR();
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Getter

- (UIView *)centerBall {
    if (!_centerBall) {
        CGFloat centerBallWidth = self.bounds.size.width*coefficient;
        _centerBall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, centerBallWidth, centerBallWidth)];
        _centerBall.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
        _centerBall.layer.cornerRadius = _centerBall.bounds.size.height/2.0f;
        _centerBall.layer.masksToBounds = true;
    }
    return _centerBall;
}

@end
