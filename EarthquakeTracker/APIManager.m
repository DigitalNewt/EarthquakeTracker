//
//  APIManager.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/3/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager
NSString *const rootURL = @"http://ehp2-earthquake.wr.usgs.gov/fdsnws/event/1/";

NSString *const kQuery = @"query";


/*
 * Convert NSDictionary to JSON string
 * @return JSON in NSString
 */
+ (NSString *)toJSON:(NSDictionary *)dictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:0
                                                         error:&error];
    NSString *JSONString = nil;
    
    if (!jsonData) {
        NSLog(@"JSON error: %@", error);
    } else {
        
        JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        NSLog(@"JSON OUTPUT: %@",JSONString);
    }
    
    return JSONString;
}

+ (NSString *)toURL:(NSDictionary *)dictionary
{
    NSMutableString *urlData = [NSMutableString stringWithString:@""];
    if (dictionary != nil && dictionary.count > 0) {
        BOOL firstParameter = true;
        [urlData appendString:@"?"];
        for(id key in dictionary) {
            if (firstParameter) {
                [urlData appendString:[NSString stringWithFormat:@"%@=%@",key, [dictionary objectForKey:key]]];
                firstParameter = false;
            } else {
                [urlData appendString:[NSString stringWithFormat:@"&%@=%@",key, [dictionary objectForKey:key]]];
            }
            
        }
    }
    return urlData;
}


+ (NSDictionary *)constructQuery:(NSString *)limit withOrder: (NSString *) orderby {
    NSString *format = @"geojson";
    NSString *eventtype = @"earthquake";
    NSString *jsonerror = @"true";
    NSString *minmagnitude = @"2.0";
    
    NSDictionary *queryData = @{@"limit":limit,
                                @"eventtype":eventtype,
                                @"orderby":orderby,
                                @"format":format,
                                @"jsonerror":jsonerror,
                                @"minmagnitude": minmagnitude};

    return queryData;
}


/*
 * HTTP Get Request
 * @returns Dictionary with results.
*/
+ (void)requestHTTPGet:(NSDictionary *)queryData withAction:(NSString *)action onCompletion:(RequestCompletionHandler)complete
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",rootURL, action, [self toURL:queryData]]]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:50];
    
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (complete) {
            complete(result, connectionError);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }] resume];
}

@end
