//
//  NinePatchManager.h
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/29.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NinePatchContentRange.h"

@interface NinePatchManager : NSObject


//传入点9图片。stretchingSize为需要拉伸到的宽高
-(UIImage *)drawNinePatchImage:(UIImage *)image stretchingSize:(CGSize)stretchingSize;

//image 传入点9图片
//contenttext为显示文本，
//textFont 为文本字体大小
//viewMaxSize为显示的最大宽高，默认优先拉伸宽度，宽度达到上限拉伸高度，高度达到最大时候不在拉伸
//该方法将传入的文本显示在需要显示的位置，并以图片的形式进行输出
-(UIImage *)drawNinePatchImage:(UIImage *)image contentText:(NSString *)contentText textFont:(UIFont *)font  viewMaxSize:(CGSize)viewMaxSize;

#pragma  mark - 变化内容处理

- (NinePatchContentRange *)getBackgroundImageConstraints:(UIImage *)image;

@end
