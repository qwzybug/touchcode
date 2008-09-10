//
//  CPointerArray.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/10/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPointerArray : NSObject <NSFastEnumeration> {
	NSUInteger count;
	void **buffer;
}

@property (readwrite, nonatomic, assign) NSUInteger count;

- (id)init;

- (void *)pointerAtIndex:(NSUInteger)inIndex;

- (void)addPointer:(void *)inPointer;

//- (void)removePointerAtIndex:(NSUInteger)index;    // everything above index, including holes, slide lower
//- (void)insertPointer:(void *)item atIndex:(NSUInteger)index;  // everything at & above index, including holes, slide higher
//- (void)replacePointerAtIndex:(NSUInteger)index withPointer:(void *)item;  // O(1); NULL item is okay; index must be < count
//- (void)compact;   // eliminate NULLs

@end
