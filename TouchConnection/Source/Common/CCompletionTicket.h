//
//  CCompletionTicket.h
//  TouchCode
//
//  Created by Jonathan Wight on 8/22/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCompletionTicketDelegate;
@class CPointerArray;

@interface CCompletionTicket : NSObject {
	NSString *identifier;
	CPointerArray *delegatePointers;
	id userInfo;
}

@property (readonly, nonatomic, retain) NSString *identifier;
@property (readonly, nonatomic, retain) NSArray *delegates;
@property (readonly, nonatomic, retain) id userInfo;

+ (CCompletionTicket *)completionTicketWithIdentifier:(NSString *)inIdentifier delegate:(id <CCompletionTicketDelegate>)inDelegate userInfo:(id)inUserInfo;

- (id)initWithIdentifier:(NSString *)inIdentifier delegates:(NSArray *)inDelegates userInfo:(id)inUserInfo;
- (id)initWithIdentifier:(NSString *)inIdentifier delegate:(id <CCompletionTicketDelegate>)inDelegate userInfo:(id)inUserInfo;

- (void)addDelegate:(id <CCompletionTicketDelegate>)inDelegate;

- (void)didCompleteForTarget:(id)inTarget result:(id)inResult;
- (void)didFailForTarget:(id)inTarget error:(NSError *)inError;
- (void)didCancelForTarget:(id)inTarget;

@end

#pragma mark -

@protocol CCompletionTicketDelegate <NSObject>

@required
- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult;

@optional
- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didFailForTarget:(id)inTarget error:(NSError *)inError;
- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCancelForTarget:(id)inTarget;

@end