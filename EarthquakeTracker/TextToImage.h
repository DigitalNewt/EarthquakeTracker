//
//  TextToImage.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/9/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

@import UIKit;

@interface TextToImage : NSObject

#define DISCLOSURE @"  >"

- (UIImage *)convertNumberToImage:(NSNumber *)number withImageView:(UIImageView *) imageView withColor:(UIColor *)color;

- (UIImage *)convertTextToImage:(NSString *)text withImageView:(UIImageView *) imageView withColor:(UIColor *)color;

@end
