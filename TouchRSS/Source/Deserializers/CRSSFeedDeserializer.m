//
//  CRSSDeserializer.m
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright (c) 2008 Jonathan Wight
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

#import "CRSSFeedDeserializer.h"

#include <libxml/xmlreader.h>
#include "RSSKeywords.h"

#import "NSDate_InternetDateExtensions.h"

static void MyXMLTextReaderErrorFunc(void *arg, const char *msg, xmlParserSeverities severity, xmlTextReaderLocatorPtr locator);

@interface CRSSFeedDeserializer ()

@property (readwrite, nonatomic, assign) xmlTextReaderPtr reader;
@property (readwrite, nonatomic, retain) NSError *error;
@property (readwrite, nonatomic, retain) NSMutableDictionary *currentFeed;
@property (readwrite, nonatomic, retain) NSMutableDictionary *currentItem;

- (void)updateAttributesOfChannel:(NSMutableDictionary *)inChannel;
- (void)updateAttributesOfItem:(NSMutableDictionary *)inItem;

@end

#pragma mark -

@implementation CRSSFeedDeserializer

@synthesize reader;
@synthesize error;
@synthesize currentFeed;
@synthesize currentItem;

- (id)initWithData:(NSData *)inData;
{
if ((self = [self init]) != NULL)
	{
	self.reader = xmlReaderForMemory([inData bytes], [inData length], NULL, NULL, 0);
	NSAssert(self.reader != NULL, @"");

	int theReturnCode = 0;

	xmlTextReaderSetErrorHandler(self.reader, MyXMLTextReaderErrorFunc, self);

//	theReturnCode = xmlTextReaderSetParserProp(self.reader, XML_PARSER_VALIDATE, 1);
//	NSAssert(theReturnCode == 0, @"");

	theReturnCode = xmlTextReaderSetParserProp(self.reader, XML_PARSER_SUBST_ENTITIES, 1);
	NSAssert(theReturnCode == 0, @"");
	}
return(self);
}

- (void)dealloc
{
xmlFreeTextReader(self.reader);
self.reader = NULL;

self.error = NULL;
self.currentFeed = NULL;
self.currentItem = NULL;
//	
[super dealloc];
}

#pragma mark -

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
if (state->state == 0)
	{
	state->state = 1;
	state->mutationsPtr = &state->state;
	}

NSUInteger theObjectCount = 0;
int theReturnCode = xmlTextReaderRead(self.reader);
while (theObjectCount != len && theReturnCode == 1 && self.error == NULL)
	{
	const int theNodeType = xmlTextReaderNodeType(self.reader);

	if (theNodeType == XML_READER_TYPE_ELEMENT)
		{
		NSMutableDictionary *theObject = NULL;
		const xmlChar *theNodeName = xmlTextReaderConstLocalName(self.reader);
		int theCode = CodeForElementName(theNodeName);
		switch (theCode)
			{
			case RSSElementNameCode_RSS:
				theObject = self.currentFeed = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:FeedDictinaryType_Feed] forKey:@"type"];
				break;
			case RSSElementNameCode_Channel:
				[self updateAttributesOfChannel:self.currentFeed];
				break;
			case RSSElementNameCode_Item:
				theObject = self.currentItem = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:FeedDictinaryType_Entry] forKey:@"type"];
				[self updateAttributesOfItem:self.currentItem];
				break;
			}
			
		if (theObject)
			stackbuf[theObjectCount++] = theObject;
		}

	theReturnCode = xmlTextReaderRead(self.reader);
	}
	
state->itemsPtr = stackbuf;

return(theObjectCount);
}

- (void)updateAttributesOfChannel:(NSMutableDictionary *)inChannel
{
xmlNodePtr theNode = xmlTextReaderCurrentNode(self.reader);
xmlNodePtr theCurrentNode = theNode->children;
while (theCurrentNode != NULL)
	{
	if (theCurrentNode->type == XML_ELEMENT_NODE)
		{
		const xmlChar *theElementName = theCurrentNode->name;
		const ERSSElementNameCode theNameCode = CodeForElementName(theElementName);
		switch (theNameCode)
			{
			case RSSElementNameCode_Title:
				{
				NSString *theContent = [NSString stringWithUTF8String:(const char *)xmlNodeGetContent(theCurrentNode)];
				[inChannel setObject:theContent forKey:@"title"];
				}
				break;
			case RSSElementNameCode_Link:
				{
				NSString *theContent = [NSString stringWithUTF8String:(const char *)xmlNodeGetContent(theCurrentNode)];
				NSURL *theLink = [NSURL URLWithString:theContent];
				[inChannel setObject:theLink forKey:@"link"];
				}
				break;
			case RSSElementNameCode_Description:
				{
				NSString *theContent = [NSString stringWithUTF8String:(const char *)xmlNodeGetContent(theCurrentNode)];
				[inChannel setObject:theContent forKey:@"subtitle"];
				}
				break;
			default:
				{
				}
				break;
			}
		}
	
	theCurrentNode = theCurrentNode->next;
	}
}

- (void)updateAttributesOfItem:(NSMutableDictionary *)inItem
{
xmlNodePtr theNode = xmlTextReaderExpand(self.reader);
xmlNodePtr theCurrentNode = theNode->children;
while (theCurrentNode != NULL && self.error == NULL)
	{
	if (theCurrentNode->type == XML_ELEMENT_NODE)
		{
		const xmlChar *theElementName = theCurrentNode->name;
		const ERSSElementNameCode theNameCode = CodeForElementName(theElementName);
		switch (theNameCode)
			{
			case RSSElementNameCode_Title:
				{
				NSString *theContent = [NSString stringWithUTF8String:(const char *)xmlNodeGetContent(theCurrentNode)];
				[inItem setObject:theContent forKey:@"title"];
				}
				break;
			case RSSElementNameCode_Link:
				{
				NSString *theContent = [NSString stringWithUTF8String:(const char *)xmlNodeGetContent(theCurrentNode)];
				NSURL *theLink = [NSURL URLWithString:theContent];
				[inItem setObject:theLink forKey:@"link"];
				}
				break;
			case RSSElementNameCode_Description:
				{
				NSString *theContent = [NSString stringWithUTF8String:(const char *)xmlNodeGetContent(theCurrentNode)];
				[inItem setObject:theContent forKey:@"subtitle"];
				}
				break;
			case RSSElementNameCode_PubDate:
				{
				NSString *theContent = [NSString stringWithUTF8String:(const char *)xmlNodeGetContent(theCurrentNode)];
				NSDate *theDate = [NSDate dateWithRFC1822String:theContent];
				[inItem setObject:theDate forKey:@"updated"];
				}
				break;
			case RSSElementNameCode_GUID:
				{
				NSString *theContent = [NSString stringWithUTF8String:(const char *)xmlNodeGetContent(theCurrentNode)];
				[inItem setObject:theContent forKey:@"identifier"];
				}
				break;
			default:
				break;
			}
		}
	
	theCurrentNode = theCurrentNode->next;
	}

int theReturnCode = xmlTextReaderNext(self.reader);
NSAssert(theReturnCode == 1, @"");
}

@end

static void MyXMLTextReaderErrorFunc(void *arg, const char *msg, xmlParserSeverities severity, xmlTextReaderLocatorPtr locator)
{
NSLog(@"ERROR: %d", severity);
if (severity >= XML_PARSER_SEVERITY_ERROR)
	{
	CRSSFeedDeserializer *theRSSFeedDeserializer = (CRSSFeedDeserializer *)arg;

	NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSString stringWithUTF8String:msg], NSLocalizedDescriptionKey,
		NULL
		];

	NSError *theError = [NSError errorWithDomain:kTouchRSSErrorDomain code:-1 userInfo:theUserInfo];
	theRSSFeedDeserializer.error = theError;
	}
}
