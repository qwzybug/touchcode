//
//  UIImage_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 1/27/09.
//  Copyright 2009 TouchCode. All rights reserved.
//

#import "UIImage_Extensions.h"


@implementation UIImage (UIImage_Extensions)

+ (UIImage *)imageWithContentsOfURL:(NSURL *)inURL
{
NSData *theData = [NSData dataWithContentsOfURL:inURL options:0 error:NULL];
return([self imageWithData:theData]);
}

@end
