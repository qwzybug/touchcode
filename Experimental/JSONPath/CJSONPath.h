//
//  CJSONPath.h
//  JSONPath
//
//  Created by Jonathan Wight on 03/06/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CJSONPath : NSObject {
	NSString *string;
}

@property (readonly, nonatomic, copy) NSString *string;

- (id)initWithString:(NSString *)inString;

- (BOOL)compile:(NSError **)outError;

- (id)evaluteWithObject:(id)inObject error:(NSError **)outError;

@end
