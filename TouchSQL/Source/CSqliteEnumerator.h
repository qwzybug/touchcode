//
//  CSqliteEnumerator.h
//  sqllitetest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sqlite3.h>

@interface CSqliteEnumerator : NSEnumerator {
	sqlite3_stmt *statement;
}

- (id)initWithStatement:(sqlite3_stmt *)inStatement;

@end
