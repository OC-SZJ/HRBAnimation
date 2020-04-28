//
//  HRBAnimationCategory.m
//  FrameWork
//
//  Created by SZJ on 2020/4/28.
//  Copyright © 2020 SZJ. All rights reserved.
//

#import "HRBAnimationCategory.h"


@implementation CALayer (HRBAnimation)

-(void)makeAnimation:(void(^)(HRBAnimation *animation))make{
    HRBAnimation *animation = HRBAnimation.new;
    make(animation);
    [animation beginAnimation:self];
}
-(void)makeAnimationsForCount:(NSInteger)count animations:(void(^)(NSMutableArray <HRBAnimation *> *animations , HRBAnimation *groupAnimations))make{
    NSMutableArray <HRBAnimation *>*animations = @[].mutableCopy;
    for (int i = 0; i < count; i++) {
        [animations addObject:HRBAnimation.new];
    }
    HRBAnimation *animation = HRBAnimation.new;
    make(animations,animation);
    [HRBAnimation beginGroupAnimation:self animations:animations set:animation];
}



- (void)makeDrawAnimationForCount:(NSInteger)count drawAnimations:(void(^)(NSMutableArray <HRBDrawAnimation *>*))make{
    NSMutableArray <HRBDrawAnimation *>*animations = @[].mutableCopy;
    for (int i = 0; i < count; i++) {
        [animations addObject:HRBDrawAnimation.new];
    }
    make(animations);
    for (HRBDrawAnimation *drawAnimation in animations) {
        [drawAnimation alreadyToWork:self];
    }
    [HRBDrawAnimation beginAnimation:animations layer:self];
}
- (void)makeTransframForDuration:(float)duration forCount:(NSInteger)count transfram:(void(^)(NSMutableArray <HRBTransfram *> *transframs))make{
    NSMutableArray *t_arr = @[].mutableCopy;
    for (int i = 0; i < count; i++) {
        [t_arr addObject:HRBTransfram.new];
    }
    make(t_arr);
    if (count == 0) return;
    CGAffineTransform transform = CATransform3DGetAffineTransform(self.transform);
    for (HRBTransfram *t in t_arr) {
        transform = [t alreadyToWork:transform];
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    self.transform = CATransform3DMakeAffineTransform(transform);
    [CATransaction commit];
}

/// 设置形变回到初始状态
- (void)makeTransframToNormal{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CATransform3DIdentity;
    }];
}

@end
@implementation UIView (HRBAnimation)

-(void)makeAnimation:(void(^)(HRBAnimation *animation))make{
    [self.layer makeAnimation:make];
}
-(void)makeAnimationsForCount:(NSInteger)count animations:(void(^)(NSMutableArray <HRBAnimation *> *animations , HRBAnimation *groupAnimations))make{
    [self.layer makeAnimationsForCount:count animations:make];
}

- (void)makeTransframForDuration:(float)duration forCount:(NSInteger)count transfram:(void(^)(NSMutableArray <HRBTransfram *> *transframs))make{
    NSMutableArray *t_arr = @[].mutableCopy;
    for (int i = 0; i < count; i++) {
        [t_arr addObject:HRBTransfram.new];
    }
    make(t_arr);
    if (count == 0) return;
    CGAffineTransform transform = self.transform;
    for (HRBTransfram *t in t_arr) {
        transform = [t alreadyToWork:transform];
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = transform;
    }];
    
}

/// 设置形变回到初始状态
- (void)makeTransframToNormal{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)makeDrawAnimationForCount:(NSInteger)count drawAnimations:(void(^)(NSMutableArray <HRBDrawAnimation *>*))make{
    [self.layer makeDrawAnimationForCount:count drawAnimations:make];
}

-(void)makeParticle{
    
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    //展示的图片
    cell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"heart.png"].CGImage);
    
    //每秒粒子产生个数的乘数因子，会和layer的birthRate相乘，然后确定每秒产生的粒子个数
    cell.birthRate = 5;
    //每个粒子存活时长
    cell.lifetime = 4;
    //粒子生命周期范围
    cell.lifetimeRange = 0.3;
    //粒子透明度变化，设置为－0.4，就是每过一秒透明度就减少0.4，这样就有消失的效果,一般设置为负数。
    cell.alphaSpeed = -0.1;
    cell.alphaRange = 1;
    //粒子的速度
    cell.velocity = 700;
    //粒子的速度范围
    cell.velocityRange = 300;
    //周围发射的角度，如果为M_PI*2 就可以从360度任意位置发射
    cell.emissionRange = M_PI / 3;
    //粒子内容的颜色
    //    cell.color = [[UIColor whiteColor] CGColor];
    
    //设置了颜色变化范围后每次产生的粒子的颜色都是随机的
    cell.redRange = 1;
    cell.blueRange = 1;
    cell.greenRange = 1;
    
    //缩放比例
    cell.scale = 0.1;
    //缩放比例范围
    cell.scaleRange = 0.02;
    
    //          //粒子的初始发射方向
    //          cell.emissionLongitude = M_PI  / 2;
    //Y方向的加速度
    cell.yAcceleration = 800;
    //X方向加速度
    cell.xAcceleration = 0.0;
    
    
    
    CAEmitterLayer *_emitterLayer = [CAEmitterLayer layer];
    
    //发射位置
    _emitterLayer.emitterPosition = CGPointMake(200, 450);
    //粒子产生系数，默认为1
    _emitterLayer.birthRate = 1;
    //发射器的尺寸
    _emitterLayer.emitterSize = CGSizeMake(1, 1);
    //发射的形状
    _emitterLayer.emitterShape = kCAEmitterLayerLine;
    //发射的模式
    _emitterLayer.emitterMode = kCAEmitterLayerOutline;
    //渲染模式
    _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    _emitterLayer.masksToBounds = NO;
    //_emitterLayer.zPosition = -1;
    _emitterLayer.emitterCells = @[cell];
    //emitterView是自己创建的一个View
    [self.superview.layer addSublayer:_emitterLayer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _emitterLayer.birthRate = 0;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_emitterLayer removeFromSuperlayer];
    });
}

/*
 CA_EXTERN NSString * const kCAEmitterLayerPoint//点
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCAEmitterLayerLine//线
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCAEmitterLayerRectangle//矩形
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCAEmitterLayerCuboid//立方体
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCAEmitterLayerCircle//圆形
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCAEmitterLayerSphere//球形
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 */


/*
 CA_EXTERN NSString * const kCAEmitterLayerUnordered//粒子是无序出现的，多个发射源将混合
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCAEmitterLayerOldestFirst//声明久的粒子会被渲染在最上层
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCAEmitterLayerOldestLast//年轻的粒子会被渲染在最上层
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCAEmitterLayerBackToFront//粒子的渲染按照Z轴的前后顺序进行
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 CA_EXTERN NSString * const kCAEmitterLayerAdditive//进行粒子混合
 CA_AVAILABLE_STARTING (10.6, 5.0, 9.0, 2.0);
 */
@end
