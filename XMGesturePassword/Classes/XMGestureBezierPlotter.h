//
//  XMGestureBezierPlotter.h
//  XMGesturePassword
//
//  Created by lxumeng on 2024/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMGestureBezierPlotter : NSObject

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *gestrueLayer; //连线

@end

NS_ASSUME_NONNULL_END
