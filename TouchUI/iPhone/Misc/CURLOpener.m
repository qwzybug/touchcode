//
//  CURLOpener.m
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/07/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CURLOpener.h"

#import <MessageUI/MessageUI.h>

static CURLOpener *gInstance = NULL;

@interface CURLOpener ()
@property (readwrite, nonatomic, retain) NSArray *selectors;

- (void)addButtonsForURL:(NSURL *)inURL;
@end

#pragma mark -

@implementation CURLOpener

@synthesize parentViewController;
@synthesize URL;
@synthesize selectors;

- (id)initWithParentViewController:(UIViewController *)inViewController URL:(NSURL *)inURL
{
if ((self = [super initWithTitle:NULL delegate:self cancelButtonTitle:NULL destructiveButtonTitle:NULL otherButtonTitles:NULL]) != NULL)
	{
	parentViewController = inViewController;
	URL = [inURL retain];


	[self addButtonsForURL:inURL];

	[self addButtonWithTitle:@"Cancel"];
	self.cancelButtonIndex = self.numberOfButtons - 1;
	
	if (gInstance)
		{
		[gInstance release];
		gInstance = NULL;
		}

	gInstance = [self retain];
	}
return(self);
}

- (void)addButtonsForURL:(NSURL *)inURL
{
NSMutableArray *theSelectors = [NSMutableArray array];

if (YES)
	{
	[self addButtonWithTitle:@"Open in Safari"];
	[theSelectors addObject:NSStringFromSelector(@selector(openURL:))];
	}

if (YES)
	{
	[self addButtonWithTitle:@"E-mail Link"];
	[theSelectors addObject:NSStringFromSelector(@selector(mailURL:))];
	}

self.selectors = theSelectors;
}

#pragma mark -

- (void)openURL:(NSURL *)inURL
{
[[UIApplication sharedApplication] openURL:inURL];
}

- (void)mailURL:(NSURL *)inURL
{
MFMailComposeViewController *theViewController = [[[MFMailComposeViewController alloc] init] autorelease];
theViewController.mailComposeDelegate = self;
[theViewController setMessageBody:[inURL absoluteString] isHTML:NO];

[self.parentViewController presentModalViewController:theViewController animated:YES];
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
if (buttonIndex < self.selectors.count)
	{
	NSString *theSelectorName = [self.selectors objectAtIndex:buttonIndex];
	SEL theSelector = NSSelectorFromString(theSelectorName);
	[self performSelector:theSelector withObject:self.URL];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
