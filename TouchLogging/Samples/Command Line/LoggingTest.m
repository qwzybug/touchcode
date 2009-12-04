//
//  LoggingTest.m
//  TouchCode
//
//  Created by Jonathan Wight on 20091204.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

//#import "CLoggingUploaderOperation.h"

#import "NSOperationQueue_Extensions.h"

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

LogDebug_(@"Ooops");

//
////CLoggingUploaderOperation *theUploaderOperation = [[[CLoggingUploaderOperation alloc] init] autorelease];
//
//NSOperationQueue *theQueue = [[[NSOperationQueue alloc] init] autorelease];
////[theQueue setSuspended:YES];
//[theQueue addOperationRecursively:theUploaderOperation];
//[theUploaderOperation dump];
//
//while (theQueue.operations.count > 0)
//	{
//	NSLog(@"LOOP");
//	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
//	}
//

[pool drain];
return 0;
}
