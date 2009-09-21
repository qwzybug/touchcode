//
//  TouchRSS_MacOS_AppDelegate.h
//  TouchRSS_MacOS
//
//  Created by Jonathan Wight on 9/20/09.
//  Copyright toxicsoftware.com 2009 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TouchRSS_MacOS_AppDelegate : NSObject 
{
    NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;

@end
