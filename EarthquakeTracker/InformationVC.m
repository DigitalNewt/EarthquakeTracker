//
//  InformationVC.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/7/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "InformationVC.h"

@implementation InformationVC
- (IBAction)exitInformationVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
