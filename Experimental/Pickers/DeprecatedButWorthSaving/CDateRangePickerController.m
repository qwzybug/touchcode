//
//  CDateRangePickerController.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/07/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
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

#import "CDateRangePickerController.h"

#import "NSDate_Extensions.h"

@interface CDateRangePickerController ()
@property (readwrite, nonatomic, retain) UITableView *tableView;
@property (readwrite, nonatomic, retain) UIDatePicker *datePicker;
@property (readwrite, nonatomic, retain) UIPickerView *durationPicker;
@end

#pragma mark -

@implementation CDateRangePickerController

@synthesize tableView = outletTableView;
@synthesize datePicker = outletDatePicker;
@synthesize durationPicker = outletDurationPicker;

@synthesize picker;

@synthesize starts;
@synthesize ends;
@synthesize minimumDuration;

- (id)initWithPicker:(CPicker *)inPicker;
{
if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
	{
	self.picker = inPicker;
	}
return(self);
}

- (void)dealloc
{
self.tableView = NULL;
self.datePicker = NULL;
self.durationPicker = NULL;
	
self.picker = NULL;
//
self.starts = NULL;
self.ends = NULL;
//
[super dealloc];
}

#pragma mark -

- (id)value
{
NSAssert(self.starts != NULL, @"start date is null");
NSAssert(self.ends != NULL, @"end date is null");
return([NSDictionary dictionaryWithObjectsAndKeys:
	self.starts, @"starts",
	self.ends, @"ends",
	NULL]);
}

- (void)setValue:(id)inValue
{
self.starts = [inValue objectForKey:@"starts"];
self.ends = [inValue objectForKey:@"ends"];
}

#pragma mark -

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)viewDidAppear:(BOOL)inAnimated
{
[super viewDidAppear:inAnimated];
//
[self reset];
}

- (void)reset
{
// TODO move to CPicker
if (self.picker.initialValue)
	self.picker.value = self.picker.initialValue;

[self.tableView reloadData];

[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
self.datePicker.minimumDate = [[NSDate date] roundedDownToClosestHalfHour];
self.datePicker.date = self.starts;
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
return(2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
if (theCell == NULL)
	{
	theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
	theCell.accessoryType = UITableViewCellAccessoryNone;
	theCell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}

if (indexPath.row == 0)
	{
	theCell.textLabel.text = @"Starts";
	
	NSDateFormatter *theDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	theDateFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
	theDateFormatter.dateFormat = @"EEE MMM d, yyyy h:mm a";
	
	theCell.detailTextLabel.text = [theDateFormatter stringFromDate:self.starts];
	}
else if (indexPath.row == 1)
	{
	theCell.textLabel.text = @"Ends";

	NSDateFormatter *theDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	theDateFormatter.formatterBehavior = NSDateFormatterBehavior10_4;

	if ([self.starts isSameCalendarDayAsDate:self.ends])
		theDateFormatter.dateFormat = @"h:mm a";
	else
		theDateFormatter.dateFormat = @"EEE MMM d, yyyy h:mm a";
	
	theCell.detailTextLabel.text = [theDateFormatter stringFromDate:self.ends];
	}

return(theCell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
if (indexPath.row == 0)
	{
    self.datePicker.minimumDate = [[NSDate date] roundedDownToClosestHalfHour];
	if (self.starts)
		[self.datePicker setDate:self.starts animated:YES];
	}
else if (indexPath.row == 1)
	{
	self.datePicker.minimumDate = [self.starts addTimeInterval:60*60];
	if (self.ends)
		[self.datePicker setDate:self.ends animated:YES];
	}
}

#pragma mark -

- (IBAction)actionDateChanged:(id)inSender;
{
if (self.tableView.indexPathForSelectedRow.row == 0)
	{
	if ([self.starts isEqualToDate:self.datePicker.date] == NO)
		{
		self.starts = self.datePicker.date;
		[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
		
		if ([self.ends compare:[self.starts addTimeInterval:self.minimumDuration]] == NSOrderedAscending)
			{
			self.ends = [self.starts addTimeInterval:self.minimumDuration];
			}

		[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
		}
	}
else if (self.tableView.indexPathForSelectedRow.row == 1)
	{
	if ([self.ends isEqualToDate:self.datePicker.date] == NO)
		{
		self.ends = self.datePicker.date;

		[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
		}
	}
}

@end
