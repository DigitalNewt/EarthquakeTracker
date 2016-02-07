//
//  Quake+CoreDataProperties.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/7/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Quake.h"

NS_ASSUME_NONNULL_BEGIN

@interface Quake (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDecimalNumber *depth;
@property (nullable, nonatomic, retain) NSString *detailURL;
@property (nullable, nonatomic, retain) NSString *eventId;
@property (nullable, nonatomic, retain) NSDecimalNumber *latitude;
@property (nullable, nonatomic, retain) NSDecimalNumber *longitude;
@property (nullable, nonatomic, retain) NSDecimalNumber *magnitude;
@property (nullable, nonatomic, retain) NSString *place;
@property (nullable, nonatomic, retain) NSDate *time;
@property (nullable, nonatomic, retain) NSNumber *tsunami;

@end

NS_ASSUME_NONNULL_END
