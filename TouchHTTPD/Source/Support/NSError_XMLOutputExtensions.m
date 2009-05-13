//
//  NSError_XMLOutputExtensions.m
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSError_XMLOutputExtensions.h"

@implementation NSError (NSError_XMLOutputExtensions)

- (NSData *)asXMLData;
{
return([[self asXMLDocument] XMLData]);
}

- (CXMLDocument *)asXMLDocument
{
// <?xml-stylesheet type="text/xsl" href="NSError.xsl"?>

CXMLDocument *theDocument = [CXMLNode documentWithRootElement:[self asXMLElement]];

CXMLNode *theProcessingInstruction = [CXMLNode processingInstructionWithName:@"xml-stylesheet" stringValue:@"type=\"text/xsl\" href=\"/static/NSError.xsl\""];
[theDocument insertChild:theProcessingInstruction atIndex:0];

return(theDocument);
}

- (CXMLElement *)asXMLElement
{
CXMLElement *theErrorElement = [CXMLNode elementWithName:@"NSError" URI:NULL];
[theErrorElement addChild:[CXMLNode elementWithName:@"domain" stringValue:self.domain]];
[theErrorElement addChild:[CXMLNode elementWithName:@"code" stringValue:[NSString stringWithFormat:@"%d", self.code]]];

CXMLElement *theUserInfoElement = [CXMLNode elementWithName:@"userInfo"];

for (NSString *theKey in [self.userInfo allKeys])
	{
	id theValue = [self.userInfo objectForKey:theKey];
	if (theValue != NULL)
		{
		if ([theValue respondsToSelector:@selector(stringValue)])
			theValue = [theValue stringValue];
		else if ([theValue isKindOfClass:[NSString class]] == NO)
			theValue = [theValue description];
		
		[theUserInfoElement addChild:[CXMLElement elementWithName:theKey stringValue:theValue]];
		}
	}

NSError *theUnderlyingError = [self.userInfo objectForKey:NSUnderlyingErrorKey];
if (theUnderlyingError != NULL)
	{
	CXMLElement *theUnderlyingErrorElement = [CXMLNode elementWithName:NSUnderlyingErrorKey];
	[theUnderlyingErrorElement addChild:[theUnderlyingError asXMLElement]];
	[theUserInfoElement addChild:theUnderlyingErrorElement];
	}

if (theUserInfoElement.children.count > 0)
	[theErrorElement addChild:theUserInfoElement];

return(theErrorElement);
}

@end
