//
//  NinePointsView.m
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import "NinePointsView.h"
#import "NinePatchUtils.h"
#import "UIImage+NinePoints.h"

static const long kPrecisionUnit = 1000;

@interface  NinePointsView(){
    CGFloat p_fontSize;
    CGFloat p_stretchingWidth;
    CGFloat p_stretchingHeight;
    NinePatchContentRange *p_ContentRange;

    NSArray *p_NinePatchAry;

    UIImage  *p_NinePatchImage;
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

    
    NSString*message = @"testdatatestdatatestdatatestdatatestdatatestdatatestdatatestdatatestdata";
    UIFont *font = [UIFont systemFontOfSize:p_fontSize];
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary*attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize messageSize = [message boundingRectWithSize:CGSizeMake(rect.size.width-p_ContentRange.rightEdgeDistance-p_ContentRange.leftEdgeDistance, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;

   // [self drawImagePicture:messageSize.width height:messageSize.height ninePatchImage:_nineImage];
    [self startStretchingImage:messageSize.width height:messageSize.height];

    [message drawWithRect:CGRectMake(p_ContentRange.leftEdgeDistance, p_ContentRange.topEdgeDistance,messageSize.width, messageSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
}

-(void)initNinePatchImage:(UIImage *)image ninePoints:(NSArray *)ninePoints contentRange:(NinePatchContentRange *)contentRange{
    p_ContentRange = contentRange;
    p_NinePatchImage = image;
    p_NinePatchAry = ninePoints;

}

-(void)initNinePatchImage:(UIImage *)image{

    if (image) {
        NinePatchContentRange *contentRange = [image  getImageContentRange];
        NSArray *ninePatchs = [image getAllNinePatchAreaPoint:image];
        [self initNinePatchImage:[NinePatchUtils  crop:CGRectMake(1, 1, image.size.width - 2, image.size.height - 2) image:image]
                        ninePoints:ninePatchs contentRange:contentRange];
    }

}

-(void)initNinePatchImage:(UIImage *)image stretchingSize:(CGSize)stretchingSize{

    if (image) {
        [self initNinePatchImage:image];
        [self startStretchingImage:stretchingSize.width height:stretchingSize.height];

    }

}


#pragma mark - scale method


- (void)startStretchingImage:(float)width height:(float)height{


    NSMutableArray *mutableAry = [p_NinePatchAry mutableCopy];

    if (mutableAry.count>0) {

        CGFloat ninePatchWidth  = [NinePatchUtils getImageWidth:p_NinePatchImage];
        CGFloat ninePatchHeight = [NinePatchUtils getImageHeight:p_NinePatchImage];
        //计算需要变化的宽高大小
        //需要变大的宽度
        CGFloat stretchingWidth = width+p_ContentRange.leftEdgeDistance+p_ContentRange.rightEdgeDistance-ninePatchWidth;
        //需要变高的高度
        CGFloat stretchingHeight = height+p_ContentRange.topEdgeDistance+p_ContentRange.bottomEdgeDistance-ninePatchHeight;

        if(stretchingWidth<0){
            stretchingWidth = 0;
        }
        if(stretchingHeight<0){
            stretchingHeight = 0;
        }
            p_stretchingWidth = [self getLengthStretch:p_NinePatchAry isWidth:YES];

            p_stretchingHeight = [self getLengthStretch:p_NinePatchAry isWidth:NO];

        //水平单位拉伸区域拉伸比例
        float horizontalStretchUnitRatio = floor(stretchingWidth/p_stretchingWidth*kPrecisionUnit) / kPrecisionUnit ;

        //垂直单位拉伸区域拉伸比例
        float verticalStretchUnitRatio = floor(stretchingHeight/p_stretchingHeight*kPrecisionUnit) / kPrecisionUnit ;


        UIImage *image  = nil;
        for (int i = 0 ; i < mutableAry.count ;i++) {

            NinePointVO *vo = mutableAry[i];
            BOOL isLastImage = NO;

            if ( i == mutableAry.count-1) {
                isLastImage = YES;
            }
            int  NinePatchCurrentWidth  = (int)(vo.variableRegionWidth*horizontalStretchUnitRatio);

            int  NinePatchCurrentHeight = (int)(vo.variableRegionHeight*verticalStretchUnitRatio);
            NSLog(@"当前是第%d个点，变化宽度=%d，变化高度=%d",i,NinePatchCurrentWidth,NinePatchCurrentHeight);
            
            CGSize size = CGSizeMake(NinePatchCurrentWidth,NinePatchCurrentHeight);

            if (i == 0) {

                image =   [self drawImageWithNinePoint:vo image:p_NinePatchImage resizableSize:size isLastImage:isLastImage];
            }else{

                if(!image){
                    NSLog(@"图片异常");
                }else{
                image =   [self drawImageWithNinePoint:vo image:image resizableSize:size isLastImage:isLastImage];
                }
            }

            //更新其他点坐标

            for(int j= i;j<mutableAry.count-1;j++){

                NinePointVO *ninePoint = mutableAry[j+1];
                NSLog(@"当前是第%d个点,左边距=%f",j,ninePoint.leftSpacing);

                ninePoint.leftSpacing = ninePoint.leftSpacing+NinePatchCurrentWidth;

                ninePoint.topSpacing = ninePoint.topSpacing+NinePatchCurrentHeight;
            }
        }

    }else{
        //普通图片，异常情况
    }

}




// 绘制点9图片，pointVO为此次变化区域，img为待变化图片，resizableSize为拉伸宽高，isLastImage判断是否是最后一次变化
- (UIImage *)drawImageWithNinePoint:(NinePointVO *) pointVO image:(UIImage *)img resizableSize:(CGSize)resizableSize isLastImage:(BOOL)islastImage{

     NSInteger top =(int)(pointVO.topSpacing);
     NSInteger left =(int)(pointVO.leftSpacing);
     NSInteger bottom = (int)(pointVO.bottomSpacing);
     NSInteger  right = (int)(pointVO.rightSpacing);

    //设置绘制区域上下左右的间距
    UIImage *resizableImage =  [img resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)
                                                   resizingMode:UIImageResizingModeStretch ];

    //设置图片这次变化后的大小
    CGSize size = CGSizeMake([NinePatchUtils getImageWidth:resizableImage ]+resizableSize.width,[NinePatchUtils getImageHeight:resizableImage ]+resizableSize.height);

    UIImage *scaleImage  = nil;
    //最后次变化
    if (islastImage) {
        [resizableImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        return nil;
    }else{
        scaleImage = [self scaleToSize:resizableImage size:size];
    }

    return scaleImage;
}

//将图片绘制到指定大小，并取出该图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context

    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (float) getLengthStretch:(NSArray *) array isWidth:(BOOL) isWidth{

    float totalLength = 0;

    for (NinePointVO *ninePoint in  array) {
        //计算出总的拉伸的黑色区域长度
        if (isWidth) {
            totalLength += ninePoint.variableRegionWidth;
        }else{
            totalLength += ninePoint.variableRegionHeight;
        }
    }
    return totalLength;
}


#pragma mark - method


- (void)dealloc {
}

-(void)redrawWithFontSize:(CGFloat)fontSize {
    p_fontSize = fontSize;

    [self setNeedsDisplay];
}

@end
