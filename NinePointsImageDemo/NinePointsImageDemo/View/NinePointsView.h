//
//  NinePointsView.h
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NinePointsView : UIView

@property(nonatomic, strong) NinePatchContentRange *contentRange;

@property(nonatomic, strong) NSArray *ninePatchAry;

@property(nonatomic, strong) UIImage  *ninePatchImage;



-(void)redrawWithFontSize:(CGFloat)fontSize;

@end
