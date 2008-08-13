//
//  CGeoLineString.h
//  TouchTheFireEagle
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CGeoObject.h"

@interface CGeoLineString : CGeoObject {
	NSMutableArray *points;
}

@property (readwrite, retain) NSMutableArray *points;

- (BOOL)isRing;

@end
