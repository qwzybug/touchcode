//
//  CTempFile.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/29/08.
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

#import "CTempFile.h"

#include <unistd.h>

@interface CTempFile ()
@property (readwrite, retain) NSString *path;
@property (readwrite, assign) int fileDescriptor;
@property (readwrite, retain) NSFileHandle *fileHandle;
@end

#pragma mark -

@implementation CTempFile

@synthesize deleteOnDealloc;
@synthesize suffix;

+ (NSString *)temporaryDirectory
{
return(NSTemporaryDirectory());
}

+ (CTempFile *)tempFile
{
return([[[self alloc] init] autorelease]);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	deleteOnDealloc = YES;
	fileDescriptor = -1;
	}
return(self);
}

- (void)dealloc
{
if (fileHandle)
	{
	[self.fileHandle synchronizeFile];
	[self.fileHandle closeFile];
	self.fileHandle = NULL;
	}

self.fileDescriptor = -1;

if (self.deleteOnDealloc == YES && path != NULL)
	{
	// Try and delete the file. But dont stress if it fails. JIWTODO - maybe log this?
	[[NSFileManager defaultManager] removeItemAtPath:self.path error:NULL];
	}

self.suffix = NULL;
self.path = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)path
{
if (path == NULL)
	[self create];
return(path);
}

- (void)setPath:(NSString *)inPath
{
if (path != inPath)
	{
	[path autorelease];
	path = [inPath retain];
    }
}

- (int)fileDescriptor
{
if (fileDescriptor == -1)
	[self create];
return(fileDescriptor);
}

- (void)setFileDescriptor:(int)inFileDescriptor
{
fileDescriptor = inFileDescriptor;
}

- (NSFileHandle *)fileHandle
{
if (fileHandle == NULL)
	{
	fileHandle = [[NSFileHandle alloc] initWithFileDescriptor:self.fileDescriptor closeOnDealloc:YES];
	}
return(fileHandle);
}

- (void)setFileHandle:(NSFileHandle *)inFileHandle
{
if (fileHandle != inFileHandle)
	{
	[fileHandle autorelease];
	fileHandle = [inFileHandle retain];
    }
}

#pragma mark -

- (void)create
{
// JIWTODO use a better (user supplied?) template
NSString *theTemplate = [[[self class] temporaryDirectory] stringByAppendingString:@"XXXXXXXXXXXXXXXXXXXXXXXXXXX"];
if (self.suffix)
	theTemplate = [theTemplate stringByAppendingString:self.suffix];

char theBuffer[theTemplate.length + 1];
strncpy(theBuffer, [theTemplate UTF8String], theTemplate.length + 1);
self.fileDescriptor = mkstemps(theBuffer, self.suffix.length);
self.path = [NSString stringWithUTF8String:theBuffer];
}

@end
