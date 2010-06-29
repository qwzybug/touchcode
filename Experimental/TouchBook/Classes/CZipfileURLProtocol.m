//
//  CZipfileURLProtocol.m
//  TouchCode
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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

#import "CZipfileURLProtocol.h"

#import "CZipfile.h"

@interface CZipfileURLProtocol ()
@property (readwrite, nonatomic, retain) CZipfile *zipfile;

+ (NSString *)MIMETypeForPath:(NSString *)inPath;
@end

#pragma mark -

@implementation CZipfileURLProtocol

@synthesize zipfile;

+ (void)load
{
[self registerClass:self];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
NSURL *theURL = request.URL;

if ([theURL.scheme isEqualToString:@"x-zipfile"] == NO)
	return(NO);

//NSString *thePath = theURL.resourceSpecifier;
//thePath = [thePath stringByStandardizingPath];
//
//thePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:thePath];
//BOOL theFileExists = [[NSFileManager defaultManager] fileExistsAtPath:thePath];
//
//return(theFileExists);

return(YES);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
return(request);
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
return([a.URL isEqual:b.URL]);
}

- (void)startLoading
{
NSAssert(self.client, @"Should never get a startLoading message.");
NSAssert([self.client conformsToProtocol:@protocol(NSURLProtocolClient)], @"Should never have a client that does not conform to NSURLProtocolClient protocol.");

NSURL *theURL = [self.request.URL standardizedURL];
NSAssert([theURL.scheme isEqualToString:@"x-zipfile"], @"The requesting URL scheme is not x-resource.");

NSString *thePath = theURL.path;
thePath = [thePath stringByStandardizingPath];

//thePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:thePath];

NSString *theNewPath = @"";
NSString *theOldPath = @"";
for (NSString *theComponent in [thePath pathComponents])
	{
	theNewPath = [theOldPath stringByAppendingPathComponent:theComponent];
	BOOL theIsDirectoryFlag = NO;
	BOOL theFileExistsFlag = [[NSFileManager defaultManager] fileExistsAtPath:theNewPath isDirectory:&theIsDirectoryFlag];
	
	if (theFileExistsFlag == NO)
		{
		break;
		}
	theOldPath = theNewPath;

	}
	
NSString *theMimeType = [[self class] MIMETypeForPath:thePath];
NSString *theEntryPath = [thePath substringFromIndex:theOldPath.length + 1];

self.zipfile = [[[CZipfile alloc] initWithURL:[NSURL fileURLWithPath:theOldPath]] autorelease];

NSError *theError = NULL;
NSData *theData = [self.zipfile dataForEntry:theEntryPath error:&theError];
if (theData == NULL)
	{
	NSLog(@"%@", theError);
	}

NSURLResponse *theResponse = [[[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:theMimeType expectedContentLength:theData.length textEncodingName:NULL] autorelease];

[self.client URLProtocol:self didReceiveResponse:theResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];

[self.client URLProtocol:self didLoadData:theData];

[self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
}

+ (NSString *)MIMETypeForPath:(NSString *)inPath
{
NSString *theExtension = [inPath pathExtension];
//if ([theExtension isEqualToString:@"js"])
//	return(@"text/javascript");
//else if ([theExtension isEqualToString:@"css"])
//	return(@"text/css");
//else if ([theExtension isEqualToString:@"html"])
//	return(@"text/html");
//else if ([theExtension isEqualToString:@"png"])
//	return(@"image/png");
//else if ([theExtension isEqualToString:@"epub"])
//	return(@"application/epub+zip");
//else if ([theExtension isEqualToString:@"xml"])
//	return(@"text/xml");
//else
	return(@"application/octet-stream");
}

@end
