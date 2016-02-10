//
//  FullMapVC.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/3/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "Quake+Annotation.h"
@import UIKit;

@interface FullMapVC : UIViewController <NSFetchedResultsControllerDelegate>

// The controller
@property (weak, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
