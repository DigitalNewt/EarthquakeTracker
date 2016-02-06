//
//  Quake+CoreDataProperties.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/5/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Quake+CoreDataProperties.h"

@implementation Quake (CoreDataProperties)

@dynamic place;
@dynamic magnitude;
@dynamic time;
@dynamic latitude;
@dynamic longitude;
@dynamic detailURL;
@dynamic eventId;
@dynamic depth;
@dynamic tsunami;

@end
