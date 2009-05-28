//
//  CManagedTableViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/25/08.
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
	}
return(sections);
}

#pragma mark -

- (CTableSection *)addSection;
{
CTableSection *theSection = [[[CTableSection alloc] initWithTag:NULL] autorelease];
[self addSection:theSection];
return(theSection);
}

- (CTableSection *)addSection:(CTableSection *)inSection
{
inSection.table = self.tableView;
[self.sections addObject:inSection];
return(inSection);
}

- (void) removeSection:(CTableSection *)inSection
{
[self.sections removeObject:inSection];
}

- (CTableRow *)addRow:(CTableRow *)inRow
{
if (self.sections.count == 0)
	[self addSection];

CTableSection *theTableSection = self.sections.lastObject;

inRow.section = theTableSection;
[theTableSection.rows addObject:inRow];

return(inRow);
}

#pragma mark -

- (CTableSection *)sectionWithTag:(NSString *)inTag
{
for (CTableSection *theSection in self.sections)
	{
	if ([theSection.tag isEqualToString:inTag])
		return(theSection);
	}
return(NULL);
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
if (theSection.rows == NULL)
	return(NULL);
CTableRow *theRow = NULL;
if (inIndexPath.row < theSection.visibleRows.count)
	theRow = [theSection.visibleRows objectAtIndex:inIndexPath.row];
return(theRow);
}

- (CTableSection *)sectionWithIndexPath:(NSIndexPath *)inIndexPath;
{
CTableSection *theSection = [self.sections objectAtIndex:inIndexPath.section];
return(theSection);
}

- (CTableSection *)sectionWithIndex:(NSInteger)inIndex;
{
CTableSection *theSection = [self.sections objectAtIndex:inIndex];
return(theSection);
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView
{
return(MAX(self.sections.count, 1));
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection
{
if (inSection >= self.sections.count)
	return(0);
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
if (inSection >= self.sections.count)
	return(NULL);
CTableSection *theSection = [self.sections objectAtIndex:inSection];
return(theSection.headerTitle);
}

- (CGFloat)tableView:(UITableView *)inTableView heightForHeaderInSection:(NSInteger)inSection
{
if (inSection >= self.sections.count)
	return(24.0f);
CTableSection *theSection = [self.sections objectAtIndex:inSection];
if (theSection.headerView)
	return(theSection.headerView.frame.size.height);
else
	return(24.0f);
}

- (CGFloat)tableView:(UITableView *)inTableView heightForFooterInSection:(NSInteger)inSection
{
if (inSection >= self.sections.count)
	return(24.0f);
CTableSection *theSection = [self.sections objectAtIndex:inSection];
if (theSection.footerView)
	return(theSection.footerView.frame.size.height);
else
	return(24.0f);
}

- (UIView *)tableView:(UITableView *)inTableView viewForHeaderInSection:(NSInteger)inSection
{
if (inSection >= self.sections.count)
	return(NULL);
CTableSection *theSection = [self.sections objectAtIndex:inSection];
return(theSection.headerView);
}

- (UIView *)tableView:(UITableView *)inTableView viewForFooterInSection:(NSInteger)inSection
{
if (inSection >= self.sections.count)
	return(NULL);
CTableSection *theSection = [self.sections objectAtIndex:inSection];
return(theSection.footerView);
}

- (CGFloat)tableView:(UITableView *)inTableView heightForRowAtIndexPath:(NSIndexPath *)inIndexPath
{
CTableRow *theRow = [self rowWithIndexPath:inIndexPath];
if (theRow)
	{
	if (theRow.height <= 0.0)
		theRow.height = theRow.cell.frame.size.height;
	return(theRow.height);
	}
return(44);
}

- (NSIndexPath *)tableView:(UITableView *)inTableView willSelectRowAtIndexPath:(NSIndexPath *)inIndexPath
{
if (inIndexPath.section >= self.sections.count)
	return(NULL);
CTableSection *theSection = [self.sections objectAtIndex:inIndexPath.section];
if (inIndexPath.row >= theSection.rows.count)
	return(NULL);


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
