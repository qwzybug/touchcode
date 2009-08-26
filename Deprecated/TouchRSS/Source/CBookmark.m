//
//  CBookmark.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/26/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CBookmark.h"

#import "CObjectTranscoder.h"

@implementation CBookmark

@synthesize title, URL;

+ (NSString *)tableName
{
return(@"bookmark");
}

+ (NSArray *)persistentPropertyNames
{
return([[super persistentPropertyNames] arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:@"title", @"URL", NULL]]);
}

+ (CObjectTranscoder *)objectTranscoder
{
CObjectTranscoder *theTranscoder = [[[CObjectTranscoder alloc] initWithTargetObjectClass:[self class]] autorelease];
theTranscoder.propertyNameMappings = [NSDictionary dictionaryWithObjectsAndKeys:
	@"rowID", @"id",
	NULL];
return(theTranscoder);
}

- (void)dealloc
{
self.title = NULL;
self.URL = NULL;
//
[super dealloc];
}

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (title = '%@', URL = '%@')", [super description], self.title, self.URL]);
}

@end
