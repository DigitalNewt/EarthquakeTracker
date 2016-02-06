//
//  Annotation.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/4/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface Annotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;

@end
