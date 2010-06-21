//
//  CBook.m
//  TouchCode
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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
