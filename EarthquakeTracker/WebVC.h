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

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) Quake *quake;

@end
