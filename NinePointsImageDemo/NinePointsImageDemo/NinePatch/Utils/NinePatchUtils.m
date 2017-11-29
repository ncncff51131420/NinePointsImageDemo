//
//  ninePatchUtils.m
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/28.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import "NinePatchUtils.h"

@implementation NinePatchUtils

//返回图片的宽度
+ (CGFloat)getImageWidth:(UIImage *)image{
    CGFloat width = 0;
    if (image) {
        CGImageRef cgImage = [image CGImage];
        width =  CGImageGetWidth(cgImage);///[UIScreen mainScreen].scale
    }
    return width;
}

//返回图片的高度
+ (CGFloat)getImageHeight:(UIImage *)image{
    CGFloat height = 0;
    if (image) {
        CGImageRef cgImage = [image CGImage];
        height =  CGImageGetHeight(cgImage);
    }
    return height;
}

+ (UIImage*)crop:(CGRect)rect image:(UIImage *)image
{
    CGFloat scale = [image scale];
    rect = CGRectMake(rect.origin.x * scale,
                      rect.origin.y * scale,
                      rect.size.width * scale,
                      rect.size.height * scale);

    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage* result = [UIImage imageWithCGImage:imageRef
                                          scale:scale
                                    orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

@end
