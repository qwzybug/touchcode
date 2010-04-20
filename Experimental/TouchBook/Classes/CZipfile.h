//
//  CZipfile.h
//  TouchBook
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZipfile : NSObject {
	NSURL *URL;
	NSArray *entries;
}

@property (readonly, nonatomic, copy) NSURL *URL;
@property (readonly, nonatomic, copy) NSArray *entries;

- (id)initWithURL:(NSURL *)inURL;

- (NSData *)dataForEntry:(NSString *)inEntry error:(NSError **)outError;

@end
