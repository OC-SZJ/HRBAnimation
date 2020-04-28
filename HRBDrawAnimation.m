//
//  HRBDrawAnimation.m
//  FrameWork
//
//  Created by SZJ on 2020/4/28.
//  Copyright © 2020 SZJ. All rights reserved.
//

#import "HRBDrawAnimation.h"

#import "HRBAnimationOption.h"
@implementation HRBDrawAnimation
{
    HRBDrawAnimationType _type;
    // 线的参数
    float _duration;
    NSArray *_values;
    float _lineWidth;
    UIColor *_strokeColor;
    UIColor *_fillColor;
    // 字的参数
    UIColor *_textColor;
    UIFont *_font;
    NSString *_string;
    CGRect _textRect;
    
    // 图的参数
    UIImage *_imageContent;
    float _imageCornerRadius;
    CGRect _imageRect;
    
    //图层
    CAShapeLayer *_lineLayer;
    CATextLayer *_textLayer;
    CALayer *_imageLayer;
}
#pragma mark --- set ---
-(HRBDrawAnimation *)line{
    self->_type = HRBDrawAnimationType_Line | HRBDrawAnimationDrawType_Parallel;
    return self;
}
-(HRBDrawAnimation *)circular{
    self->_type = HRBDrawAnimationType_Circular | HRBDrawAnimationDrawType_Parallel;
    return self;
}
-(HRBDrawAnimation *)word{
    self->_type = HRBDrawAnimationType_Word | HRBDrawAnimationDrawType_Parallel;
    return self;
}
-(HRBDrawAnimation *)image{
    self->_type = HRBDrawAnimationType_Image | HRBDrawAnimationDrawType_Parallel;
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
-(HRBDrawAnimation *)serialWord{
    self->_type = HRBDrawAnimationType_Word | HRBDrawAnimationDrawType_Serial;
    return self;
}
-(HRBDrawAnimation *)serialImage{
    self->_type = HRBDrawAnimationType_Image | HRBDrawAnimationDrawType_Serial;
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

-(HRBDrawAnimation *(^)(UIColor *))textColor{
    HRBDrawAnimation *(^a)(UIColor *) = ^(UIColor * textColor){
        self->_textColor = textColor;
        return self;
    };
    return a;
}
-(HRBDrawAnimation *(^)(UIFont *))font{
   HRBDrawAnimation *(^a)(UIFont *) = ^(UIFont * font){
        self->_font = font;
        return self;
    };
    return a;
}
-(HRBDrawAnimation *(^)(NSString *))string{
    HRBDrawAnimation *(^a)(NSString *) = ^(NSString * string){
        self->_string = string;
        return self;
    };
    return a;
}
-(HRBDrawAnimation *(^)(CGRect))textRect{
    HRBDrawAnimation *(^a)(CGRect) = ^(CGRect textRect){
           self->_textRect = textRect;
           return self;
       };
       return a;
}
-(HRBDrawAnimation *(^)(CGRect))imageRect{
    HRBDrawAnimation *(^a)(CGRect) = ^(CGRect imageRect){
           self->_imageRect = imageRect;
           return self;
       };
       return a;
}
-(HRBDrawAnimation *(^)(UIImage *))imageContent{
    HRBDrawAnimation *(^a)(UIImage *) = ^(UIImage* imageContent){
              self->_imageContent = imageContent;
              return self;
          };
          return a;
}
-(HRBDrawAnimation *(^)(float))imageCornerRadius{
    HRBDrawAnimation *(^a)(float) = ^(float imageCornerRadius){
           self->_imageCornerRadius = imageCornerRadius;
           return self;
       };
       return a;
}
#pragma mark --- get ---
-(CAShapeLayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = CAShapeLayer.layer;
    }
    return _lineLayer;
}

-(CATextLayer *)textLayer{
    if (!_textLayer) {
        _textLayer = CATextLayer.layer;
    }
    return _textLayer;
}

-(CALayer *)imageLayer{
    if (!_imageLayer) {
        _imageLayer = CALayer.layer;
    }
    return _imageLayer;
}

-(__kindof CALayer *)layer{
    
    if (_type & HRBDrawAnimationType_Word) {
        return [self textLayer];
    }
    if (_type & HRBDrawAnimationType_Image) {
        return [self imageLayer];
    }
    return [self lineLayer];
}

#pragma mark --- 方法 ---
- (void)alreadyToWork:(CALayer *)layer{
    if (_type & HRBDrawAnimationType_Word)[self handleWord:layer];
    if (_type & HRBDrawAnimationType_Image)[self handleImage:layer];
    if (_type & HRBDrawAnimationType_Line)[self handleLine:layer];
    if (_type & HRBDrawAnimationType_Circular)[self handleCircular:layer];
}

- (void)handleLine:(CALayer *)layer{
    CAShapeLayer *shapLayer = self.lineLayer;
    UIBezierPath * path = UIBezierPath.bezierPath;
    NSMutableArray *arr = _values.mutableCopy;
    CGPoint position = HRBCGPointNull;
    
    if (arr.count){
        position = [arr[0] CGPointValue];
        [path moveToPoint:position];
        [arr removeFirstObject];
    }
    for (NSValue *value in arr) {
        [path addLineToPoint:value.CGPointValue];
    }
    
    
    if (!CGPointEqualToPoint(position, HRBCGPointNull)) {
        shapLayer.position = position;
        shapLayer.anchorPoint = CGPointMake(position.x / layer.bounds.size.width, position.y / layer.size.height);
    }
    shapLayer.lineWidth = _lineWidth ? _lineWidth : 1.5f;
    shapLayer.strokeColor = (_strokeColor ? _strokeColor : UIColor.blackColor).CGColor;
    shapLayer.fillColor = (_fillColor ? _fillColor : UIColor.clearColor).CGColor;
    shapLayer.path = path.CGPath;
    shapLayer.bounds = layer.bounds;
}
- (void)handleCircular:(CALayer *)layer{
    CAShapeLayer *shapLayer = self.lineLayer;
    UIBezierPath * path = UIBezierPath.bezierPath;
    NSMutableArray *arr = _values.mutableCopy;
    CGPoint position = HRBCGPointNull;
    
    for (NSValue *value in arr) {
        HRBCircularSet set;
        [value getValue:&set];
        if (set.isBezierPath) {
            [path moveToPoint:set.beginPoint];
            position = set.beginPoint;
            if (CGPointEqualToPoint(set.secondPoint, HRBCGPointNull)) {
                [path addQuadCurveToPoint:set.endPoint controlPoint:set.firstPoint];
            }else{
                [path addCurveToPoint:set.endPoint controlPoint1:set.firstPoint controlPoint2:set.secondPoint];
            }
        }else{
            position = set.center;
            [path addArcWithCenter:set.center radius:set.radius startAngle:HRBAngleToRadian(set.startAngle) endAngle:HRBAngleToRadian(set.endAngle) clockwise:set.clockwise];
        }
    }
    
    if (!CGPointEqualToPoint(position, HRBCGPointNull)) {
        shapLayer.position = position;
        shapLayer.anchorPoint = CGPointMake(position.x / layer.bounds.size.width, position.y / layer.size.height);
    }
    shapLayer.lineWidth = _lineWidth ? _lineWidth : 1.5f;
    shapLayer.strokeColor = (_strokeColor ? _strokeColor : UIColor.blackColor).CGColor;
    shapLayer.fillColor = (_fillColor ? _fillColor : UIColor.clearColor).CGColor;
    shapLayer.path = path.CGPath;
    shapLayer.bounds = layer.bounds;
}
- (void)handleWord:(CALayer *)layer{
    CATextLayer *layerText = [self textLayer];
    layerText.contentsScale = [UIScreen mainScreen].scale;

    layerText.bounds = (CGRect){CGPointZero,_textRect.size};
    layerText.position = _textRect.origin;

    layerText.wrapped = YES;

    layerText.truncationMode = kCATruncationNone;

    layerText.foregroundColor = (_textColor ? _textColor : UIColor.blackColor).CGColor;
    
    UIFont *font = _font ? _font : [UIFont systemFontOfSize:14];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef =CGFontCreateWithFontName(fontName);
    layerText.font = fontRef;
    layerText.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    layerText.alignmentMode = kCAAlignmentCenter;

    layerText.string = _string;
}
- (void)handleImage:(CALayer *)layer{

    CALayer *layerContant = self.imageLayer;

    layerContant.position = _imageRect.origin;
    layerContant.bounds = (CGRect){CGPointZero,_imageRect.size};
    
    if (_imageCornerRadius) {
        layerContant.cornerRadius = _imageCornerRadius;
        layerContant.masksToBounds = YES;
    }
    
    [layerContant setContents:(id)_imageContent.CGImage];
}
- (void)beginAnimation:(CALayer *)layer{
    CALayer *m_layer = self.layer;
    [layer addSublayer:m_layer];
    if ([m_layer isKindOfClass:CAShapeLayer.class]) {
        CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        base.duration = _duration;
        base.fromValue = @0.f;
        base.toValue = @1.f;
        base.fillMode = kCAFillModeForwards;
        base.removedOnCompletion = NO;
        [self.layer addAnimation:base forKey:@"HRBDrawAnimation"];
    }
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
