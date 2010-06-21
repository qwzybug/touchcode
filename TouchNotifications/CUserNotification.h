//
//  CUserNotification.h
//  TouchCode
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
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

enum {
	UserNotificationFlag_UsesNetwork = 0x01,
	UserNotificationFlag_Defaults = 0x00,
	};

@interface CUserNotification : NSObject <NSCopying> {
	NSString *identifier;
	NSString *styleName;
	NSString *title;
	NSString *message;
	UIImage *icon;
	CGFloat progress;
//	NSInteger priority;
	NSUInteger flags;
	SEL action;
	id target;
	id userInfo;
}

@property (readwrite, nonatomic, copy) NSString *identifier;
@property (readwrite, nonatomic, copy) NSString *styleName;
@property (readwrite, nonatomic, copy) NSString *title;
@property (readwrite, nonatomic, copy) NSString *message;
@property (readwrite, nonatomic, retain) UIImage *icon;
@property (readwrite, nonatomic, assign) CGFloat progress; // 0.0 to 1.0 for progress, INFINITY for activity, anything else (default NAN) for no progress/activity
//@property (readwrite, nonatomic, assign) NSInteger priority;
@property (readwrite, nonatomic, assign) NSUInteger flags;
@property (readwrite, nonatomic, assign) SEL action;
@property (readwrite, nonatomic, retain) id target;
@property (readwrite, nonatomic, retain) id userInfo;

@end
