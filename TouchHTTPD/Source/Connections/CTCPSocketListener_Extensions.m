//
//  CTCPSocketListener_Extensions.m
//  Echo
//
//  Created by Jonathan Wight on 12/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CTCPSocketListener_Extensions.h"

@implementation CTCPSocketListener (CTCPSocketListener_Extensions)

- (BOOL)serveForever:(BOOL)inIgnoreExceptions error:(NSError **)outError
{
if (self.listening == NO)
	{
	if ([self start:outError] == NO)
		return(NO);
	}

NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

BOOL theFlag = self.listening;
while (theFlag)
	{
	@try
		{
		NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
		theFlag = self.listening;
		[thePool drain];
		}
	@catch (NSException *exception)
		{
		if (inIgnoreExceptions == NO)
			{
			LOG_(@"Exception caught, exiting runloop: %@", exception);
			theFlag = NO;
			}
		}
	}

[thePool drain];

return(YES);
}

@end
