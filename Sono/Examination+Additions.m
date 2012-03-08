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


- (NSString *)heightAsStringWithUnits:(BOOL)units {
  if (units) {
    return [NSString stringWithFormat:@"%d cm", self.height.intValue];
  } else {
    return [NSString stringWithFormat:@"%d", self.height.intValue];
  }
}


- (NSString *)weightAsStringWithUnits:(BOOL)units {
  if (units) {
    return [NSString stringWithFormat:@"%d g", self.weight.intValue];
  } else {
    return [NSString stringWithFormat:@"%d", self.weight.intValue];
  }
}


- (NSNumber *)numberFromString:(NSString *)string {
  static NSNumberFormatter *f = nil;
  if (f == nil) {
    f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
  }
  return [f numberFromString:string];
}


- (NSNumber *)numberFromString:(NSString *)string ignoringSuffixes:(NSArray *)suffixes {
  for (NSString *suffix in suffixes) {
    if ([string hasSuffix:suffix]) {
      NSString *s = [string substringWithRange:NSMakeRange(0, string.length-suffix.length)];
      return [self numberFromString:s];
    }
  }
  return [self numberFromString:string];
}


- (void)setHeightFromString:(NSString *)value {
  NSArray *suffixes = [NSArray arrayWithObjects:@" cm", @"cm", nil];
  NSNumber *val = [self numberFromString:value ignoringSuffixes:suffixes];
  self.height = val;
}


- (void)setWeightFromString:(NSString *)value {
  NSArray *suffixes = [NSArray arrayWithObjects:@" g", @"g", nil];
  NSNumber *val = [self numberFromString:value ignoringSuffixes:suffixes];
  self.weight = val;
}


@end
