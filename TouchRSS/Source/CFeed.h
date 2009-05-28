//
//  CFeed.h
//  TouchCode
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CPersistentObject.h"

@class CFeedStore;
@class CFeedEntry;
@class CObjectTranscoder;
@class CRandomAccessTemporaryTable;

@interface CFeed : CPersistentObject {
	CFeedStore *feedStore;
	BOOL updating;
	CRandomAccessTemporaryTable *randomAccessTemporaryTable;
	NSDate *lastChecked;
	NSURL *url;

	NSString *identifier;
	NSString *title;
	NSURL *link;
	NSString *subtitle;
}

@property (readwrite, nonatomic, assign) CFeedStore *feedStore;
@property (readwrite, nonatomic, assign) BOOL updating;
@property (readwrite, nonatomic, retain) NSDate *lastChecked;
@property (readwrite, nonatomic, retain) NSURL *url;

@property (readwrite, nonatomic, retain) NSString *identifier;
@property (readwrite, nonatomic, retain) NSString *title;
@property (readwrite, nonatomic, retain) NSString *subtitle;
@property (readwrite, nonatomic, retain) NSURL *link;

- (NSInteger)countOfEntries;

- (void)addEntry:(CFeedEntry *)inEntry;

- (CFeedEntry *)entryAtIndex:(NSInteger)inIndex;
- (CFeedEntry *)entryForIdentifier:(NSString *)inIdentifier;

@end
