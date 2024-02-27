//
//  XXGesturePasswordViewProtocol.h
//  XMGesturePassword
//
//  Created by lxumeng on 2024/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XMGesturePasswordCell;

@protocol XMGesturePasswordViewProtocol <NSObject>

@optional

/// 九宫格主体
@property (nonatomic, strong) UICollectionView *collectionView;
/// 路径
@property (nonatomic, strong) UIBezierPath *path;
/// 连线
@property (nonatomic, strong) CAShapeLayer *gestrueLayer;
/// 存放每次手势路径上的indexPath
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *passwordIndexPathArr;
/// 错误标识
@property (nonatomic, getter=isShowError) BOOL showError;

/// 设置cell样式
/// - Parameters:
///   - cell: cell
///   - isSelected: 选中状态
- (void)setCell:(XMGesturePasswordCell *)cell isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
