//
//  CSqliteDatabase_Functions.h
//  TouchSQL
//
//  Created by Jonathan Wight on 12/9/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CSqliteDatabase.h"

@interface CSqliteDatabase (CSqliteDatabase_Functions)

- (BOOL)loadFunctions:(NSError **)outError;

@end
