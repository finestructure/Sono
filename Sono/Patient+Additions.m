//
//  Patient+Additions.m
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Patient+Additions.h"

@implementation Patient (Additions)


- (NSString *)fullName {
  if (self.firstName == nil && self.lastName == nil) {
    return @"<unbenannt>";
  }
  
  if (self.firstName != nil) {
    NSMutableString *name = [NSMutableString stringWithString:@""];
    [name appendString:self.firstName];
    if (self.lastName != nil) {
      [name appendString:@" "];
      [name appendString:self.lastName];
    }
    return name;
  } else {
    return self.lastName;
  }
}


@end
