//
//  Examination+Additions.h
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Examination.h"

@interface Examination (Additions)

- (NSUInteger)ageInDays;
- (NSString *)ageAsString;
- (NSString *)heightAsString;
- (NSString *)weightAsString;

- (void)setHeightFromString:(NSString *)value;
- (void)setWeightFromString:(NSString *)value;

@end
