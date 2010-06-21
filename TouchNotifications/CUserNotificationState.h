//
//  CUserNotificationState.h
//  TouchCode
//
//  Created by Jonathan Wight on 11/19/09.
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

@class CUserNotification;
@class CUserNotificationStyle;

@interface CUserNotificationState : NSObject {
	CUserNotification *notification;
	CUserNotificationStyle *style;
	BOOL shown;
	BOOL showingNetworkIndicator;
	CFAbsoluteTime created;
	CFAbsoluteTime requestedShowDate;
	CFAbsoluteTime showDate;
	CFAbsoluteTime requestedHideDate;
	CFAbsoluteTime hideDate;

}

@property (readwrite, nonatomic, retain) CUserNotification *notification;
@property (readwrite, nonatomic, retain) CUserNotificationStyle *style;
@property (readwrite, nonatomic, assign) BOOL shown;
@property (readwrite, nonatomic, assign) BOOL showingNetworkIndicator;
@property (readwrite, nonatomic, assign) CFAbsoluteTime created;
@property (readwrite, nonatomic, assign) CFAbsoluteTime requestedShowDate;
@property (readwrite, nonatomic, assign) CFAbsoluteTime showDate;
@property (readwrite, nonatomic, assign) CFAbsoluteTime requestedHideDate;
@property (readwrite, nonatomic, assign) CFAbsoluteTime hideDate;

@end
