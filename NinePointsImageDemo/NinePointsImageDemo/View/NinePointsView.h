//
//  NinePointsView.h
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NinePointsView : UIView



-(void)initNinePatchImage:(UIImage *)image ninePoints:(NSArray *)ninePoints contentRange:(NinePatchContentRange *)contentRange;

-(void)redrawWithFontSize:(CGFloat)fontSize;

@end
