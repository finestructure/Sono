//
//  Examination+Additions.m
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Examination+Additions.h"
#import "Patient.h"


@implementation Examination (Additions)


- (NSUInteger)ageInDays {
  NSTimeInterval age = [self.examinationDate timeIntervalSinceDate:self.patient.birthDate];
  int ageInDays = (age + 0.5) / 86400.; // 86400 seconds per day
  return ageInDays;
}


- (NSString *)ageAsString {
  NSUInteger age = [self ageInDays];
  NSString *formatString = (age == 1) ? @"%d Tag" : @"%d Tage";
  return [NSString stringWithFormat:formatString, age];
}


- (NSString *)heightAsString {
  return [NSString stringWithFormat:@"%d cm", self.height];
}


- (NSString *)weightAsString {
  return [NSString stringWithFormat:@"%d g", self.weight];
}


@end
