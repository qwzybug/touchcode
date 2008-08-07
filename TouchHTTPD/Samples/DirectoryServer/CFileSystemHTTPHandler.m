//
//  CFileSystemHTTPHandler.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CFileSystemHTTPHandler.h"

#import "CHTTPMessage.h"
#import "CHTTPMessage_ConvenienceExtensions.h"

@implementation CFileSystemHTTPHandler

- (BOOL)handleRequest:(CHTTPMessage *)inRequest forConnection:(CHTTPConnection *)inConnection response:(CHTTPMessage **)outResponse error:(NSError **)outError
{
#pragma unused (inRequest, inConnection, outError)

CHTTPMessage *theResponse = NULL;
NSURL *theURL = inRequest.requestURL;
NSString *thePath = theURL.relativeString;

NSLog(@"%@", thePath);

BOOL theIsDirectoryFlag = NO;
BOOL theFileExistsFlag = [[NSFileManager defaultManager] fileExistsAtPath:thePath isDirectory:&theIsDirectoryFlag];
if (theFileExistsFlag == NO)
	{
	theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:404 bodyString:@"File not found."];
	}
else if (theIsDirectoryFlag == YES)
	{
	NSMutableString *thePage = [NSMutableString stringWithString:@"<html><body><ul>"];
	
	for (NSString *theFilename in [[NSFileManager defaultManager] directoryContentsAtPath:thePath])
		{
		NSString *theEntryPath = [thePath stringByAppendingPathComponent:theFilename];
		
		[thePage appendFormat:@"<li><a href=\"%@\">%@</a></li>", theEntryPath, theFilename];
		}

	[thePage appendString:@"</ul></body></html>"];
	
	theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:200 statusDescription:@"OK" httpVersion:kHTTPVersion1_0];
	[theResponse setContentType:@"text/html" body:[thePage dataUsingEncoding:NSUTF8StringEncoding]];
	}
else
	{
	theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:200 statusDescription:@"OK" httpVersion:kHTTPVersion1_0];
	[theResponse setContentType:@"application/octet-stream" body:[NSData dataWithContentsOfFile:thePath]];
	}

if (outResponse)
	*outResponse = theResponse;

return(YES);
}


@end
