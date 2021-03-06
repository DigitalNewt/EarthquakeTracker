//
//  AppDelegate.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/3/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "AppDelegate.h"
#import "APIManager.h"
#import "Quake.h"
#import "JSONUtility.h"
#import "QuakeDatabaseAvailibility.h"
#import "AlertUtility.h"

@interface AppDelegate ()
@property (strong, nonatomic) NSManagedObjectContext *quakeDatabaseContext;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.quakeDatabaseContext = [self managedObjectContext];
    [self fetchEarthquakeData:application performFetchWithCompletionHandler:nil];
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (self.quakeDatabaseContext) {
        NSDictionary *queryData = [APIManager constructQuery:BACKGROUND_QUAKE_FETCH_LIMIT withOrder: BACKGROUND_QUAKE_FETCH_ORDERBY];
        
        [APIManager requestHTTPGet:queryData withAction:kQuery onCompletion: ^(NSString *result, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (completionHandler) {
                        completionHandler(UIBackgroundFetchResultFailed);
                    }
                    NSLog(@"Earthquake background fetch failed: %@", error.localizedDescription);
                    [AlertUtility showMessage:NETWORK_ERROR_MESSAGE withTitle:NETWORK_ERROR_TITLE];
                    
                    NSLog(@"%@", error);
                } else {
                    [self stopFetchingEarthquakeData:result
                                         intoContext:self.quakeDatabaseContext];
                    if (completionHandler) {
                        completionHandler(UIBackgroundFetchResultNewData);
                    }
                }
            });
        }];

    }else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hbbglobal.EarthquakeTracker" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EarthquakeTracker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EarthquakeTracker.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Database Context

- (void)setQuakeDatabaseContext:(NSManagedObjectContext *)quakeDatabaseContext
{
    _quakeDatabaseContext = quakeDatabaseContext;
        
    NSDictionary *userInfo = self.quakeDatabaseContext ? @{ QUAKE_DATABASE_AVAILIBILITY_CONTEXT : self.quakeDatabaseContext } : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:QUAKE_DATABASE_AVAILIBILITY_NOTIFICATION
                                                        object:self
                                                      userInfo:userInfo];
}

#pragma mark - Fetch Earthquake data

/**
 * Call API to retrieve Earthquake data
 @returns void
 */
- (void)fetchEarthquakeData:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    
    if (self.quakeDatabaseContext) {
        NSDictionary *queryData = [APIManager constructQuery:BACKGROUND_QUAKE_FETCH_LIMIT withOrder: BACKGROUND_QUAKE_FETCH_ORDERBY];
        
        [APIManager requestHTTPGet:queryData withAction:kQuery onCompletion: ^(NSString *result, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Earthquake background fetch failed: %@", error.localizedDescription);
                    [AlertUtility showMessage:NETWORK_ERROR_MESSAGE withTitle:NETWORK_ERROR_TITLE];
                    NSLog(@"%@", error);
                    if (completionHandler) {
                        completionHandler(UIBackgroundFetchResultFailed);
                    }
                    
                } else {
                    [self stopFetchingEarthquakeData:result intoContext:self.quakeDatabaseContext];
                    if (completionHandler) {
                        completionHandler(UIBackgroundFetchResultNewData);
                    }
                }
            });
        }];
    }
}

/**
 * Stop retrieveing Earthquake data and reload tableview.
 */
-(void)stopFetchingEarthquakeData:(NSString *) result
                      intoContext:(NSManagedObjectContext *)context {
    if (context) {
        NSDictionary *results = [JSONUtility getDictionaryFromJSON:result];
        NSArray *earthquakes = [results objectForKey:EARTHQUAKE_FEATURES];
        [context performBlock:^{
            [Quake loadEarthquakeDataFromArray:earthquakes intoManagedObjectCOntext:context];
            [context save:NULL];
        }];
    }    
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
