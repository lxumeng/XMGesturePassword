//
//  XMGesturePasswordView.m
//  XMGesturePassword
//
//  Created by lxumeng on 2021/5/20.
//

#import "XMGesturePasswordView.h"
#import "XMGesturePasswordCell.h"
#import "XMGestureBezierCurveProtocol.h"
@interface XMGesturePasswordView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XMGestureBezierCurveProtocol>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *gestrueLayer; //连线
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *passwordIndexPathArr;   //存放每次手势路径上的indexPath
@property (nonatomic, assign) BOOL isShowError;
@property (nonatomic, copy) PasswordBlock passwordBlock; //密码block

@end

@implementation XMGesturePasswordView

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = true;
        self.itemBackGoundColor = [UIColor lightGrayColor];
        self.itemCenterBallColor = [UIColor grayColor];
        self.itemCenterBallErrorColor = [UIColor grayColor];
        self.lineNormalColor = [UIColor grayColor];
        self.lineErrorColor = [UIColor redColor];
        self.isShowError = NO;
        
        [self addSubview:self.collectionView];
        //初始化手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panMethod:)];
        [self.collectionView addGestureRecognizer:pan];
        [self.layer addSublayer:self.gestrueLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - Public

//报错
- (void)showError {
    self.isShowError = YES;
    [self.collectionView reloadData];
    self.gestrueLayer.strokeColor = _lineErrorColor.CGColor;
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
    self.gestrueLayer.strokeColor = _lineNormalColor.CGColor;
}

//添加密码输入回调
- (void)addPasswordBlock:(PasswordBlock)passwordBlock {
    self.passwordBlock = passwordBlock;
}

#pragma mark - CollectonViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self _itemSpacing];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self _itemSpacing];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self _itemWidth], [self _itemWidth]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake([self _itemSpacing], [self _itemSpacing], [self _itemSpacing], [self _itemSpacing]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"XMGesturePasswordCell";
    XMGesturePasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [self setCell:cell isSelected:[self.passwordIndexPathArr containsObject:indexPath]];
    
    return cell;
}

- (void)setCell:(XMGesturePasswordCell *)cell isSelected:(BOOL)isSelected
{
    cell.selected = isSelected;
    if (cell.isSelected) {
        if (self.isShowError) {
            cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
            cell.centerBall.backgroundColor = self.itemCenterBallErrorColor;
            cell.layer.borderColor = self.itemCenterBallErrorColor.CGColor;
        } else {
            cell.backgroundColor = self.itemBackGoundColor;
            cell.centerBall.backgroundColor = self.itemCenterBallColor;
            cell.layer.borderColor = self.itemCenterBallColor.CGColor;
        }
    }
}

#pragma mark - Private

- (CGFloat)_itemSpacing {
    return (self.bounds.size.width - 3*[self _itemWidth])*0.25f;
}

- (CGFloat)_itemWidth {
    return 70;
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
    !self.passwordBlock ?: self.passwordBlock(password);
}

#pragma mark - Setter

//设置线条正常颜色
- (void)setLineNormalColor:(UIColor *)lineNormalColor {
    _lineNormalColor = lineNormalColor;
    self.gestrueLayer.strokeColor = lineNormalColor.CGColor;
}

//设置线条错误颜色
- (void)setLineErrorColor:(UIColor *)lineErrorColor {
    _lineErrorColor = lineErrorColor;
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //初始化collectionView
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XMGesturePasswordCell class] forCellWithReuseIdentifier:@"XMGesturePasswordCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (UIBezierPath *)path {
    if (!_path) {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}

- (NSMutableArray<NSIndexPath *> *)passwordIndexPathArr {
    if (!_passwordIndexPathArr) {
        _passwordIndexPathArr = [[NSMutableArray alloc] init];
    }
    return _passwordIndexPathArr;
}

- (CAShapeLayer *)gestrueLayer {
    if (!_gestrueLayer) {
        _gestrueLayer = [CAShapeLayer layer];
        _gestrueLayer.fillColor = [UIColor clearColor].CGColor;
        if (self.lineWidth > 0) {
            _gestrueLayer.lineWidth = self.lineWidth;
        }else{
            _gestrueLayer.lineWidth = 20;
        }
        _gestrueLayer.lineCap = kCALineCapRound;
        _gestrueLayer.lineJoin = kCALineJoinRound;
    }
    return _gestrueLayer;
}

@end
