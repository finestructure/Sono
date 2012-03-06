//
//  Constants.h
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kValidationErrorDomain;
extern NSString * const kWhoWeightGirls;
extern NSString * const kWhoHeightGirls;
extern NSString * const kWhoWeightBoys;
extern NSString * const kWhoHeightBoys;


@interface Constants : NSObject

@property (readonly) NSString *version;
@property (readonly) NSArray *booleanValues;
@property (readonly) NSArray *praenatDiagValues;
@property (readonly) UIColor *color1;
@property (readonly) UIColor *color2;
@property (readonly) UIColor *color3;
@property (readonly) UIColor *color4;
@property (readonly) UIColor *color5;

+ (Constants *)sharedInstance;

- (NSArray *)whoData:(NSString *)dataSet;

@end
