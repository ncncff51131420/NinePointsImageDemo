//
//  UIImage+NinePoints.h
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NinePoints)

// Subimage Slicing
-(UIImage *)subImageInRect:(CGRect)rect;

-(NSArray *)blackAllPixelRangeInLeftStrip;

-(NSArray *)blackAllPixelRangeInUpperStrip;

-(NinePatchContentRange *)getImageContentRange;

- (UIImage*)crop:(CGRect)rect;

@end
