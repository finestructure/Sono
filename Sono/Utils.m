//
//  Helpers.m
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+ (Utils *)sharedInstance {
  static Utils *sharedInstance = nil;

  if (sharedInstance) {
    return sharedInstance;
  }
  
  @synchronized(self) {
    if (! sharedInstance) {
      sharedInstance = [[Utils alloc] init];
    }
    
    return sharedInstance;
  }
}


- (WHOPlotViewController *)heightPlot {
  static WHOPlotViewController *plot = nil;
  if (plot) {
    return plot;
  }
  @synchronized(self) {
    if (! plot) {
      float width = 300;
      float height = 200;
      CGRect frame = CGRectMake(0, 0, width, height);
      plot = [[WHOPlotViewController alloc] initWithWithFrame:frame];
    }
  }
  return plot;
}


- (WHOPlotViewController *)weightPlot {
  static WHOPlotViewController *plot = nil;
  if (plot) {
    return plot;
  }
  @synchronized(self) {
    if (! plot) {
      float width = 300;
      float height = 200;
      CGRect frame = CGRectMake(0, 0, width, height);
      plot = [[WHOPlotViewController alloc] initWithWithFrame:frame];
    }
  }
  return plot;
}


- (NSString *)shortDate:(NSDate *)date {
  static NSDateFormatter *dateFormatter = nil;
  if (dateFormatter == nil) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
  }
  return [dateFormatter stringFromDate:date];
}


- (NSString *)mediumDate:(NSDate *)date {
  static NSDateFormatter *dateFormatter = nil;
  if (dateFormatter == nil) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  }
  return [dateFormatter stringFromDate:date];
}


- (void)showError:(NSError *)error {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error domain] message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}


@end
