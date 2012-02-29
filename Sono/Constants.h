//
//  Constants.h
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kValidationErrorDomain;


@interface Constants : NSObject

@property (readonly) NSString *version;
@property (readonly) NSArray *booleanValues;
@property (readonly) NSArray *praenatDiagValues;

+ (Constants *)sharedInstance;

@end
