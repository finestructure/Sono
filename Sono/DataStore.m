//
//  DataStore.m
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore


+ (DataStore *)sharedInstance {
  static DataStore *sharedInstance = nil;
  
  if (sharedInstance) {
    return sharedInstance;
  }
  
  @synchronized(self) {
    if (! sharedInstance) {
      sharedInstance = [[DataStore alloc] init];
    }
    
    return sharedInstance;
  }
}


@end
