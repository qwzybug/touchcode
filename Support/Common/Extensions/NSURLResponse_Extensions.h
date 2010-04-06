//
//  NSURLResponse_Extensions.h
//  touchcode
//
//  Created by Jonathan Wight on 11/09/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLResponse (NSURLResponse_Extensions)

- (NSError *)asError;

- (NSString *)debuggingDescription;

- (void)dump;

@end

