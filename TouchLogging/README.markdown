# TouchLogging

Source code for providing simple logging to CoreData functionality.

## Requirements

You need "CCoreDataManager.h/.m" from "{TouchCode}/Support/Common/CoreData".

## Description

Log messages comprise of a sender string, facility string, level integer, timestamp, a message string and a dictionary of extra attributes.

By default all log messages are printed to stderr and saved to core data.

## Usage

All symbols with a trailing underscore are preprocessor macros and not functions.

You can turn the logging macros on and off with the LOGGING preprocessor define. If set to 1 this define will cause all the macros to do nothing. The CLogging class will still exist and can be access via its methods and properties like any other class.

At the very basic level you just need to call a logging macro:

    LogDebug_(@"This is a logging message!");

That is equivalent (and preferable) to:

	Log_(LoggingLevel_DEBUG, @"This is a logging message!");

Convenience categories exist for logging NSError and NSException objects:

	NSError *theError = [someObject someMethodReturningAnError];
	[theError log];

You can set up the logging defaults before logging any messages:

	[CLogging instance].sender = @"Test Sender";
	[CLogging instance].facility = @"Test Facility";

## Multithreading

TouchLogging should be thread safe. Each thread should have its own CoreData NSManagedObjectContext (a function of CCoreDataManager).

## CLoggingHandler and events

CLogging defines the notion of events that occur during CLogging's lifetime. These events are named: "start", "log" and "end". These events occur when logging starts, when a log message is sent and at end of logging respectively.

You can register objects that conform to the CLoggingHandler protocol:

    [[CLogging instance] addHandler:theHandler forEvents:[NSArray arrayWithObject:@"start"];

When an event occurs CLogging will send the follow message

    - (BOOL)handleLogging:(CLogging *)inLogging event:(NSString *)inEvent error:(NSError **)outError;

A sample handler (in the Extras directory) shows how to email the logging data on the iPhone.

## Performance

TouchLogging is not intended to be a high performance logging framework. You should not be logging hundreds of messages per second.

## BUGS

"end" event does not fire because CLogging is a leaking singleton.

## TODO

Improve performance by either deferring CoreData saves until needed or offload message saving into background operations.
