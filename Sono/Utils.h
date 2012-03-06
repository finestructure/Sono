//
//  Helpers.h
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WHOPlotViewController.h"


@interface Utils : NSObject


+ (Utils *)sharedInstance;

@property (readonly) WHOPlotViewController *heightPlot;
@property (readonly) WHOPlotViewController *weightPlot;

- (NSString *)shortDate:(NSDate *)date;
- (NSString *)mediumDate:(NSDate *)date;
- (void)showError:(NSError *)error;


@end
