//
//  CFileBasedManagedURLConnection.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/22/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

#import "CFileBasedManagedURLConnection.h"

@interface CFileBasedManagedURLConnection ()
@property (readwrite, nonatomic, retain) NSString *filePath;
@property (readwrite, nonatomic, retain) NSFileHandle *fileHandle;
@end

#pragma mark -

@implementation CFileBasedManagedURLConnection

@synthesize filePath;
@synthesize fileHandle;

- (void)dealloc
{
if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath])
	{
	NSError *theError = NULL;
	[[NSFileManager defaultManager] removeItemAtPath:self.filePath error:&theError];
	}

self.filePath = NULL;
self.fileHandle = NULL;
//
[super dealloc];
}

- (NSData *)data
{
if (super.data == NULL)
	return([NSData dataWithContentsOfFile:self.filePath options:0 error:NULL]);
return(super.data); 
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData
{
if (self.connection == NULL)
	{
	return;
	}
NSAssert(self.connection == inConnection, NULL);

if (self.fileHandle == NULL)
	{
	// TODO - most of this could be moved to the connection manager.
	NSString *theTempRoot = [@"~/Library/Temporary Items/TouchCode" stringByExpandingTildeInPath];
	NSError *theError = NULL;
	BOOL theResult = [[NSFileManager defaultManager] createDirectoryAtPath:theTempRoot withIntermediateDirectories:YES attributes:NO error:&theError];
	if (theResult == NO)
		{
		return;
		}

	NSString *theTempPath = [theTempRoot stringByAppendingPathComponent:@"TEMP_XXXXXXX"];

	char theBuffer[theTempPath.length + 1];
	strncpy(theBuffer, [theTempPath UTF8String], theTempPath.length + 1);
	
	self.filePath = [NSString stringWithUTF8String:mktemp(theBuffer)];

	theResult = [[NSFileManager defaultManager] createFileAtPath:self.filePath contents:inData attributes:NULL];
	if (theResult == NO)
		{
		}
	
	self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
	[self.fileHandle seekToEndOfFile];
	}
else
	{
	[self.fileHandle writeData:inData];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection
{
if (self.fileHandle != NULL)
	{
	[self.fileHandle synchronizeFile];
	[self.fileHandle closeFile];
	self.fileHandle = NULL;
	}

[super connectionDidFinishLoading:inConnection];
}

@end
