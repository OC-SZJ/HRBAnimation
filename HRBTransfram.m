//
//  HRBTransfram.m
//  FrameWork
//
//  Created by SZJ on 2020/4/28.
//  Copyright © 2020 SZJ. All rights reserved.
//

#import "HRBTransfram.h"

#import "HRBAnimationOption.h"
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

- (CGAffineTransform)alreadyToWork:(CGAffineTransform)transform{
    switch (_transframType) {
        case HRBTransframType_translation:{
            CGPoint point = _point;
            transform = CGAffineTransformTranslate(transform, point.x, point.y);
        }
            break;
        case HRBTransframType_zoom:{
            transform = CGAffineTransformScale(transform, _value, _value);
        }
            break;
        case HRBTransframType_rotate:{
            transform = CGAffineTransformRotate(transform, HRBAngleToRadian(_value));
        }
            break;
        case HRBTransframType_transform3D:{
            CGPoint point = _point;
            CATransform3D t_3d;
            t_3d = CATransform3DMakeAffineTransform(transform);
            t_3d = CATransform3DRotate(t_3d, HRBAngleToRadian(_value),point.x, point.y, 0);
            transform = CATransform3DGetAffineTransform(t_3d);
        }
            break;
        default:
            break;
    }
    return transform;
}

@end

