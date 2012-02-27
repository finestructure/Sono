//
//  Patient.m
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Patient.h"


@implementation Patient

@dynamic birthDate;
@dynamic famBelastung;
@dynamic firstName;
@dynamic gebheftId;
@dynamic gender;
@dynamic lastName;
@dynamic patientId;
@dynamic praenatDiag;


- (NSString *)fullName {
  if (self.firstName == nil && self.lastName == nil) {
    return @"<unbenannt>";
  }
  
  if (self.firstName != nil) {
    NSMutableString *name = [NSMutableString stringWithString:@""];
    [name appendString:self.firstName];
    if (self.lastName != nil) {
      [name appendString:self.lastName];
    }
    return name;
  } else {
    return self.lastName;
  }
}


@end
