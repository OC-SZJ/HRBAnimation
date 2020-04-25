//
//  HRBAnimationOption.h
//  FrameWork
//
//  Created by SZJ on 2020/4/25.
//  Copyright © 2020 SZJ. All rights reserved.
//

#import <Foundation/Foundation.h>


/// 3D
///旋转x,y,z分别是绕x,y,z轴旋转
static NSString *HRBAnimationKeyPath_transform = @"transform";
static NSString *HRBAnimationKeyPath_rotation = @"transform.rotation";
static NSString *HRBAnimationKeyPath_rotation_x = @"transform.rotation.x";
static NSString *HRBAnimationKeyPath_rotation_y = @"transform.rotation.y";
static NSString *HRBAnimationKeyPath_rotation_z = @"transform.rotation.z";

///缩放x,y,z分别是对x,y,z方向进行缩放
static NSString *HRBAnimationKeyPath_scale = @"transform.scale";
static NSString *HRBAnimationKeyPath_scale_x = @"transform.scale.x";
static NSString *HRBAnimationKeyPath_scale_y = @"transform.scale.y";
static NSString *HRBAnimationKeyPath_scale_z = @"transform.scale.z";

///平移x,y,z同上
static NSString *HRBAnimationKeyPath_translation = @"transform.translation";
static NSString *HRBAnimationKeyPath_translation_x = @"transform.translation.x";
static NSString *HRBAnimationKeyPath_translation_y = @"transform.translation.y";
static NSString *HRBAnimationKeyPath_translation_z = @"transform.translation.z";

///平面

///CGPoint中心点改变位置，针对平面
static NSString *HRBAnimationKeyPath_position = @"position";
static NSString *HRBAnimationKeyPath_position_x = @"position.x";
static NSString *HRBAnimationKeyPath_position_y = @"position.y";

///CGRect
static NSString *HRBAnimationKeyPath_bounds = @"bounds.size";
static NSString *HRBAnimationKeyPath_bounds_width = @"bounds.size.width";
static NSString *HRBAnimationKeyPath_bounds_height = @"bounds.size.height";
static NSString *HRBAnimationKeyPath_bounds_x = @"bounds.origin.x";
static NSString *HRBAnimationKeyPath_bounds_y = @"bounds.origin.y";

///透明度
static NSString *HRBAnimationKeyPath_opacity = @"opacity";
///背景色
static NSString *HRBAnimationKeyPath_bgColor = @"backgroundColor";
///圆角
static NSString *HRBAnimationKeyPath_cor = @"cornerRadius";
///边框
static NSString *HRBAnimationKeyPath_border_w = @"borderWidth";
///阴影颜色
static NSString *HRBAnimationKeyPath_shadow_color = @"shadowColor";
///偏移量 (CGSize)
static NSString *HRBAnimationKeyPath_shadow_offset = @"shadowOffset";
///阴影透明度
static NSString *HRBAnimationKeyPath_shadow_opacity = @"shadowOpacity";
///阴影圆角
static NSString *HRBAnimationKeyPath_shadow_radius = @"shadowRadius";



typedef NS_ENUM(NSInteger, HRBAnimationType) {
    /// 平移 value传入 @(CGPoint)
    HRBAnimationType_translation = 0,
    /// 旋转 value传入 @(float(角度))
    HRBAnimationType_rotate,
    /// 缩放 value传入 @(float(缩放比例))
    HRBAnimationType_zoom,
    
    /// 翻转 value传入 @(CATransform3DMakeRotation (翻转角度))
    HRBAnimationType_transform3D
    /// angle: 弧度
    /// x:竖直方向 [-1,1]
    /// y:水平方向 [-1,1]
    /// z:暂时没发现有啥用
    /// CATransform3DMakeRotation(angle,x,y,z)
};
typedef NS_ENUM(NSInteger, HRBTransframType) {
    HRBTransframType_Null = 0,
    /// 平移
    HRBTransframType_translation,
    /// 旋转
    HRBTransframType_rotate,
    /// 缩放
    HRBTransframType_zoom,
    /// 翻转
    HRBTransframType_transform3D

};

/// 角度转弧度
static inline float HRBAngleToRadian(float angle){
    return angle * M_PI / 180.f;
}
