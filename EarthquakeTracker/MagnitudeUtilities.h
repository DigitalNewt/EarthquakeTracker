//
//  MagnitudeUtilities.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/10/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

@import UIKit;

@interface MagnitudeUtilities : NSObject

+ (UIColor *)getStatusColor:(NSNumber *)magnitude;
+ (UIColor *)getFontStatusColor:(NSNumber *)magnitude;
+ (NSString *)getStatusIconNumber:(NSNumber *)magnitude;

@end
