//
//  APIManager.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/3/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

@import UIKit;

#define EARTHQUAKE_URL @"properties.url"
#define EARTHQUAKE_TIME @"properties.time"
#define EARTHQUAKE_TIME_ZONE @"properties.tz"
#define EARTHQUAKE_TSUNAMI @"properties.tsunami"
#define EARTHQUAKE_EVENT_ID @"properties.ids"
#define EARTHQUAKE_LOCATION @"geometry.coordinates"
#define EARTHQUAKE_MAGNITUDE @"properties.mag"
#define EARTHQUAKE_PLACE @"properties.place"
#define EARTHQUAKE_FEATURES @"features"

extern NSString *const kQuery;

typedef void(^RequestCompletionHandler) (NSString*, NSError*);

@interface APIManager : NSObject

+ (NSDictionary *)constructQuery:(NSString *)limit withOrder: (NSString *) orderby;

+ (void)requestHTTPGet:(NSDictionary *)userData withAction:(NSString *)action onCompletion:(RequestCompletionHandler)complete;

+ (void)sendHTTPGet:(NSDictionary *)userData withAction:(NSString *)action onCompletion:(RequestCompletionHandler)complete;

@end
