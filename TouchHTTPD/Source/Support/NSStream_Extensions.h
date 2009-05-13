//
//  NSStream_Extensions.h
//  FileServer
//
//  Created by Jonathan Wight on 12/6/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSStream (NSStream_Extensions)

+ (NSString *)stringForStatus:(NSStreamStatus)inStatus;
+ (NSString *)stringForEvent:(NSStreamEvent)inEvent;

@end
