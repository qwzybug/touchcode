//
//  CRSSObject.h
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CRSSObject : NSObject {
	CRSSObject *parent;
}

@property (readonly, nonatomic, assign)	CRSSObject *parent;

- (id)initWithParent:(CRSSObject *)inParent;

@end
