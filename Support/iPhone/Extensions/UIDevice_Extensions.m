//
//  UIDevice_Extensions.m
//  Touchcode
//
//  Created by brandon on 6/3/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import "UIDevice_Extensions.h"


@implementation UIDevice(Extensions)

- (BOOL)canDial
{
	const BOOL kSimulatorCanDial = YES;

	NSString *model = [self model];
	if ([model isEqualToString:@"iPhone Simulator"])
		return(kSimulatorCanDial);
	else if ([[model substringToIndex:6] isEqualToString:@"iPhone"])
		return(YES);
	else
		return(NO);
}

@end

