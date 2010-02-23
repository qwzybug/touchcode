//
//  NSURLResponse_Extensions.m
//  Zipcar2
//
//  Created by Jonathan Wight on 11/09/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "NSURLResponse_Extensions.h"

@implementation NSURLResponse (NSURLResponse_Extensions)

- (NSError *)asError
{
// TODO - we can make a minimal OH NOES error here and just use the URL in the error. No?
return(NULL);
}

- (NSString *)debuggingDescription
{
NSMutableArray *theComponents = [NSMutableArray array];

[theComponents addObject:[NSString stringWithFormat:@"URL: %@", [self URL]]];
[theComponents addObject:[NSString stringWithFormat:@"MIMEType: %@", [self MIMEType]]];

NSString *theDescription = [theComponents componentsJoinedByString:@"\n"];
return(theDescription);
}

- (void)dump
{
fprintf(stderr, "%s\n", [[self debuggingDescription] UTF8String]);
}

@end

#pragma mark -

@implementation NSHTTPURLResponse (NSURLResponse_Extensions)

- (NSError *)asError
{
NSString *theLocalizedDescription = NULL;
NSString *theRecoverySuggestion = NULL;

switch ([self statusCode])
	{
	case 401:
		theLocalizedDescription = @"Authorization failed.";
		theRecoverySuggestion = @"Try again later.";
		break;
	case 503:
		theLocalizedDescription = @"The service is currently unavailable.";
		theRecoverySuggestion = @"Try again later.";
		break;
	default:
		theLocalizedDescription = [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode];
		break;
	}

NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionary];

if (self.URL)
	[theUserInfo setObject:self.URL forKey:NSURLErrorKey];

if (theLocalizedDescription != NULL)
	[theUserInfo setObject:theLocalizedDescription forKey:NSLocalizedDescriptionKey];
if (theRecoverySuggestion != NULL)
	[theUserInfo setObject:theRecoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];

NSError *theError = [NSError errorWithDomain:@"HTTP" code:self.statusCode userInfo:theUserInfo];
return(theError);
}

- (NSString *)debuggingDescription
{
NSMutableArray *theComponents = [NSMutableArray array];

[theComponents addObject:[NSString stringWithFormat:@"URL: %@", [self URL]]];
[theComponents addObject:[NSString stringWithFormat:@"MIMEType: %@", [self MIMEType]]];
[theComponents addObject:[NSString stringWithFormat:@"statusCode: %d", [self statusCode]]];
[theComponents addObject:[NSString stringWithFormat:@"Headers: %@", [self allHeaderFields]]];


NSString *theDescription = [theComponents componentsJoinedByString:@"\n"];
return(theDescription);
}

@end
