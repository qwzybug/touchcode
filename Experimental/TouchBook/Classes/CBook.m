//
//  CBook.m
//  TouchBook
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CBook.h"

#import "TouchXML.h"
#import "CSection.h"

@implementation CBook

@synthesize URL;
@synthesize rootURL;
@synthesize sections;

- (id)initWithURL:(NSURL *)inURL rootURL:(NSURL *)inRootURL
{
if ((self = [super init]) != NULL)
	{
	URL = [inURL retain];
	rootURL = [inRootURL retain];
	}
return(self);
}

- (NSArray *)sections
{
if (sections == NULL)
	{
	NSError *theError = NULL;
	CXMLDocument *theDocument = [[[CXMLDocument alloc] initWithContentsOfURL:self.URL options:0 error:&theError] autorelease];
	if (theDocument == NULL)
		{
		NSLog(@"%@", theError);
		}

	NSDictionary *theMappings = [NSDictionary dictionaryWithObjectsAndKeys:
		@"http://www.idpf.org/2007/opf", @"NS",
		NULL];

	NSArray *theNodes = [theDocument nodesForXPath:@"/NS:package/NS:spine/NS:itemref/@idref" namespaceMappings:theMappings error:&theError];

	NSMutableArray *theSections = [NSMutableArray array];

	for (CXMLNode *theItemRef in theNodes)
		{
//		NSString *theIDRef = [theElement attributeForName:@"idref"]
		
		NSString *theXPath = [NSString stringWithFormat:@"/NS:package/NS:manifest/NS:item[@id='%@']", [theItemRef stringValue]];
		
		CXMLElement *theElement = [[theDocument nodesForXPath:theXPath namespaceMappings:theMappings error:&theError] lastObject];
		
		NSString *thePathComponent = [[theElement attributeForName:@"href"] stringValue];
		NSURL *theSectionURL = [NSURL URLWithString:thePathComponent relativeToURL:self.rootURL];
		CSection *theSection = [[[CSection alloc] initWithURL:theSectionURL] autorelease];
		[theSections addObject:theSection];
		}

	sections = [theSections copy];
	}
return(sections);
}

- (NSString *)title
{
return(@"TITLE");
}

@end
