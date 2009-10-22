//
//  CFeedEntry.m
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 09/20/09
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CFeedEntry.h"

#import "CObjectTranscoder.h"

#pragma mark begin emogenerator forward declarations
#import "CFeed.h"
#pragma mark end emogenerator forward declarations

@implementation CFeedEntry

+ (NSArray *)persistentPropertyNames
{
return([NSArray arrayWithObjects:@"feed", @"identifier", @"title", @"subtitle", @"content", @"link", @"updated", NULL]);
}

+ (CObjectTranscoder *)objectTranscoder
{
CObjectTranscoder *theTranscoder = [[[CObjectTranscoder alloc] initWithTargetObjectClass:[self class]] autorelease];
theTranscoder.propertyNameMappings = [NSDictionary dictionaryWithObjectsAndKeys:
//	@"rowID", @"id",
//	@"feed", @"feed_id",
	NULL];
return(theTranscoder);
}


#pragma mark begin emogenerator accessors

+ (NSString *)entityName
{
return(@"Entry");
}

@dynamic updated;

@dynamic content;

@dynamic subtitle;

@dynamic title;

@dynamic feed;

- (CFeed *)feed
{
[self willAccessValueForKey:@"feed"];
CFeed *theResult = [self primitiveValueForKey:@"feed"];
[self didAccessValueForKey:@"feed"];
return(theResult);
}

- (void)setFeed:(CFeed *)inFeed
{
[self willChangeValueForKey:@"feed"];
[self setPrimitiveValue:inFeed forKey:@"feed"];
[self didChangeValueForKey:@"feed"];
}

@dynamic link;

@dynamic identifier;

#pragma mark end emogenerator accessors

@end
