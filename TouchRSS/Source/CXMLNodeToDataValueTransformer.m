//
//  CXMLNodeToDataValueTransformer.m
//  DNC
//
//  Created by Jonathan Wight on 04/22/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CXMLNodeToDataValueTransformer.h"

#import "CXMLDocument.h"
#import "CXMLElement.h"

@implementation CXMLNodeToDataValueTransformer

+ (void)load
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
//
[self setValueTransformer:[[[self alloc] init] autorelease] forName:NSStringFromClass(self)];
//
[thePool release];
}

+ (Class)transformedValueClass
{
return([NSData class]);
}

+ (BOOL)allowsReverseTransformation
{
return(YES);
}

- (id)transformedValue:(id)value
{
NSData *theData = NULL;

if ([value isKindOfClass:[NSDictionary class]])
	{
	NSMutableDictionary *theStrings = [NSMutableDictionary dictionary];
	
	for (NSString *theKey in value)
		{
		CXMLElement *theElement = [value objectForKey:theKey];
		[theStrings setObject:[theElement XMLString] forKey:theKey];
		}

	theData = [NSKeyedArchiver archivedDataWithRootObject:theStrings];
	}
return(theData);
}

- (id)reverseTransformedValue:(id)value
{
NSDictionary *theStringsDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:value];
NSMutableDictionary *theElementsDictionary = [NSMutableDictionary dictionary];
for (NSString *theKey in theStringsDictionary)
	{
	NSString *theString = [theStringsDictionary objectForKey:theKey];

	NSError *theError = NULL;
	CXMLDocument *theDocument = [[[CXMLDocument alloc] initWithXMLString:theString options:0 error:&theError] autorelease];
	if (theDocument == NULL)
		{
		NSLog(@"Warning: couldn't process XML: %@", theError);
		}
	else
		{
		CXMLElement *theRootElement = [[[theDocument rootElement] copy] autorelease];
		[theElementsDictionary setObject:theRootElement forKey:theKey];
		}
	}

return(theElementsDictionary);
}

@end
