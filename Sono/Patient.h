//
//  Patient.h
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Examination;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSNumber * famBelastung;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gebheftId;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * patientId;
@property (nonatomic, retain) NSNumber * praenatDiag;
@property (nonatomic, retain) NSOrderedSet *examinations;
@end

@interface Patient (CoreDataGeneratedAccessors)

- (void)insertObject:(Examination *)value inExaminationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromExaminationsAtIndex:(NSUInteger)idx;
- (void)insertExaminations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeExaminationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInExaminationsAtIndex:(NSUInteger)idx withObject:(Examination *)value;
- (void)replaceExaminationsAtIndexes:(NSIndexSet *)indexes withExaminations:(NSArray *)values;
- (void)addExaminationsObject:(Examination *)value;
- (void)removeExaminationsObject:(Examination *)value;
- (void)addExaminations:(NSOrderedSet *)values;
- (void)removeExaminations:(NSOrderedSet *)values;
@end
