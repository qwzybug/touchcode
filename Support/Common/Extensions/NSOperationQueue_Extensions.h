//
//  NSOperationQueue_Extensions.h
//  WebServiceEngine
//
//  Created by Jonathan Wight on 4/28/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (NSOperationQueue_Extensions)

- (void)addOperationRecursively:(NSOperation *)inOperation;

@end
