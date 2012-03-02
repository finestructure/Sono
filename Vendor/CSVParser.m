//
//  CSVParser.m
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

#import "CSVParser.h"


@implementation CSVParser

@synthesize csvString = _csvString;
@synthesize separator = _separator;
@synthesize scanner = _scanner;
@synthesize hasHeader = _hasHeader;
@synthesize fieldNames = _fieldNames;
@synthesize receiver = _receiver;
@synthesize receiverSelector = _receiverSelector;
@synthesize endTextCharacterSet = _endTextCharacterSet;
@synthesize separatorIsSingleChar = _separatorIsSingleChar;
@synthesize block = _block;

//
// initWithString:separator:hasHeader:fieldNames:
//
// Parameters:
//    aCSVString - the string that will be parsed
//    aSeparatorString - the separator (normally "," or "\t")
//    header - if YES, treats the first row as a list of field names
//    names - a list of field names (will have no effect if header is YES)
//
// returns the initialized object (nil on failure)
//
- (id)initWithString:(NSString *)aCSVString
    separator:(NSString *)aSeparatorString
    hasHeader:(BOOL)header
    fieldNames:(NSArray *)names
{
	self = [super init];
	if (self)
	{
		self.csvString = aCSVString;
		self.separator = aSeparatorString;
		
		NSAssert([self.separator length] > 0 &&
			[self.separator rangeOfString:@"\""].location == NSNotFound &&
			[self.separator rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound,
			@"CSV separator string must not be empty and must not contain the double quote character or newline characters.");
		
		NSMutableCharacterSet *endTextMutableCharacterSet =
			[[NSCharacterSet newlineCharacterSet] mutableCopy];
		[endTextMutableCharacterSet addCharactersInString:@"\""];
		[endTextMutableCharacterSet addCharactersInString:[self.separator substringToIndex:1]];
		self.endTextCharacterSet = endTextMutableCharacterSet;

		if ([self.separator length] == 1)
		{
			self.separatorIsSingleChar = YES;
		}

		self.hasHeader = header;
		self.fieldNames = [names mutableCopy];
	}
	
	return self;
}

//
// arrayOfParsedRows
//
// Performs a parsing of the csvString, returning the entire result.
//
// returns the array of all parsed row records
//
- (NSArray *)arrayOfParsedRows
{
	self.scanner = [[NSScanner alloc] initWithString:self.csvString];
	[self.scanner setCharactersToBeSkipped:[[NSCharacterSet alloc] init]];
	
	NSArray *result = [self parseFile];
	self.scanner = nil;
	
	return result;
}


- (void)parseRowsUsingBlock:(void (^)(NSDictionary *record))aBlock {
  self.scanner = [[NSScanner alloc] initWithString:self.csvString];
	[self.scanner setCharactersToBeSkipped:[[NSCharacterSet alloc] init]];
  self.block = aBlock;
  
	[self parseFile];
	
	self.scanner = nil;
  self.block = nil;
}


//
// parseFile
//
// Attempts to parse a file from the current scan location.
//
// returns the parsed results if successful and receiver is nil, otherwise
//	returns nil when done or on failure.
//
- (NSArray *)parseFile
{
	if (self.hasHeader)
	{		
		self.fieldNames = [self parseHeader];
		if (!self.fieldNames || ![self parseLineSeparator])
		{
			return nil;
		}
	}
	
	NSMutableArray *records = nil;
	if (!self.block)
	{
		records = [NSMutableArray array];
	}
	
	NSDictionary *record = [self parseRecord];
	if (!record)
	{
		return nil;
	}
	
	while (record)
	{
		@autoreleasepool {
			
			if (self.block)
			{
				self.block(record);
			}
			else
			{
				[records addObject:record];
			}
			
			if (![self parseLineSeparator])
			{
				break;
			}
			
			record = [self parseRecord];
			
		}
	}
	
	return records;
}

//
// parseHeader
//
// Attempts to parse a header row from the current scan location.
//
// returns the array of parsed field names or nil on parse failure.
//
- (NSMutableArray *)parseHeader
{
	NSString *name = [self parseName];
	if (!name)
	{
		return nil;
	}

	NSMutableArray *names = [NSMutableArray array];
	while (name)
	{
		[names addObject:name];

		if (![self parseSeparator])
		{
			break;
		}
		
		name = [self parseName];
	}
	return names;
}

//
// parseRecord
//
// Attempts to parse a record from the current scan location. The record
// dictionary will use the fieldNames as keys, or FIELD_X for each column
// X-1 if no fieldName exists for a given column.
//
// returns the parsed record as a dictionary, or nil on failure. 
//
- (NSDictionary *)parseRecord
{
	//
	// Special case: return nil if the line is blank. Without this special case,
	// it would parse as a single blank field.
	//
	if ([self parseLineSeparator] || [self.scanner isAtEnd])
	{
		return nil;
	}
	
	NSString *field = [self parseField];
	if (!field)
	{
		return nil;
	}

	NSInteger fieldNamesCount = [self.fieldNames count];
	NSInteger fieldCount = 0;
	
	NSMutableDictionary *record =
		[NSMutableDictionary dictionaryWithCapacity:[self.fieldNames count]];
	while (field)
	{
		NSString *fieldName;
		if (fieldNamesCount > fieldCount)
		{
			fieldName = [self.fieldNames objectAtIndex:fieldCount];
		}
		else
		{
			fieldName = [NSString stringWithFormat:@"FIELD_%ld", fieldCount + 1];
			[self.fieldNames addObject:fieldName];
			fieldNamesCount++;
		}
		
		[record setObject:field forKey:fieldName];
		fieldCount++;

		if (![self parseSeparator])
		{
			break;
		}
		
		field = [self parseField];
	}
	
	return record;
}

//
// parseName
//
// Attempts to parse a name from the current scan location.
//
// returns the name or nil.
//
- (NSString *)parseName
{
	return [self parseField];
}

//
// parseField
//
// Attempts to parse a field from the current scan location.
//
// returns the field or nil
//
- (NSString *)parseField
{
	NSString *escapedString = [self parseEscaped];
	if (escapedString)
	{
		return escapedString;
	}
	
	NSString *nonEscapedString = [self parseNonEscaped];
	if (nonEscapedString)
	{
		return nonEscapedString;
	}
	
	//
	// Special case: if the current location is immediately
	// followed by a separator, then the field is a valid, empty string.
	//
	NSInteger currentLocation = [self.scanner scanLocation];
	if ([self parseSeparator] || [self parseLineSeparator] || [self.scanner isAtEnd])
	{
		[self.scanner setScanLocation:currentLocation];
		return @"";
	}

	return nil;
}

//
// parseEscaped
//
// Attempts to parse an escaped field value from the current scan location.
//
// returns the field value or nil.
//
- (NSString *)parseEscaped
{
	if (![self parseDoubleQuote])
	{
		return nil;
	}
	
	NSString *accumulatedData = [NSString string];
	while (YES)
	{
		NSString *fragment = [self parseTextData];
		if (!fragment)
		{
			fragment = [self parseSeparator];
			if (!fragment)
			{
				fragment = [self parseLineSeparator];
				if (!fragment)
				{
					if ([self parseTwoDoubleQuotes])
					{
						fragment = @"\"";
					}
					else
					{
						break;
					}
				}
			}
		}
		
		accumulatedData = [accumulatedData stringByAppendingString:fragment];
	}
	
	if (![self parseDoubleQuote])
	{
		return nil;
	}
	
	return accumulatedData;
}

//
// parseNonEscaped
//
// Attempts to parse a non-escaped field value from the current scan location.
//
// returns the field value or nil.
//
- (NSString *)parseNonEscaped
{
	return [self parseTextData];
}

//
// parseTwoDoubleQuotes
//
// Attempts to parse two double quotes from the current scan location.
//
// returns a string containing two double quotes or nil.
//
- (NSString *)parseTwoDoubleQuotes
{
	if ([self.scanner scanString:@"\"\"" intoString:NULL])
	{
		return @"\"\"";
	}
	return nil;
}

//
// parseDoubleQuote
//
// Attempts to parse a double quote from the current scan location.
//
// returns @"\"" or nil.
//
- (NSString *)parseDoubleQuote
{
	if ([self.scanner scanString:@"\"" intoString:NULL])
	{
		return @"\"";
	}
	return nil;
}

//
// parseSeparator
//
// Attempts to parse the separator string from the current scan location.
//
// returns the separator string or nil.
//
- (NSString *)parseSeparator
{
	if ([self.scanner scanString:self.separator intoString:NULL])
	{
		return self.separator;
	}
	return nil;
}

//
// parseLineSeparator
//
// Attempts to parse newline characters from the current scan location.
//
// returns a string containing one or more newline characters or nil.
//
- (NSString *)parseLineSeparator
{
	NSString *matchedNewlines = nil;
	[self.scanner
		scanCharactersFromSet:[NSCharacterSet newlineCharacterSet]
		intoString:&matchedNewlines];
	return matchedNewlines;
}

//
// parseTextData
//
// Attempts to parse text data from the current scan location.
//
// returns a non-zero length string or nil.
//
- (NSString *)parseTextData
{
	NSString *accumulatedData = [NSString string];
	while (YES)
	{
		NSString *fragment;
		if ([self.scanner scanUpToCharactersFromSet:self.endTextCharacterSet intoString:&fragment])
		{
			accumulatedData = [accumulatedData stringByAppendingString:fragment];
		}
		
		//
		// If the separator is just a single character (common case) then
		// we know we've reached the end of parseable text
		//
		if (self.separatorIsSingleChar)
		{
			break;
		}
		
		//
		// Otherwise, we need to consider the case where the first character
		// of the separator is matched but we don't have the full separator.
		//
		NSUInteger location = [self.scanner scanLocation];
		NSString *firstCharOfSeparator;
		if ([self.scanner scanString:[self.separator substringToIndex:1] intoString:&firstCharOfSeparator])
		{
			if ([self.scanner scanString:[self.separator substringFromIndex:1] intoString:NULL])
			{
				[self.scanner setScanLocation:location];
				break;
			}
			
			//
			// We have the first char of the separator but not the whole
			// separator, so just append the char and continue
			//
			accumulatedData = [accumulatedData stringByAppendingString:firstCharOfSeparator];
			continue;
		}
		else
		{
			break;
		}
	}
	
	if ([accumulatedData length] > 0)
	{
		return accumulatedData;
	}
	
	return nil;
}

@end
