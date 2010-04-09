//
//  CDistancePickerController.m
//  touchcode
//
//  Created by Jonathan Wight on 05/07/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CValuesPickerController.h"

@interface CValuesPickerController ()
@end

#pragma mark -

@implementation CValuesPickerController

@synthesize selectedValueIndex;
@synthesize values;
@synthesize textLabelKeyPath;
@synthesize textLabelTransformer;
@synthesize imageViewKeyPath;
@synthesize initialValue;
@synthesize value;
@synthesize validator;
@synthesize pickerDelegate;
@synthesize userInfo;

- (id)init
{
if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
	{
	self.selectedValueIndex = NSNotFound;
	self.values = NULL;
	self.textLabelKeyPath = NULL;
	self.textLabelTransformer = NULL;
	self.imageViewKeyPath = NULL;
	self.initialValue = NULL;
	self.value = NULL;
	self.pickerDelegate = NULL;
	self.userInfo = NULL;
	}
return(self);
}

- (void)dealloc
{
self.values = NULL;
self.textLabelKeyPath = NULL;
self.textLabelTransformer = NULL;
self.imageViewKeyPath = NULL;
self.initialValue = NULL;
self.value = NULL;
self.pickerDelegate = NULL;
self.userInfo = NULL;
//
[super dealloc];
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)] autorelease];
self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)] autorelease];
//
self.value = self.initialValue;
self.selectedValueIndex = [self.values indexOfObject:self.value];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
return(self.values.count);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
self.selectedValueIndex = indexPath.row;
self.value = [self.values objectAtIndex:self.selectedValueIndex];
[self.tableView reloadData];
[self performSelector:@selector(unselectRow:) withObject:indexPath afterDelay:0.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
if (theCell == NULL)
	{
	theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	}
	
id theValue = [self.values objectAtIndex:indexPath.row];

NSString *theTextLabelValue = theValue;
if (self.textLabelKeyPath)
	theTextLabelValue = [theValue valueForKeyPath:self.textLabelKeyPath];
	
if (self.textLabelTransformer)
	theTextLabelValue = [self.textLabelTransformer transformedValue:theValue];

theCell.textLabel.text = theTextLabelValue;

if (self.imageViewKeyPath)
	{
	theCell.imageView.image = [theValue valueForKeyPath:self.imageViewKeyPath];
	}

 if (indexPath.row == self.selectedValueIndex)
 	{
 	theCell.textLabel.textColor = [UIColor colorWithRed:0.31f green:0.408f blue:0.584f alpha:1.0f];
	theCell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
else
	{
	theCell.textLabel.textColor = [UIColor darkTextColor];
	theCell.accessoryType = UITableViewCellAccessoryNone;
	}
return(theCell);
}

- (void)actionCancel:(id)inSender
{
if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerControllerDidCancel:)])
	[self.pickerDelegate pickerControllerDidCancel:self];

[self.navigationController popViewControllerAnimated:YES];
}

- (void)actionDone:(id)inSender
{
if (self.selectedValueIndex != NSNotFound)
	{
	if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerController:didFinishWithValue:)])
		[self.pickerDelegate pickerController:self didFinishWithValue:[self.values objectAtIndex:self.selectedValueIndex]];
	}
else
	{
	if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerControllerDidCancel:)])
		[self.pickerDelegate pickerControllerDidCancel:self];
	}

[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)unselectRow:(NSIndexPath *)inIndexPath
{
[self.tableView deselectRowAtIndexPath:inIndexPath animated:YES];
}

@end
