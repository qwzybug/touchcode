//
//  CLinkActionSheet.m
//  TouchCode
//
//  Created by Jonathan Wight on 2/7/09.
//  Copyright 2009 TouchCode. All rights reserved.
//

#import "CLinkActionSheet.h"

@implementation CLinkActionSheet

@synthesize URL;

- (id)initWithLink:(NSURL *)inURL
{
return([self initWithLink:inURL defaultApplicationName:NULL]);
}

- (id)initWithLink:(NSURL *)inURL defaultApplicationName:(NSString *)inDefaultApplicationName
{
NSString *theButtonTitle = NULL;

if (inDefaultApplicationName == NULL)
	{
	if ([inURL.scheme isEqualToString:@"http"] || [inURL.scheme isEqualToString:@"http"])
		{
		inDefaultApplicationName = @"Safari";
		}
	else if ([inURL.scheme isEqualToString:@"mailto"])
		{
		inDefaultApplicationName = @"Mail";
		}
	}

if (inDefaultApplicationName != NULL)
	theButtonTitle = [NSString stringWithFormat:@"Open in %@", inDefaultApplicationName];
else
	theButtonTitle = @"Open external link.";

if ((self = [super initWithTitle:NULL delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NULL otherButtonTitles:theButtonTitle, NULL]) != NULL)
	{
	self.URL = inURL;
	}
return(self);
}

- (void)dealloc
{
self.URL = NULL;
//
[super dealloc];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
if (buttonIndex == 0)
	{
	NSLog(@"Opening: %@", self.URL);
	BOOL theResult = [[UIApplication sharedApplication] openURL:self.URL];
	if (theResult == NO)
		{
		#if defined(TARGET_IPHONE_SIMULATOR) && TARGET_IPHONE_SIMULATOR == 1
		if ([self.URL.scheme isEqualToString:@"mailto"])
			{
			UIAlertView *theAlertView = [[[UIAlertView alloc] initWithTitle:@"OOPS" message:@"The simulator doesn't support mailto: URLs. But thanks for trying." delegate:NULL cancelButtonTitle:@"Darn" otherButtonTitles:NULL] autorelease];
			[theAlertView show];
			}
		#else
			NSString *theMessage = [NSString stringWithFormat:@"Could not open URL with '%@' scheme.", self.URL.scheme];
			UIAlertView *theAlertView = [[[UIAlertView alloc] initWithTitle:NULL message:theMessage delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:NULL] autorelease];
			[theAlertView show];
		#endif
		}
	}
}

@end
