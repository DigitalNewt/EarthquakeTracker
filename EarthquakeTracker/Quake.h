//
//  Quake.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/4/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN
#define QUAKE_DATABASE @"Quake"
#define DEFAULT_SORT_ORDER @"time"

@interface Quake : NSManagedObject

+ (Quake *)quakeWithEarthquakeInfo:(NSDictionary *)quakeDictionary
            inManagedObjectContext:(NSManagedObjectContext *)context
            withDateFormat:(NSDateFormatter *)dateFormatter;

+ (void)loadEarthquakeDataFromArray:(NSArray *)quakes  // of Quake NSDictionary
           intoManagedObjectCOntext:(NSManagedObjectContext *)context;

+ (NSArray *)getTopQuakes:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Quake+CoreDataProperties.h"
