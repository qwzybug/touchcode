//
//  CBookContainer.h
//  TouchBook
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CBookContainer : NSObject {
	NSURL *URL;
	NSArray *books;
}

@property (readonly, copy) NSURL *URL;
@property (readonly, copy) NSArray *books;

- (id)initWithURL:(NSURL *)inURL;

@end
