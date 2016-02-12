//
//  AlertUtility.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/10/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "AlertUtility.h"

@implementation AlertUtility

/**
 *  Show message if error retrieving data.
 */
+(void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}
@end
