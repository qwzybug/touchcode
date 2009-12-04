//
//  CFeed.m
//  <#ProjectName#>
//
//  Created by Jonathan Wight on 09/20/09
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CFeed.h"

#import "CObjectTranscoder.h"

#pragma mark begin emogenerator forward declarations
#import "CFeedEntry.h"
#pragma mark end emogenerator forward declarations

@implementation CFeed

+ (CObjectTranscoder *)objectTranscoder
{
CObjectTranscoder *theTranscoder = [[[CObjectTranscoder alloc] initWithTargetObjectClass:self] autorelease];
theTranscoder.propertyNameMappings = [NSDictionary dictionaryWithObjectsAndKeys:
	NULL];
return(theTranscoder);
}

#pragma mark begin emogenerator accessors

+ (NSString *)entityName
{
return(@"Feed");
}

@dynamic lastChecked;

@dynamic subtitle;

@dynamic title;

@dynamic identifier;

@dynamic link;

@dynamic URL;

@dynamic entries;

- (NSMutableSet *)entries
{
return([self mutableSetValueForKey:@"entries"]);
}

#pragma mark end emogenerator accessors

@end
