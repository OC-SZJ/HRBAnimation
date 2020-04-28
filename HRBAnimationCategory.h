//
//  HRBAnimationCategory.h
//  FrameWork
//
//  Created by SZJ on 2020/4/28.
//  Copyright © 2020 SZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRBAnimationOption.h"
#import "HRBAnimation.h"
#import "HRBTransfram.h"
#import "HRBDrawAnimation.h"

/*
 
 形变:(动画停止后不会自动回到初始的效果)
 动画:(动画停止会回到初始的效果)
 
 eg:
 
 单个动画:
 [self.view makeAnimation:^(HRBAnimation *animation) {
   animation.transform3D.values(@(CATransform3DMakeRotation(0,1,1,1)),@(CATransform3DMakeRotation(HRBAngleToRadian(90),1,1,1)),@(CATransform3DMakeRotation(0,1,1,1)),nil).repeatCount(-1).duration(0.5);
 }];
 
 组合动画:
 !!!!! 取值的时候 不要超过自己设置的个数(count)  会越界崩溃
 [self.view makeAnimationsForCount:2 animations:^(NSMutableArray<HRBAnimation *> *animations, HRBAnimation *groupAnimation) {
     animations[0].zoom.values(@(3),nil);
     animations[1].translation.values(@(-150),nil);
     groupAnimation.duration(0.5).repeatCount(-1);
 }];
 
 形变:
 !!!!! 取值的时候 不要超过自己设置的个数(count)  会越界崩溃
 !!!!! 如果有放大和缩小的变换最好放在最后 要不其他的变换也会相应的倍数变化
 [self.view makeTransframForDuration:2 forCount:3 transfram:^(NSMutableArray<HRBTransfram *> *transframs) {
     transframs[0].translation.point(CGPointMake(-100, -100));
     transframs[1].rotate.value(45.f);
     transframs[2].zoom.value(2);
 }];
 
 画线:
!!!!! 取值的时候 不要超过自己设置的个数(count)  会越界崩溃
[self.view makeDrawAnimationForCount:1 drawAnimations:^(NSMutableArray<HRBDrawAnimation *> *animations) {
    //直线:
    animations[0].serialLine.values(@(CGPointMake(halfWidth - 10,50)),@(CGPointMake(halfWidth + 10,65)),nil).duration(1).lineWidth(4);
   //曲线绘制:
       贝塞尔曲线(也可绘制标准圆):
    animations[0].serialCircular.values(HRBCircularPointsMakeBezierPath(CGPointMake(50, 50),CGPointMake(200, 200), CGPointMake(150, 70), CGPointMake(70, 150)),nil).duration(1).strokeColor(UIColor.redColor);
       标准圆:
    animations[1].serialCircular.values(HRBCircularPointsMakeCircular(CGPointMake(40, 40), 50, 250, -110, YES)).duration(2);
}];

     
 
 !!!!!!!! 要是没有效果 看看传的值类型对不对
 */


@interface UIView (HRBAnimation)
/// 设置动画 (动画停止会回到起始的效果)
/// @param make 设置动画参数
- (void)makeAnimation:(void(^)(HRBAnimation *animation))make;

/// 设置组合动画 (动画停止会回到起始的效果)
/// @param count 组合动画的个数
/// @param make 设置动画参数
- (void)makeAnimationsForCount:(NSInteger)count animations:(void(^)(NSMutableArray <HRBAnimation *> *animations , HRBAnimation *groupAnimations))make;

/// 设置形变 (动画停止后不会回到起始的效果)
/// @param duration 动画时间 (0的时候 不会显示动画)
/// @param count 形变的个数
/// @param make 设置形变参数
- (void)makeTransframForDuration:(float)duration forCount:(NSInteger)count transfram:(void(^)(NSMutableArray <HRBTransfram *> *transframs))make;

/// 设置形变回到初始状态
- (void)makeTransframToNormal;

/// 画线
/// @param count 元素的个数 (点的个数 或 HRBCircularSet的个数)
/// @param make 设置画线参数
- (void)makeDrawAnimationForCount:(NSInteger)count drawAnimations:(void(^)(NSMutableArray <HRBDrawAnimation *>*animations))make;
/// 设置粒子动画
- (void)makeParticle;

@end


@interface CALayer (HRBAnimation)
/// 设置动画 (动画停止会回到起始的效果)
/// @param make 设置动画参数
- (void)makeAnimation:(void(^)(HRBAnimation *animation))make;

/// 设置组合动画 (动画停止会回到起始的效果)
/// @param count 组合动画的个数
/// @param make 设置动画参数
- (void)makeAnimationsForCount:(NSInteger)count animations:(void(^)(NSMutableArray <HRBAnimation *> *animations , HRBAnimation *groupAnimations))make;

/// 设置形变 (动画停止后不会回到起始的效果)
/// @param duration 动画时间 (0的时候 不会显示动画)
/// @param count 形变的个数
/// @param make 设置形变参数
- (void)makeTransframForDuration:(float)duration forCount:(NSInteger)count transfram:(void(^)(NSMutableArray <HRBTransfram *> *transframs))make;

/// 设置形变回到初始状态
- (void)makeTransframToNormal;
/// 画线
/// @param count 元素的个数 (点的个数 或 HRBCircularSet的个数)
/// @param make 设置画线参数
- (void)makeDrawAnimationForCount:(NSInteger)count drawAnimations:(void(^)(NSMutableArray <HRBDrawAnimation *>*animations))make;


@end


