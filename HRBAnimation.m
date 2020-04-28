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
- (void)beginAnimation:(CALayer *)layer{
    [self alreadyToWork];
    [layer addAnimation:self.animation forKey:@"HRBAnimation"];
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

+ (void)beginGroupAnimation:(CALayer *)layer animations:(NSArray *)animations set:(HRBAnimation *)set{
    CAAnimationGroup *group = [CAAnimationGroup animation];
       NSMutableArray *groupAnimations = @[].mutableCopy;
       for (HRBAnimation *a in animations) {
           [a alreadyToWork];
           if (a.animation != nil)[groupAnimations addObject:a.animation];
       }
       group.animations = groupAnimations;
       group.duration = set->_duration;
       if (set->_repeatCount == -1)  set->_repeatCount = MAXFLOAT;
       group.repeatCount = set->_repeatCount;
       [layer addAnimation:group forKey:@"HRBAnimations"];
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




