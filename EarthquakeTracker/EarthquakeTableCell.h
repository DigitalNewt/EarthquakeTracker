//
//  EarthquakeTableCell.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/6/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarthquakeTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *magnitude;

@property (strong, nonatomic) IBOutlet UILabel *customTitle;


@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIView *statusColor;

@property (strong, nonatomic) IBOutlet UILabel *dateIcon;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeIcon;

@property (strong, nonatomic) IBOutlet UILabel *statusIcon;
@property (weak, nonatomic) IBOutlet UILabel *waveIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *tsunamiLabel;

@end
