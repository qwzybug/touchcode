//
//  CImageProvider.h
//  TouchCode
//
//  Created by Jonathan Wight on 07/28/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCompletionTicket.h"

@protocol CImageProviderDelegate;

@class CManagedURLConnection;

@interface CImageProvider : NSObject <CCompletionTicketDelegate> {
	id <CImageProviderDelegate> delegate;

	UIImage *image;
	NSURL *imageURL;

	CManagedURLConnection *connection;
	
	NSString *placeholderImageName;
	NSString *failedImageName;
	NSString *cancelledImageName;
}

@property (readwrite, nonatomic, assign) id <CImageProviderDelegate> delegate;

@property (readwrite, nonatomic, retain) UIImage *image;
@property (readwrite, nonatomic, retain) NSURL *imageURL;
@property (readwrite, nonatomic, retain) NSString *placeholderImageName;
@property (readwrite, nonatomic, retain) NSString *failedImageName;
@property (readwrite, nonatomic, retain) NSString *cancelledImageName;

- (id)initWithImageURL:(NSURL *)inURL;

- (void)loadContentFromImageAtURL:(NSURL *)inURL;

@end

#pragma mark -

@protocol CImageProviderDelegate <NSObject>

- (void)imageProvider:(CImageProvider *)inImageProvider didUpdateImage:(UIImage *)inImage;

@end