//
//  CJSONPath.m
//  JSONPath
//
//  Created by Jonathan Wight on 03/06/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CJSONPath.h"

@implementation CJSONPath

@synthesize string;

- (id)initWithString:(NSString *)inString
{
if ((self = [super init]) != NULL)
	{
	string = [inString copy];
	}
return(self);
}

- (void)dealloc
{
[string release];
string = NULL;
//
[super dealloc];
}

- (BOOL)compile:(NSError **)outError
{
NSMutableArray *theState = [NSMutableArray array];

NSScanner *theScanner = [NSScanner scannerWithString:self.string];
if ([theScanner scanString:@"$" intoString:NULL] == NO)
	{
	return(NO);
	}



}

- (id)evaluteWithObject:(id)inObject error:(NSError **)outError
{
return(NULL);
}

@end
