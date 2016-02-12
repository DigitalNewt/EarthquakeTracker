//
//  MagnitudeUtilities.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/10/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "MagnitudeUtilities.h"
#import "FontelloIcons.h"
@import UIKit;
@implementation MagnitudeUtilities


/**
 * Return UIColor for magnitude level.
 */
+ (UIColor *)getStatusColor:(NSNumber *)magnitude {
    
    if ([[NSNumber numberWithDouble:8.0] compare:magnitude] == NSOrderedAscending) {
        return [UIColor brownColor];
    } else if ([[NSNumber numberWithDouble:7.0] compare:magnitude] == NSOrderedAscending) {
        return [UIColor redColor];
    } else if ([[NSNumber numberWithDouble:6.0] compare:magnitude] == NSOrderedAscending) {
        return [UIColor orangeColor];
    } else if ([[NSNumber numberWithDouble:5.0]compare:magnitude] == NSOrderedAscending) {
        return [UIColor yellowColor];
    } else if ([[NSNumber numberWithDouble:4.0]compare:magnitude] == NSOrderedAscending) {
        return [UIColor greenColor];
    } else if ([[NSNumber numberWithDouble:3.0]compare:magnitude] == NSOrderedAscending) {
        return [UIColor blueColor];
    } else {
        return [UIColor whiteColor];
    }
}

/**
 * Return text UIColor for magnitude level.
 */
+ (UIColor *)getFontStatusColor:(NSNumber *)magnitude {
    
    if ([[NSNumber numberWithDouble:8.0] compare:magnitude] == NSOrderedAscending) {
        return [UIColor redColor];
    } else {
        return [UIColor blackColor];
    }
}

/**
 * Returns the fontello icon face for magnitude level
 */
+ (NSString *)getStatusIconNumber:(NSNumber *)magnitude {
    
    if ([[NSNumber numberWithDouble:8.0] compare:magnitude] == NSOrderedAscending) {
        return HELL_ICON;
    } else if ([[NSNumber numberWithDouble:7.0] compare:magnitude] == NSOrderedAscending) {
        return OH_NO_ICON;
    } else if ([[NSNumber numberWithDouble:6.0] compare:magnitude] == NSOrderedAscending) {
        return CRY_ICON;
    } else if ([[NSNumber numberWithDouble:5.0]compare:magnitude] == NSOrderedAscending) {
        return MAD_ICON;
    } else if ([[NSNumber numberWithDouble:4.0]compare:magnitude] == NSOrderedAscending) {
        return SAD_ICON;
    } else if ([[NSNumber numberWithDouble:3.0]compare:magnitude] == NSOrderedAscending) {
        return NOT_SURE_ICON;
    } else {
        return HAPPY_ICON;
    }
}

@end
