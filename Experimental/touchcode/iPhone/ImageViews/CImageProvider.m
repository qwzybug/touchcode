//
//  CImageProvider.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/28/08.
//  Copyright 2008 Toxic Software. All rights reserved.
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

+ (CLazyCache *)cache
{
static CLazyCache *sCache = NULL;
@synchronized(self)
	{
	if (sCache == NULL)
		{
		sCache = [[CLazyCache alloc] initWithCapacity:128];
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
		if (theImage)
			{
			self.image = theImage;
			}
		
		[self loadContentFromImageAtURL:imageURL];
		}
    }
}

- (UIImage *)image
{
return(image); 
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
UIImage *cachedImage = [[[self class] cache] cachedObjectForKey:inURL];
if(cachedImage == NULL) 
	{
	if (self.image == NULL && self.placeholderImageName != NULL)
		self.image = [UIImage imageNamed:self.placeholderImageName];

	NSURLRequest *theRequest = [[[NSURLRequest alloc] initWithURL:inURL] autorelease];
	
	CCompletionTicket *theTicket = [CCompletionTicket completionTicketWithIdentifier:@"Load Image" delegate:self userInfo:NULL];
	
	self.connection = [[[CManagedURLConnection alloc] initWithRequest:theRequest completionTicket:theTicket] autorelease];
	
	[[CURLConnectionManager instance] addAutomaticURLConnection:self.connection toChannel:@"images"];
	} 
else 
	{
	self.image = cachedImage;
	}	
}

#pragma mark -

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult
{
CManagedURLConnection *theConnection = inTarget;
UIImage *theImage = [UIImage imageWithData:theConnection.data];
[[[self class] cache] cacheObject:theImage forKey:theConnection.request.URL];
if (theImage)
	self.image = theImage;
else
	[UIImage imageNamed:self.failedImageName];
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
