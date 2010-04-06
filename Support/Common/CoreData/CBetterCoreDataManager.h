//
//  CBetterCoreDataManager.h
//  touchcode
//
//  Created by Jonathan Wight on 11/10/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CCoreDataManager.h"

// TODO rename!!!
@interface CBetterCoreDataManager : CCoreDataManager {
	id defaultMergePolicy;
}

@property (readwrite, retain) id defaultMergePolicy;

@end
