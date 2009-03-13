//
//  CKeyValueStore.h
//  TouchCode
//
//  Created by Jonathan Wight on 2/27/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSqliteDatabase;

@interface CKeyValueStore : NSObject {
	NSString *name;
	NSString *databasePath;
	CSqliteDatabase *database;
}

@property (readonly, nonatomic, retain) NSString *name;
@property (readonly, nonatomic, retain) NSString *databasePath;

+ (CKeyValueStore *)namedKeyValueStore:(NSString *)inName;

- (id)initWithName:(NSString *)inName error:(NSError **)outError;

- (void)setObject:(id)inObject forKey:(NSString *)inKey;
- (id)objectForKey:(NSString *)inKey;

@end
