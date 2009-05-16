//
//  CCrossSwitch.m
//  TouchWar
//
//  Created by Jonathan Wight on 04/25/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CCrossSwitch.h"

#import <QuartzCore/QuartzCore.h>

#import "Geometry.h"

@interface CCrossSwitch()
@property(readwrite,nonatomic, retain) CALayer *imageLayer;
@end

@implementation CCrossSwitch

@dynamic on;
@synthesize imageLayer;

- (id)initWithCoder:(NSCoder *)inCoder
{
if ((self = [super initWithCoder:inCoder]) != nil)
	{
	self.userInteractionEnabled = YES;
	
	self.imageLayer = [[[CALayer alloc] initWithFrame:self.bounds] autorelease];
	self.imageLayer.contents = (id)[UIImage imageNamed:@"CrossSwitchButton.png"].CGImage;
	if (on == YES)
		{
		CATransform3D theTransform = CATransform3DIdentity;
		theTransform = CATransform3DRotate(theTransform, DegreesToRadians(45), 0.0, 0.0, 1.0);
		self.imageLayer.transform = theTransform;
		}
	else
		{
		self.imageLayer.transform = CATransform3DIdentity;
		}
	
	[self.layer addSublayer:self.imageLayer];
	}
return(self);
}

- (void)dealloc
{
self.imageLayer = NULL;
//
[super dealloc];
}

- (BOOL)isOn
{
return(on);
}

- (void)setOn:(BOOL)inOn
{
[self setOn:inOn animated:YES];
}

- (void)setOn:(BOOL)inOn animated:(BOOL)inAnimated; // does not send action
{
if (on != inOn)
	{
	on = inOn;

	if (on == YES)
		{
		CATransform3D theTransform = CATransform3DIdentity;
		theTransform = CATransform3DRotate(theTransform, DegreesToRadians(45), 0.0, 0.0, 1.0);
		self.imageLayer.transform = theTransform;
		}
	else
		{
		self.imageLayer.transform = CATransform3DIdentity;
		}
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

- (void)touchesBegan:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
self.on = !self.on;
}

- (void)touchesMoved:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
}

- (void)touchesEnded:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
}


@synthesize imageLayer;
@end
