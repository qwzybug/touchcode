//
//  CImageProvider.h
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
	NSString *cachedImagePath;
}

@property (readwrite, nonatomic, assign) id <CImageProviderDelegate> delegate;

@property (readwrite, nonatomic, retain) UIImage *image;
@property (readwrite, nonatomic, retain) NSURL *imageURL;
@property (readwrite, nonatomic, retain) NSString *placeholderImageName;
@property (readwrite, nonatomic, retain) NSString *failedImageName;
@property (readwrite, nonatomic, retain) NSString *cancelledImageName;
@property (readwrite, nonatomic, retain) NSString *cachedImagePath;

- (id)initWithImageURL:(NSURL *)inURL;
- (id)initWithImageURL:(NSURL *)inURL cacheToPath:(NSString*)cachePath;

- (void)loadContentFromImageAtURL:(NSURL *)inURL;

@end

#pragma mark -

@protocol CImageProviderDelegate <NSObject>

- (void)imageProvider:(CImageProvider *)inImageProvider didUpdateImage:(UIImage *)inImage;

@end
