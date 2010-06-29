//
//  CMailLoggingHandler.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/27/09.
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

#import "CMailLoggingHandler.h"

#import <MessageUI/MessageUI.h>

#import "CBetterCoreDataManager.h"
#import "NSManagedObjectContext_Extensions.h"
#import "CJSONDataSerializer.h"
#import "NSDate_InternetDateExtensions.h"

@interface CMailLoggingHandler ()
@property (readwrite, nonatomic, retain) CLogging *logging;
@property (readwrite, nonatomic, retain) NSArray *sessions;

- (void)doIt;
@end

#pragma mark -

@implementation CMailLoggingHandler

@synthesize predicate;
@synthesize viewController;
@synthesize recipients;
@synthesize subject;
@synthesize body;
@synthesize logging;
@synthesize sessions;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	predicate = [[NSPredicate predicateWithFormat:@"messages.level.@min <= %@", [NSNumber numberWithInteger:LoggingLevel_ERR]] retain];
	}
return(self);
}

- (void)dealloc
{
[predicate release];
predicate = NULL;
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

NSPredicate *thePredicate = NULL;


NSDate *theLastLogAlertWhen = [[NSUserDefaults standardUserDefaults] objectForKey:@"CoreLogging_LastMailLogsAlertWhen"];

NSPredicate *theNonCurrentSessionPredicate = NULL;
if (theLastLogAlertWhen == NULL)
	theNonCurrentSessionPredicate = [NSPredicate predicateWithFormat:@"self != %@", inLogging.session];
else
	theNonCurrentSessionPredicate = [NSPredicate predicateWithFormat:@"self != %@ AND created > %@", inLogging.session, theLastLogAlertWhen];

if (self.predicate == NULL)
	{
	thePredicate = theNonCurrentSessionPredicate;
	}
else
	{
	thePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:theNonCurrentSessionPredicate, self.predicate, NULL]];
	}

NSArray *theSessions = [inLogging.coreDataManager.managedObjectContext fetchObjectsOfEntityForName:@"LoggingSession" predicate:thePredicate error:&theError];

if ([theSessions count] == 0)
	return(YES);

self.logging = inLogging;
self.sessions = [theSessions valueForKey:@"objectID"];

[self doIt];

return(YES);
}

- (void)doIt
{
if ([NSThread isMainThread] == NO)
	{
	[self performSelectorOnMainThread:@selector(doIt:) withObject:NULL waitUntilDone:YES];
	return;
	}
	
[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"CoreLogging_LastMailLogsAlertWhen"];
[[NSUserDefaults standardUserDefaults] synchronize];

UIAlertView *theAlert = [[[UIAlertView alloc] initWithTitle:NULL message:@"Do you want to email a log file containing debugging information to the developer of this software?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", NULL] autorelease];
[theAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
NSManagedObjectContext *theManagedObjectContext = self.logging.coreDataManager.managedObjectContext;

if (buttonIndex == 1)
	{
	NSMutableArray *theSessionsArray = [NSMutableArray array];

	for (NSManagedObjectID *theSessionID in self.sessions)
		{
		NSError *theError = NULL;
		NSManagedObject *theSession = [theManagedObjectContext existingObjectWithID:theSessionID error:&theError];
		if (theSession == NULL || theError != NULL)
			{
			return;
			}
		
		NSMutableDictionary *theSessionDictionary = [NSMutableDictionary dictionary];
		[theSessionDictionary setObject:[[theSession valueForKey:@"created"] ISO8601MinimalString] forKey:@"created"];
		
		NSMutableArray *theMessagesArray = [NSMutableArray array];
		
		NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"session == %@", theSession];

		NSArray *theMessages = [theManagedObjectContext fetchObjectsOfEntityForName:@"LoggingMessage" predicate:thePredicate error:&theError];
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
		
	NSData *theJSON = [[CJSONDataSerializer serializer] serializeObject:theSessionsArray];

	MFMailComposeViewController *theController = [[[MFMailComposeViewController alloc] init] autorelease];
	theController.mailComposeDelegate = self;
	[theController setToRecipients:self.recipients];
	[theController setSubject:self.subject];
	[theController setMessageBody:self.body isHTML:NO];
	[theController addAttachmentData:theJSON mimeType:@"application/json" fileName:@"Log.json"];

	[self.viewController presentModalViewController:theController animated:YES];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
if (result == MFMailComposeResultSaved || result == MFMailComposeResultSent)
	{
	NSManagedObjectContext *theManagedObjectContext = self.logging.coreDataManager.managedObjectContext;

	for (NSManagedObjectID *theSessionID in self.sessions)
		{
		NSError *theError = NULL;
		NSManagedObject *theSession = [theManagedObjectContext existingObjectWithID:theSessionID error:&theError];
		if (theSession == NULL || theError != NULL)
			{
			return;
			}
		[self.logging.coreDataManager.managedObjectContext deleteObject:theSession];
		}
	[self.logging.coreDataManager save];
	}

self.logging = NULL;
self.sessions = NULL;

[self.viewController dismissModalViewControllerAnimated:YES];
}

@end
