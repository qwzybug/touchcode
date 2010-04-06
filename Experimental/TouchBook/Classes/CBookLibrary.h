//
//  CBookLibrary.h
//  TouchBook
//
//  Created by Jonathan Wight on 02/25/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CBookLibrary : NSObject {
	NSMutableArray *books;
}

@property (readonly, nonatomic, retain) NSMutableArray *books;

@end
