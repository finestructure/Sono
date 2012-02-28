//
//  Constants.m
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Constants.h"

@implementation Constants


+ (Constants *)sharedInstance {
  static Constants *sharedInstance = nil;
  
  if (sharedInstance) {
    return sharedInstance;
  }
  
  @synchronized(self) {
    if (! sharedInstance) {
      sharedInstance = [[Constants alloc] init];
    }
    
    return sharedInstance;
  }
}


- (NSString *)version {
  static NSString *version = nil;
  
  if (version) {
    return version;
  }
  
  @synchronized(self) {
    if (! version) {
      version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
  }
  
  return version;
}


- (NSArray *)booleanValues {
  static NSArray *values = nil;
  
  if (values) {
    return values;
  }
  
  @synchronized(self) {
    if (! values) {
      values = [NSArray arrayWithObjects:
                @"keine Angabe",
                @"Ja",
                @"Nein",
                nil];
    }
  }
  
  return values;
}


@end
