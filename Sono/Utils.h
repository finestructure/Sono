//
//  Helpers.h
//  Sono
//
//  Created by Sven A. Schmidt on 29.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject


+ (Utils *)sharedInstance;


- (NSString *)shortDate:(NSDate *)date;
- (NSString *)mediumDate:(NSDate *)date;


@end
