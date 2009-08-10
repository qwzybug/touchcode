//
//  UIViewController_ErrorExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 3/2/09.
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

#import "UIViewController_ErrorExtensions.h"

@implementation UIViewController (UIViewController_ErrorExtensions)

- (void)presentError:(NSError *)inError
{
// Verifying error codes/msgs
//NSInteger code = [inError code];
//NSDictionary *ufdict = [inError userInfo];
//for (id key in ufdict) {

//    NSString *value = (NSString *)[ufdict objectForKey:key];

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
