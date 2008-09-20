//
//  NSDictionary_SqlExtensions.m
//  Project V
//
//  Created by Jonathan Wight on 9/20/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSDictionary_SqlExtensions.h"

@implementation NSDictionary (NSDictionary_SqlExtensions)

+ (id)dictionaryWithPropertyListData:(NSData *)inData
{
id thePropertyList = [NSPropertyListSerialization propertyListFromData:inData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
NSAssert([thePropertyList isKindOfClass:self], @"Decoded property list is not of the right class.");
return(thePropertyList);
}

- (NSData *)propertyListData
{
return([NSPropertyListSerialization dataFromPropertyList:self format:NSPropertyListOpenStepFormat errorDescription:NULL]);
}

@end
