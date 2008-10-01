//
//  CImageTileView.m
//  TouchCode
//
//  Created by Devin Chalmers on 6/20/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CImageTileView.h"
#import "UIImage_ThumbnailExtensions.h"
#import "CURLConnectionManager.h"
#import "CURLConnectionManagerChannel.h"

@implementation CImageTileView

@synthesize maxImagesPerRow, maxImageSize;

- (void)awakeFromNib;
{
	// some sensible defaults
	maxImagesPerRow = 5;
	maxImageSize = 300;
	
	imageViews = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
}

- (void)dealloc {
	// cancel outstanding image connections
	[[[CURLConnectionManager instance] channelForName:@"imageTiles"] cancelAll:YES];

	[imageViews release];
	imageViews = NULL;
	
	[super dealloc];
}

- (void)setImageURLs:(NSArray *)URLs;
{
	imagesPerRow = ([URLs count] > maxImagesPerRow) ? maxImagesPerRow : [URLs count];
	imageSize = MIN(self.frame.size.width / imagesPerRow, maxImageSize);
	
	int imageNumber = 0;
	for (NSURL *url in URLs) {
		// images identified by URL
		NSString *imageIdentifier = [url absoluteString];
		
		// add image subview for the image
		CGPoint position;
		if ([URLs count] > 1)
			position = CGPointMake(imageNumber % imagesPerRow * imageSize, imageNumber / imagesPerRow * imageSize);
		else // center a single image in the view
			position = CGPointMake((self.frame.size.width - imageSize) / 2, 0);
		
		CGRect imageRect = CGRectMake(position.x, position.y, imageSize, imageSize);
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
		[self addSubview:imageView];
		[imageViews setObject:[imageView autorelease] forKey:imageIdentifier];
		
		// start URL connection
		CCompletionTicket *theTicket = [CCompletionTicket completionTicketWithIdentifier:imageIdentifier delegate:self userInfo:NULL];
		CManagedURLConnection *conn = [[CManagedURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0]
																		  completionTicket:theTicket];
		[[CURLConnectionManager instance] addAutomaticURLConnection:conn toChannel:@"imageTiles"];
		
		imageNumber++;
	}
	
	[self sizeToFit];
}


- (CGSize)sizeThatFits:(CGSize)size
{
	CGSize mySize = self.frame.size;
	if (imagesPerRow > 0)
		mySize = CGSizeMake(self.frame.size.width, (([imageViews count] - 1) / imagesPerRow + 1) * imageSize);
	return mySize;
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult
{
	// add to image tile view
	UIImageView *imageView = [imageViews valueForKey:[inCompletionTicket identifier]];
	
	UIImage *image = [UIImage imageWithData:inResult];
	if (!image)
		return;
	
	// make image thumbnail
	UIImage *thumbnail = [image thumbnail:CGSizeMake(imageSize, imageSize) cropped:YES];
	
	imageView.image = thumbnail;
}


@end
