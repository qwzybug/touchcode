//
//  UIView_Extensions.m
//  PlateView
//
//  Created by Jonathan Wight on 1/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "UIView_Extensions.h"

@implementation UIView (UIView_Extensions)

- (void)setClipsToBoundsRecursively:(BOOL)clips;
{
UIView *currentView = self;    
do {
	currentView.clipsToBounds = clips;
    }
while ((currentView = [currentView superview]));
}

- (void)dump:(NSInteger)inDepth
{
char theSpaces[] = "..........";

printf("%.*s%s %s (bgColor:%s, hidden:%d, opaque:%d, alpha:%g, clipsToBounds:%d)\n", MIN(inDepth, strlen(theSpaces)), theSpaces, [[self description] UTF8String], [NSStringFromCGRect(self.frame) UTF8String], [[self.backgroundColor description] UTF8String], self.hidden, self.opaque, self.alpha, self.clipsToBounds);
for (UIView *theView in self.subviews)
	{
	[theView dump:inDepth + 1];
	}
}

@end
