//
//  CAScrollLayer_Extensions.h
//  Test
//
//  Created by Jonathan Wight on 04/14/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAScrollLayer (CAScrollLayer_Extensions)

- (void)scrollBy:(CGPoint)inDelta;
- (void)scrollCenterToPoint:(CGPoint)inPoint;

@end
