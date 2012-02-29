//
//  Patient.m
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Patient.h"
#import "Examination.h"


@implementation Patient

@dynamic birthDate;
@dynamic famBelastung;
@dynamic firstName;
@dynamic gebheftId;
@dynamic gender;
@dynamic lastName;
@dynamic patientId;
@dynamic praenatDiag;
@dynamic examinations;

- (void)addExaminationsObject:(Examination *)value {
  NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.examinations];
  [tempSet addObject:value];
  self.examinations = tempSet;
}


- (BOOL)validateBirthDate:(__autoreleasing id *)value error:(NSError *__autoreleasing *)error
{
  NSDate *date = *value;
  if (date == nil) {
    if (error != nil) {
      NSString *errorStr = @"Geburtsdatum ist Pflichtfeld";
      NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorStr forKey:NSLocalizedDescriptionKey];
      NSError *e = [[NSError alloc] initWithDomain:@"Patient" code:1 userInfo:userInfoDict];
      *error = e;
    }
    return NO;
  }
  if ([[NSDate date] timeIntervalSinceDate:date] < 0) {
    if (error != nil) {
      NSString *errorStr = @"Geburtsdatum muss in der Vegangenheit liegen";
      NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorStr forKey:NSLocalizedDescriptionKey];
      NSError *e = [[NSError alloc] initWithDomain:@"Patient" code:2 userInfo:userInfoDict];
      *error = e;
    }
    return NO;
  }
  return YES;
}


@end
