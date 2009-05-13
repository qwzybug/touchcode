//
//  CTCPSocketListener_Extensions.h
//  Echo
//
//  Created by Jonathan Wight on 12/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CTCPSocketListener.h"

@interface CTCPSocketListener (CTCPSocketListener_Extensions)

- (BOOL)serveForever:(BOOL)inIgnoreExceptions error:(NSError **)outError;

@end
