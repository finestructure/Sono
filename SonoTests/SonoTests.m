//
//  SonoTests.m
//  SonoTests
//
//  Created by Sven A. Schmidt on 02.03.12.
//  Copyright (c) 2012 abstracture GmbH & Co. KG. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "CSVParser.h"

@interface SonoTests : SenTestCase
@end


@implementation SonoTests


- (void)setUp {
  [super setUp];
}


- (void)tearDown {
  [super tearDown];
}


- (void)test_01_parser {
  NSString *test = @"A;B;C\n1;2;3\n";
  CSVParser *parser = [[CSVParser alloc] initWithString:test separator:@";" hasHeader:YES fieldNames:nil];
  __block int count = 0;
  [parser parseRowsUsingBlock:^(NSDictionary *row) {
    count++;
    STAssertEqualObjects([row objectForKey:@"A"], @"1", nil);
    STAssertEqualObjects([row objectForKey:@"B"], @"2", nil);
    STAssertEqualObjects([row objectForKey:@"C"], @"3", nil);
  }];
}

@end
