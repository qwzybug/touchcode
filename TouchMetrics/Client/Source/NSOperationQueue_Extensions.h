//
//  NSOperationQueue_Extensions.h
//  Uploadr
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (NSOperationQueue_Extensions)

- (void)runSynchronousOperation:(NSOperation *)inOperation;

@end
