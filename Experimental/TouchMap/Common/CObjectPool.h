//
//  CObjectPool.h
//  MapToy
//
//  Created by Jonathan Wight on 08/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CObjectPool : NSObject {
	Class objectClass;
	SEL creationSelector;
	NSMutableSet *spareObjects;
}

@property (readonly, nonatomic, assign) Class objectClass;
@property (readonly, nonatomic, assign) SEL creationSelector;

- (id)initWithObjectClass:(Class)inObjectClass creationSelector:(SEL)inCreationSelector;

- (id)createObject;
- (void)returnObjectToPool:(id)inObject;

@end
