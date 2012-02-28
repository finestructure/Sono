//
//  Patient.h
//  Sono
//
//  Created by Sven A. Schmidt on 27.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Patient : NSManagedObject

@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSNumber * famBelastung;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gebheftId;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * patientId;
@property (nonatomic, retain) NSNumber * praenatDiag;

@property (readonly) NSString *fullName;

@end
