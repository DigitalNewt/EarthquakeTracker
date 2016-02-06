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
#import "SingleEventMapVC.h"
#import "FullMapVC.h"
#import "APIManager.h"
#import "JSONUtility.h"

@interface EarthquakeCDTVC ()
{
    UIRefreshControl *refreshControl;
}
@end

@implementation EarthquakeCDTVC

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
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Earthquake Data Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Quake *quake = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    cell.detailTextLabel.text = [formatter stringFromNumber:quake.magnitude];
    cell.textLabel.text = quake.place;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    Quake *quake = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([vc isKindOfClass:[SingleEventMapVC class]]) {
        SingleEventMapVC *singleEventMapVC = (SingleEventMapVC *)vc;
        singleEventMapVC.quake = quake;
    } else if ([vc isKindOfClass:[FullMapVC class]]) {
        FullMapVC *fullMapVC = (FullMapVC *)vc;
        fullMapVC.title = @"Resent Earthquakes";
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
