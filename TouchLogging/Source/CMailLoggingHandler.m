//
//  CMailLoggingHandler.m
//  Logging
//
//  Created by Jonathan Wight on 10/27/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CMailLoggingHandler.h"

#import <MessageUI/MessageUI.h>

#import "NSManagedObjectContext_Extensions.h"
#import "CJSONDataSerializer.h"
#import "NSDate_InternetDateExtensions.h"

@interface CMailLoggingHandler ()
@property (readwrite, nonatomic, retain) CLogging *logging;
@property (readwrite, nonatomic, retain) NSArray *sessions;
@end

#pragma mark -

@implementation CMailLoggingHandler

@synthesize viewController;
@synthesize recipients;
@synthesize subject;
@synthesize body;
@synthesize logging;
@synthesize sessions;

- (void)dealloc
{
[viewController release];
viewController = NULL;
[recipients release];
recipients = NULL;
[subject release];
subject = NULL;
[body release];
body = NULL;
[sessions release];
sessions = NULL;
//
[super dealloc];
}

#pragma mark -

- (BOOL)handleLogging:(CLogging *)inLogging event:(NSString *)inEvent error:(NSError **)outError;
{
NSError *theError = NULL;

NSMutableArray *theSessionsArray = [NSMutableArray array];

NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"self != %@", inLogging.session];

NSArray *theSessions = [inLogging.coreDataManager.managedObjectContext fetchObjectsOfEntityForName:@"LoggingSession" predicate:thePredicate error:&theError];

for (NSManagedObject *theSession in theSessions)
	{
	NSMutableDictionary *theSessionDictionary = [NSMutableDictionary dictionary];
	[theSessionDictionary setObject:[[theSession valueForKey:@"created"] ISO8601MinimalString] forKey:@"created"];
	
	NSMutableArray *theMessagesArray = [NSMutableArray array];
	
	thePredicate = [NSPredicate predicateWithFormat:@"session == %@", theSession];

	NSArray *theMessages = [inLogging.coreDataManager.managedObjectContext fetchObjectsOfEntityForName:@"LoggingMessage" predicate:thePredicate error:&theError];
	for (NSManagedObject *theMessage in theMessages)
		{
		NSMutableDictionary *theMessageDictionary = [NSMutableDictionary dictionary];
		if ([theMessage valueForKey:@"extraAttributes"] != NULL)
			[theMessageDictionary setObject:[theMessage valueForKey:@"extraAttributes"] forKey:@"extraAttributes"];
		if ([theMessage valueForKey:@"facility"] != NULL)
			[theMessageDictionary setObject:[theMessage valueForKey:@"facility"] forKey:@"facility"];
		if ([theMessage valueForKey:@"level"] != NULL)
			[theMessageDictionary setObject:[theMessage valueForKey:@"level"] forKey:@"level"];
		if ([theMessage valueForKey:@"message"] != NULL)
			[theMessageDictionary setObject:[theMessage valueForKey:@"message"] forKey:@"message"];
		if ([theMessage valueForKey:@"sender"] != NULL)
			[theMessageDictionary setObject:[theMessage valueForKey:@"sender"] forKey:@"sender"];
		if ([theMessage valueForKey:@"timestamp"] != NULL)
			[theMessageDictionary setObject:[[theMessage valueForKey:@"timestamp"] ISO8601MinimalString] forKey:@"timestamp"];
		
		[theMessagesArray addObject:theMessageDictionary];
		}

	[theSessionDictionary setObject:theMessagesArray forKey:@"messages"];

	[theSessionsArray addObject:theSessionDictionary];
	}
	
self.logging = inLogging;
self.sessions = theSessions;

NSData *theJSON = [[CJSONDataSerializer serializer] serializeObject:theSessionsArray];

MFMailComposeViewController *theController = [[[MFMailComposeViewController alloc] init] autorelease];
theController.mailComposeDelegate = self;
[theController setToRecipients:self.recipients];
[theController setSubject:self.subject];
[theController setMessageBody:self.body isHTML:NO];
[theController addAttachmentData:theJSON mimeType:@"application/json" fileName:@"Log.json"];

[self.viewController presentModalViewController:theController animated:YES];

return(YES);
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
if (result == MFMailComposeResultSaved || result == MFMailComposeResultSent)
	{
	for (NSManagedObject *theSession in self.sessions)
		{
		[self.logging.coreDataManager.managedObjectContext deleteObject:theSession];
		}
	[self.logging.coreDataManager save];
	}

self.logging = NULL;
self.sessions = NULL;

[self.viewController dismissModalViewControllerAnimated:YES];
NSLog(@"%d", result);
}

@end