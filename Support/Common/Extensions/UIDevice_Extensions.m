//
//  UIDevice_Extensions.m
//
//  Created by brandon on 6/3/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import "UIDevice_Extensions.h"


@implementation UIDevice(Extensions)

- (BOOL)canDial
{
	NSString *model = [self model];
	if ([model isEqualToString:@"iPhone"] || [model isEqualToString:@"iPhone Simulator"])
		return YES;
	return NO;
}

@end

