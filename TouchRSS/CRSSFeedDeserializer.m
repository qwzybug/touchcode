//
//  CRSSDeserializer.m
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CRSSFeedDeserializer.h"

#include <libxml/xmlreader.h>
#include "words.h"

#import "NSDate_InternetDateExtensions.h"

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
//		NSLog(@"%s", xmlTextReaderConstNamespaceUri(self.reader));
		
		NSMutableDictionary *theObject = NULL;
		const xmlChar *theNodeName = xmlTextReaderConstLocalName(self.reader);
		int theCode = CodeForElementName(theNodeName);
		switch (theCode)
			{
			case RSSElementNameCode_RSS:
				theObject = self.currentFeed = [NSMutableDictionary dictionaryWithObject:@"feed" forKey:@"type"];
				break;
			case RSSElementNameCode_Channel:
				[self updateAttributesOfChannel:self.currentFeed];
				break;
			case RSSElementNameCode_Item:
				theObject = self.currentItem = [NSMutableDictionary dictionaryWithObject:@"item" forKey:@"type"];
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
				[inChannel setObject:theContent forKey:@"description_"];
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
				[inItem setObject:theContent forKey:@"description_"];
				}
				break;
			case RSSElementNameCode_PubDate:
				{
				NSString *theContent = [NSString stringWithUTF8String:(const char *)xmlNodeGetContent(theCurrentNode)];
				NSDate *theDate = [NSDate dateWithRFC1822String:theContent];
				[inItem setObject:theDate forKey:@"publicationDate"];
				}
				break;
			case RSSElementNameCode_GUID:
				{
				NSString *theContent = [NSString stringWithUTF8String:(const char *)xmlNodeGetContent(theCurrentNode)];
				[inItem setObject:theContent forKey:@"identifier"];
				}
				break;
			default:
//				NSLog(@"Unhandled element: %s %d", theElementName, theNode->ns);
				break;
			}
		}
	
	theCurrentNode = theCurrentNode->next;
	}

int theReturnCode = xmlTextReaderNext(self.reader);
NSAssert(theReturnCode == 1, @"");
}

@end
