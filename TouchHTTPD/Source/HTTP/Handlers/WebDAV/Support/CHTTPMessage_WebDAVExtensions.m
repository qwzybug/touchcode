//
//  CHTTPMessage_WebDAVExtensions.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 11/6/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CHTTPMessage_WebDAVExtensions.h"

#import "TouchXML.h"
#import "CHTTPMessage_ConvenienceExtensions.h"
#import "TouchHTTPDConstants.h"

@implementation CHTTPMessage (CHTTPMessage_WebDAVExtensions)

- (BOOL)getDepth:(NSInteger *)outDepth
{
NSInteger theDepth = -1;
NSString *theDepthString = [self headerForKey:@"Depth"];
if (theDepthString != NULL)
	{
	if ([theDepthString isEqualToString:@"0"])
		theDepth = 0;
	else if ([theDepthString isEqualToString:@"1"])
		theDepth = 1;
	else if ([theDepthString isEqualToString:@"infinity"])
		theDepth = -1;
	else
		return(NO);
	}

if (outDepth)
	*outDepth = theDepth;

return(YES);
}

- (NSNumber *)depth
{
NSNumber *theDepth = NULL;
NSString *theDepthString = [self headerForKey:@"Depth"];
if (theDepthString == NULL)
	{
	theDepth = [NSNumber numberWithInteger:-1];
	}
else
	{
	if ([theDepthString isEqualToString:@"0"])
		theDepth = [NSNumber numberWithInteger:0];
	else if ([theDepthString isEqualToString:@"1"])
		theDepth = [NSNumber numberWithInteger:1];
	else if ([theDepthString isEqualToString:@"infinity"])
		theDepth = [NSNumber numberWithInteger:-1];
	}

return(theDepth);
}

- (NSNumber *)overwrite
{
NSString *theOverwriteString = [self headerForKey:@"Overwrite"];
if (theOverwriteString == NULL)
	return([NSNumber numberWithBool:YES]);
if ([theOverwriteString isEqualToString:@"T"])
	return([NSNumber numberWithBool:YES]);
else if ([theOverwriteString isEqualToString:@"F"])
	return([NSNumber numberWithBool:NO]);
else
	{
	LOG_(@"Weird overwrite header value: %@", theOverwriteString);
	return([NSNumber numberWithBool:YES]);
	}
}

- (CXMLDocument *)XMLBodyWithError:(NSError **)outError
{
NSString *theContentType = [self mainHeaderComponentForKey:@"Content-Type"];
if ([theContentType isEqualToString:@"text/xml"] == NO && [theContentType isEqualToString:@"application/xml"] == NO)
	{
	if (outError)
		{
		*outError = [NSError errorWithDomain:kTouchHTTPErrorDomain code:-1 userInfo:NULL];
		}
	return(NULL);
	}

NSData *theData = [self bodyData];
if (theData != NULL && theData.length > 0)
	{
	CXMLDocument *theDocument = [[[CXMLDocument alloc] initWithData:[self bodyData] options:0 error:outError] autorelease];
	return(theDocument);
	}
	
return(NULL);
}

@end
