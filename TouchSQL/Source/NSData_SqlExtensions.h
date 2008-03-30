//
//  NSData_SqlExtensions.h
//  kcal
//
//  Created by Ian Baird on 3/30/08.
//  Copyright 2008 Skorpiostech, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSqliteDatabase;

@interface NSData (NSData_SqlExtensions)

- (BOOL)writeToDatabase:(CSqliteDatabase *)database table:(NSString *)table field:(NSString *)field whereClause:(NSString *)whereClause;

@end
