//
//  AlertUtility.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/10/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

@import UIKit;

@interface AlertUtility : NSObject
#define NETWORK_ERROR_MESSAGE @"Unable to fetch data.  Check your network settings."
#define NETWORK_ERROR_TITLE @"Network Error"
+(void)showMessage:(NSString*)message withTitle:(NSString *)title;
@end
