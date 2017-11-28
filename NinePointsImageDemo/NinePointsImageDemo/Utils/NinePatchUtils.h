//
//  ninePatchUtils.h
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/28.
//  Copyright © 2017年 chinaway. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NinePatchUtils : NSObject

//返回图片的宽度
+ (CGFloat)getImageWidth:(UIImage *)image;

//返回图片的高度
+ (CGFloat)getImageHeight:(UIImage *)image;
//图片截取
+ (UIImage*)crop:(CGRect)rect image:(UIImage *)image;

@end
