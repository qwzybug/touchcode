//
//  CZipfile.m
//  TouchBook
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CZipfile.h"

#include <zzip/lib.h>

@implementation CZipfile

@synthesize URL;

- (id)initWithURL:(NSURL *)inURL
{
if ((self = [super init]) != NULL)
	{
	URL = [inURL retain];
	
	BOOL theIsDirectoryFlag = NO;
	BOOL theFileExistsFlag = [[NSFileManager defaultManager] fileExistsAtPath:self.URL.path isDirectory:&theIsDirectoryFlag];
	if (theFileExistsFlag == NO || theIsDirectoryFlag == YES)
		{
		NSLog(@"NO FILE EXISTS");
		}
	}
return(self);
}

- (void)dealloc
{
[super dealloc];
}

- (NSArray *)entries
{
if (entries == NULL)
	{
	NSMutableArray *theEntries = [NSMutableArray array];

	ZZIP_DIR *dir = zzip_dir_open([self.URL.path UTF8String], 0);
	ZZIP_DIRENT dirent;
	while (zzip_dir_read(dir, &dirent))
		{
		[theEntries addObject:[NSString stringWithUTF8String:dirent.d_name]];
		}
	zzip_dir_close(dir);

	entries = [theEntries copy];
	}
return(entries);
}

- (NSData *)dataForEntry:(NSString *)inEntry error:(NSError **)outError
{
ZZIP_DIR *dir = zzip_dir_open([self.URL.path UTF8String], 0);

ZZIP_STAT dirent;
int theResult = zzip_dir_stat(dir, [inEntry UTF8String], &dirent, 0);
if (theResult != 0)
	{
	NSLog(@"ENTRY NOT FOUND: %@", inEntry);
	if (outError)
		{
		*outError = [NSError errorWithDomain:@"TODO_ERROR" code:-1 userInfo:NULL];
		}
	return(NULL);
	}

NSMutableData *theData = [NSMutableData dataWithLength:dirent.st_size];
ZZIP_FILE *fp = zzip_file_open(dir, [inEntry UTF8String], 0);
zzip_ssize_t len = zzip_file_read(fp, [theData mutableBytes], dirent.st_size);
if (len < dirent.st_size)
	{
	if (outError)
		*outError = [NSError errorWithDomain:@"TODO_ERROR" code:-2 userInfo:NULL];
	return(NULL);
	}
zzip_file_close(fp);
return(theData);
}

@end
