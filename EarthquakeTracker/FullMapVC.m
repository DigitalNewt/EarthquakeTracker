//
//  FullMapVC.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/3/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "FullMapVC.h"
#import "Quake+Annotation.h"
@import MapKit;

@interface FullMapVC () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *fullMapView;
@property (nonatomic, strong) NSArray *latestEarthquakes;
@end

@implementation FullMapVC

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *reuseId = @"SingleEventMapVC";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        
        view.canShowCallout = YES;
    }
    
    view.annotation = annotation;
    
    return view;
}

- (void) updateFullMapViewAnnotations {
    [self.fullMapView removeAnnotations:self.fullMapView.annotations];
    [self.fullMapView addAnnotations:self.latestEarthquakes];
    [self.fullMapView showAnnotations:self.latestEarthquakes animated:YES];
}

- (void)setFullMapView:(MKMapView *)fullMapView {
    _fullMapView = fullMapView;
    self.fullMapView.delegate = self;
    [self updateFullMapViewAnnotations];
}


- (NSArray *)latestEarthquakes {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Quake"];
    
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    request.fetchLimit = 100;
    
    _latestEarthquakes = [self.managedObjectContext executeFetchRequest:request error:NULL];
    return _latestEarthquakes;
}


- (IBAction)exit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
