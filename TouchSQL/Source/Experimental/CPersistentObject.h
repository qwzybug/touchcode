//
//  CPersistentObject.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CPersistentObjectManager;
@class CObjectTranscoder;

@interface CPersistentObject : NSObject {
	CPersistentObjectManager *persistentObjectManager;
	NSInteger rowID;
	NSDate *created;
	NSDate *modified;
}

@property (readonly, nonatomic, assign) CPersistentObjectManager *persistentObjectManager;
@property (readonly, nonatomic, retain) NSString *persistentIdentifier;
@property (readwrite, nonatomic, assign) NSInteger rowID;
@property (readwrite, nonatomic, retain) NSDate *created;
@property (readwrite, nonatomic, retain) NSDate *modified;

+ (CObjectTranscoder *)objectTranscoder;
+ (NSString *)tableName;

- (id)initWithPersistenObjectManager:(CPersistentObjectManager *)inManager rowID:(NSInteger)inRowID;

@end
