//
//  Quake.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/4/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "Quake.h"
#import "APIManager.h"
#import "FontelloIcons.h"
#import "DateFormats.h"

@implementation Quake

+(NSDate *) setTimeToZero:(NSDate *)myDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitYear|
                                    NSCalendarUnitMonth|
                                    NSCalendarUnitDay
                                               fromDate:myDate];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

+ (NSString *)getCityCountyFromString:(NSString *)title {
    NSRange searchResult = [title rangeOfString:@" of "];
    
    if (searchResult.location == NSNotFound) {
        return title;
    } else {
        return [title substringFromIndex:searchResult.location + 4];
    }
}

+ (Quake *)quakeWithEarthquakeInfo:(NSDictionary *)quakeDictionary
            inManagedObjectContext:(NSManagedObjectContext *)context
                    withDateFormat:(NSDateFormatter *)dateFormatter {
    Quake * quake = nil;
    if([quakeDictionary valueForKeyPath:EARTHQUAKE_MAGNITUDE] != NULL && [quakeDictionary valueForKeyPath:EARTHQUAKE_MAGNITUDE] != [NSNull null]) {
        NSString *eventId = [quakeDictionary valueForKeyPath:EARTHQUAKE_EVENT_ID];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:QUAKE_DATABASE];
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
            quake = [NSEntityDescription insertNewObjectForEntityForName:QUAKE_DATABASE inManagedObjectContext:context];
            quake.eventId = eventId;
            quake.place = [quakeDictionary valueForKeyPath:EARTHQUAKE_PLACE];
            quake.title = [self getCityCountyFromString:[quakeDictionary valueForKeyPath:EARTHQUAKE_PLACE]];
            quake.magnitude = [quakeDictionary valueForKeyPath:EARTHQUAKE_MAGNITUDE];
            quake.detailURL = [quakeDictionary valueForKeyPath:EARTHQUAKE_URL];
            
            
            if ([quakeDictionary valueForKey:EARTHQUAKE_TSUNAMI] != [NSNull null] && [quakeDictionary valueForKey:EARTHQUAKE_TSUNAMI] != NULL) {
                quake.tsunami = [quakeDictionary valueForKeyPath:EARTHQUAKE_TSUNAMI];
            } else {
                quake.tsunami = false;
            }
            NSArray *coordinates = [quakeDictionary valueForKeyPath:EARTHQUAKE_LOCATION];
            
            // The longitude, latitude, and depth values are stored in an array in JSON.
            // Access these values by index directly.
            quake.latitude = (NSDecimalNumber *) @([coordinates[1] doubleValue]);
            quake.longitude = (NSDecimalNumber *) @([coordinates[0] doubleValue]);
            quake.depth = (NSDecimalNumber *) @([coordinates[2] doubleValue]);
            
            NSNumber *time = [quakeDictionary valueForKeyPath:EARTHQUAKE_TIME];
            NSTimeInterval timeInterval = [time doubleValue] / 1000.0;
            quake.time = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            quake.date = [self setTimeToZero:quake.time];            
            [dateFormatter setDateFormat:DEFAULT_DATA_WITH_TIME_FORMAT];
            
            quake.subtitle = [dateFormatter stringFromDate:quake.time];
        }
    }
    
    return quake;
}

+ (void)loadEarthquakeDataFromArray:(NSArray *)quakes  // of Quake NSDictionary
            intoManagedObjectCOntext:(NSManagedObjectContext *)context {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSArray *newIDs = [quakes valueForKeyPath:@"distinctUnionOfObject.eventId"];
    
    for (NSDictionary *quake in quakes) {
        [self quakeWithEarthquakeInfo:quake inManagedObjectContext:context withDateFormat:dateFormatter];
    }
}

+ (NSArray *)getTopQuakes:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:QUAKE_DATABASE];
    
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DEFAULT_SORT_ORDER ascending:NO]];
    request.fetchLimit = 100;
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        if (error) {
            matches = nil;
            NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]),
                  NSStringFromSelector(_cmd),
                  [error localizedDescription],
                  [error localizedFailureReason]);
        }
    }
    return matches;
}
@end
