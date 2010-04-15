//
//  CDynamicCell.h
//  Zipcar
//
//  Created by Jonathan Wight on 08/13/09.
//  Copyright 2009 Zipcar, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CDynamicCellDelegate;

@protocol CDynamicCell <NSObject>

@property (readwrite, nonatomic, assign) id <CDynamicCellDelegate> delegate;

@end

#pragma mark -

@protocol CDynamicCellDelegate <NSObject>

- (void)dynamicCellDidResize:(id <CDynamicCell>)inCell;

@end
