//
//  NSValue_Extensions.h
//  MapToy
//
//  Created by Jonathan Wight on 04/29/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (NSValue_Extensions)

+ (NSValue *)valueWithCGPoint:(CGPoint)inPoint;
- (CGPoint)CGPointValue;

+ (NSValue *)valueWithCGSize:(CGSize)inSize;
- (CGSize)CGSizeValue;

+ (NSValue *)valueWithCGRect:(CGRect)inRect;
- (CGRect)CGRectValue;

@end
