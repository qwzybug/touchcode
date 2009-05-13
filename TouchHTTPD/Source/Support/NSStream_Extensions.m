//
//  NSStream_Extensions.m
//  FileServer
//
//  Created by Jonathan Wight on 12/6/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSStream_Extensions.h"

@implementation NSStream (NSStream_Extensions)

+ (NSString *)stringForStatus:(NSStreamStatus)inStatus
{
switch (inStatus)
	{
	case NSStreamStatusNotOpen:
		return(@"NSStreamStatusNotOpen");
	case NSStreamStatusOpening:
		return(@"NSStreamStatusOpening");
	case NSStreamStatusOpen:
		return(@"NSStreamStatusOpen");
	case NSStreamStatusReading:
		return(@"NSStreamStatusReading");
	case NSStreamStatusWriting:
		return(@"NSStreamStatusWriting");
	case NSStreamStatusAtEnd:
		return(@"NSStreamStatusAtEnd");
	case NSStreamStatusClosed:
		return(@"NSStreamStatusClosed");
	case NSStreamStatusError:
		return(@"NSStreamStatusError");
	}
return(NULL);
}

+ (NSString *)stringForEvent:(NSStreamEvent)inEvent
{
switch (inEvent)
	{
	case NSStreamEventNone:
		return(@"NSStreamEventNone");
	case NSStreamEventOpenCompleted:
		return(@"NSStreamEventOpenCompleted");
	case NSStreamEventHasBytesAvailable:
		return(@"NSStreamEventHasBytesAvailable");
	case NSStreamEventHasSpaceAvailable:
		return(@"NSStreamEventHasSpaceAvailable");
	case NSStreamEventErrorOccurred:
		return(@"NSStreamEventErrorOccurred");
	case NSStreamEventEndEncountered:
		return(@"NSStreamEventEndEncountered");
	}
return(NULL);
}

@end

#pragma mark -

@implementation NSInputStream (NSStream_Extensions)

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (status: %@, hasBytes: %d)", [super description], [[self class] stringForStatus:[self streamStatus]], [self hasBytesAvailable]]);
}

@end

#pragma mark -

@implementation NSOutputStream (NSStream_Extensions)

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (status: %@, hasSpace: %d)", [super description], [[self class] stringForStatus:[self streamStatus]], [self hasSpaceAvailable]]);
}

@end
