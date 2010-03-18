//
//  CBook.h
//  TouchBook
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBook : NSObject {
	NSURL *URL;
	NSURL *rootURL;
	NSArray *sections;
}

@property (readonly, nonatomic, copy) NSURL *URL;
@property (readonly, nonatomic, copy) NSURL *rootURL;
@property (readonly, nonatomic, copy) NSArray *sections;
@property (readonly, nonatomic, copy) NSString *title;

- (id)initWithURL:(NSURL *)inURL rootURL:(NSURL *)inRootURL;

@end
