//
//  XXGesturePasswordViewProtocol.h
//  XMGesturePassword
//
//  Created by xixi on 2024/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XMGesturePasswordCell;

@protocol XMGesturePasswordViewProtocol <NSObject>

@optional

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *gestrueLayer; //连线
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *passwordIndexPathArr;   //存放每次手势路径上的indexPath
@property (nonatomic, assign) BOOL isShowError;

- (void)setCell:(XMGesturePasswordCell *)cell isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
