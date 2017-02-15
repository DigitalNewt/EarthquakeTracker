//
//  EarthquakeTableCell.h
//  EarthquakeTracker
//
//  Created by Brent Baker on 2/6/16.
//  Copyright © 2016 HBB Global. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarthquakeTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *magnitude;

@property (weak, nonatomic) IBOutlet UILabel *customTitle;

@property (weak, nonatomic) IBOutlet UIView *statusColor;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeIcon;

@property (weak, nonatomic) IBOutlet UILabel *statusIcon;
@property (weak, nonatomic) IBOutlet UILabel *waveIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *tsunamiLabel;

@end
