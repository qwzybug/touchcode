//
//  NSDictionary_SqlExtensions.h
//  Project V
//
//  Created by Jonathan Wight on 9/20/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSDictionary_SqlExtensions.h"

@interface NSDictionary (NSDictionary_SqlExtensions)

+ (id)dictionaryWithPropertyListData:(NSData *)inData;
- (NSData *)propertyListData;

@end
