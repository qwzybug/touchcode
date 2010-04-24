//
//  CLoginViewController.m
//  touchcode
//
//  Created by Jonathan Wight on 5/22/09.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CLoginViewController.h"

#import "CButtonTableViewCell.h"
//#import "UIViewController_Extensions.h"
#import "CErrorPresenter.h"
#import "CValueValidator.h"

@interface CLoginViewController()
@property (readwrite, nonatomic, retain) UITextField *usernameField;
@property (readwrite, nonatomic, retain) UITextField *passwordField;
@property (readwrite, nonatomic, retain) CButtonTableViewCell *doneCell;
@property (readwrite, nonatomic, retain) NSIndexPath *editedCellIndexPath;

- (void)textFieldTextDidChangeNotification:(NSNotification *)inNotification;

- (void)keyboardWillShowNotification:(NSNotification *)inNotification;
- (void)keyboardDidShowNotification:(NSNotification *)inNotification;
- (void)keyboardWillHideNotification:(NSNotification *)inNotification;

@end

#pragma mark -

@implementation CLoginViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize doneCell;
@synthesize editedCellIndexPath;

- (id)initWithPicker:(CPicker *)inPicker
{
if ((self = [super initWithNibName:self.nibName bundle:NULL]) != NULL)
	{
	self.picker = inPicker;
	
	self.picker.initialValue = [[NSMutableDictionary alloc] init];
	
	self.initialStyle = UITableViewStyleGrouped;
	
	self.picker.validatorName = @"UsernamePasswordValidator";
	}
return(self);
}

- (void)dealloc
{
[[NSNotificationCenter defaultCenter] removeObserver:self];
//
[usernameField release];
usernameField = NULL;

[passwordField release];
passwordField = NULL;

[doneCell release];
doneCell = NULL;

[editedCellIndexPath release];
editedCellIndexPath = NULL;

[super dealloc];
}

- (void)viewDidUnload
{
[super viewDidUnload];

[[NSNotificationCenter defaultCenter] removeObserver:self];
//
[usernameField release];
usernameField = NULL;

[passwordField release];
passwordField = NULL;

[doneCell release];
doneCell = NULL;

[editedCellIndexPath release];
editedCellIndexPath = NULL;
}

#pragma mark -

- (NSString *)username
{
return([self.picker.value objectForKey:@"username"]);
}

- (void)setUsername:(NSString *)inUsername
{
inUsername = inUsername != NULL ? (id)inUsername : (id)[NSNull null];
[self.picker.value setObject:inUsername forKey:@"username"];
}

- (NSString *)password
{
return([self.picker.value objectForKey:@"password"]);
}

- (void)setPassword:(NSString *)inPassword
{
inPassword = inPassword != NULL ? (id)inPassword : (id)[NSNull null];
[self.picker.value setObject:inPassword forKey:@"password"];
}

#pragma mark -

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.title = @"Sign In";
self.navigationItem.prompt = @"TODO Enter your twitter info yo!";
}

- (void)viewWillAppear:(BOOL)animated
{
[super viewWillAppear:animated];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:NULL];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:NULL];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:NULL];
}

- (void)viewDidAppear:(BOOL)animated
{
[super viewDidAppear:animated];
//
[self.usernameField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
[super viewWillDisappear:animated];
//
[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:NULL];
[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:NULL];
[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:NULL];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
return(2);
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
switch (section)
	{
	case 0:
		return(2);
	case 1:
		return(1);
	}
return(0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *theCell = NULL;

switch (indexPath.section)
	{
	case 0:
		{
		switch (indexPath.row)
			{
			case 0:
				{
				theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NULL] autorelease];
				theCell.textLabel.text = @"Username";
				theCell.selectionStyle = UITableViewCellSelectionStyleNone;
				self.usernameField = [[[UITextField alloc] initWithFrame:CGRectMake(100, 0, 210, 44)] autorelease];
				self.usernameField.tag = 0;
				self.usernameField.delegate = self;
				self.usernameField.textAlignment = UITextAlignmentLeft;
				self.usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
				self.usernameField.textColor = [UIColor colorWithRed:0.31f green:0.408f blue:0.584f alpha:1.0f];
				self.usernameField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				self.usernameField.keyboardType = UIKeyboardTypeEmailAddress;
				self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
				self.usernameField.text = self.username;
				
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.usernameField];
				
				[theCell.contentView addSubview:self.usernameField];
				}
				break;
			case 1:
				{
				theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NULL] autorelease];
				theCell.textLabel.text = @"Password";
				theCell.selectionStyle = UITableViewCellSelectionStyleNone;
				self.passwordField = [[[UITextField alloc] initWithFrame:CGRectMake(100, 0, 210, 44)] autorelease];
				self.passwordField.tag = 1;
				self.passwordField.delegate = self;
				self.passwordField.textAlignment = UITextAlignmentLeft;
				self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
				self.passwordField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				self.passwordField.textColor = [UIColor colorWithRed:0.31f green:0.408f blue:0.584f alpha:1.0f];
				self.passwordField.keyboardType = UIKeyboardTypeEmailAddress;
				self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
				self.passwordField.secureTextEntry = YES;
				self.passwordField.text = self.password;

				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.passwordField];

				[theCell.contentView addSubview:self.passwordField];
				}
				break;
			}
		}
		break;
	case 1:
		{
		switch (indexPath.row)
			{
			case 0:
				{
				if (self.doneCell == NULL)
					{
					CButtonTableViewCell *theButtonCell = [[[CButtonTableViewCell alloc] initWithReuseIdentifier:@"LoginButton"] autorelease];
					theButtonCell.selectionStyle = UITableViewCellSelectionStyleNone;
					theButtonCell.backgroundColor = [UIColor redColor];
					theButtonCell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
					[theButtonCell.button setTitle:@"Sign In" forState:UIControlStateNormal];
					theButtonCell.target = self;
					theButtonCell.action = @selector(done:);
					theButtonCell.button.enabled = NO;
					
					self.doneCell = theButtonCell;
					}

                theCell = self.doneCell;
				}
				break;
			}
		}
		break;
	default:
		break;
	}
return(theCell);
}

#pragma mark -

- (void)keyboardWillShowNotification:(NSNotification *)inNotification
{
}

- (void)keyboardDidShowNotification:(NSNotification *)inNotification
{
[UIView beginAnimations:nil context:nil];
[UIView setAnimationDuration:0.3];
[UIView setAnimationBeginsFromCurrentState:YES];

CGRect theViewFrame = self.view.frame;
theViewFrame.size.height -= 150;
self.view.frame = theViewFrame;

[UIView commitAnimations];

[self.tableView scrollToRowAtIndexPath:self.editedCellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)keyboardWillHideNotification:(NSNotification *)inNotification
{
[UIView beginAnimations:nil context:nil];
[UIView setAnimationDuration:0.3];
[UIView setAnimationBeginsFromCurrentState:YES];

CGRect theViewFrame = self.view.frame;
theViewFrame.size.height += 150;
self.view.frame = theViewFrame;

[UIView commitAnimations];
}

#pragma mark -

- (void)textFieldTextDidChangeNotification:(NSNotification *)inNotification
{
UITextField *theTextField = inNotification.object;

switch (theTextField.tag)
    {
    case 0:
        self.username = theTextField.text;
        break;
    case 1:
        self.password = theTextField.text;
        break;
    }

if ([self isValid])
	{
	self.doneCell.button.enabled = YES;
	self.finishButtonItem.enabled = YES;
	}
else
	{
	self.doneCell.button.enabled = NO;
	self.finishButtonItem.enabled = NO;
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
self.editedCellIndexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
[textField resignFirstResponder];

if (textField == self.usernameField)
	{
	if ([self isValid])
		{
		self.doneCell.button.enabled = YES;
		self.finishButtonItem.enabled = YES;
		}
	else
		{
		self.doneCell.button.enabled = NO;
		self.finishButtonItem.enabled = NO;
		}
	[self.passwordField becomeFirstResponder];
	}
else if (textField == self.passwordField)
	{
	if ([self isValid])
		{
		self.doneCell.button.enabled = YES;
		self.finishButtonItem.enabled = YES;
		[self done:NULL];
		}
	else
		{
		self.doneCell.button.enabled = NO;
		self.finishButtonItem.enabled = NO;
		[self.usernameField becomeFirstResponder];
		}
	}

return(YES);
}

// The password field is not firing this event
- (void)textFieldDidEndEditing:(UITextField *)textField
{
switch (textField.tag)
    {
    case 0:
        self.username = textField.text;
        break;
    case 1:
        self.password = textField.text;
        break;
    }

if ([self isValid])
	{
	self.doneCell.button.enabled = YES;
	self.finishButtonItem.enabled = YES;
	}
else
	{
	self.doneCell.button.enabled = NO;
	self.finishButtonItem.enabled = NO;
	}
}

#pragma mark -

- (BOOL)isValid
{
return([self validate:NULL]);
}

- (BOOL)validate:(NSError **)outError;
{
CValueValidator *theValidator = [CValueValidator valueValidatorForName:self.picker.validatorName];
return([theValidator validateValue:self error:outError]);
}

- (IBAction)done:(id)inSender
{
self.username = self.usernameField.text;
self.password = self.passwordField.text;

NSError *theError = NULL;
if ([self validate:&theError] == YES)
	{
	[self.usernameField resignFirstResponder];
	[self.passwordField resignFirstResponder];

	[self.picker done:inSender];
	}
else
	{
	if (theError != NULL)
		[self presentError:theError];
	}
}

@end
