//
//  EarthquakeCDTVC.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/5/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "CoreDataTVC.h"

@interface EarthquakeCDTVC : CoreDataTVC

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
