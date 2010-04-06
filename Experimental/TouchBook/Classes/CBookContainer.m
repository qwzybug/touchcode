//
//  CBookContainer.m
//  TouchBook
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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
