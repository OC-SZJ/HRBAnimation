//
//  HRBAnimation.m
//  FrameWork
//
//  Created by SZJ on 2020/4/25.
//  Copyright © 2020 SZJ. All rights reserved.
//

#import "HRBAnimation.h"

#import "HRBAnimationOption.h"



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
    [self AngleToRadian];
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
- (void)AngleToRadian{
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
 
    [UIView animateWithDuration:2 animations:^{
        self.transform = transform;
    }];
    
   
    
}

/// 设置形变回到初始状态
- (void)makeTransframToNormal{
    [UIView animateWithDuration:0.5 animations:^{
        self.layer.transform = CATransform3DIdentity;
    }];
   
}
@end



