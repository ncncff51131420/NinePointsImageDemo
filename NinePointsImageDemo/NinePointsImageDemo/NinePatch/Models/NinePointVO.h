//
//  NinePointVO.h
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/25.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NinePointVO : NSObject

@property (nonatomic, assign)  float topSpacing;
@property (nonatomic, assign)  float leftSpacing;
@property (nonatomic, assign)  float bottomSpacing;
@property (nonatomic, assign)  float rightSpacing;


@property (nonatomic, assign)  int horizontalSequence;
@property (nonatomic, assign)  int verticalSequence;

@property (nonatomic, assign)  int variableRegionWidth;
@property (nonatomic, assign)  int variableRegionHeight;

@end

