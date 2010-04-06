//
//  CBlankViewController.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CBlankViewController.h"


@implementation CBlankViewController

@synthesize label;


- (id)initWithText:(NSString *)inText
{
if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
	{
	self.label.text = inText;
	}
return(self);
}


@end
