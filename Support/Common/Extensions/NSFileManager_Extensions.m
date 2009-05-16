//
//  NSFileManager_Extensions.m
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSFileManager_Extensions.h"

#import "GMAppleDouble.h"
#include <sys/xattr.h>
#import "NSString_Extensions.h"

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

- (NSData *)appleDoubleDataForPath:(NSString *)inPath error:(NSError **)outError
{
#pragma unused (outError)
const char *thePath = [inPath UTF8String];

GMAppleDouble *theAppleDouble = [GMAppleDouble appleDouble];
ssize_t theSize = getxattr(thePath, "com.apple.FinderInfo", NULL, 0, 0, XATTR_NOFOLLOW);
if (theSize > 0)
	{
	NSMutableData *theData = [NSMutableData dataWithLength:theSize];
	if (getxattr(thePath, "com.apple.FinderInfo", [theData mutableBytes], theSize, 0, XATTR_NOFOLLOW) < 0)
		{
		if (outError)
			*outError = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:NULL];
		return(NULL);
		}
	[theAppleDouble addEntryWithID:DoubleEntryFinderInfo data:theData];
	}

theSize = getxattr(thePath, "com.apple.ResourceFork", NULL, 0, 0, XATTR_NOFOLLOW);
if (theSize > 0)
	{
	NSMutableData *theData = [NSMutableData dataWithLength:theSize];
	if (getxattr(thePath, "com.apple.ResourceFork", [theData mutableBytes], theSize, 0, XATTR_NOFOLLOW) < 0)
		{
		if (outError)
			*outError = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:NULL];
		return(NULL);
		}
	[theAppleDouble addEntryWithID:DoubleEntryResourceFork data:theData];
	}

return([theAppleDouble data]);
}

- (BOOL)setAppleDoubleData:(NSData *)inData forPath:(NSString *)inPath error:(NSError **)outError
{
const char *thePath = [inPath UTF8String];

GMAppleDouble *theAppleDouble = [GMAppleDouble appleDoubleWithData:inData];
for (GMAppleDoubleEntry *theEntry in [theAppleDouble entries])
	{
	NSString *theAttributeName = NULL;
	switch ([theEntry entryID])
		{
		case DoubleEntryFinderInfo:
			theAttributeName = @"com.apple.FinderInfo";
			break;
		case DoubleEntryResourceFork:
			theAttributeName = @"com.apple.ResourceFork";
			break;
		}
		
	if (theAttributeName != NULL)
		{
		NSData *theEntryData = [theEntry data];
		int theResult = setxattr(thePath, [theAttributeName UTF8String], [theEntryData bytes], [theEntryData length], 0, XATTR_NOFOLLOW);
		if (theResult != 0)
			{
			if (outError)
				*outError = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:NULL];
			return(NO);
			}
		}
	}

return(YES);
}

@end
