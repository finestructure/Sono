//
//  Constants.m
//  Sono
//
//  Created by Sven A. Schmidt on 28.02.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import "Constants.h"

#import "CSVParser.h"


NSString * const kValidationErrorDomain = @"Validierungsfehler";
NSString * const kWhoWeightGirls = @"WhoWeightGirls";
NSString * const kWhoHeightGirls = @"WhoHeightGirls";
NSString * const kWhoWeightBoys = @"WhoWeightBoys";
NSString * const kWhoHeightBoys = @"WhoHeightBoys";


@interface Constants () {
  dispatch_queue_t whoDataSerialQueue;
}

@property (strong) NSMutableDictionary *whoData;

@end


@implementation Constants

@synthesize whoData = _whoData;


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


- (NSArray *)parseDataForResource:(NSString *)resource {
  NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"txt"];
  if (url == nil) {
    // unit tests require this
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    url = [thisBundle URLForResource:resource withExtension:@"txt"];
  }
  if (url == nil) {
    NSLog(@"warning: no valid resource url!");
    return nil;
  }
  
  NSError *error = nil;
  NSString *data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
  if (error == nil) {
    CSVParser *parser = [[CSVParser alloc] initWithString:data separator:@"\t" hasHeader:YES fieldNames:nil];
    NSArray *rows = [parser arrayOfParsedRows];
    return rows;
  } else {
    return nil;
  }
}


- (id)init {
  self = [super init];
  if (self) {
    whoDataSerialQueue = dispatch_queue_create("de.abstracture.Sono.whoDataSerialQueue", NULL);
    self.whoData = [NSMutableDictionary dictionary];
    
    NSDictionary *resourceMap = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"lhfa_boys_p_exp", kWhoHeightBoys,
                                 @"lhfa_girls_p_exp", kWhoHeightGirls,
                                 @"wfa_boys_p_exp", kWhoWeightBoys,
                                 @"wfa_girls_p_exp", kWhoWeightGirls,
                                 nil];
    [resourceMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *resource = obj;
        NSArray *rows = [self parseDataForResource:resource];
        dispatch_async(whoDataSerialQueue, ^{
          [self.whoData setObject:rows forKey:key];
        });
      });
    }];
  }
  return self;
}


- (void)dealloc {
  dispatch_release(whoDataSerialQueue);
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


- (NSArray *)whoData:(NSString *)dataSet {
  __block NSArray *result = nil;
  
  dispatch_sync(whoDataSerialQueue, ^{
    result = [self.whoData objectForKey:dataSet];
  });

  while (result == nil) {
    // keep polling until there's a value
    dispatch_sync(whoDataSerialQueue, ^{
      result = [self.whoData objectForKey:dataSet];
    });
  }
  return result;
}


@end
