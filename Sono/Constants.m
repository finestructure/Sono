//
//  Constants.m
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Constants.h"


NSString * const kValidationErrorDomain = @"Validierungsfehler";


@implementation Constants


+ (Constants *)sharedInstance {
  static Constants *sharedInstance = nil;
  
  if (sharedInstance) {
    return sharedInstance;
  }
  
  @synchronized(self) {
    if (! sharedInstance) {
      sharedInstance = [[Constants alloc] init];
    }
    
    return sharedInstance;
  }
}


- (NSString *)version {
  static NSString *version = nil;
  
  if (version) {
    return version;
  }
  
  @synchronized(self) {
    if (! version) {
      version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
  }
  
  return version;
}


- (UIColor *)color1 {
  return [UIColor colorWithRed:52/255. green:35/255. blue:38/255. alpha:1];
}


- (UIColor *)color2 {
  return [UIColor colorWithRed:148/255. green:143/255. blue:112/255. alpha:1];
}


- (UIColor *)color3 {
  return [UIColor colorWithRed:196/255. green:197/255. blue:150/255. alpha:1];
}


- (UIColor *)color4 {
  return [UIColor colorWithRed:244/255. green:250/255. blue:186/255. alpha:1];
}


- (UIColor *)color5 {
  return [UIColor colorWithRed:154/255. green:147/255. blue:82/255. alpha:1];
}


- (NSArray *)booleanValues {
  static NSArray *values = nil;
  
  if (values) {
    return values;
  }
  
  @synchronized(self) {
    if (! values) {
      values = [NSArray arrayWithObjects:
                @"keine Angabe",
                @"Ja",
                @"Nein",
                nil];
    }
  }
  
  return values;
}


- (NSArray *)praenatDiagValues {
  static NSArray *values = nil;
  
  if (values) {
    return values;
  }
  
  @synchronized(self) {
    if (! values) {
      values = [NSArray arrayWithObjects:
                @"ja, unauffällig",
                @"nicht durchgeführt",
                @"ja, auffällig",
                @"Kopf/WS auffällig",
                @"Thorax auffällig",
                @"Abdomen auffällig",
                @"Extremitäten auffällig",
                @"Wachstumsretardierung",
                @"Nieren auffällig (allg.)",
                @"Zystennieren/Nierenzysten",
                @"Hydronephrose",
                @"Tumor i. Nierenlager",
                @"Oligohydramnion",
                @"Polyhydramnion",
                @"sonstige Fehlbildung",
                @"keine Angabe",
                @"siehe Freitext",
                nil];
    }
  }
  
  return values;
}


@end
