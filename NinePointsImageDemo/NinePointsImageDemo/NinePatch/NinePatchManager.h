//
//  NinePatchManager.h
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/29.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NinePatchManager : NSObject


//传入点9图片。stretchingSize为需要拉伸到的宽高
-(void)drawNinePatchImage:(UIImage *)image stretchingSize:(CGSize)stretchingSize;

//image 传入点9图片
//contenttext为显示文本，
//textFont 为文本字体大小
//viewMaxSize为显示的最大宽高，默认优先拉伸宽度，宽度达到上限拉伸高度，高度达到最大时候不在拉伸
-(void)drawNinePatchImage:(UIImage *)image contentText:(NSString *)contentText textFont:(UIFont *)font  viewMaxSize:(CGSize)viewMaxSize;


@end
