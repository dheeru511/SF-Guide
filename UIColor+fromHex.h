//
//  UIColor+fromHex.h
//  SF Guide
//
//  Created by Dheeraj Singh on 1/23/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (fromHex)

//category method which return UIColor based on hex string
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

@end
