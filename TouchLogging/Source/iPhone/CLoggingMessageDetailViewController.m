//
//  CLoggingMessageDetailViewController.m
//  Touchcode
//
//  Created by Jonathan Wight on 05/11/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import "CLoggingMessageDetailViewController.h"

#import "CLogging.h"
#import "CDynamicTableViewCell.h"

@implementation CLoggingMessageDetailViewController

@synthesize message;
@synthesize extraAttributes;

- (id)init
{
if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
	{
	}
return(self);
}

- (void)dealloc
{
self.message = NULL;
self.extraAttributes = NULL;
//
[super dealloc];
}

- (id)contentForRowAtIndexPath:(NSIndexPath *)indexPath
{
NSMutableDictionary *theContent = [NSMutableDictionary dictionaryWithCapacity:2];

switch (indexPath.row)
	{
	case 0:
		{
		[theContent setObject:@"Level" forKey:@"textLabel.text"];
		[theContent setObject:[CLogging stringForLevel:[[self.message valueForKey:@"level"] integerValue]] forKey:@"detailTextLabel.text"];
		}
		break;
	case 1:
		{
		[theContent setObject:@"Timestamp" forKey:@"textLabel.text"];
		[theContent setObject:[NSString stringWithFormat:@"%@", [self.message valueForKey:@"timestamp"]] forKey:@"detailTextLabel.text"];
		}
		break;
	case 2:
		{
		[theContent setObject:@"Message" forKey:@"textLabel.text"];
 		[theContent setObject:[self.message valueForKey:@"message"] forKey:@"detailTextLabel.text"];
		}
		break;
	case 3:
		{
		NSString *theDetail = [self.message valueForKey:@"sender"];
		[theContent setObject:@"Sender" forKey:@"textLabel.text"];
		[theContent setObject:theDetail ? theDetail : @"" forKey:@"detailTextLabel.text"];
		}
		break;
	case 4:
		{
		NSString *theDetail = [self.message valueForKey:@"facility"];
		[theContent setObject:@"Facility" forKey:@"textLabel.text"];
		[theContent setObject:theDetail ? theDetail : @"" forKey:@"detailTextLabel.text"];
		}
		break;
	default:
		{
		if (self.extraAttributes == NULL)
			{
			NSData *theExtraAttributesData = [self.message valueForKey:@"extraAttributes"];
			self.extraAttributes = [NSPropertyListSerialization propertyListFromData:theExtraAttributesData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
			}

		NSString *theKey = [[self.extraAttributes allKeys] objectAtIndex:indexPath.row - 5];
		id theValue = [self.extraAttributes objectForKey:theKey];
		[theContent setObject:theKey forKey:@"textLabel.text"];
		[theContent setObject:[NSString stringWithFormat:@"%@", theValue] forKey:@"detailTextLabel.text"];
		}
		break;
	}
return(theContent);
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
if (self.extraAttributes == NULL)
	{
	NSData *theExtraAttributesData = [self.message valueForKey:@"extraAttributes"];
	self.extraAttributes = [NSPropertyListSerialization propertyListFromData:theExtraAttributesData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
	}

return(5 + self.extraAttributes.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
CDynamicTableViewCell *theCell = (CDynamicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
if (theCell == NULL)
	{
	theCell = [[[CDynamicTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
	theCell.selectionStyle = UITableViewCellSelectionStyleNone;

//	theCell.textLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
//	theCell.detailTextLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 4];
	}

switch (indexPath.row)
	{
	case 0:
		{
		theCell.textLabel.text = @"Level";
		theCell.detailTextLabel.text = [CLogging stringForLevel:[[self.message valueForKey:@"level"] integerValue]];
		}
		break;
	case 1:
		{
		theCell.textLabel.text = @"Timestamp";
		theCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.message valueForKey:@"timestamp"]];
		}
		break;
	case 2:
		{
		theCell.textLabel.text = @"Message";
		theCell.detailTextLabel.text = [self.message valueForKey:@"message"];
		}
		break;
	case 3:
		{
		theCell.textLabel.text = @"Sender";
		theCell.detailTextLabel.text = [self.message valueForKey:@"sender"];
		}
		break;
	case 4:
		{
		theCell.textLabel.text = @"Facility";
		theCell.detailTextLabel.text = [self.message valueForKey:@"facility"];
		}
		break;
	default:
		{
		if (self.extraAttributes == NULL)
			{
			NSData *theExtraAttributesData = [self.message valueForKey:@"extraAttributes"];
			self.extraAttributes = [NSPropertyListSerialization propertyListFromData:theExtraAttributesData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
			}

		NSString *theKey = [[self.extraAttributes allKeys] objectAtIndex:indexPath.row - 5];
		id theValue = [self.extraAttributes objectForKey:theKey];
		theCell.textLabel.text = theKey;
		theCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", theValue];
		}
		break;
	}
return(theCell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
return([CDynamicTableViewCell preferredHeightForCellWithTable:tableView content:[self contentForRowAtIndexPath:indexPath]]);
}

@end
