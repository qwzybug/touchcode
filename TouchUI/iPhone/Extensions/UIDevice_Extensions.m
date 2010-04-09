//
//  UIDevice_Extensions.m
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/08/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "UIDevice_Extensions.h"

@implementation UIDevice (UIDevice_Extensions)

- (NSInteger)numericSystemVersion
{
static NSInteger sNumericSystemVersion = -1;
@synchronized(@"-[UIDevice numericSystemVersion]")
	{
	if (sNumericSystemVersion == -1)
		{
		NSString *theSystemVersion = self.systemVersion;
		NSScanner *theScanner = [NSScanner scannerWithString:theSystemVersion];
		[theScanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];

		NSInteger theMajorVersion, theMinorVersion;

		[theScanner scanInteger:&theMajorVersion];
		[theScanner scanString:@"." intoString:NULL];
		[theScanner scanInteger:&theMinorVersion];
		
		sNumericSystemVersion = theMajorVersion * 10000 + theMinorVersion * 100;
		}
	}
return(sNumericSystemVersion);
}

@end
