//
//  CTCPEchoConnection.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CTCPEchoConnection.h"

@implementation CTCPEchoConnection

- (void)dataReceived:(NSData *)inData
{
NSString *theString = [[[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding] autorelease];
NSLog(@"%@", theString);

theString = [NSString stringWithFormat:@"Hello World (%@)", theString];
NSData *theData = [theString dataUsingEncoding:NSUTF8StringEncoding];

[self sendData:theData];
}

@end
