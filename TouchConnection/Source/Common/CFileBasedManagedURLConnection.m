//
//  CFileBasedManagedURLConnection.m
//  EverybodyVotes
//
//  Created by Jonathan Wight on 8/22/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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
if (data == NULL)
	return([NSData dataWithContentsOfFile:self.filePath options:0 error:NULL]);
return(data); 
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData
{
if (self.connection == NULL)
	{
	NSLog(@"Received event after connction has been reset. This is bad.");
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
		NSLog(@"Could not create temporary directory: %@.", theError);
		return;
		}

	NSString *theTempPath = [theTempRoot stringByAppendingPathComponent:@"TEMP_XXXXXXX"];

	char theBuffer[theTempPath.length + 1];
	strncpy(theBuffer, [theTempPath UTF8String], theTempPath.length + 1);
	
	self.filePath = [NSString stringWithUTF8String:mktemp(theBuffer)];

	theResult = [[NSFileManager defaultManager] createFileAtPath:self.filePath contents:inData attributes:NULL];
	if (theResult == NO)
		{
		NSLog(@"createFileAtPath (%@) failed!");
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
