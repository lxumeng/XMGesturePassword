//
//  XMGesturePasswordView.m
//  XMGesturePassword
//
//  Created by lxumeng on 2021/5/20.
//

#import "XMGesturePasswordView.h"
#import "XMGesturePasswordCell.h"
#import "XMGesturePasswordView+BezierPlotter.h"

static NSString *cellId = @"XMGesturePasswordCell";

@interface XMGesturePasswordView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XMGesturePasswordViewProtocol>

@property (nonatomic) CGFloat itemSpacing;

@end

@implementation XMGesturePasswordView

@synthesize passwordIndexPathArr = _passwordIndexPathArr;
@synthesize collectionView       = _collectionView;
@synthesize path                 = _path;
@synthesize gestrueLayer         = _gestrueLayer;
@synthesize showError            = _showError;

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = true;
        self.lineWidth = 20.0f;
        self.diameter = 70.0f;
        self.itemSpacing = (self.bounds.size.width - 3*self.diameter)*0.25f;
        self.normalColor = [UIColor grayColor];
        self.errorColor = [UIColor redColor];
        [self addSubview:self.collectionView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMethod:)];
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

- (void)reset {
    [self resetView];
}

- (void)showError {
    [self errorPath];
}

#pragma mark - CollectonViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.itemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.itemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.diameter, self.diameter);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(self.itemSpacing, self.itemSpacing, self.itemSpacing, self.itemSpacing);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMGesturePasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [self setCell:cell isSelected:[self.passwordIndexPathArr containsObject:indexPath]];
    return cell;
}

- (void)setCell:(XMGesturePasswordCell *)cell isSelected:(BOOL)isSelected {
    cell.xmSelected = isSelected;
    if (!isSelected) {
        return;
    }
    if (self.isShowError) {
        cell.centerBall.backgroundColor = self.errorColor;
        cell.layer.borderColor = self.errorColor.CGColor;
    } else {
        cell.centerBall.backgroundColor = self.normalColor;
        cell.layer.borderColor = self.normalColor.CGColor;
    }
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
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
        _gestrueLayer.lineWidth = self.lineWidth;
        _gestrueLayer.lineCap = kCALineCapRound;
        _gestrueLayer.lineJoin = kCALineJoinRound;
        _gestrueLayer.strokeColor = self.normalColor.CGColor;
    }
    return _gestrueLayer;
}

@end
