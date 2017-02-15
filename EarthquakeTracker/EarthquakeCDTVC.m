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
#import "SingleEventMapVC.h"
#import "APIManager.h"
#import "JSONUtility.h"
#import "EarthquakeTableCell.h"
#import "DateFormats.h"
#import "FontelloIcons.h"
#import "MagnitudeUtilities.h"
#import "AlertUtility.h"

@interface EarthquakeCDTVC ()
{
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIFont *quakeFont;
@property (nonatomic, strong) UIFont *buttonFont;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fullMapButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;

@end

@implementation EarthquakeCDTVC


- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (UIFont *)quakeFont {
    if (_quakeFont == nil) {
        _quakeFont = [UIFont fontWithName:FONTELLO_FILE size:14.0];
    }
    return _quakeFont;
}

- (UIFont *)buttonFont {
    if (_buttonFont == nil) {
        _buttonFont = [UIFont fontWithName:FONTELLO_FILE size:25.0];
    }
    return _buttonFont;
}

- (NSNumberFormatter *)numberFormatter {
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
    }
    return _numberFormatter;
}

- (void)awakeFromNib {
        [[NSNotificationCenter defaultCenter] addObserverForName:QUAKE_DATABASE_AVAILIBILITY_NOTIFICATION
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          self.managedObjectContext = note.userInfo[QUAKE_DATABASE_AVAILIBILITY_CONTEXT];
                                                      }];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:QUAKE_DATABASE];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:DEFAULT_SORT_ORDER ascending:NO];

    request.predicate = nil;
    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:@"date"
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Earthquake Data Cell";
    EarthquakeTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Quake *quake = (Quake *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    customCell.magnitude.text = [self.numberFormatter stringFromNumber:quake.magnitude];
    customCell.customTitle.text = quake.place;
    
    [self.dateFormatter setDateFormat:DEFAULT_DATA_FORMAT];
    
    customCell.timeIcon.font = self.quakeFont;
    customCell.timeIcon.text = TIME_ICON;
    
    [self.dateFormatter setDateFormat:DEFAULT_TIME_FORMAT];
    customCell.timeLabel.text = [self.dateFormatter stringFromDate:quake.time];
    
    customCell.statusIcon.font = self.quakeFont;
    
    customCell.statusIcon.text = [MagnitudeUtilities getStatusIconNumber:quake.magnitude];
    
    customCell.statusColor.backgroundColor = [MagnitudeUtilities getStatusColor:quake.magnitude];
    
    if (quake.tsunami) {
        customCell.waveIconLabel.hidden = false;
        customCell.tsunamiLabel.hidden = false;
        customCell.waveIconLabel.font = self.quakeFont;
        customCell.waveIconLabel.text = WAVE_ICON;
        customCell.waveIconLabel.textColor = [UIColor blueColor];
    } else {
        customCell.waveIconLabel.hidden = true;
        customCell.tsunamiLabel.hidden = true;
    }
    return customCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 88.0)];
    customView.backgroundColor = [UIColor lightGrayColor];
    
    // create the button object
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //headerLabel.backgroundColor = [UIColor grayColor];
    dateLabel.opaque = NO;
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.highlightedTextColor = [UIColor whiteColor];
    dateLabel.font = [UIFont boldSystemFontOfSize:16];
    dateLabel.numberOfLines = 0;
    dateLabel.textAlignment = NSTextAlignmentLeft;
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    Quake *quake = sectionInfo.objects[0];
    [self.dateFormatter setDateFormat:@" E, LLLL d yyyy"];
    
    NSString *diaplayDate = [self.dateFormatter stringFromDate:quake.time];
    dateLabel.text = diaplayDate;
    dateLabel.frame = CGRectMake(0.0, 0.0, 200.0, 24.0);
    [customView addSubview:dateLabel];
    
    return customView;
    
}

#pragma mark - Navigation

/**
 * Determine which controller class is getting called and set properties needed for segue.
 */
- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    Quake *quake = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([vc isKindOfClass:[WebVC class]]) {
        WebVC *webVC = (WebVC *)vc;
        webVC.quake = quake;
    } else if ([vc isKindOfClass:[SingleEventMapVC class]]) {
        SingleEventMapVC * singleEventMapVC = (SingleEventMapVC *)vc;
        singleEventMapVC.quake = quake;        
    }
}


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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
//    self.navigationController.navigationBar.backgroundColor = [UIColor brownColor];
    self.navigationController.navigationBar.alpha = 1;
    [self.fullMapButton setTitleTextAttributes:@{
                                                 NSFontAttributeName: self.buttonFont,
                                                 NSForegroundColorAttributeName: [UIColor grayColor]
                                                 } forState:UIControlStateNormal];
    self.fullMapButton.title = GLOBE_ICON;
    
    [self.infoButton setTitleTextAttributes:@{
                                                 NSFontAttributeName: self.buttonFont,
                                                 NSForegroundColorAttributeName: [UIColor grayColor]
                                                 } forState:UIControlStateNormal];
    self.infoButton.title = INFO_ICON;
    
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
    
    NSDictionary *queryData = [APIManager constructQuery:limit withOrder: DEFAULT_SORT_ORDER];
    
    [APIManager requestHTTPGet:queryData withAction:kQuery onCompletion: ^(NSString *result, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"Failed to query earthquake data.  ");
                NSLog(@"%@", error);
                [AlertUtility showMessage:NETWORK_ERROR_MESSAGE withTitle:NETWORK_ERROR_TITLE];
            } else {
                NSDictionary *results = [JSONUtility getDictionaryFromJSON:result];
                NSArray *earthquakes = [results objectForKey:EARTHQUAKE_FEATURES];
                [Quake loadEarthquakeDataFromArray:earthquakes intoManagedObjectCOntext:self.managedObjectContext];                
                [self.tableView reloadData];
            }
            [(UIRefreshControl *)sender endRefreshing];
        });
    }];
}

@end
