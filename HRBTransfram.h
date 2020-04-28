//
//  HRBTransfram.h
//  FrameWork
//
//  Created by SZJ on 2020/4/28.
//  Copyright © 2020 SZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRBTransfram : NSObject
/// 形变 缩放 需要设置缩放比例 value
- (HRBTransfram *)zoom;
/// 形变 旋转 需要设置旋转角度 value
- (HRBTransfram *)rotate;
/// 形变 平移 需要设置平移位置 point
- (HRBTransfram *)translation;
/// 形变 翻转 需要设置翻转方向 point 翻转角度 value
- (HRBTransfram *)transform3D;
/// 形变值 (x:水平方向,y:竖直方向)
- (HRBTransfram *(^)(CGPoint))point;
/// 形变值 (角度/缩放比例)
- (HRBTransfram *(^)(float))value;

/// 设置形变
- (CGAffineTransform)alreadyToWork:(CGAffineTransform)transform;
@end
