//
//  NinePatchGlobal.h
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/29.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#ifndef NinePatchGlobal_h
#define NinePatchGlobal_h

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#endif

typedef struct _TURGBAPixel {
    UInt8 red;
    UInt8 green;
    UInt8 blue;
    UInt8 alpha;
} TURGBAPixel;

#define RGBABytesPerPixel (4)
#define RGBAPixelIsBlack(PIXEL) (((PIXEL.red == 0) && (PIXEL.green == 0) && (PIXEL.blue == 0) && (PIXEL.alpha != 0))?(YES):(NO))

#define TruncateBelow(VALUE, FLOOR) ((( VALUE ) < ( FLOOR ))?(( FLOOR )):(( VALUE )))
#define TruncateAbove(VALUE, CEILING) ((( VALUE ) > ( CEILING ))?(( CEILING )):(( VALUE )))
#define TruncateWithin(VALUE, FLOOR, CEILING) ((( VALUE ) < ( FLOOR ))?(( FLOOR )):((( VALUE ) > ( CEILING ))?(( CEILING )):(( VALUE ))))
#define TruncateAtZero(VALUE) TruncateBelow(VALUE, 0.0f)


#endif /* NinePatchGlobal_h */
