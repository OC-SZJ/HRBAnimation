//
//  HRBAnimation.h
//  FrameWork
//
//  Created by SZJ on 2020/4/25.
//  Copyright © 2020 SZJ. All rights reserved.
//





#import <Foundation/Foundation.h>



/// <#Description#>
@interface HRBAnimation : NSObject

/// 动画开始的回调
@property (nonatomic,copy) void(^start)(void);
/// 动画结束的回调
@property (nonatomic,copy) void(^finish)(BOOL finish);

/// 动画 缩放 需要设置 缩放比例 float
- (HRBAnimation *)zoom;
/// 动画 旋转 需要设置 旋转角度 float
- (HRBAnimation *)rotate;
/// 动画 平移 需要设置 平移位置 point
- (HRBAnimation *)translation;
/// 动画 翻转 需要设置 翻转方向&翻转角度 CATransform3DMakeRotation
- (HRBAnimation *)transform3D;
/// 设置动画数值 (末尾必须设置nil,不写崩溃)
- (HRBAnimation *(^)(id value, ...))values;
/// 设置动画时长
- (HRBAnimation *(^)(float duration))duration;
/// 设置动画次数 (持续动画 传 -1)
- (HRBAnimation *(^)(int repeatCount))repeatCount;


/// 开始动画
/// @param layer 设置动画的layer
- (void)beginAnimation:(CALayer *)layer;

/// 开始动画组
/// @param layer 设置动画的layer
/// @param animations 动画的数组
/// @param set 动画的设置
+ (void)beginGroupAnimation:(CALayer *)layer animations:(NSArray *)animations set:(HRBAnimation *)set;
@end

