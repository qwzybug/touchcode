//
//  CImageTileView.h
//  TouchCode
//
//  Created by Devin Chalmers on 6/20/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CManagedURLConnection.h"
#import "CCompletionTicket.h"

@interface CImageTileView : UIView <CCompletionTicketDelegate> {
	int imageSize;
	int imagesPerRow;
	int maxImagesPerRow;
	int maxImageSize;
	
	NSMutableDictionary *imageViews;
}

@property(nonatomic, readwrite, assign) int maxImagesPerRow;
@property(nonatomic, readwrite, assign) int maxImageSize;

- (void)setImageURLs:(NSArray *)URLs;

@end
