//
//  CEventHandler.h
//  TouchCode
//
//  Created by Jonathan Wight on 04/15/08.
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

#import <UIKit/UIKit.h>

@protocol CEventHandlerDelegate;

@interface CEventHandler : UIResponder {
	id <CEventHandlerDelegate> delegate;
	UIView *view;

	BOOL isDrag;

	CGFloat flickThreshold;

	NSTimeInterval beginningTime;
	NSUInteger beginningTouchCount;
	CGPoint beginningLocation;
	CGFloat beginningPinchWidth;

	NSSet *currentTouches;
	UIEvent *currentEvent;
}

@property (readwrite, nonatomic, assign) id <CEventHandlerDelegate> delegate;
@property (readwrite, nonatomic, assign) UIView *view;

@property (readwrite, nonatomic, assign) CGFloat flickThreshold;

@property (readonly, nonatomic, assign) NSTimeInterval beginningTime;
@property (readonly, nonatomic, assign) NSUInteger beginningTouchCount;
@property (readonly, nonatomic, assign) CGPoint beginningLocation;
@property (readonly, nonatomic, assign) CGFloat beginningPinchWidth;
@property (readonly, nonatomic, assign) BOOL isDrag;

@property (readonly, nonatomic, assign) NSSet *currentTouches;
@property (readonly, nonatomic, assign) UIEvent *currentEvent;

- (BOOL)dragWasFlick;

- (void)dragBegan;
- (void)dragMoved;
- (void)dragEnded;

- (void)pinchBegan;
- (void)pinchMoved:(CGFloat)inPinchDistance center:(CGPoint)inCenter;
- (void)pinchEnded;

- (void)tapped;
- (void)doubleTapped;
- (void)multiTapped;

- (void)zoomBy:(CGFloat)inDelta center:(CGPoint)inCenter;
- (void)scrollBy:(CGPoint)inDelta;

@end

#pragma mark -

@protocol CEventHandlerDelegate <NSObject>

- (BOOL)eventHandlerShouldScroll:(CEventHandler *)inEventHandler;

@optional

- (void)eventHandlerDidReceiveTap:(CEventHandler *)inEventHandler;
- (void)eventHandlerDidReceiveDoubleTap:(CEventHandler *)inEventHandler;

- (void)eventHandlerDidReceiveDragBegan:(CEventHandler *)inEventHandler;
- (void)eventHandlerDidReceiveDragMoved:(CEventHandler *)inEventHandler;
- (void)eventHandlerDidReceiveDragEnded:(CEventHandler *)inEventHandler;

- (void)eventHandler:(CEventHandler *)inEventHandler didReceiveZoomBy:(CGFloat)inDelta center:(CGPoint)inCenter;
- (void)eventHandler:(CEventHandler *)inEventHandler didReceiveScrollBy:(CGPoint)inDelta;

@end
