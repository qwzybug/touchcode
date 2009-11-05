//
//  CTemporaryData.m
//  Uploadr
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CTemporaryData.h"

@interface CTemporaryData ()
@property (readwrite, assign) size_t dataLimit;
@property (readwrite, retain) id storage;
@property (readwrite, copy) NSURL *tempFileURL;
@end

#pragma mark -

@implementation CTemporaryData

@synthesize dataLimit;
@dynamic data;
@synthesize storage;
@synthesize tempFileURL;

- (id)initWithDataLimit:(size_t)inDataLimit;
{
if ((self = [self init]) != NULL)
	{
	dataLimit = inDataLimit;
	}
return(self);
}

- (void)dealloc
{
[storage release];
storage = NULL;

[tempFileURL release];
tempFileURL = NULL;

[super dealloc];
}

- (NSData *)data
{
NSData *theData = NULL;
if ([self.storage isKindOfClass:[NSData class]])
	theData = self.storage;
else if ([self.storage isKindOfClass:[NSFileHandle class]])
	{
	[self.storage synchronizeFile];
	NSError *theError = NULL;
	theData = [NSData dataWithContentsOfURL:self.tempFileURL options:NSMappedRead error:&theError];
	if (theData == NULL || theError != NULL)
		{
		NSLog(@"ERROR: %@", theError);
		}
	}
return(theData);
}

- (BOOL)writeData:(NSData *)inData error:(NSError **)outError
{
if ([self.storage isKindOfClass:[NSFileHandle class]])
	{		
	[(NSFileHandle *)self.storage writeData:inData];
	}
else if ([self.storage length] + [inData length] > self.dataLimit)
	{
	NSString *theTemplate = [NSTemporaryDirectory() stringByAppendingPathComponent:@"XXXXXXXXXXXXXXXX.tmp"];
	char thePathBuffer[theTemplate.length + 1];
	strncpy(thePathBuffer, theTemplate.UTF8String, theTemplate.length);
	mkstemps(thePathBuffer, 4);
	NSString *thePath = [NSString stringWithUTF8String:thePathBuffer];
	self.tempFileURL = [NSURL fileURLWithPath:thePath];
	NSError *theError = NULL;
	
	// Create an empty file.
	BOOL theResult = [[NSData data] writeToURL:self.tempFileURL options:0 error:&theError];
	if (theResult == NO || theError != NULL)
		{
		NSLog(@"ERROR: %@", theError);
		if (outError)
			*outError = theError;
		return(NO);
		}

	NSFileHandle *theFileHandle = [NSFileHandle fileHandleForWritingAtPath:self.tempFileURL.path];
	if (theFileHandle == NULL || theError != NULL)
		{
		NSLog(@"ERROR: %@", theError);
		if (outError)
			*outError = theError;
		return(NO);
		}

	if (self.storage)
		[theFileHandle writeData:self.storage];
	[theFileHandle writeData:inData];

	self.storage = theFileHandle;
	}
else if (self.storage == NULL)
	{
	self.storage = inData;
	}
else if ([self.storage isKindOfClass:[NSMutableData class]])
	{
	[self.storage appendData:inData];
	}
else if ([self.storage isKindOfClass:[NSData class]])
	{
	self.storage = [[self.storage mutableCopy] autorelease];
	[self.storage appendData:inData];
	}
	
return(YES);
}

- (BOOL)copyDataToURL:(NSURL *)inURL error:(NSError **)outError
{
// TODO
return(NO);
}

@end
