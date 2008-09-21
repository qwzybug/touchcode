//
//  CPersistentObjectManager.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSqliteDatabase;
@class CPersistentObject;

@interface CPersistentObjectManager : NSObject {
	CSqliteDatabase *database;
	NSMutableDictionary *cachedObjects;
}

@property (readonly, nonatomic, retain) CSqliteDatabase *database;
@property (readonly, nonatomic, retain) NSMutableDictionary *cachedObjects;

- (id)initWithDatabase:(CSqliteDatabase *)inDatabase;

- (id)makePersistentObjectOfClass:(Class)inClass error:(NSError **)outError;
- (id)loadPersistentObjectOfClass:(Class)inClass rowID:(NSInteger)inRowID error:(NSError **)outError;
- (id)loadPersistentObjectOfClass:(Class)inClass rowID:(NSInteger)inRowID fromDictionary:(NSDictionary *)inValues error:(NSError **)outError;

// Mostly private APIs
- (void)cachePersistentObject:(CPersistentObject *)inPersistentObject;
- (void)uncachePersistentObject:(CPersistentObject *)inPersistentObject;

@end
