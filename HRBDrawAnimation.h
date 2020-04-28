//
//  HRBDrawAnimation.h
//  FrameWork
//
//  Created by SZJ on 2020/4/28.
//  Copyright © 2020 SZJ. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HRBDrawAnimation : NSObject
/// 画线 需要设置 途经点 CGPoint (一起画)
- (HRBDrawAnimation *)line;
/// 画弧线 需要设置 参数 HRBCircularSet (一起画)
/// 创建贝塞尔曲线 HRBCircularPointsMakeBezierPath
/// 创建标准圆    HRBCircularPointsMakeCircular
- (HRBDrawAnimation *)circular;
/// 画字 需要设置 内容 NSString (一起画)
- (HRBDrawAnimation *)word;
/// 画图 需要设置 图片 UIImage (一起画)
- (HRBDrawAnimation *)image;

/// 画线 需要设置 途经点 CGPoint (一个一个画)
- (HRBDrawAnimation *)serialLine;
/// 画弧线 需要设置 参数 HRBCircularSet (一个一个画)
/// 创建贝塞尔曲线 HRBCircularPointsMakeBezierPath
/// 创建标准圆    HRBCircularPointsMakeCircular
- (HRBDrawAnimation *)serialCircular;
/// 画字 需要设置 内容 NSString (一个一个画)
- (HRBDrawAnimation *)serialWord;
/// 画图 需要设置 图片 UIImage (一个一个画)
- (HRBDrawAnimation *)serialImage;



/// 设置 线的参数
/// 设置 途经点 @(CGPoint) (末尾必须设置nil,不写崩溃)
- (HRBDrawAnimation *(^)(id value, ...))values;
/// 设置动画时长
- (HRBDrawAnimation *(^)(float duration))duration;
/// 设置线条宽度 (默认 1.f)
- (HRBDrawAnimation *(^)(float lineWidth))lineWidth;
/// 设置线条颜色 (默认 黑色)
- (HRBDrawAnimation *(^)(UIColor * strokeColor))strokeColor;
/// 设置填充颜色 (默认 透明)
- (HRBDrawAnimation *(^)(UIColor * fillColor))fillColor;

/// 设置 字的参数
/// 设置 字体颜色 (默认黑色)
- (HRBDrawAnimation *(^)(UIColor *textColor))textColor;
/// 设置 字体大小 (默认 system 14)
- (HRBDrawAnimation *(^)(UIFont * font))font;
/// 设置 内容
- (HRBDrawAnimation *(^)(NSString * string))string;
/// 设置 位置
- (HRBDrawAnimation *(^)(CGRect textRect))textRect;

/// 设置 图的参数
/// 设置 圆角 (默认0)
- (HRBDrawAnimation *(^)(float cornerRadius))imageCornerRadius;
/// 设置 内容 (默认 system 14)
- (HRBDrawAnimation *(^)(UIImage * image))imageContent;
/// 设置 位置
- (HRBDrawAnimation *(^)(CGRect imageRect))imageRect;


/// 绘制的图层(线:CAShapLayer 字:CATextLayer 图:CALayer)
- (__kindof CALayer *)layer;
///准备绘制
- (void)alreadyToWork:(CALayer *)layer;
///开始绘制
+ (void)beginAnimation:(NSMutableArray <HRBDrawAnimation *> *)animations layer:(CALayer *)layer;
@end


