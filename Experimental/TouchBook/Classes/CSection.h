//
//  CSection.h
//  TouchBook
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSection : NSObject {
	NSURL *URL;
}

@property (readonly, nonatomic, retain) NSURL *URL;

- (id)initWithURL:(NSURL *)inURL;

@end
