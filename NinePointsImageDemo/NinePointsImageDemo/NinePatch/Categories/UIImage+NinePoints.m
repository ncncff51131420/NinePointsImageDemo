//
//  UIImage+NinePoints.m
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//
#import "UIImage+NinePoints.h"
#import "NinePatchUtils.h"
#import "PointLocation.h"
#import "NinePointVO.h"
#import "NinePatchGlobal.h"

static   const  NSString *kNinePatchEndName = @".9.png";

@implementation UIImage (NinePoints)
#pragma mark - check

- (BOOL)isNinePatchImageFormName:(NSString *)imageName{

    BOOL isNinePatch = NO;
    if (imageName && imageName.length >kNinePatchEndName.length) {
        NSString *name = [imageName substringFromIndex:(imageName.length-kNinePatchEndName.length)];
        if ([kNinePatchEndName isEqualToString:name]) {
            isNinePatch = YES;
        }
    }
    return isNinePatch;
}

- (BOOL)isNinePatchImageFormImage:(UIImage *)image{

    BOOL isNinePatch = NO;

    if (image) {
        NSArray *bottomPixelRangeAry;
        NSArray *rightPixelRangeAry;
        UIImage *lowerStrip = [self lowerStrip];
        if (lowerStrip) {
            bottomPixelRangeAry = [lowerStrip blackAllPixelRangeAsHorizontalStrip];
        }
        if (bottomPixelRangeAry.count == 1) {
            UIImage *rightStrip = [self rightStrip];
            if (rightStrip) {
                rightPixelRangeAry = [rightStrip blackAllPixelRangeAsVerticalStrip];
            }
            if (rightPixelRangeAry.count == 1) {
                isNinePatch = YES;
            }
        }
    }

    return isNinePatch;
}
#pragma mark - allPointsAry
-(NSArray *)blackAllPixelRangeInUpperStrip {
    NSArray *blackPixelRangeAry;
    UIImage *upperStrip = [self upperStrip];
    if (upperStrip) {
        blackPixelRangeAry = [upperStrip blackAllPixelRangeAsHorizontalStrip];
    }
    return blackPixelRangeAry;
}

-(NSArray *)blackAllPixelRangeInLeftStrip {
    NSArray *blackPixelRangeAry;
    UIImage *leftrStri = [self leftStrip];
    if (leftrStri) {
        blackPixelRangeAry = [leftrStri blackAllPixelRangeAsVerticalStrip];
    }
    return blackPixelRangeAry;
}

- (NinePatchContentRange *)getImageContentRange{

    NSArray *bottomPixelRangeAry;
    NSArray *rightPixelRangeAry;
    NinePatchContentRange *contentRange = [[NinePatchContentRange alloc] init];
    UIImage *lowerStrip = [self lowerStrip];
    if (lowerStrip) {
        bottomPixelRangeAry = [lowerStrip blackAllPixelRangeAsHorizontalStrip];
    }
    if (bottomPixelRangeAry && bottomPixelRangeAry.count>0) {
        PointLocation *startLocation = bottomPixelRangeAry[0];
        contentRange.leftEdgeDistance = startLocation.startLocation;

        PointLocation *endLocation = bottomPixelRangeAry[bottomPixelRangeAry.count -1];

        contentRange.rightEdgeDistance = lowerStrip.size.width - endLocation.endLocation;
    }

    UIImage *rightStrip = [self rightStrip];
    if (rightStrip) {
        rightPixelRangeAry = [rightStrip blackAllPixelRangeAsVerticalStrip];
    }
    if (rightPixelRangeAry && rightPixelRangeAry.count>0) {
        PointLocation *startLocation = rightPixelRangeAry[0];
        contentRange.topEdgeDistance = startLocation.startLocation;

        PointLocation *endLocation = rightPixelRangeAry[rightPixelRangeAry.count -1];

        contentRange.bottomEdgeDistance =rightStrip.size.height - endLocation.endLocation;
    }
    return contentRange;
}

#pragma mark Strips - Slicing
-(UIImage *)upperStrip {
    return [self subImageInRect:[self upperStripRect]];
}

-(UIImage *)lowerStrip {
    return [self subImageInRect:[self lowerStripRect]];
}

-(UIImage *)leftStrip {
    return [self subImageInRect:[self leftStripRect]];
}

-(UIImage *)rightStrip {
    return [self subImageInRect:[self rightStripRect]];
}

//截取图片
-(UIImage *)subImageInRect:(CGRect)rect {
    UIImage *subImage = nil;
    CGImageRef cir = [self CGImage];
    if (cir) {
        rect.origin.x *= self.scale;
        rect.origin.y *= self.scale;
        rect.size.width *= self.scale;
        rect.size.height *= self.scale;
        CGImageRef subCGImage = CGImageCreateWithImageInRect(cir, rect);
        if (subCGImage) {
            subImage = [UIImage imageWithCGImage:subCGImage scale:self.scale orientation:self.imageOrientation];
            CGImageRelease(subCGImage);
        } else {
            NSLog(@"Couldn't create subImage in rect: '%@'.", NSStringFromCGRect(rect));
        }
    } else {
        NSLog(@"self.CGImage is somehow nil.");
    }

    return subImage;
}

#pragma mark Strips - Sizing
-(CGRect)upperStripRect {
    CGSize selfSize = [self size];
    CGFloat stripWidth = TruncateAtZero(selfSize.width - (2.0f/self.scale));
    return CGRectMake((1.0f/self.scale), 0.0f, stripWidth, 1.0f/self.scale);
}

-(CGRect)lowerStripRect {
    CGSize selfSize = [self size];
    CGFloat stripWidth = TruncateAtZero(selfSize.width - (2.0f/self.scale));
    return CGRectMake(1.0f/self.scale, selfSize.height - (1.0f/self.scale), stripWidth, 1.0f/self.scale);
}

-(CGRect)leftStripRect {
    CGSize selfSize = [self size];
    CGFloat stripHeight = TruncateAtZero(selfSize.height - (2.0f/self.scale));
    return CGRectMake(0.0f, 1.0f/self.scale, 1.0f/self.scale, stripHeight);
}

-(CGRect)rightStripRect {
    CGSize selfSize = [self size];
    CGFloat stripHeight = TruncateAtZero(selfSize.height - (2.0f/self.scale));
    return CGRectMake(selfSize.width - (1.0f/self.scale), 1.0f/self.scale, 1.0f/self.scale, stripHeight);
}


-(NSArray *)blackAllPixelRangeAsHorizontalStrip {
    NSMutableArray *turAry = [NSMutableArray  arrayWithCapacity:0];
    NSUInteger firstBlackPixel = NSNotFound;
    NSUInteger lastBlackPixel = NSNotFound;
    if ([self size].width > 0.0f) {
        CGImageRef cgImage = [self CGImage];

        NSUInteger width = CGImageGetWidth(cgImage);
        NSUInteger height = CGImageGetHeight(cgImage);
        NSUInteger bytesPerRow = width * RGBABytesPerPixel;
        NSUInteger bitsPerComponent = 8;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        UInt8 *pixelByteData = malloc(width * height * RGBABytesPerPixel);

        CGContextRef context = CGBitmapContextCreate(
                                                     (void *)pixelByteData,
                                                     width,
                                                     height,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorSpace,
                                                     kCGImageAlphaPremultipliedLast);

        CGRect contextBounds = CGRectMake(0.0f, 0.0f, width, height);
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, contextBounds);

        // Having normalized the context we now paint the image
        CGContextDrawImage(context, contextBounds, cgImage);
        TURGBAPixel *pixelData = (TURGBAPixel *) CGBitmapContextGetData(context);
        if (pixelData) {

            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            PointLocation *location ;
            for (NSUInteger i = 0; i < width; i++) {
                if (RGBAPixelIsBlack(pixelData[i])&&!RGBAPixelIsBlack(pixelData[i-1])) {
                    lastBlackPixel = i;
                    location = [[PointLocation alloc]init];
                    location.startLocation = i;
                }
                if (!RGBAPixelIsBlack(pixelData[i]) && location && RGBAPixelIsBlack(pixelData[i-1])) {
                    location.endLocation = i-1;
                    [array addObject:location];
                }

            }
            if ([array count] > 0) {
                for (PointLocation *location in array) {
                    firstBlackPixel = location.startLocation;
                    lastBlackPixel = location.endLocation;
                    if ((firstBlackPixel != NSNotFound) && (lastBlackPixel != NSNotFound)) {

                        NSInteger length = lastBlackPixel - firstBlackPixel;

                        if (length >= 0) {
                            length += 1;
                        } else {
                            length = 0;
                        }
                        location.length = length / self.scale;
                        [turAry addObject:location];
                    }
                }
            }
        }
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        free(pixelByteData);
    }
    return turAry;
}

-(NSArray *)blackAllPixelRangeAsVerticalStrip {

    NSMutableArray *turAry = [NSMutableArray  arrayWithCapacity:0];
    NSUInteger firstBlackPixel = NSNotFound;
    NSUInteger lastBlackPixel = NSNotFound;
    if ([self size].height > 0.0f) {
        CGImageRef cgImage = [self CGImage];

        NSUInteger width = CGImageGetWidth(cgImage);
        NSUInteger height = CGImageGetHeight(cgImage);
        NSUInteger bytesPerRow = width * RGBABytesPerPixel;
        NSUInteger bitsPerComponent = 8;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        UInt8 *pixelByteData = malloc(width * height * RGBABytesPerPixel);

        CGContextRef context = CGBitmapContextCreate(
                                                     (void *)pixelByteData,
                                                     width,
                                                     height,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorSpace,
                                                     kCGImageAlphaPremultipliedLast);

        // NEW: seeing nondetermnistic errors where sometimes the image is parsed right
        // and sometimes not parsed right. The followthing three lines paint the context
        // to solid white, then paste the image over it, so this ought to normalize the
        // outcome a bit more.
        CGRect contextBounds = CGRectMake(0.0f, 0.0f, width, height);
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, contextBounds);

        // Having normalized the context we now paint the image
        CGContextDrawImage(context, contextBounds, cgImage);
        TURGBAPixel *pixelData = (TURGBAPixel *) CGBitmapContextGetData(context);
        if (pixelData) {

            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            PointLocation *location ;
            for (NSUInteger i = 0; i < height; i++) {
                if (RGBAPixelIsBlack(pixelData[i])&&!RGBAPixelIsBlack(pixelData[i-1])) {
                    lastBlackPixel = i;
                    location = [[PointLocation alloc]init];
                    location.startLocation = i;
                }
                if (!RGBAPixelIsBlack(pixelData[i]) && location && RGBAPixelIsBlack(pixelData[i-1])) {
                    location.endLocation = i-1;
                    [array addObject:location];
                }

            }
            if ([array count] > 0) {
                for (PointLocation *location in array) {
                    firstBlackPixel = location.startLocation;
                    lastBlackPixel = location.endLocation;
                    if ((firstBlackPixel != NSNotFound) && (lastBlackPixel != NSNotFound)) {

                        NSInteger length = lastBlackPixel - firstBlackPixel;


                        if (length >= 0) {
                            length += 1;
                        } else {
                            length = 0;
                        }
                        location.length = length / self.scale;
                        [turAry addObject:location];
                    }
                }    }
        }
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        free(pixelByteData);
    }
    return turAry;
}

- (NSArray *) getAllNinePatchAreaPoint:(UIImage *) image{
    NSArray *ninePatchHorizontalPoints =  [image blackAllPixelRangeInUpperStrip];
    NSArray *ninePatchVerticalPoints = [image blackAllPixelRangeInLeftStrip];
    NSMutableArray *array   = [NSMutableArray arrayWithCapacity:1];
    UIImage* ninepatch = [NinePatchUtils crop:CGRectMake(1, 1, image.size.width - 2, image.size.height - 2) image:image];

    CGFloat ninePatchWidth  = [NinePatchUtils getImageWidth:ninepatch];
    CGFloat ninePatchHeight = [NinePatchUtils getImageHeight:ninepatch];




    if (ninePatchHorizontalPoints.count > 0) {
        for (int i = 0 ;i<ninePatchHorizontalPoints.count ;i++) {

            PointLocation *horizontalLocation = ninePatchHorizontalPoints[i];
            //纵向有拉伸
            if (ninePatchVerticalPoints.count > 0) {
                for (int j = 0 ; j< ninePatchVerticalPoints.count ;j++) {

                    PointLocation *verticalLocation = ninePatchVerticalPoints[j];

                    NinePointVO * pointVO = [[NinePointVO alloc] init];
                    pointVO.leftSpacing = horizontalLocation.startLocation;

                    pointVO.rightSpacing = ninePatchWidth - horizontalLocation.endLocation;
                    //宽度一个像素都不足的时候手动添加一点
                    if (ninePatchWidth>0 &&(pointVO.rightSpacing + pointVO.leftSpacing == ninePatchWidth)) {
                        pointVO.rightSpacing = pointVO.rightSpacing -1;
                    }
                    pointVO.topSpacing = verticalLocation.startLocation;
                    pointVO.bottomSpacing = ninePatchHeight - verticalLocation.endLocation;

                    if (ninePatchHeight>0 &&(pointVO.topSpacing + pointVO.bottomSpacing == ninePatchHeight)) {
                        pointVO.bottomSpacing = pointVO.bottomSpacing -1;
                    }

                    if (j == 0) {
                        pointVO.variableRegionWidth =  horizontalLocation.length;
                    }
                    if (i==0) {//垂直方向变化一次就可以了，因为i=0时候已经将垂直方向的高度全部变完了
                        pointVO.variableRegionHeight = verticalLocation.length;
                    }

                    pointVO.horizontalSequence = i;
                    pointVO.verticalSequence = j;
                    [array addObject:pointVO];
                }

            }else{
                NinePointVO * pointVO = [[NinePointVO alloc] init];
                pointVO.leftSpacing = horizontalLocation.startLocation;
                pointVO.rightSpacing = ninePatchWidth - horizontalLocation.endLocation;
                pointVO.variableRegionWidth =  horizontalLocation.length;

                pointVO.horizontalSequence = i;
                [array addObject:pointVO];
            }

        }
    }else{////横向无拉伸

        //纵向有拉伸
        if (ninePatchVerticalPoints.count > 0) {
            for(int j = 0 ; j< ninePatchVerticalPoints.count ;j++) {

                PointLocation *verticalLocation = ninePatchVerticalPoints[j];

                NinePointVO * pointVO = [[NinePointVO alloc] init];
                pointVO.topSpacing = verticalLocation.startLocation;
                pointVO.bottomSpacing = ninePatchHeight - verticalLocation.endLocation;
                pointVO.variableRegionHeight =  verticalLocation.length;
                pointVO.verticalSequence = j;
                [array addObject:pointVO];
            }

        }
        //纵向也无拉伸返回array无内容
    }

    return array;
}


@end
