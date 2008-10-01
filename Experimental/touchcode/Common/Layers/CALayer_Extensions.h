//
//  CALayer_Extensions.h
//  TouchCode
//
//  Created by Jonathan Wight on 04/24/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (CALayer_Extensions)

- (id)initWithFrame:(CGRect)inFrame;

@property (readwrite, copy) NSString *name;

@property (readwrite, assign) CGFloat zoom;

- (void)setZoom:(CGFloat)inZoom centeringAtPoint:(CGPoint)inPoint;

- (CAScrollLayer *)scrollLayer;

@end
