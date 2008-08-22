//
//  CFileBasedManagedURLConnection.h
//  EverybodyVotes
//
//  Created by Jonathan Wight on 8/22/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CManagedURLConnection.h"

@interface CFileBasedManagedURLConnection : CManagedURLConnection {
	NSString * filePath;
	NSFileHandle * fileHandle;
}

@property (readonly, nonatomic, retain) NSString *filePath;
@property (readonly, nonatomic, retain) NSFileHandle *fileHandle;

@end
