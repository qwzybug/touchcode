//
//  UIViewController_ErrorExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 3/2/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "UIViewController_ErrorExtensions.h"

@implementation UIViewController (UIViewController_ErrorExtensions)

- (void)presentError:(NSError *)inError
{
// Verifying error codes/msgs
//NSInteger code = [inError code];
//NSDictionary *ufdict = [inError userInfo];
//for (id key in ufdict) {
//    NSLog([NSString stringWithFormat:@"%@",key]);
//    NSString *value = (NSString *)[ufdict objectForKey:key];
//    NSLog([NSString stringWithFormat:@"%@",value]);
//}
NSString *theMessage = inError.localizedDescription;
if (theMessage == NULL)
	{
	theMessage = [NSString stringWithFormat:@"An error (domain: '%@', code: %d) has occured.", inError.domain, inError.code];
	}
NSString *theCancelButtonTitle = @"OK";

UIAlertView *theAlert = [[[UIAlertView alloc] initWithTitle:NULL message:theMessage delegate:NULL cancelButtonTitle:theCancelButtonTitle otherButtonTitles:NULL] autorelease];
[theAlert show];



}

@end
