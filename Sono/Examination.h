//
//  Examination.h
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface Examination : NSManagedObject

@property (nonatomic, retain) NSDate * examinationDate;
@property (nonatomic, retain) NSString * examiner;
@property (nonatomic, retain) NSDecimalNumber * weight;
@property (nonatomic, retain) NSDecimalNumber * height;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) Patient *patient;

@end
