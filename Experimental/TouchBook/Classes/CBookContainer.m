//
//  CBookContainer.m
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

#import "CBookContainer.h"

#import "TouchXML.h"
#import "CBook.h"

@implementation CBookContainer

@synthesize URL;

- (id)initWithURL:(NSURL *)inURL
{
if ((self = [super init]) != NULL)
	{
	URL = [inURL retain];
	}
return(self);
}

- (NSArray *)books
{
if (books == NULL)
	{	
	NSURL *theContainerURL = [NSURL URLWithString:@"META-INF/container.xml" relativeToURL:self.URL];
	theContainerURL = [theContainerURL absoluteURL];
	
	NSError *theError = NULL;
	CXMLDocument *theDocument = [[[CXMLDocument alloc] initWithContentsOfURL:theContainerURL options:0 error:&theError] autorelease];
	if (theDocument == NULL)
		{
		NSLog(@"%@", theError);
		}

	NSDictionary *theMappings = [NSDictionary dictionaryWithObjectsAndKeys:
		@"urn:oasis:names:tc:opendocument:xmlns:container", @"NS",
		NULL];

	NSArray *theNodes = [theDocument nodesForXPath:@"/NS:container/NS:rootfiles/NS:rootfile" namespaceMappings:theMappings error:&theError];

	NSMutableArray *theBooks = [NSMutableArray array];

	for (CXMLElement *theElement in theNodes)
		{
		NSString *thePathComponent = [[theElement attributeForName:@"full-path"] stringValue];
		NSURL *theBookURL = [NSURL URLWithString:thePathComponent relativeToURL:self.URL];
		CBook *theBook = [[[CBook alloc] initWithURL:theBookURL rootURL:[NSURL URLWithString:@"OPS/" relativeToURL:self.URL]] autorelease];
		[theBooks addObject:theBook];
		}

	books = [theBooks copy];
	}

return(books);
}

@end
