//
//  Quake.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/4/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "Quake.h"
#import "APIManager.h"
#import "DateUtility.h"

@implementation Quake

+ (Quake *)quakeWithEarthquakeInfo:(NSDictionary *)quakeDictionary
            inManagedObjectContext:(NSManagedObjectContext *)context {
    Quake * quake = nil;
    
    NSString *eventId = [quakeDictionary valueForKeyPath:EARTHQUAKE_EVENT_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Quake"];
    request.predicate = [NSPredicate predicateWithFormat:@"eventId = %@", eventId];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        if (error) {
            NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]),
                  NSStringFromSelector(_cmd),
                  [error localizedDescription],
                  [error localizedFailureReason]);
        }
    } else if ([matches count]) {
        quake = [matches firstObject];
    } else {
        quake = [NSEntityDescription insertNewObjectForEntityForName:@"Quake" inManagedObjectContext:context];
        quake.eventId = eventId;
        quake.place = [quakeDictionary valueForKeyPath:EARTHQUAKE_PLACE];
        quake.magnitude = [quakeDictionary valueForKeyPath:EARTHQUAKE_MAGNITUDE];
        quake.detailURL = [quakeDictionary valueForKeyPath:EARTHQUAKE_URL];
        NSLog(@"Tsunami = %@", [quakeDictionary valueForKey:EARTHQUAKE_TSUNAMI]);
//        if ([quakeDictionary valueForKey:EARTHQUAKE_TSUNAMI] != [NSNull null]) {
//            quake.tsunami = [quakeDictionary valueForKeyPath:EARTHQUAKE_TSUNAMI];
//        } else {
//            quake.tsunami = false;
//        }
        NSArray *coordinates = [quakeDictionary valueForKeyPath:EARTHQUAKE_LOCATION];
        // The longitude, latitude, and depth values are stored in an array in JSON.
        // Access these values by index directly.
        quake.latitude = (NSDecimalNumber *) @([coordinates[0] doubleValue]);
        quake.longitude = (NSDecimalNumber *) @([coordinates[1] doubleValue]);
        quake.depth = (NSDecimalNumber *) @([coordinates[2] doubleValue]);
//        quake.latitude = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:[coordinates[0] doubleValue]];
//        quake.longitude = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:[coordinates[1] doubleValue]];
//        quake.depth = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:[coordinates[2] doubleValue]];
        NSLog(@"Latitude = %f  :  %@", [coordinates[0] floatValue], quake.latitude);
        NSLog(@"Longitude = %f  :  %@", [coordinates[1] floatValue], quake.longitude);
        
        NSNumber *time = [quakeDictionary valueForKeyPath:EARTHQUAKE_TIME];
        NSTimeInterval timeInterval = [time doubleValue] / 1000.0;
        quake.time = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    
    
    return quake;
}

+ (void)loadEarthquakeDataFromArray:(NSArray *)quakes  // of Quake NSDictionary
            intoManagedObjectCOntext:(NSManagedObjectContext *)context {
    
    for (NSDictionary *quake in quakes) {
        [self quakeWithEarthquakeInfo:quake inManagedObjectContext:context];
    }
    
}
@end
