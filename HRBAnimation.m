//
//  HRBAnimation.m
//  FrameWork
//
//  Created by SZJ on 2020/4/25.
//  Copyright © 2020 SZJ. All rights reserved.
//

#import "HRBAnimation.h"




@interface HRBAnimation()<CAAnimationDelegate>
@property (nonatomic,strong) CAAnimation * animation;
@property (nonatomic,weak) UIView * animation_view;
@end


@implementation HRBAnimation
{
@public
    float _duration;
    float _repeatCount;
    NSString *_keyPath;
    NSArray *_values;
}

-(HRBAnimation *(^)(float))duration{
    HRBAnimation *(^a)(float) = ^(float duration){
        self->_duration = duration;
        return self;
    };
    return a;
}

-(HRBAnimation *(^)(int))repeatCount{
    HRBAnimation *(^a)(int) = ^(int repeatCount){
        self->_repeatCount = repeatCount;
        return self;
    };
    return a;
}

-(HRBAnimation *)zoom{
    _keyPath = HRBAnimationKeyPath_scale;
    return self;
}
-(HRBAnimation *)rotate{
    _keyPath = HRBAnimationKeyPath_rotation;
    return self;
}
-(HRBAnimation *)translation{
    _keyPath = HRBAnimationKeyPath_translation;
    return self;
}
-(HRBAnimation *)transform3D{
    _keyPath = HRBAnimationKeyPath_transform;
    return self;
}
-(HRBAnimation *(^)(id value, ...))values{
    HRBAnimation *(^a)(id value, ... ) = ^(id value, ...){
        
        NSMutableArray *valueArr = @[value].mutableCopy;
        if (value){
            va_list args;
            va_start(args, value);
            NSNumber * otherValue;
            //要是崩溃在这了 看看value传值的时候 是不是没设置nil
            while ((otherValue = va_arg(args, NSNumber *)))
            {
                [valueArr addObject:otherValue];
            }
            va_end(args);
        }
        if (valueArr.count != 0) {
            self->_values = valueArr;
        }
        return self;
    };
    return a;
}

- (void)alreadyToWork{
    CAPropertyAnimation *animation = nil;
    [self angleToRadian];
    if (_values.count == 1) {
        animation = CABasicAnimation.new;
        [(CABasicAnimation *)animation setToValue:_values[0]];
    }else{
        animation = CAKeyframeAnimation.new;
        if ([_keyPath isEqualToString:HRBAnimationKeyPath_rotation]) {
            NSMutableArray *v = _values.mutableCopy;
            [v insertObject:@(CGPointZero) atIndex:0];
            [(CAKeyframeAnimation *)animation setValues:v];
        }else{
            [(CAKeyframeAnimation *)animation setValues:_values];
        }
    }
    animation.duration = _duration;
    if (_repeatCount == -1)  _repeatCount = MAXFLOAT;
    animation.repeatCount = _repeatCount;
    animation.keyPath = _keyPath;
    animation.cumulative = YES;
    self.animation = animation;
}
/*
 如果 旋转  把角度 转换成弧度
 */
- (void)angleToRadian{
    NSMutableArray *a = @[].mutableCopy;
    if (_keyPath.length > 0 && [_keyPath isEqualToString:HRBAnimationKeyPath_rotation]) {
        for (NSNumber *number in _values) {
            [a addObject:@(HRBAngleToRadian(number.floatValue))];
        }
    }
    
    if (a.count) _values = a;
}

#pragma mark --- CAAnimationDelegate ---
/* Called when the animation begins its active duration. */
- (void)animationDidStart:(CAAnimation *)anim{
    if (self.start)self.start();
}
/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.finish) self.finish(flag);
    //    [self.animation_view.layer removeAnimationForKey:@"HRBAnimation"];
}

@end

@implementation HRBTransfram
{
@public
    /// 形变类型
    HRBTransframType _transframType;
    /// 形变值 (水平方向,竖直方向)
    CGPoint _point;
    
    float _value;
}
-(HRBTransfram *)zoom{
    _transframType = HRBTransframType_zoom;
    return self;
}
-(HRBTransfram *)rotate{
    _transframType = HRBTransframType_rotate;
    return self;
}
-(HRBTransfram *)translation{
    _transframType = HRBTransframType_translation;
    return self;
}
-(HRBTransfram *)transform3D{
    _transframType = HRBTransframType_transform3D;
    return self;
}
-(HRBTransfram *(^)(CGPoint))point{
    HRBTransfram *(^a)(CGPoint) = ^(CGPoint point){
        self->_point = point;
        return self;
    };
    return a;
}
-(HRBTransfram *(^)(float))value{
    HRBTransfram *(^a)(float) = ^(float value){
        self->_value = value;
        return self;
    };
    return a;
}
@end

@implementation HRBDrawAnimation
{
    HRBDrawAnimationType _type;
    float _duration;
    NSArray *_values;
    float _lineWidth;
    UIColor *_strokeColor;
    UIColor *_fillColor;
@public
    UIBezierPath *_path;
    
}
-(HRBDrawAnimation *)line{
    self->_type = HRBDrawAnimationType_Line | HRBDrawAnimationDrawType_Parallel;
    return self;
}
-(HRBDrawAnimation *)circular{
    self->_type = HRBDrawAnimationType_Circular | HRBDrawAnimationDrawType_Parallel;
    return self;
}
-(HRBDrawAnimation *)serialLine{
    self->_type = HRBDrawAnimationType_Line | HRBDrawAnimationDrawType_Serial;
    return self;
}
-(HRBDrawAnimation *)serialCircular{
    self->_type = HRBDrawAnimationType_Circular | HRBDrawAnimationDrawType_Serial;
    return self;
}
-(HRBDrawAnimation *(^)(float))duration{
    HRBDrawAnimation *(^a)(float) = ^(float duration){
        self->_duration = duration;
        return self;
    };
    return a;
}
-(HRBDrawAnimation *(^)(float))lineWidth{
    HRBDrawAnimation *(^a)(float) = ^(float lineWidth){
        self->_lineWidth = lineWidth;
        return self;
    };
    return a;
}
-(HRBDrawAnimation *(^)(UIColor *))strokeColor{
    HRBDrawAnimation *(^a)(UIColor *) = ^(UIColor * strokeColor){
        self->_strokeColor = strokeColor;
        return self;
    };
    return a;
}

-(HRBDrawAnimation *(^)(UIColor *))fillColor{
    HRBDrawAnimation *(^a)(UIColor *) = ^(UIColor * fillColor){
        self->_fillColor = fillColor;
        return self;
    };
    return a;
}

-(HRBDrawAnimation *(^)(id value, ...))values{
    HRBDrawAnimation *(^a)(id value, ... ) = ^(id value, ...){
        
        NSMutableArray *valueArr = @[value].mutableCopy;
        if (value){
            va_list args;
            va_start(args, value);
            NSValue * otherValue;
            //要是崩溃在这了 看看value传值的时候 是不是没设置nil
            while ((otherValue = va_arg(args, NSValue *)))
            {
                [valueArr addObject:otherValue];
            }
            va_end(args);
        }
        if (valueArr.count != 0) {
            self->_values = valueArr;
        }
        return self;
    };
    return a;
}
- (void)alreadyToWork:(CALayer *)layer{
    
    UIBezierPath * path = UIBezierPath.bezierPath;
    NSMutableArray *arr = _values.mutableCopy;
    
    
    if (_type & HRBDrawAnimationType_Line) {
        if (arr.count){
            [path moveToPoint:[arr[0] CGPointValue]];
            [arr removeFirstObject];
        }
        for (NSValue *value in arr) {
            [path addLineToPoint:value.CGPointValue];
        }
    }
    if (_type & HRBDrawAnimationType_Circular) {
        for (NSValue *value in arr) {
            HRBCircularSet set;
            [value getValue:&set];
            if (set.isBezierPath) {
                [path moveToPoint:set.beginPoint];
                if (CGPointEqualToPoint(set.secondPoint, HRBCGPointNull)) {
                    [path addQuadCurveToPoint:set.endPoint controlPoint:set.firstPoint];
                }else{
                    [path addCurveToPoint:set.endPoint controlPoint1:set.firstPoint controlPoint2:set.secondPoint];
                }
            }else{
                [path addArcWithCenter:set.center radius:set.radius startAngle:HRBAngleToRadian(set.startAngle) endAngle:HRBAngleToRadian(set.endAngle) clockwise:set.clockwise];
            }
        }
    }
    _path = path;
}
- (void)beginAnimation:(CALayer *)layer{
    CAShapeLayer *shapLayer = CAShapeLayer.layer;
    shapLayer.lineWidth = _lineWidth ? _lineWidth : 1.5f;
    shapLayer.strokeColor = (_strokeColor ? _strokeColor : UIColor.blackColor).CGColor;
    shapLayer.fillColor = (_fillColor ? _fillColor : UIColor.clearColor).CGColor;
    shapLayer.path = _path.CGPath;
    shapLayer.frame = layer.bounds;
    [layer addSublayer:shapLayer];
    CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    base.duration = _duration;
    base.fromValue = @0.f;
    base.toValue = @1.f;
    base.fillMode = kCAFillModeForwards;
    base.removedOnCompletion = NO;
    [shapLayer addAnimation:base forKey:@"HRBDrawAnimation"];

    
}

+ (void)beginAnimation:(NSMutableArray <HRBDrawAnimation *> *)animations layer:(CALayer *)layer{
    
    float time = 0.f;
    for (HRBDrawAnimation *animation in animations) {
        if (animation->_type & HRBDrawAnimationDrawType_Parallel) {
            [animation beginAnimation:layer];
        }
        if (animation->_type & HRBDrawAnimationDrawType_Serial) {
            [animation performSelector:@selector(beginAnimation:) withObject:layer afterDelay:time];
            time += animation->_duration;
        }
        
    }    
}


@end

@implementation UIView (HRBAnimation)

-(void)makeAnimation:(void(^)(HRBAnimation *animation))make{
    HRBAnimation *animation = HRBAnimation.new;
    make(animation);
    animation.animation_view = self;
    [animation alreadyToWork];
    [self.layer addAnimation:animation.animation forKey:@"HRBAnimation"];
}
-(void)makeAnimationsForCount:(NSInteger)count animations:(void(^)(NSMutableArray <HRBAnimation *> *animations , HRBAnimation *groupAnimations))make{
    NSMutableArray <HRBAnimation *>*animations = @[].mutableCopy;
    for (int i = 0; i < count; i++) {
        [animations addObject:HRBAnimation.new];
    }
    HRBAnimation *animation = HRBAnimation.new;
    make(animations,animation);
    CAAnimationGroup *group = [CAAnimationGroup animation];
    NSMutableArray *groupAnimations = @[].mutableCopy;
    for (HRBAnimation *a in animations) {
        [a alreadyToWork];
        if (a.animation != nil)[groupAnimations addObject:a.animation];
    }
    group.animations = groupAnimations;
    group.duration = animation->_duration;
    if (animation->_repeatCount == -1)  animation->_repeatCount = MAXFLOAT;
    group.repeatCount = animation->_repeatCount;
    [self.layer addAnimation:group forKey:@"HRBAnimations"];
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
        switch (t->_transframType) {
            case HRBTransframType_translation:{
                CGPoint point = t->_point;
                transform = CGAffineTransformTranslate(transform, point.x, point.y);
            }
                break;
            case HRBTransframType_zoom:{
                transform = CGAffineTransformScale(transform, t->_value, t->_value);
            }
                break;
            case HRBTransframType_rotate:{
                transform = CGAffineTransformRotate(transform, HRBAngleToRadian(t->_value));
            }
                break;
            case HRBTransframType_transform3D:{
                CGPoint point = t->_point;
                CATransform3D t_3d;
                t_3d = CATransform3DMakeAffineTransform(transform);
                t_3d = CATransform3DRotate(t_3d, HRBAngleToRadian(t->_value),point.x, point.y, 0);
                transform = CATransform3DGetAffineTransform(t_3d);
            }
                break;
            default:
                return;
                break;
        }
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = transform;
    }];
    
}

/// 设置形变回到初始状态
- (void)makeTransframToNormal{
    [UIView animateWithDuration:0.5 animations:^{
        self.layer.transform = CATransform3DIdentity;
    }];
}

- (void)makeDrawAnimationForCount:(NSInteger)count drawAnimations:(void(^)(NSMutableArray <HRBDrawAnimation *>*))make{
    NSMutableArray <HRBDrawAnimation *>*animations = @[].mutableCopy;
    for (int i = 0; i < count; i++) {
        [animations addObject:HRBDrawAnimation.new];
    }
    make(animations);
    for (HRBDrawAnimation *drawAnimation in animations) {
          [drawAnimation alreadyToWork:self.layer];
    }
    [HRBDrawAnimation beginAnimation:animations layer:self.layer];
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



