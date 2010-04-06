//
//  NSError_Extensions.m
//  Logging
//
//  Created by Jonathan Wight on 8/27/07.
//  Copyright 2007 Toxic Software. All rights reserved.
//

#import "NSError_Extensions.h"

@implementation NSError (NSError_Extensions)

+ (id)errorWithDomain:(NSString *)inDomain code:(int)inCode userInfo:(NSDictionary *)inUserInfo localizedDescription:(NSString *)inFormat, ...
{
NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionaryWithDictionary:inUserInfo];

va_list theArgs;
va_start(theArgs, inFormat);
NSString *theLocalizedDescription = [[[NSString alloc] initWithFormat:inFormat arguments:theArgs] autorelease];
va_end(theArgs);
[theUserInfo setObject:theLocalizedDescription forKey:NSLocalizedDescriptionKey];

NSError *theError = [self errorWithDomain:inDomain code:inCode userInfo:theUserInfo];
return(theError);
}

+ (int)errnoForError:(NSError *)inError;
{
NSAssert(inError && [[inError domain] isEqualToString:NSPOSIXErrorDomain] == YES, @"Error domain is not NSPOSIXErrorDomain");
return([inError code]);
}

+ (id)errorWithException:(NSException *)inException
{
NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
	inException, @"NSException",
	NULL];


NSError *theError = [NSError errorWithDomain:@"NSException" code:-1 userInfo:theUserInfo];
return(theError);
}

@end
