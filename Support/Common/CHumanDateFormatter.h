//
//  CHumanDateFormatter.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHumanDateFormatter : NSDateFormatter {
	BOOL singleLine;
	BOOL relative;
}

@property (readwrite, nonatomic, assign) BOOL singleLine;
@property (readwrite, nonatomic, assign) BOOL relative;

+ (id)humanDateFormatter:(BOOL)inSingleLine;

@end
