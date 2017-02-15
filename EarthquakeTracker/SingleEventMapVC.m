//
//  SingleEventMapVC.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/3/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "SingleEventMapVC.h"
#import "TextToImage.h"
#import "WebVC.h"
#import "MagnitudeUtilities.h"
@import MapKit;

@interface SingleEventMapVC () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) TextToImage *textToImage;
@end


//Span
#define DEFAULT_SPAN 6.0f;
#define REUSE_ID @"SingleEventMapVC"

@implementation SingleEventMapVC

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
        
        UILabel *disclosureLabel = [[UILabel alloc] init];
        disclosureLabel.frame = CGRectMake(0, 0, 46, 46);
        disclosureLabel.text = DISCLOSURE;
        disclosureLabel.font = [UIFont systemFontOfSize:35];
        disclosureLabel.backgroundColor = [UIColor clearColor];
        disclosureLabel.textColor = [UIColor blackColor];
        [disclosureLabel sizeToFit];
        
        view.rightCalloutAccessoryView = disclosureLabel;
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
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
        }
    }
}


- (void) updateSingleMapViewAnnotations {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //Create the region
    MKCoordinateRegion earthquakeRegion;
    
    //Span
    MKCoordinateSpan span;
    span.latitudeDelta = DEFAULT_SPAN;
    span.longitudeDelta = DEFAULT_SPAN;
    
    earthquakeRegion.center = self.quake.coordinate;
    earthquakeRegion.span = span;
    
    //Set mapView
    [self.mapView setRegion:earthquakeRegion animated:YES];
    
    [self.mapView addAnnotation:self.quake];
    
    self.mapView.centerCoordinate = self.quake.coordinate;
    
    NSMutableArray *quakes = [NSMutableArray arrayWithCapacity:1];
    
    [self.mapView showAnnotations:quakes animated:YES];


}

- (void)setMapView:(MKMapView *)mapView {
    _mapView = mapView;
    self.mapView.delegate = self;
}

- (void)setQuake:(Quake *)quake {
    _quake = quake;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateSingleMapViewAnnotations];

}


@end
