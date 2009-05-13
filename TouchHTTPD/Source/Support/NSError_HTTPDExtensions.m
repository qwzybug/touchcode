//
//  NSError_HTTPDExtensions.m
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSError_HTTPDExtensions.h"

#import "CHTTPMessage.h"

@implementation NSError (NSError_HTTPDExtensions)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code underlyingError:(NSError *)inUnderlyingError request:(CHTTPMessage *)inRequest
{
NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionary];
if (inUnderlyingError)
	[theUserInfo setObject:inUnderlyingError forKey:NSUnderlyingErrorKey];
if (inRequest && [inRequest debuggingDescription])
	[theUserInfo setObject:[inRequest debuggingDescription] forKey:@"TouchHTTPRequestKey"];

NSError *theError = [self errorWithDomain:domain code:code userInfo:theUserInfo];

return(theError);
}


+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code underlyingError:(NSError *)inUnderlyingError request:(CHTTPMessage *)inRequest format:(NSString *)inFormat, ...
{
NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionary];
if (inUnderlyingError)
	[theUserInfo setObject:inUnderlyingError forKey:NSUnderlyingErrorKey];
if (inRequest && [inRequest debuggingDescription])
	[theUserInfo setObject:[inRequest debuggingDescription] forKey:@"TouchHTTPRequestKey"];

va_list theArgs;
va_start(theArgs, inFormat);
NSString *theDescription = [[[NSString alloc] initWithFormat:inFormat arguments:theArgs] autorelease];
va_end(theArgs);

[theUserInfo setObject:theDescription forKey:NSLocalizedDescriptionKey];

NSError *theError = [self errorWithDomain:domain code:code userInfo:theUserInfo];

return(theError);
}

@end
