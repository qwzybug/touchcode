//
//  CUserDefaultsRunnerMainWindowController.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/11/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CUserDefaultsRunnerMainWindowController.h"

#import "CHTTPServer.h"
#import "CHTTPBasicAuthHandler.h"
#import "CUserDefaultsHTTPRouter.h"

@implementation CUserDefaultsRunnerMainWindowController

@dynamic authRealm;
@synthesize authUsername;
@synthesize authPassword;

@dynamic serving;
@synthesize server;
@synthesize authHandler;
@synthesize userDefaultsRouter;

@synthesize port;
@dynamic URL;

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)inKey
{
//if ([inKey isEqualToString:@"URL"])
//	return([NSSet setWithObjects:@"serving", NULL]);
//else
	return(NULL);
}

- (id)init
{	
if ((self = [super init]) != nil)
	{
	self.server = [[[CHTTPServer alloc] init] autorelease];
	[self.server createDefaultSocketListener];

	self.userDefaultsRouter = [[[CUserDefaultsHTTPRouter alloc] init] autorelease];

	CRoutingHTTPRequestHandler *theRequestHandler = [[[CRoutingHTTPRequestHandler alloc] init] autorelease];
	theRequestHandler.router = self.userDefaultsRouter;

	self.authHandler = [[[CHTTPBasicAuthHandler alloc] init] autorelease];
	self.authHandler.delegate = self;
	self.authHandler.childHandler = theRequestHandler;
	[self.server.defaultRequestHandlers addObject:self.authHandler];
	}
return(self);
}

- (void)dealloc
{
[self.server.socketListener stop];
//
self.server = NULL;
self.authHandler = NULL;
self.userDefaultsRouter = NULL;
self.authUsername = NULL;
self.authPassword = NULL;
//
[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)inNotification
{
}


- (NSString *)authRealm
{
return(self.authHandler.realm);
}

- (void)setAuthRealm:(NSString *)inAuthRealm
{
self.authHandler.realm = inAuthRealm;
}

- (BOOL)serving
{
return(self.server.socketListener.listening);
}

- (void)setServing:(BOOL)inServing
{
if (inServing != self.server.socketListener.listening)
	{
	if (inServing == NO)
		[self.server.socketListener stop];
	else
		{
		NSError *theError;
		[self.server.socketListener start:&theError];
		
		[self willChangeValueForKey:@"URL"];
		[self didChangeValueForKey:@"URL"];
		}
	}
}

- (NSURL *)URL
{
if (self.serving == NO)
	return(NULL);
	
NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d", [[NSHost currentHost] name], self.server.socketListener.port]];
return(theURL);
}

- (BOOL)HTTPAuthHandler:(CHTTPBasicAuthHandler *)inHandler shouldAuthenticateCredentials:(NSData *)inData
{
NSString *theAuthString = [NSString stringWithFormat:@"%@:%@", self.authUsername, self.authPassword];
NSData *theAuthData = [theAuthString dataUsingEncoding:NSUTF8StringEncoding];
return([theAuthData isEqual:inData]);
}

- (IBAction)actionURL:(id)inSender
{
[[NSWorkspace sharedWorkspace] openURL:self.URL];
}

@end
