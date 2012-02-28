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

@end
