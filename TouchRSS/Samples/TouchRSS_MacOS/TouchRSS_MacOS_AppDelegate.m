//
//  TouchRSS_MacOS_AppDelegate.m
//  TouchRSS_MacOS
//
//  Created by Jonathan Wight on 9/20/09.
//  Copyright toxicsoftware.com 2009 . All rights reserved.
//

#import "TouchRSS_MacOS_AppDelegate.h"

#import "CFeedStore.h"
#import "CFeedFetcher.h"

@implementation TouchRSS_MacOS_AppDelegate

@synthesize window;

- (void)dealloc
{
[window release];
//	
[super dealloc];
}

- (NSManagedObjectContext *)managedObjectContext
{
return([CFeedStore instance].managedObjectContext);
}
 
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
return [[self managedObjectContext] undoManager];
}

- (IBAction)saveAction:(id)sender {

    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%s unable to commit editing before saving", [self class], _cmd);
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification;
{

NSURL *theURL = [NSURL URLWithString:@"http://toxicsoftware.com/feed/"];
NSError *theError = NULL;
[[CFeedStore instance].feedFetcher subscribeToURL:theURL error:&theError];

}
 
//- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
//
//    if (!managedObjectContext) return NSTerminateNow;
//
//    if (![managedObjectContext commitEditing]) {
//        NSLog(@"%@:%s unable to commit editing to terminate", [self class], _cmd);
//        return NSTerminateCancel;
//    }
//
//    if (![managedObjectContext hasChanges]) return NSTerminateNow;
//
//    NSError *error = nil;
//    if (![managedObjectContext save:&error]) {
//    
//        // This error handling simply presents error information in a panel with an 
//        // "Ok" button, which does not include any attempt at error recovery (meaning, 
//        // attempting to fix the error.)  As a result, this implementation will 
//        // present the information to the user and then follow up with a panel asking 
//        // if the user wishes to "Quit Anyway", without saving the changes.
//
//        // Typically, this process should be altered to include application-specific 
//        // recovery steps.  
//                
//        BOOL result = [sender presentError:error];
//        if (result) return NSTerminateCancel;
//
//        NSString *question = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
//        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
//        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
//        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
//        NSAlert *alert = [[NSAlert alloc] init];
//        [alert setMessageText:question];
//        [alert setInformativeText:info];
//        [alert addButtonWithTitle:quitButton];
//        [alert addButtonWithTitle:cancelButton];
//
//        NSInteger answer = [alert runModal];
//        [alert release];
//        alert = nil;
//        
//        if (answer == NSAlertAlternateReturn) return NSTerminateCancel;
//
//    }
//
//    return NSTerminateNow;
//}

@end
