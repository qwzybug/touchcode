//
//  UIColor_Extensions.m
//  PlateView
//
//  Created by Jonathan Wight on 1/12/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "UIColor_Extensions.h"


@implementation UIColor (UIColor_Extensions)

+ (UIColor *)colorWithString:(NSString *)inString
{
NSArray *theComponents = [inString componentsSeparatedByString:@" "];
if (theComponents.count != 4)
	return(NULL);

CGFloat theRed = [[theComponents objectAtIndex:0] doubleValue];
CGFloat theGreen = [[theComponents objectAtIndex:1] doubleValue];
CGFloat theBlue = [[theComponents objectAtIndex:2] doubleValue];
CGFloat theAlpha = [[theComponents objectAtIndex:3] doubleValue];

UIColor *theColor = [self colorWithRed:theRed green:theGreen blue:theBlue alpha:theAlpha];
return(theColor);
}



@end
