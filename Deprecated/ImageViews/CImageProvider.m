//
//  CImageProvider.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/28/08.
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

#import "CImageProvider.h"

#import "CManagedURLConnection.h"
#import "CURLConnectionManager.h"
#import "CLazyCache.h"

// TODO -- imageURL isn't really used properly! (Use it or remove it)
@interface CImageProvider ()

@property (readwrite, nonatomic, retain) CManagedURLConnection *connection;

@end

#pragma mark -

@implementation CImageProvider

@synthesize delegate;
@dynamic image;
@synthesize imageURL;
@synthesize connection;
@synthesize placeholderImageName;
@synthesize failedImageName;
@synthesize cancelledImageName;
@synthesize cachedImagePath;

+ (CLazyCache *)cache
{
	static CLazyCache *sCache = NULL;
	@synchronized(self)
	{
		if (sCache == NULL)
		{
			sCache = [[CLazyCache alloc] initWithCapacity:64];
		}
	}
	return(sCache);
}

- (id)initWithImageURL:(NSURL *)inURL
{
	if ((self = [super init]) != NULL)
	{
		self.imageURL = inURL;
	}
	return(self);
}

- (id)initWithImageURL:(NSURL *)inURL cacheToPath:(NSString*)cachePath
{
	if ((self = [super init]) != NULL)
	{
		self.cachedImagePath = cachePath;
		self.imageURL = inURL;
	}
	return(self);
}

- (void)dealloc
{
	if (self.connection)
	{
		[self.connection cancel];
		self.connection.completionTicket = NULL;
		self.connection = NULL;
	}
	
	self.delegate = NULL;
	self.image = NULL;
	self.imageURL = NULL;
	self.placeholderImageName = NULL;
	self.failedImageName = NULL;
	self.cancelledImageName = NULL;
	self.cachedImagePath = NULL;
	//
	[super dealloc];
}

#pragma mark -

- (id <CImageProviderDelegate>)delegate
{
	return(delegate); 
}

- (void)setDelegate:(id <CImageProviderDelegate>)inDelegate
{
	if (delegate != inDelegate)
	{
		delegate = inDelegate;
		
		if (self.image && self.delegate && [self.delegate respondsToSelector:@selector(imageProvider:didUpdateImage:)])
		{
			[self.delegate imageProvider:self didUpdateImage:image];
		}
    }
}

- (NSURL *)imageURL
{
	return(imageURL); 
}

- (void)setImageURL:(NSURL *)inImageURL
{
	if (imageURL != inImageURL)
	{
		[imageURL autorelease];
		imageURL = [inImageURL retain];
		if (imageURL != NULL)
		{
			UIImage *theImage = [[[self class] cache] cachedObjectForKey:imageURL];
			self.image = theImage;
			// should maybe add a setting for whether we actually want to reload images
			// even if they've been memory cached
			if (!theImage)
				[self loadContentFromImageAtURL:imageURL];
		}
		else
		{
			self.image = nil;
		}
    }
}

- (UIImage *)image
{
	if (image)
	{
		return(image); 
	}
	else if (placeholderImageName)
	{
		return([UIImage imageNamed:placeholderImageName]);
	}
	else
	{
		return nil;
	}
}

- (void)setImage:(UIImage *)inImage
{
	if (image != inImage)
	{
		[image release];
		image = [inImage retain];
		
		if (self.delegate && [self.delegate respondsToSelector:@selector(imageProvider:didUpdateImage:)])
		{
			[self.delegate imageProvider:self didUpdateImage:image];
		}
    }
}

- (NSString *)placeholderImageName
{
	return(placeholderImageName); 
}

- (void)setPlaceholderImageName:(NSString *)inPlaceholderImageName
{
	if (placeholderImageName != inPlaceholderImageName)
	{
		[placeholderImageName autorelease];
		placeholderImageName = [inPlaceholderImageName retain];
	}
	
	if (placeholderImageName && self.image == NULL)
		self.image = [UIImage imageNamed:placeholderImageName];
}

#pragma mark -

- (void)loadContentFromImageAtURL:(NSURL *)inURL
{
	if (self.image == NULL && self.placeholderImageName != NULL)
		self.image = [UIImage imageNamed:self.placeholderImageName];
	
	if (cachedImagePath)
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		// create cache directory if it doesn't exist.
		NSString *cachedDirectory = [cachedImagePath stringByDeletingLastPathComponent];
		if (![fileManager fileExistsAtPath:cachedDirectory])
			[fileManager createDirectoryAtPath:cachedDirectory attributes:nil];
		
		if ([fileManager fileExistsAtPath:cachedImagePath])
		{
			self.image = [UIImage imageWithContentsOfFile:cachedImagePath];
			return;
		}
	}

	// we don't have the image cached on disk already, so lets load it like normal..
	NSURLRequest *theRequest = [[[NSURLRequest alloc] initWithURL:inURL] autorelease];
	
	CCompletionTicket *theTicket = [CCompletionTicket completionTicketWithIdentifier:@"Load Image" delegate:self userInfo:self.imageURL];
	
	[self.connection cancel];
	self.connection.completionTicket = NULL;
	
	self.connection = [[[CManagedURLConnection alloc] initWithRequest:theRequest completionTicket:theTicket] autorelease];
	
	[[CURLConnectionManager instance] addAutomaticURLConnection:self.connection toChannel:@"images"];
}

#pragma mark -

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult
{
	CManagedURLConnection *theConnection = inTarget;
	UIImage *theImage = [UIImage imageWithData:theConnection.data];
	[[[self class] cache] cacheObject:theImage forKey:theConnection.request.URL];
	
	// if our URL has changed in the interim, don't load it
	if (theConnection.request.URL == self.imageURL)
	{
		if (theImage)
		{
			self.image = theImage;
			if (cachedImagePath)
			{
				[theConnection.data writeToFile:cachedImagePath atomically:YES];
			}
		}
		else
			[UIImage imageNamed:self.failedImageName];
	}
}


- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didFailForTarget:(id)inTarget error:(NSError *)inError
{
	if (self.failedImageName != NULL)
		[UIImage imageNamed:self.failedImageName];
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCancelForTarget:(id)inTarget
{
	if (self.cancelledImageName != NULL)
		[UIImage imageNamed:self.cancelledImageName];
}

@end
