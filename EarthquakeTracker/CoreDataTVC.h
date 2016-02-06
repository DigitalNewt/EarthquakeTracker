//
//  CoreDataTVC.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/5/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

@import UIKit;
@import CoreData;

@interface CoreDataTVC : UITableViewController <NSFetchedResultsControllerDelegate>

// The controller
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(void)performFetch;

//Set to YES to get some debugging output in the console.
@property BOOL debug;


@end
