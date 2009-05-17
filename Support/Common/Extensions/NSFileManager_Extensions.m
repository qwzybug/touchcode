//
//  NSFileManager_Extensions.m
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSFileManager_Extensions.h"

@implementation NSFileManager (NSFileManager_Extensions)

- (NSString *)mimeTypeForPath:(NSString *)inPath
{
if ([inPath pathIsAppleDouble])
	return(@"application/octet-stream");

NSString *thePathExtension = [inPath pathExtension];
if ([thePathExtension isEqualToString:@"html"])
	{
	return(@"text/html");
	}
else if ([thePathExtension isEqualToString:@"png"])
	{
	return(@"image/png");
	}
else if ([thePathExtension isEqualToString:@"css"])
	{
	return(@"text/css");
	}
else if ([thePathExtension isEqualToString:@"jpg"])
	{
	return(@"image/jpeg");
	}
else if ([thePathExtension isEqualToString:@"gif"])
	{
	return(@"image/gif");
	}
else if ([thePathExtension isEqualToString:@"js"])
	{
	return(@"text/javascript");
	}
else if ([thePathExtension isEqualToString:@"rtf"])
	{
	return(@"application/rtf");
	}
return(@"application/octet-stream");
}

@end
