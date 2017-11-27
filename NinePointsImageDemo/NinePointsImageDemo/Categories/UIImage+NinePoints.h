//
//  UIImage+NinePoints.h
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NinePoints)

//通过名字判断是否是点9
- (BOOL)isNinePatchImageFormName:(NSString *)imageName;

//通过底部后右边的黑边数量判断，如果不等于1都认为不是点9图
- (BOOL)isNinePatchImageFormImage:(UIImage *)image;

// Subimage Slicing
-(UIImage *)subImageInRect:(CGRect)rect;

-(NSArray *)blackAllPixelRangeInLeftStrip;

-(NSArray *)blackAllPixelRangeInUpperStrip;

-(NinePatchContentRange *)getImageContentRange;

- (UIImage*)crop:(CGRect)rect;

@end
