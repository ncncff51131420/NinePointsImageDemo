//
//  NinePointsView.m
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import "NinePointsView.h"
#import "UIImage+NinePoints.h"

@interface  NinePointsView(){
    CGFloat p_fontSize;
    CGFloat p_stretchingWidth;
    CGFloat p_stretchingHeight;
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
    CGSize messageSize = [message boundingRectWithSize:CGSizeMake(rect.size.width-_contentRange.rightEdgeDistance-_contentRange.leftEdgeDistance, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;

   // [self drawImagePicture:messageSize.width height:messageSize.height ninePatchImage:_nineImage];
    [self startStretchingImage:messageSize.width height:messageSize.height];

    [message drawWithRect:CGRectMake(_contentRange.leftEdgeDistance, _contentRange.topEdgeDistance,messageSize.width, messageSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
}
#pragma mark - scale method


- (void)startStretchingImage:(float)width height:(float)height{

    NSArray *array = [self getAllNinePatchAreaPoint:_ninePatchHorizontalPoints ninePatchVerticalPoints:_ninePatchVerticalPoints];
    if (array.count>0) {

        CGFloat ninePatchWidth  = [self getImageWidth:_nineImage];
        CGFloat ninePatchHeight = [self getImageHeight:_nineImage];

        //计算需要变化的宽高大小
        //需要变大的宽度
        CGFloat stretchingWidth = width+_contentRange.leftEdgeDistance+_contentRange.rightEdgeDistance-ninePatchWidth;
        //需要变高的高度
        CGFloat stretchingHeight = height+_contentRange.topEdgeDistance+_contentRange.bottomEdgeDistance-ninePatchHeight;

        if(stretchingWidth<0){
            stretchingWidth = 0;
        }
        if(stretchingHeight<0){
            stretchingHeight = 0;
        }
            p_stretchingWidth = [self getLengthStretch:_ninePatchHorizontalPoints];

            p_stretchingHeight = [self getLengthStretch:_ninePatchVerticalPoints];

        //水平单位拉伸区域拉伸比例
        float horizontalStretchUnitRatio = floor(stretchingWidth/p_stretchingWidth*1000) / 1000 ;

        //垂直单位拉伸区域拉伸比例
        float verticalStretchUnitRatio = floor(stretchingHeight/p_stretchingHeight*1000) / 1000 ;


        UIImage *image  = nil;
        NSMutableArray *mutableAry = [array mutableCopy];
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

                image =   [self drawImageWithNinePoint:vo image:_nineImage resizableSize:size isLastImage:isLastImage];
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



- (NSArray *) getAllNinePatchAreaPoint:(NSArray *)ninePatchHorizontalPoints
               ninePatchVerticalPoints:(NSArray *)ninePatchVerticalPoints{

    NSMutableArray *array   = [NSMutableArray arrayWithCapacity:1];
    CGFloat ninePatchWidth  = [self getImageWidth:_nineImage];
    CGFloat ninePatchHeight = [self getImageHeight:_nineImage];

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
                    pointVO.topSpacing = verticalLocation.startLocation;
                    pointVO.bottomSpacing = ninePatchHeight - verticalLocation.endLocation;
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



- (UIImage *)drawImageWithNinePoint:(NinePointVO *) pointVO image:(UIImage *)img resizableSize:(CGSize)resizableSize isLastImage:(BOOL)islastImage{

     NSInteger top =(int)(pointVO.topSpacing);
     NSInteger left =(int)(pointVO.leftSpacing);
     NSInteger bottom = (int)(pointVO.bottomSpacing);
     NSInteger  right = (int)(pointVO.rightSpacing);


    UIImage *resizableImage =  [img resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)
                                                   resizingMode:UIImageResizingModeStretch ];


    CGSize size = CGSizeMake([self getImageWidth:resizableImage ]+resizableSize.width,[self getImageHeight:resizableImage ]+resizableSize.height);

    UIImage *scaleImage  = nil;
    if (islastImage) {
        [resizableImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        return nil;
    }else{
        scaleImage = [self scaleToSize:resizableImage size:size];
    }

    return scaleImage;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    size.width = size.width;
    size.height = size.height;
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

- (float) getLengthStretch:(NSArray *) array{

    float totalLength = 0;
    for (int i = 0; i<array.count; i++) {
    PointLocation *location  = array[i];

    totalLength +=location.length;//计算出总的拉伸的黑色区域长度
}

    return totalLength;
}
#pragma mark - old method

-(UIImage *)drawImagePicture:(int)width height:(int)height ninePatchImage:(UIImage *)ninePatchImage{

    //计算该.9图片的宽高
    CGImageRef cgImage          = [ninePatchImage CGImage];
    //点9图片的宽，不包含黑边
    NSUInteger ninePatchWidth   = CGImageGetWidth(cgImage);
    //点9图片的高，不包含黑边
    NSUInteger ninePatchHeight  = CGImageGetHeight(cgImage);

    //计算需要变化的宽高大小
    //需要变大的宽度
    CGFloat stretchingWidth = width+_contentRange.leftEdgeDistance+_contentRange.rightEdgeDistance-ninePatchWidth;
    //需要变高的高度
    CGFloat stretchingHeight = height+_contentRange.topEdgeDistance+_contentRange.bottomEdgeDistance-ninePatchHeight;

    //首先绘制水平方向图片

    UIImage *image = [self drawHorizontalPicture:stretchingWidth image:ninePatchImage horizontalPoints:_ninePatchHorizontalPoints];

    //如果纵向有.9点
    if (_ninePatchVerticalPoints&&_ninePatchVerticalPoints.count>0 &&image&&stretchingHeight>0) {
        [self drawVerticalPicture:stretchingHeight image:image VerticalPoints:_ninePatchVerticalPoints];
    }else{
        //没有变化点，就纵向填满;
        [image drawInRect:CGRectMake(0,0, [self getImageWidth:image], [self getImageHeight:image]+stretchingHeight)];
    }
    return image;
}

//绘制水平方向图片,因为纵向还需要这张图片，所以返回绘制完成后的UIImage
- (UIImage *)drawHorizontalPicture:(CGFloat)stretchingWidth
                             image:(UIImage *)image
                  horizontalPoints:(NSArray *)horizontalPoints{
    //这里不用判断stretchingWidth,因为图片可能有拉伸和缩小
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    UIGraphicsBeginImageContext(size);

    //存在水平方向拉伸的点
    if (horizontalPoints && horizontalPoints.count>0) {
        //水平拉伸可能存在以下几种情况。一个点，。。多个点
        //如果只有一个点，那么可能位置有三个：头，尾，其他
        if(horizontalPoints.count == 1){
            //单个点
            [self drawOnePointImage:stretchingWidth image:image horizontalPoints:horizontalPoints isHorizontal:YES];
        }else{
            //多个点的情况
            [self drawMoreThanOnePointImage:stretchingWidth image:image horizontalPoints:horizontalPoints isHorizontal:YES];
        }

    }else{//不存在
        [image drawInRect:CGRectMake(0,0, [self getImageWidth:image]+stretchingWidth, [self getImageHeight:image])];

    }
    UIImage *stretchResultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return stretchResultImage;
}

//绘制纵向图片
- (void)drawVerticalPicture:(CGFloat)stretchingHeight
                      image:(UIImage *)image
             VerticalPoints:(NSArray *)VerticalPoints{
    //存在纵向拉伸的点
    if (VerticalPoints && VerticalPoints.count>0) {
        //水平拉伸可能存在以下几种情况。一个点，。。多个点
        //如果只有一个点，那么可能位置有三个：头，尾，其他
        if(VerticalPoints.count == 1){
            //单个点
            [self drawOnePointImage:stretchingHeight image:image horizontalPoints:VerticalPoints isHorizontal:NO];
        }else{
            //多个点的情况
            [self drawMoreThanOnePointImage:stretchingHeight image:image horizontalPoints:VerticalPoints isHorizontal:NO];
        }

    }else{//不存在
        [image drawInRect:CGRectMake(0,0, [self getImageWidth:image], [self getImageHeight:image]+stretchingHeight)];
    }
}

#pragma mark - HorizontalPoints
// 画一个点的点9图可能位置有三个：头，尾，其他
- (void)drawOnePointImage:(CGFloat)stretchingWidth
                    image:(UIImage *)image
         horizontalPoints:(NSArray *)horizontalPoints
             isHorizontal:(BOOL) isHorizontal{

    CGFloat width  = [self getImageWidth:image];
    CGFloat height = [self getImageHeight:image];
    PointLocation *location  = horizontalPoints[0];

    CGRect normalLeftRect ;
    CGRect normalLeftDrawRect ;
    CGRect nineRect ;
    CGRect nineDrawRect ;
    CGRect normalRightRect ;
    CGRect normalRightDrawRect ;

    if(location){
        if (location.startLocation == 0) {//在头

            if (location.length == width) {//说明整个都是变化区
                if (isHorizontal) {
                    [image drawInRect:CGRectMake(0,0, width+stretchingWidth, height)];
                }else{
                    [image drawInRect:CGRectMake(0,0, width, height+stretchingWidth)];
                }
            }else{
                //会有两个区域
                if (isHorizontal) {
                    //拉伸区
                    nineRect = CGRectMake(0, 0, location.length, height);
                    nineDrawRect = CGRectMake(0,0, location.length+stretchingWidth, height) ;
                    //固定区
                    normalRightRect = CGRectMake( location.endLocation, 0, width-location.endLocation, height);
                    normalRightDrawRect = CGRectMake(location.length+stretchingWidth,0, width-location.endLocation, height);
                }else{
                    nineRect = CGRectMake(0, 0, width, location.length);
                    nineDrawRect = CGRectMake(0,0, width, location.length+stretchingWidth);
                    normalRightRect = CGRectMake( 0, location.endLocation, width, height-location.endLocation);
                    normalRightDrawRect = CGRectMake(0,location.length+stretchingWidth, width, height-location.endLocation);
                }
                [self clipAndDrawNewImageWihtRect:nineRect drawRect:nineDrawRect image:image];
                [self clipAndDrawNewImageWihtRect:normalRightRect drawRect:normalRightDrawRect image:image];
            }
        }else if(location.startLocation != 0 && width ==location.endLocation){//在尾
            //会有两个区域
            if (isHorizontal) {
                //固定区
                normalLeftRect = CGRectMake(0, 0, location.startLocation, height);
                normalLeftDrawRect = CGRectMake(0,0, location.startLocation, height);
                //拉伸区
                nineRect = CGRectMake( location.startLocation, 0, location.length, height);
                nineDrawRect = CGRectMake(location.startLocation,0, location.length+stretchingWidth, height) ;
            }else{
                normalLeftRect = CGRectMake(0, 0, width, location.startLocation);
                normalLeftDrawRect = CGRectMake(0,0, width, location.startLocation);
                nineRect = CGRectMake( 0, location.startLocation, width, location.length);
                nineDrawRect = CGRectMake(0,location.startLocation, width, location.length+stretchingWidth);
            }
            [self clipAndDrawNewImageWihtRect:normalLeftRect drawRect:normalLeftDrawRect image:image];
            [self clipAndDrawNewImageWihtRect:nineRect drawRect:nineDrawRect image:image];

        }else{//在中会有三个区域
            if (isHorizontal) {
                //固定区
                normalLeftRect = CGRectMake(0, 0, location.startLocation, height);
                normalLeftDrawRect = CGRectMake(0,0, location.startLocation, height);
                //拉伸区
                nineRect = CGRectMake( location.startLocation, 0, location.length, height);
                nineDrawRect = CGRectMake(location.startLocation,0, location.length+stretchingWidth, height) ;
                //固定区
                normalRightRect = CGRectMake(location.endLocation, 0, width-location.endLocation, height);
                normalRightDrawRect = CGRectMake(location.endLocation+stretchingWidth,0,width-location.endLocation, height);
            }else{
                normalLeftRect = CGRectMake(0, 0, width, location.startLocation);
                normalLeftDrawRect = CGRectMake(0,0, width, location.startLocation);
                nineRect = CGRectMake( 0, location.startLocation, width, location.length);
                nineDrawRect = CGRectMake(0,location.startLocation, width, location.length+stretchingWidth);
                normalRightRect = CGRectMake(0, location.endLocation, width, height-location.endLocation);
                normalRightDrawRect = CGRectMake(0,location.endLocation+stretchingWidth,width, height-location.endLocation);
            }
            [self clipAndDrawNewImageWihtRect:normalLeftRect drawRect:normalLeftDrawRect image:image];
            [self clipAndDrawNewImageWihtRect:nineRect drawRect:nineDrawRect image:image];
            [self clipAndDrawNewImageWihtRect:normalRightRect drawRect:normalRightDrawRect image:image];
        }
    }

}
//绘制多个点
- (void)drawMoreThanOnePointImage:(CGFloat)stretchingWidth
                            image:(UIImage *)image
                 horizontalPoints:(NSArray *)horizontalPoints
                     isHorizontal:(BOOL) isHorizontal{

    CGFloat width  = [self getImageWidth:image];
    CGFloat height = [self getImageHeight:image];
    NSInteger aryCount = horizontalPoints.count;
    PointLocation *firstLocation  = horizontalPoints[0];
    PointLocation *endLocation  = horizontalPoints[aryCount-1];


    float totalLength = 0;
    for (int i = 0; i<horizontalPoints.count; i++) {
        PointLocation *location  = horizontalPoints[i];

        totalLength +=location.length;//计算出总的拉伸的黑色区域长度
    }
    if (totalLength == 0) {//异常情况，不可能是0
        return;
    }
    CGFloat lastNineChangeSite = 0;//为了定位方便这里将变化区坐标提出

    //单位拉伸区域拉伸比例
    float lengthStretchUnitRatio = floor(stretchingWidth/totalLength*1000) / 1000 ;

    CGRect normalRect ;
    CGRect normalDrawRect ;
    CGRect nineRect ;
    CGRect nineDrawRect ;

    //绘制多个点会有三种情况，一种是一个点在边缘，两个点在边缘，没有点在边缘，其中一个点在边缘情况可能是起点，也可能是终点在边缘
    if(firstLocation.startLocation == 0 || endLocation.endLocation == width){

        if (firstLocation.startLocation == 0) {
            //至少有两个点在首尾
            for (int i = 0; i<horizontalPoints.count; i++) {
                PointLocation *location  = horizontalPoints[i];

                if (i == 0) {
                    if (isHorizontal) {
                        //拉伸区
                        nineRect = CGRectMake(0, 0, location.length, height);
                        nineDrawRect = CGRectMake(0,0, location.length*(1+lengthStretchUnitRatio), height);
                    }else{
                        nineRect = CGRectMake(0, 0, width, location.length);
                        nineDrawRect = CGRectMake(0,0, width,location.length*(1+lengthStretchUnitRatio));
                    }
                    [self clipAndDrawNewImageWihtRect:nineRect drawRect:nineDrawRect image:image];

                    lastNineChangeSite = location.length*(1+lengthStretchUnitRatio);
                }else{
                    PointLocation *lastLocation  = horizontalPoints[i-1];
                    CGFloat normalImageLength = location.startLocation-lastLocation.endLocation;

                    if (isHorizontal) {
                        //固定区
                        normalRect = CGRectMake(lastLocation.endLocation, 0,normalImageLength, height);
                        normalDrawRect = CGRectMake(lastNineChangeSite,0, normalImageLength, height);
                        //拉伸区
                        nineRect = CGRectMake(location.startLocation, 0,location.length, height);
                        nineDrawRect = CGRectMake(lastNineChangeSite+normalImageLength,0, location.length*(1+lengthStretchUnitRatio), height);
                    }else{
                        normalRect = CGRectMake(0, lastLocation.endLocation,width, normalImageLength);
                        normalDrawRect = CGRectMake(0,lastNineChangeSite, width, normalImageLength);
                        nineRect = CGRectMake(0, location.startLocation,width, location.length);
                        nineDrawRect = CGRectMake(0,lastNineChangeSite+normalImageLength, width, location.length*(1+lengthStretchUnitRatio));
                    }
                    [self clipAndDrawNewImageWihtRect:normalRect drawRect:normalDrawRect image:image];
                    [self clipAndDrawNewImageWihtRect:nineRect drawRect:nineDrawRect image:image];

                    lastNineChangeSite += normalImageLength+location.length*(1+lengthStretchUnitRatio);
                }
            }
            //最后个点不在末尾，那么最后固定区域需要加上
            if(endLocation.endLocation == width){
                if (isHorizontal) {
                    normalRect = CGRectMake(endLocation.endLocation, 0, width-endLocation.endLocation, height);
                    normalDrawRect = CGRectMake(lastNineChangeSite,0, width-endLocation.endLocation, height);
                }else{
                    normalRect = CGRectMake(0, endLocation.endLocation, width, height-endLocation.endLocation);
                    normalDrawRect = CGRectMake(0,lastNineChangeSite, width, height-endLocation.endLocation);
                }
                [self clipAndDrawNewImageWihtRect:normalRect drawRect:normalDrawRect image:image];
            }
        }else if(endLocation.endLocation == width){//第一个点不在首位，最后个点在末尾

            for (int i = 0; i<horizontalPoints.count; i++) {
                PointLocation *location  = horizontalPoints[i];

                if (i == 0) {
                    if (isHorizontal) {
                        //固定区
                        normalRect = CGRectMake(0, 0, firstLocation.startLocation, height);
                        normalDrawRect = CGRectMake(0,0, location.startLocation, height);
                        //拉伸区
                        nineRect = CGRectMake( location.startLocation, 0, location.length, height);
                        nineDrawRect = CGRectMake(location.startLocation,0, location.length*(1+lengthStretchUnitRatio), height);
                    }else{
                        normalRect = CGRectMake(0, 0, width, firstLocation.startLocation);
                        normalDrawRect = CGRectMake(0,0, width, location.startLocation);
                        nineRect = CGRectMake( 0, location.startLocation, width, location.length);
                        nineDrawRect = CGRectMake(0,location.startLocation, width, location.length*(1+lengthStretchUnitRatio));
                    }
                    [self clipAndDrawNewImageWihtRect:normalRect drawRect:normalDrawRect image:image];
                    [self clipAndDrawNewImageWihtRect:nineRect drawRect:nineDrawRect image:image];

                    lastNineChangeSite = location.startLocation + location.length*(1+lengthStretchUnitRatio);
                }else{
                    PointLocation *lastLocation  = horizontalPoints[i-1];
                    CGFloat normalImageWidth = location.startLocation-lastLocation.endLocation;
                    if (isHorizontal) {
                        //固定区
                        normalRect = CGRectMake(lastLocation.endLocation, 0,normalImageWidth, height);
                        normalDrawRect = CGRectMake(lastNineChangeSite,0, normalImageWidth, height);
                        //拉伸区
                        nineRect = CGRectMake(location.startLocation, 0,location.length, height);
                        nineDrawRect = CGRectMake(lastNineChangeSite+normalImageWidth,0, location.length*(1+lengthStretchUnitRatio), height);
                    }else{
                        normalRect = CGRectMake(0, lastLocation.endLocation,width, normalImageWidth);
                        normalDrawRect = CGRectMake(0,lastNineChangeSite, width, normalImageWidth);
                        nineRect = CGRectMake(0, location.startLocation,width, location.length);
                        nineDrawRect = CGRectMake(0,lastNineChangeSite+normalImageWidth, width, location.length*(1+lengthStretchUnitRatio));
                    }
                    [self clipAndDrawNewImageWihtRect:normalRect drawRect:normalDrawRect image:image];
                    [self clipAndDrawNewImageWihtRect:nineRect drawRect:nineDrawRect image:image];

                    lastNineChangeSite += normalImageWidth+location.length*(1+lengthStretchUnitRatio);
                }
            }
        }
    }else{
        for (int i = 0; i<horizontalPoints.count; i++) {

            PointLocation *location  = horizontalPoints[i];
            if (i == 0) {
                if (isHorizontal) {
                    //固定区
                    normalRect = CGRectMake(0, 0, firstLocation.startLocation, height);
                    normalDrawRect = CGRectMake(0,0, location.startLocation, height);
                    //拉伸区
                    nineRect = CGRectMake( location.startLocation, 0, location.length, height);
                    nineDrawRect = CGRectMake(location.startLocation,0, location.length*(1+lengthStretchUnitRatio), height);
                }else{
                    normalRect = CGRectMake(0, 0, width, firstLocation.startLocation);
                    normalDrawRect = CGRectMake(0,0, width, location.startLocation);
                    nineRect = CGRectMake( 0, location.startLocation, width, location.length);
                    nineDrawRect = CGRectMake(0,location.startLocation, width, location.length*(1+lengthStretchUnitRatio));
                }
                [self clipAndDrawNewImageWihtRect:normalRect drawRect:normalDrawRect image:image];
                [self clipAndDrawNewImageWihtRect:nineRect drawRect:nineDrawRect image:image];
                lastNineChangeSite = location.startLocation + location.length*(1+lengthStretchUnitRatio);
            }else{

                PointLocation *lastLocation  = horizontalPoints[i-1];
                CGFloat normalImageWidth = location.startLocation-lastLocation.startLocation-lastLocation.length;

                if (isHorizontal) {
                    //固定区
                    normalRect = CGRectMake(lastLocation.startLocation+lastLocation.length-1, 0, normalImageWidth+2, height);
                    normalDrawRect = CGRectMake(lastNineChangeSite-1,0, normalImageWidth+2, height);
                    //拉伸区
                    nineRect = CGRectMake( location.startLocation, 0, location.length, height);
                    nineDrawRect = CGRectMake(lastNineChangeSite+normalImageWidth,0, location.length*(1+lengthStretchUnitRatio), height);
                }else{
                    normalRect = CGRectMake(0, lastLocation.endLocation, width, normalImageWidth);
                    normalDrawRect = CGRectMake(0,lastNineChangeSite, width, normalImageWidth);
                    nineRect = CGRectMake( 0, location.startLocation, width, location.length);
                    nineDrawRect = CGRectMake(0,lastNineChangeSite+normalImageWidth, width, location.length*(1+lengthStretchUnitRatio));
                }
                [self clipAndDrawNewImageWihtRect:normalRect drawRect:normalDrawRect image:image];
                [self clipAndDrawNewImageWihtRect:nineRect drawRect:nineDrawRect image:image];

                lastNineChangeSite =lastNineChangeSite + normalImageWidth+location.length*(1+lengthStretchUnitRatio);
            }

        }
        //固定区
        if (isHorizontal) {
            normalRect = CGRectMake(endLocation.startLocation+endLocation.length, 0,  width-endLocation.endLocation, height);
            normalDrawRect = CGRectMake(lastNineChangeSite-horizontalPoints.count, 0, width-endLocation.endLocation, height);
        }else{
            normalRect = CGRectMake(0, endLocation.endLocation, width, height-endLocation.endLocation);
            normalDrawRect = CGRectMake(0,lastNineChangeSite-horizontalPoints.count, width, height-endLocation.endLocation);
        }
        [self clipAndDrawNewImageWihtRect:normalRect drawRect:normalDrawRect image:image];

    }
}

#pragma mark - method

- (void)clipAndDrawNewImageWihtRect:(CGRect)clipRect drawRect:(CGRect)drawRect image:(UIImage *)image{

    UIImage *clipImage = [image subImageInRect:clipRect];
    [clipImage drawInRect:drawRect];

}

//返回图片的宽度
- (CGFloat)getImageWidth:(UIImage *)image{
    CGFloat width = 0;
    if (image) {
        CGImageRef cgImage = [image CGImage];
        width =  CGImageGetWidth(cgImage);///[UIScreen mainScreen].scale
    }
    return width;
}

//返回图片的高度
- (CGFloat)getImageHeight:(UIImage *)image{
    CGFloat height = 0;
    if (image) {
        CGImageRef cgImage = [image CGImage];
        height =  CGImageGetHeight(cgImage);
    }
    return height;
}

- (void)dealloc {
}

-(void)redrawWithFontSize:(CGFloat)fontSize {
    p_fontSize = fontSize;

    [self setNeedsDisplay];
}

@end
