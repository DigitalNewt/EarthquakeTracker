//
//  Quake.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/4/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Quake : NSManagedObject

+ (Quake *)quakeWithEarthquakeInfo:(NSDictionary *)quakeDictionary
            inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)loadEarthquakeDataFromArray:(NSArray *)quakes  // of Quake NSDictionary
           intoManagedObjectCOntext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Quake+CoreDataProperties.h"
