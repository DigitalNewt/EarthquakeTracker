//
//  WebVC.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/7/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "Quake.h"
@import UIKit;

@interface WebVC : UIViewController <UIWebViewDelegate>

#define WEBVC_IDENTIFIER @"Show Web"

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) Quake *quake;

@end
