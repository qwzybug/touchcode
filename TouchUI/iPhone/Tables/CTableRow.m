//
//  CTableRow.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/26/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CTableRow.h"

#import "CTableSection.h"
#import "CLabelledTextFieldCell.h"

@implementation CTableRow

@synthesize section;
@synthesize tag;
@dynamic cell;
@synthesize hidden;
@synthesize selectable;
@synthesize selectionAction;
@synthesize editable;
@synthesize height;
@synthesize editingStyle;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.hidden = NO;
	self.selectable = YES;
	self.editable = NO;
	self.editingStyle = UITableViewCellEditingStyleNone;
	}
return(self);
}

- (id)initWithTag:(NSString *)inTag
{
if ((self = [self init]) != NULL)
	{
	self.tag = inTag;
	}
return(self);
}

- (id)initWithTag:(NSString *)inTag cell:(UITableViewCell *)inCell
{
if ((self = [self initWithTag:inTag]) != NULL)
	{
	self.cell = inCell;
	}
return(self);
}

- (void)dealloc
{
self.tag = NULL;
self.section = NULL;
self.cell = NULL;
//
[super dealloc];
}

#pragma mark -

- (UITableViewCell *)cell
{
if (cell == NULL)
	{
	UITableViewCell *theCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
	cell = [theCell retain];
	}
return(cell);
}

- (void)setCell:(UITableViewCell *)inCell
{
if (cell != inCell)
	{
	[cell autorelease];
	cell = [inCell retain];
    }
}

@end

#pragma mark -

@implementation CTableRow (CTableRow_ConvenienceExtensions)

- (id)initWithTag:(NSString *)inTag title:(NSString *)inTitle
{
return([self initWithTag:inTag title:inTitle value:NULL accessoryType:UITableViewCellAccessoryNone]);
}

- (id)initWithTag:(NSString *)inTag title:(NSString *)inTitle value:(NSString *)inValue
{
return([self initWithTag:inTag title:inTitle value:inValue accessoryType:UITableViewCellAccessoryNone]);
}

- (id)initWithTag:(NSString *)inTag title:(NSString *)inTitle value:(NSString *)inValue accessoryType:(UITableViewCellAccessoryType)inAccessoryType
{
UITableViewCell *theCell = NULL;
if (inValue == NULL)
	{
	const CGRect theDefaultCellBounds = { .origin = CGPointZero, .size = { .width = 300.0f, .height = 44 } };
	theCell = [[[UITableViewCell alloc] initWithFrame:theDefaultCellBounds] autorelease];
	}
else
	{
	CLabelledTextFieldCell *theLabelledValueTableViewCell = [CLabelledTextFieldCell cell];
	theLabelledValueTableViewCell.valueView.text = inValue;
	theCell = theLabelledValueTableViewCell;
	}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_0
theCell.textLabel.text = inTitle;
#else
theCell.text = inTitle;
#endif

theCell.accessoryType = inAccessoryType;

return([self initWithTag:inTag cell:theCell]);
}

- (id)initWithTag:(NSString *)inTag title:(NSString *)inTitle buttonImage:(UIImage *)inImage target:(id)inTarget action:(SEL)inAction;
{
const CGRect theDefaultCellBounds = { .origin = CGPointZero, .size = { .width = 300.0f, .height = 44 } };

UIButton *theButton = [UIButton buttonWithType:UIButtonTypeCustom];
theButton.frame = theDefaultCellBounds;
[theButton setTitle:inTitle forState:UIControlStateNormal];
[theButton setBackgroundImage:inImage forState:UIControlStateNormal];
[theButton addTarget:inTarget action:inAction forControlEvents:UIControlEventTouchDown];
[theButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_0
theButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
#else
[theButton setFont:[UIFont boldSystemFontOfSize:[UIFont buttonFontSize]]];
#endif

UITableViewCell *theCell = [[[UITableViewCell alloc] initWithFrame:theDefaultCellBounds] autorelease];
[theCell.contentView addSubview:theButton];

theCell.backgroundView = [[[UIView alloc] initWithFrame:theButton.frame] autorelease];

return([self initWithTag:inTag cell:theCell]);
}

#pragma mark -

- (CGRect)frameForCellContentView
{
CGRect theCellBounds = self.cell.bounds;
theCellBounds = CGRectInset(theCellBounds, 18, 6);
return(theCellBounds);
}

@end
