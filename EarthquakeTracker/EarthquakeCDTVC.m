//
//  EarthquakeCDTVC.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/5/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "EarthquakeCDTVC.h"
#import "Quake.h"
#import "QuakeDatabaseAvailibility.h"
#import "WebVC.h"
#import "APIManager.h"
#import "JSONUtility.h"
#import "EarthquakeTableCell.h"

@interface EarthquakeCDTVC ()
{
    UIRefreshControl *refreshControl;
}

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIFont *quakeFonts;

@end

@implementation EarthquakeCDTVC


- (UIFont *)quakeFonts
{
    if (_quakeFonts == nil) {
        _quakeFonts = [UIFont fontWithName:@"fontello" size:14.0];
    }
    return _quakeFonts;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (void)awakeFromNib
{
        [[NSNotificationCenter defaultCenter] addObserverForName:QUAKE_DATABASE_AVAILIBILITY_NOTIFICATION
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          self.managedObjectContext = note.userInfo[QUAKE_DATABASE_AVAILIBILITY_CONTEXT];
                                                      }];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Quake"];
    
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

/**
 * Return UIColor for magnitude level.
 */
- (UIColor *)getStatusColor:(NSNumber *)magnitude {
    
    if ([[NSNumber numberWithDouble:8.0] compare:magnitude] == NSOrderedAscending) {
        return [UIColor brownColor];
    } else if ([[NSNumber numberWithDouble:7.0] compare:magnitude] == NSOrderedAscending) {
        return [UIColor colorWithRed:0.651 green:0.11 blue:0 alpha:1];
    } else if ([[NSNumber numberWithDouble:6.0] compare:magnitude] == NSOrderedAscending) {
        return [UIColor redColor];
    } else if ([[NSNumber numberWithDouble:5.0]compare:magnitude] == NSOrderedAscending) {
        return [UIColor orangeColor];
    } else if ([[NSNumber numberWithDouble:4.0]compare:magnitude] == NSOrderedAscending) {
        return [UIColor yellowColor];
    } else if ([[NSNumber numberWithDouble:3.0]compare:magnitude] == NSOrderedAscending) {
        return [UIColor greenColor];
    } else if ([[NSNumber numberWithDouble:2.5]compare:magnitude] == NSOrderedAscending) {
        return [UIColor blueColor];
    } else {
        return [UIColor whiteColor];
    }

}

- (NSString *)getStatusIconNumber:(NSNumber *)magnitude {
    
    if ([[NSNumber numberWithDouble:8.0] compare:magnitude] == NSOrderedAscending) {
        return @"\ue807";
    } else if ([[NSNumber numberWithDouble:7.0] compare:magnitude] == NSOrderedAscending) {
        return @"\ue808";
    } else if ([[NSNumber numberWithDouble:6.0] compare:magnitude] == NSOrderedAscending) {
        return @"\ue80b";
    } else if ([[NSNumber numberWithDouble:5.0]compare:magnitude] == NSOrderedAscending) {
        return @"\ue801";
    } else if ([[NSNumber numberWithDouble:4.0]compare:magnitude] == NSOrderedAscending) {
        return @"\ue80c";
    } else if ([[NSNumber numberWithDouble:3.0]compare:magnitude] == NSOrderedAscending) {
        return @"\ue80a";
    } else if ([[NSNumber numberWithDouble:2.5]compare:magnitude] == NSOrderedAscending) {
        return @"\ue809";
    } else {
        return @"\ue805";
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Earthquake Data Cell";
    EarthquakeTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Quake *quake = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    customCell.magnitude.text = [formatter stringFromNumber:quake.magnitude];
    customCell.customTitle.text = quake.place;
    
    [self.dateFormatter setDateFormat:@"E  MM/dd/yyyy"];
    
    customCell.dateLabel.text = [self.dateFormatter stringFromDate:quake.time];
    customCell.dateIcon.font = self.quakeFonts;
    customCell.dateIcon.text = @"\ue802";
    customCell.timeIcon.font = self.quakeFonts;
    customCell.timeIcon.text = @"\ue803";
    
    [self.dateFormatter setDateFormat:@"hh:mm a"];
    customCell.timeLabel.text = [self.dateFormatter stringFromDate:quake.time];
    
    customCell.statusIcon.font = self.quakeFonts;
    customCell.statusIcon.text = [self getStatusIconNumber:quake.magnitude];
    
    customCell.statusColor.backgroundColor = [self getStatusColor:quake.magnitude];
    return customCell;
}

#pragma mark - Navigation

- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    Quake *quake = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([vc isKindOfClass:[WebVC class]]) {
        WebVC *webVC = (WebVC *)vc;
        webVC.quake = quake;
    }
    
}

// boilerplate
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
}

// boilerplate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detailvc = [self.splitViewController.viewControllers lastObject];
    if ([detailvc isKindOfClass:[UINavigationController class]]) {
        detailvc = [((UINavigationController *)detailvc).viewControllers firstObject];
        [self prepareViewController:detailvc
                           forSegue:nil
                      fromIndexPath:indexPath];
    }
}

#pragma mark - Pull to Refresh
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor brownColor];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(fetchEarthquakeData:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refreshControl];
}

/**
 * Call API to retrieve Earthquake data
 @returns void
 */
- (void)fetchEarthquakeData:(id)sender {
    
    NSString *limit = @"20";
    NSString *orderby = @"time";
    
    NSDictionary *queryData = [APIManager constructQuery:limit withOrder: orderby];
    
    [APIManager requestHTTPGet:queryData withAction:kQuery onCompletion: ^(NSString *result, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"Failed to query earthquake data.  ");
                NSLog(@"%@", error);
            } else {
                NSDictionary *results = [JSONUtility getDictionaryFromJSON:result];
                NSArray *earthquakes = [results objectForKey:EARTHQUAKE_FEATURES];
                [Quake loadEarthquakeDataFromArray:earthquakes intoManagedObjectCOntext:self.managedObjectContext];                
                [self.tableView reloadData];
                [(UIRefreshControl *)sender endRefreshing];
            }
        });
    }];
}

@end
