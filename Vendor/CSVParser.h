//
//  CSVParser.h
//  CSVImporter
//
//  Created by Matt Gallagher on 2009/11/30.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//



typedef void (^ParseRowsBlock)(NSDictionary *row);

@interface CSVParser : NSObject

@property (nonatomic, strong) NSString *csvString;
@property (nonatomic, strong) NSString *separator;
@property (nonatomic, strong) NSScanner *scanner;
@property (nonatomic, assign) BOOL hasHeader;
@property (nonatomic, strong) NSMutableArray *fieldNames;
@property (nonatomic, strong) id receiver;
@property (nonatomic, assign) SEL receiverSelector;
@property (nonatomic, strong) NSCharacterSet *endTextCharacterSet;
@property (nonatomic, assign) BOOL separatorIsSingleChar;
@property (nonatomic, strong) ParseRowsBlock block;

- (id)initWithString:(NSString *)aCSVString
    separator:(NSString *)aSeparatorString
    hasHeader:(BOOL)header
    fieldNames:(NSArray *)names;

- (NSArray *)arrayOfParsedRows;
- (void)parseRowsUsingBlock:(ParseRowsBlock)aBlock;

- (NSArray *)parseFile;
- (NSMutableArray *)parseHeader;
- (NSDictionary *)parseRecord;
- (NSString *)parseName;
- (NSString *)parseField;
- (NSString *)parseEscaped;
- (NSString *)parseNonEscaped;
- (NSString *)parseDoubleQuote;
- (NSString *)parseSeparator;
- (NSString *)parseLineSeparator;
- (NSString *)parseTwoDoubleQuotes;
- (NSString *)parseTextData;

@end
