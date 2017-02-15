//
//  ViewWithTag.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/19/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "ViewWithTag.h"

@implementation ViewWithTag

-(UIView *)viewWithTag:(NSInteger)tag
{
    UIView *results = nil;
    if (self.tag == tag) {
        return self;
    }

    if (self.subviews.count > 0)
    {
        for (UIView *view in self.subviews) {
            results = [view viewWithTag: view.tag];
            if(results) {
                return results;
            }
        }
    }
    return nil;
}

@end
