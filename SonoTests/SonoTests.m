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


- (void)test_01_parser_lf_only {
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


- (void)test_02_parser_cr_only {
  NSString *test = @"A;B;C\r1;2;3\r";
  CSVParser *parser = [[CSVParser alloc] initWithString:test separator:@";" hasHeader:YES fieldNames:nil];
  __block int count = 0;
  [parser parseRowsUsingBlock:^(NSDictionary *row) {
    count++;
    STAssertEqualObjects([row objectForKey:@"A"], @"1", nil);
    STAssertEqualObjects([row objectForKey:@"B"], @"2", nil);
    STAssertEqualObjects([row objectForKey:@"C"], @"3", nil);
  }];
}


- (void)test_02_who_data {
  NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [thisBundle URLForResource:@"wfa_boys_p_exp" withExtension:@"txt"];
  STAssertNotNil(url, nil);
  NSError *error = nil;
  NSString *data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
  STAssertNotNil(data, nil);
  STAssertNil(error, nil);
  CSVParser *parser = [[CSVParser alloc] initWithString:data separator:@"\t" hasHeader:YES fieldNames:nil];
  NSArray *rows = [parser arrayOfParsedRows];
  STAssertEquals(rows.count, 1857u, nil);
  STAssertEqualObjects([[rows objectAtIndex:0] objectForKey:@"Age"], @"0", nil);
  STAssertEqualObjects([[rows objectAtIndex:1856] objectForKey:@"Age"], @"1856", nil);
}


@end
