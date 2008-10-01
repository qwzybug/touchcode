//
//  CTrivialTemplate.m
//  Obama
//
//  Created by Jonathan Wight on 9/19/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CTrivialTemplate.h"

#import "CValueTransformer.h"

@implementation CTrivialTemplate

@synthesize template;

- (id)initWithTemplate:(NSString *)inTemplate
{
if ((self = [super init]) != NULL)
	{
	self.template = inTemplate;
	}
return(self);
}

- (id)initWithPath:(NSString *)inPath;
{
NSString *theTemplate = [NSString stringWithContentsOfFile:inPath];
return([self initWithTemplate:theTemplate]);
}

- (id)initWithTemplateName:(NSString *)inTemplateName
{
NSString *theName = [inTemplateName stringByDeletingPathExtension];
NSString *theExtension = [inTemplateName pathExtension];

NSString *thePath = [[NSBundle mainBundle] pathForResource:theName ofType:theExtension];
return([self initWithPath:thePath]);
}

- (void)dealloc
{
self.template = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)transform:(NSDictionary *)inReplacementDictionary error:(NSError **)outError
{
NSMutableString *theOutputString = [NSMutableString stringWithCapacity:self.template.length];
NSScanner *theScanner = [NSScanner scannerWithString:self.template];
[theScanner setCharactersToBeSkipped:NULL];

NSInteger theLastScanLocation = [theScanner scanLocation];

NSString *theString = NULL;
while ([theScanner isAtEnd] == NO)
	{
	if ([theScanner scanUpToString:@"${" intoString:&theString] == YES)
		{
		[theOutputString appendString:theString];
		}
		
	if ([theScanner scanString:@"${" intoString:&theString] == YES)
		{
		if ([theScanner scanUpToString:@"}" intoString:&theString] == NO)
			{
			return(NULL);
			}

		NSArray *theComponents = [theString componentsSeparatedByString:@":"];
		NSString *theKeyValuePath = [theComponents objectAtIndex:0];
		NSString *theTransformerName = NULL;
		if (theComponents.count == 2)
			theTransformerName = [theComponents objectAtIndex:1];

		id theValue = [inReplacementDictionary valueForKeyPath:theKeyValuePath];
		
		if (theTransformerName)
			{
			CValueTransformer *theTransformer = [CValueTransformer valueTransformerForName:theTransformerName];
			if (theTransformer == NULL)
				{
				[NSException raise:NSGenericException format:@"Cannot find a value transform named: %@", theTransformerName];
				}
			theValue = [theTransformer transformedValue:theValue];
			}
		
		if (theValue)
			{
			NSString *theReplacementString = [theValue description];
			[theOutputString appendString:theReplacementString];
			}

		if ([theScanner scanString:@"}" intoString:&theString] == NO)
			{
			return(NULL);
			}
		}
		
	if ([theScanner scanLocation] == theLastScanLocation)
		{
		NSAssert(NO, @"NSScanner infinite loop detected!");
		}
	
	theLastScanLocation = [theScanner scanLocation];
	}

return(theOutputString);
}

@end

#pragma mark -

@implementation CTrivialTemplate (CTrivialTemplate_Conveniences)

+ (NSString *)transformTemplateNamed:(NSString *)inName replacementDictionary:(NSDictionary *)inDictionary error:(NSError **)outError
{
CTrivialTemplate *theTemplate = [[[self alloc] initWithTemplateName:inName] autorelease];
return([theTemplate transform:inDictionary error:outError]);
}

@end