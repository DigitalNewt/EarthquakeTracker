//
//  Quake+Annotation.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/6/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "Quake+Annotation.h"

@implementation Quake (Annotation)

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate;
    
//    coordinate.latitude = [self.latitude doubleValue];
//    coordinate.longitude = [self.longitude doubleValue];
    MKMapPoint mapPoint;
    mapPoint.x = [self.latitude doubleValue];
    mapPoint.y = [self.longitude doubleValue];
    
    coordinate = MKCoordinateForMapPoint(mapPoint);
    
    return coordinate;
}

@end
