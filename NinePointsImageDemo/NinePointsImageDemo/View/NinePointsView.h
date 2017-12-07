//
//  NinePointsView.h
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NinePatchContentRange.h"

@interface NinePointsView : UIView

- (void) setText:(NSString *)contentString;

-(void)initNinePatchImage:(UIImage *)image;


-(void)redrawWithFontSize:(CGFloat)fontSize;

@end
