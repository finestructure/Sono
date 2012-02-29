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


- (void)showError:(NSError *)error {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"General error dialog title") message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}


@end
