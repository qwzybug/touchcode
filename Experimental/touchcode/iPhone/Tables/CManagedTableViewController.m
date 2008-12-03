//
//  CManagedTableViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CManagedTableViewController.h"

#import "CTableSection.h"
#import "CTableRow.h"

@implementation CManagedTableViewController

@dynamic sections;
@synthesize target;

- (void)dealloc
{
[sections release];
sections = NULL;
self.target = NULL;

[super dealloc];
}

#pragma mark -

- (NSMutableArray *)sections
{
if (sections == NULL)
	{
	sections = [[NSMutableArray alloc] init];
	
	[self addSection];
	}
return(sections);
}

#pragma mark -

- (CTableSection *)addSection;
{
CTableSection *theSection = [[[CTableSection alloc] initWithTable:self.tableView] autorelease];
[self addSection:theSection];
return(theSection);
}

- (CTableSection *)addSection:(CTableSection *)inSection
{
[self.sections addObject:inSection];
return(inSection);
}

- (void)addRow:(CTableRow *)inRow
{
if (self.sections.count == 0)
	[self addSection];

CTableSection *theTableSection = self.sections.lastObject;
	
inRow.section = theTableSection;
[theTableSection.rows addObject:inRow];
}

- (CTableRow *)rowWithTag:(NSString *)inTag
{
for (CTableSection *theSection in self.sections)
	{
	for (CTableRow *theRow in theSection.rows)
		{
		if ([theRow.tag isEqualToString:inTag])
			return(theRow);
		}
	}
return(NULL);
}

- (CTableRow *)rowWithIndexPath:(NSIndexPath *)inIndexPath
{
CTableSection *theSection = [self.sections objectAtIndex:inIndexPath.section];
CTableRow *theRow = [theSection.visibleRows objectAtIndex:inIndexPath.row];
return(theRow);
}

- (CTableSection *)sectionWithIndexPath:(NSIndexPath *)inIndexPath;
{
CTableSection *theSection = [self.sections objectAtIndex:inIndexPath.section];
return(theSection);
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView
{
return(MAX(self.sections.count, 1));
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection
{
CTableSection *theSection = [self.sections objectAtIndex:inSection];
return(theSection.visibleRows.count);
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath
{
CTableRow *theRow = [self rowWithIndexPath:inIndexPath];
UITableViewCell *theRowCell = theRow.cell;
return(theRowCell);
}

- (NSString *)tableView:(UITableView *)inTableView titleForHeaderInSection:(NSInteger)inSection
{
CTableSection *theSection = [self.sections objectAtIndex:inSection];
return(theSection.headerTitle);
}

- (CGFloat)tableView:(UITableView *)inTableView heightForHeaderInSection:(NSInteger)inSection
{
CTableSection *theSection = [self.sections objectAtIndex:inSection];
if (theSection.headerView)
	return(theSection.headerView.frame.size.height);
else
	return(24.0f);
}

- (CGFloat)tableView:(UITableView *)inTableView heightForFooterInSection:(NSInteger)inSection
{
CTableSection *theSection = [self.sections objectAtIndex:inSection];
if (theSection.footerView)
	return(theSection.footerView.frame.size.height);
else
	return(24.0f);
}

- (UIView *)tableView:(UITableView *)inTableView viewForHeaderInSection:(NSInteger)inSection
{
CTableSection *theSection = [self.sections objectAtIndex:inSection];
return(theSection.headerView);
}

- (UIView *)tableView:(UITableView *)inTableView viewForFooterInSection:(NSInteger)inSection
{
CTableSection *theSection = [self.sections objectAtIndex:inSection];
return(theSection.footerView);
}

- (CGFloat)tableView:(UITableView *)inTableView heightForRowAtIndexPath:(NSIndexPath *)inIndexPath
{
return([[self tableView:inTableView cellForRowAtIndexPath:inIndexPath] bounds].size.height);
}

- (NSIndexPath *)tableView:(UITableView *)inTableView willSelectRowAtIndexPath:(NSIndexPath *)inIndexPath
{
CTableSection *theSection = [self.sections objectAtIndex:inIndexPath.section];
CTableRow *theRow = [theSection.rows objectAtIndex:inIndexPath.row];
if (theRow.selectable == YES)
	return(inIndexPath);
else
	return(NULL);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
if (self.target)
	{
	CTableSection *theSection = [self.sections objectAtIndex:indexPath.section];
	CTableRow *theRow = [theSection.rows objectAtIndex:indexPath.row];
	if (theRow.selectionAction && [self.target respondsToSelector:theRow.selectionAction])
		{
		[self.target performSelector:theRow.selectionAction withObject:theRow];
		}
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
CTableRow *theRow = [self rowWithIndexPath:indexPath];
return(theRow.editable);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
CTableRow *theRow = [self rowWithIndexPath:indexPath];
return(theRow.editingStyle);
}


@end
