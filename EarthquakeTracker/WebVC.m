//
//  WebVC.m
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/7/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import "WebVC.h"

@implementation WebVC

- (IBAction)exitWebVC:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;

    NSURL *url = [NSURL URLWithString:self.quake.detailURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}


- (void) webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.activityIndicator removeFromSuperview];
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}


@end
