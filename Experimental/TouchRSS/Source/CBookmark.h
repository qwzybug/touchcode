//
//  CBookmark.h
//  TouchCode
//
//  Created by Jonathan Wight on 11/26/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CPersistentObject.h"


@interface CBookmark : CPersistentObject {
	NSString *title;
	NSURL *URL;
}

@property (readwrite, nonatomic, retain) NSString *title;
@property (readwrite, nonatomic, retain) NSURL *URL;

@end
