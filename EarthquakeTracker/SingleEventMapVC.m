//
//  SingleEventMapVC.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/3/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "SingleEventMapVC.h"
@import MapKit;

@interface SingleEventMapVC () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *singleMapView;
@end

////Wimbledon Coordiantes
//#define LATITUDE 51.434783;
//#define LONGITUDE -0.213428;

//Span
#define DEFAULT_SPAN 5.0f;

@implementation SingleEventMapVC

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

- (void) updateSingleMapViewAnnotations {
    
    [self.singleMapView removeAnnotations:self.singleMapView.annotations];
    
    //Create the region
    MKCoordinateRegion earthquakeRegion;
    
    //Span
    MKCoordinateSpan span;
    span.latitudeDelta = DEFAULT_SPAN;
    span.longitudeDelta = DEFAULT_SPAN;

    CLLocationCoordinate2D earthquakeCenter;
    earthquakeCenter.latitude = [self.quake.latitude doubleValue];
    earthquakeCenter.longitude = [self.quake.longitude doubleValue];
    
    earthquakeRegion.center = earthquakeCenter;
    earthquakeRegion.span = span;

    NSLog(@"latitude = %@", self.quake.latitude);
    NSLog(@"longitude = %@", self.quake.longitude);
    
    //Set mapView
    [self.singleMapView setRegion:earthquakeRegion animated:YES];
    
    //Create a coordiante for use with the annotation
//    CLLocationCoordinate2D location;
//    location.latitude = LATITUDE;
//    location.longitude = LONGITUDE;
//    wimbLocation.latitude = [self.quake.latitude doubleValue];;
//    wimbLocation.longitude = [self.quake.longitude doubleValue];;
    
    [self.singleMapView addAnnotation:self.quake];
    
//    self.singleMapView.centerCoordinate = earthquakeCenter;
    
    
    
    
    
//    NSArray *quakes = @[self.quake];
//    [self.singleMapView addAnnotations:quakes];
//    [self.singleMapView showAnnotations:quakes animated:YES];

//    self.singleMapView.centerCoordinate = self.quake.coordinate;


}

- (void)setSinlgeMapView:(MKMapView *)singleMapView {
    _singleMapView = singleMapView;
    self.singleMapView.delegate = self;
    [self updateSingleMapViewAnnotations];
}

- (void)setQuake:(Quake *)quake {
    _quake = quake;
    self.title = quake.place;
    [self updateSingleMapViewAnnotations];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateSingleMapViewAnnotations];

}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    //Create the region
//    MKCoordinateRegion earthquakeRegion;
//    
//    //Center
//    CLLocationCoordinate2D earthquakeCenter;
////    earthquakeCenter.latitude = [self.quake.latitude doubleValue];
////    earthquakeCenter.longitude = [self.quake.longitude doubleValue];
//    
//    earthquakeCenter.latitude = LATITUDE;
//    earthquakeCenter.longitude = LONGITUDE;
//    NSLog(@"Latatude =  %f",earthquakeCenter.latitude);
//    NSLog(@"Longitude =  %f",earthquakeCenter.longitude);
//    
//    
//    //Span
//    MKCoordinateSpan span;
//    span.latitudeDelta = DEFAULT_SPAN;
//    span.longitudeDelta = DEFAULT_SPAN;
//    
//    earthquakeRegion.center = earthquakeCenter;
//    earthquakeRegion.span = span;
//    
//    //Set mapView
//    [self.singleMapView setRegion:earthquakeRegion animated:YES];
//    
//    //Create a coordiante for use with the annotation
//    CLLocationCoordinate2D wimbLocation;
//    wimbLocation.latitude = LATITUDE;
//    wimbLocation.longitude = LONGITUDE;
////    wimbLocation.latitude = [self.quake.latitude doubleValue];;
////    wimbLocation.longitude = [self.quake.longitude doubleValue];;
//    
//    Annotation * myAnnotation = [Annotation alloc];
//    myAnnotation.coordinate = wimbLocation;
//    myAnnotation.title = @"Dude";
//    myAnnotation.subtitle = @"This is cool!!";
//
//    
//    [self.singleMapView addAnnotation:myAnnotation];
//    
//    
//    
//}

@end
