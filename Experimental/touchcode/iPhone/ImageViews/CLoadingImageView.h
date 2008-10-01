//
//  CLoadingImageView.h
//  Obama
//
//  Created by Jonathan Wight on 9/19/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CImageProvider.h"

@interface CLoadingImageView : UIImageView <CImageProviderDelegate> {
	CImageProvider *imageProvider;
}

@property (readwrite, nonatomic, retain) CImageProvider *imageProvider;

@end
