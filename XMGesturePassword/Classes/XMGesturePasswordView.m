//
//  XMGesturePasswordView.m
//  XMGesturePassword
//
//  Created by lxumeng on 2021/5/20.
//

#import "XMGesturePasswordView.h"
#import "XMGesturePasswordCell.h"
#import "XMGesturePasswordView+BezierPlotter.h"

static const CGFloat itemWidth = 70;
static NSString *cellId = @"XMGesturePasswordCell";

@interface XMGesturePasswordView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL isShowError;

@end

@implementation XMGesturePasswordView

@synthesize collectionView = _collectionView;
@synthesize path = _path;
@synthesize gestrueLayer = _gestrueLayer;
@synthesize passwordIndexPathArr = _passwordIndexPathArr;

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
    return CGSizeMake(itemWidth, itemWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake([self _itemSpacing], [self _itemSpacing], [self _itemSpacing], [self _itemSpacing]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    return (self.bounds.size.width - 3*itemWidth)*0.25f;
}

//设置线条正常颜色
- (void)setLineNormalColor:(UIColor *)lineNormalColor {
    _lineNormalColor = lineNormalColor;
    self.gestrueLayer.strokeColor = lineNormalColor.CGColor;
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //初始化collectionView
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XMGesturePasswordCell class] forCellWithReuseIdentifier:cellId];
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
