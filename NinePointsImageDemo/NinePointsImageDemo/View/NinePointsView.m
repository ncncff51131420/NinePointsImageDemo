//
//  NinePointsView.m
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import "NinePointsView.h"
#import "NinePatchManager.h"


@interface  NinePointsView(){
    CGFloat p_fontSize;
    UIImage *p_NinePatchImage;
    NSString *message;
}
@end

@implementation NinePointsView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{

    
    UIFont *font = [UIFont systemFontOfSize:p_fontSize];
    [[NinePatchManager alloc] drawNinePatchImage:p_NinePatchImage contentText:message textFont:font viewMaxSize:CGSizeMake(rect.size.width, rect.size.height)];
  //  [[NinePatchManager alloc] drawNinePatchImage:p_NinePatchImage stretchingSize:CGSizeMake(rect.size.width-50, rect.size.height-50)];
}




#pragma mark - method

-(void)initNinePatchImage:(UIImage *)image{

    p_NinePatchImage = image;
}
- (void)dealloc {
}

- (void) setText:(NSString *)contentString{
    message = contentString;
    [self setNeedsDisplay];
}

-(void)redrawWithFontSize:(CGFloat)fontSize {
    p_fontSize = fontSize;

    [self setNeedsDisplay];
}

@end
