//
//  CBookmark.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/26/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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
