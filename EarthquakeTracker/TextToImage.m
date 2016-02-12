//
//  TextToImage.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/9/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "TextToImage.h"
@interface TextToImage()

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end


@implementation TextToImage

- (NSNumberFormatter *)numberFormatter {
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
    }
    return _numberFormatter;
}

- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)convertNumberToImage:(NSNumber *)number
                    withImageView:(UIImageView *) imageView
                    withTextColor:(UIColor *)textColor withBackgroundColor:(UIColor *)backgroundColor{
    
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *string = [NSString stringWithFormat:@"%@", [self.numberFormatter stringFromNumber:number]];
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:22],
                                 NSForegroundColorAttributeName : textColor,
                                 NSBackgroundColorAttributeName : backgroundColor};
    
    UIImage *image = [self imageFromString:string attributes:attributes size:imageView.bounds.size];
    
    return  image;
}

- (UIImage *)convertTextToImage:(NSString *)text withImageView:(UIImageView *) imageView withColor:(UIColor *)color {
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:35],
                                 NSForegroundColorAttributeName : color,
                                 NSBackgroundColorAttributeName : [UIColor clearColor]};
    
    UIImage *image = [self imageFromString:text attributes:attributes size:imageView.bounds.size];
    
    return  image;
}


@end
