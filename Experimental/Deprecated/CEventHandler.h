// 
//  CEventHandler.h
//  Test
//
//  Created by Jonathan Wight on 04/15/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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
