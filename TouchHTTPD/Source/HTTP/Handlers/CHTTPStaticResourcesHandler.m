//
//  CHTTPStaticResourcesHandler.m
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CHTTPStaticResourcesHandler.h"

#import "CHTTPMessage.h"
#import "CHTTPMessage_ConvenienceExtensions.h"
#import "NSFileManager_Extensions.h"
#import "NSError_HTTPDExtensions.h"
#import "TouchHTTPDConstants.h"

@implementation CHTTPStaticResourcesHandler

- (void) dealloc
{
self.rootDirectory = NULL;
//	
[super dealloc];
}

- (NSString *)rootDirectory
{
if (rootDirectory == NULL)
	{
	NSBundle *theBundle = [NSBundle mainBundle];
	NSString *theResourceDirectory = [theBundle resourcePath];
	rootDirectory = [[theResourceDirectory stringByStandardizingPath] retain];
	}
return rootDirectory; 
}

- (void)setRootDirectory:(NSString *)inRootDirectory
{
if (rootDirectory != inRootDirectory)
	{
	[rootDirectory autorelease];
	rootDirectory = [inRootDirectory retain];
    }
}


- (BOOL)handleRequest:(CHTTPMessage *)inRequest forConnection:(CHTTPConnection *)inConnection response:(CHTTPMessage **)ioResponse error:(NSError **)outError
{
#pragma unused (inConnection, outError)

if (*ioResponse != NULL && [*ioResponse responseStatusCode] != 404)
	return(YES);

if ([[inRequest requestMethod] isEqualToString:@"GET"] == NO && [[inRequest requestMethod] isEqualToString:@"HEAD"] == NO)
	return(YES);

NSString *thePath = [inRequest.requestURL.path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
if (thePath.length < 7 || [[thePath substringToIndex:7] isEqualToString:@"/static"] == NO)
	return(YES);

NSArray *thePathComponents = [thePath pathComponents];
thePathComponents = [thePathComponents subarrayWithRange:NSMakeRange(2, thePathComponents.count - 2)];

thePath = [NSString pathWithComponents:thePathComponents];
thePath = [self.rootDirectory stringByAppendingPathComponent:thePath];
thePath = [thePath stringByStandardizingPath];

if ([[thePath substringToIndex:self.rootDirectory.length] isEqualToString:self.rootDirectory] == NO)
	{
	if (ioResponse != NULL)
		{
		NSError *theError = [NSError errorWithDomain:kHTTPErrorDomain code:kHTTPStatusCode_NotFound underlyingError:NULL request:inRequest format:@"Not found."];
		*ioResponse = [CHTTPMessage HTTPMessageResponseWithError:theError];
		}		
	return(YES);
	}

BOOL theReadableFileFlag = [[NSFileManager defaultManager] isReadableFileAtPath:thePath];
if (theReadableFileFlag == NO)
	{
	if (ioResponse != NULL)
		{
		NSError *theError = [NSError errorWithDomain:kHTTPErrorDomain code:kHTTPStatusCode_NotFound underlyingError:NULL request:inRequest format:@"Not found."];
		*ioResponse = [CHTTPMessage HTTPMessageResponseWithError:theError];
		}
	return(YES);
	}

NSString *theMimeType = [[NSFileManager defaultManager] mimeTypeForPath:thePath];

CHTTPMessage *theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:200];

NSError *theError = NULL;
NSData *theBody = [NSData dataWithContentsOfFile:thePath options:NSMappedRead error:&theError];

[theResponse setContentType:theMimeType bodyData:theBody];

if ([[inRequest requestMethod] isEqualToString:@"HEAD"] == YES)
	{
	NSString *theContentLength = [theResponse headerForKey:@"Content-Length"];
	theResponse.bodyData = NULL;
	[theResponse setHeader:theContentLength forKey:@"Content-Length"];
	}

if (ioResponse)
	*ioResponse = theResponse;

return(YES);
}

@end
