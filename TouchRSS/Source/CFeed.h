//
//  CRSSChannel.h
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright (c) 2008 Jonathan Wight
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

#import <Foundation/Foundation.h>

@class CFeedStore;
@class CFeedEntry;
@class CObjectTranscoder;

@interface CFeed : NSObject {
	NSInteger rowID;
	CFeedStore *feedStore;
	NSURL *url;
	NSString *title;
	NSURL *link;
	NSString *description_;
	NSDate *lastChecked;
}

@property (readonly, nonatomic, assign)	NSInteger rowID;
@property (readonly, nonatomic, assign) CFeedStore *feedStore;
@property (readwrite, nonatomic, assign) NSURL *url;
@property (readwrite, nonatomic, retain) NSString *title;
@property (readwrite, nonatomic, retain) NSURL *link;
@property (readwrite, nonatomic, retain) NSString *description_;
@property (readwrite, nonatomic, retain) NSDate *lastChecked;

+ (CObjectTranscoder *)objectTranscoder;

- (id)initWithFeedStore:(CFeedStore *)inFeedStore;
- (id)initWithFeedStore:(CFeedStore *)inFeedStore rowID:(NSInteger)inRowID;

- (CFeedEntry *)entryAtIndex:(NSInteger)inIndex;
- (CFeedEntry *)entryForIdentifier:(NSString *)inIdentifier;

- (BOOL)read:(NSError **)outError;
- (BOOL)write:(NSError **)outError;

@end
