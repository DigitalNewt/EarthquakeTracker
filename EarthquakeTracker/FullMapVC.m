//
//  FullMapVC.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/3/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "FullMapVC.h"
#import "Quake+Annotation.h"
#import "AppDelegate.h"
#import "WebVC.h"
#import "TextToImage.h"
#import "MagnitudeUtilities.h"
@import MapKit;

@interface FullMapVC () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *latestEarthquakes;
@property (strong, nonatomic) TextToImage *textToImage;

@end

#define REUSE_ID @"FullEventMapVC"

@implementation FullMapVC

- (TextToImage *)textToImage {
    if (!_textToImage) {
        _textToImage = [[TextToImage alloc] init];
    }
    return _textToImage;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *reuseId = REUSE_ID;
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        
        view.canShowCallout = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        view.leftCalloutAccessoryView = imageView;
        
        UIButton *disclosureButton = [[UIButton alloc] init];
        UIImage *disclosure = [self.textToImage convertTextToImage:DISCLOSURE withImageView:imageView withColor:[UIColor blackColor]];
        
        [disclosureButton setBackgroundImage:disclosure forState:UIControlStateNormal];
        [disclosureButton sizeToFit];
        view.rightCalloutAccessoryView = disclosureButton;
    }
    
    view.annotation = annotation;
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [self updateLeftCalloutAccessoryViewInAnnotationView:view];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:WEBVC_IDENTIFIER sender:view];
}

- (void)prepareViewController:(id)vc
                       forSeq:(NSString *)sequeIdentifer
             toShowAnnotation:(id <MKAnnotation>)annotation {
    Quake *quake = nil;
    if ([annotation isKindOfClass:[Quake class]]) {
        quake = (Quake *)annotation;
    }
    if (quake) {
        if (![sequeIdentifer length] || [sequeIdentifer isEqualToString:WEBVC_IDENTIFIER]) {
            if ([vc isKindOfClass:[WebVC class]]) {
                WebVC *wvc = (WebVC *)vc;
                wvc.quake = quake;
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[MKAnnotationView class]]) {
        [self prepareViewController:segue.destinationViewController
                             forSeq:segue.identifier
                   toShowAnnotation:((MKAnnotationView *)sender).annotation];
    }
}

- (void)updateLeftCalloutAccessoryViewInAnnotationView:(MKAnnotationView *)annotationView
{
    UIImageView *imageView = nil;
    if ([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
    }
    if (imageView) {
        Quake *quake = nil;
        if ([annotationView.annotation isKindOfClass:[Quake class]]) {
            quake = (Quake *)annotationView.annotation;
        }
        if (quake) {
            UIColor *fontColor = [MagnitudeUtilities getFontStatusColor:quake.magnitude];
            UIColor *backgroundColor = [MagnitudeUtilities getStatusColor:quake.magnitude];
            imageView.image = [self.textToImage convertNumberToImage:quake.magnitude withImageView:imageView withTextColor:fontColor withBackgroundColor:backgroundColor];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
        }
    }
}


- (void)updateFullMapViewAnnotations {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.latestEarthquakes];
    [self.mapView showAnnotations:self.latestEarthquakes animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = UIApplication.sharedApplication.delegate;
    self.latestEarthquakes = [Quake getTopQuakes:appDelegate.managedObjectContext];
}

- (void)setMapView:(MKMapView *)mapView {
    _mapView = mapView;
    self.mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateFullMapViewAnnotations];
}

- (IBAction)exit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
