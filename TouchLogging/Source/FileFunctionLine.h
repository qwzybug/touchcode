/*
 *  FileFunctionLine.h
 *  Logging
 *
 *  Created by Jonathan Wight on 8/18/07.
 *  Copyright 2009 Small Society. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

typedef struct {
	const char *file;
	const char *function;
	int line;
	} SFileFunctionLine;

extern SFileFunctionLine FileFunctionLine(const char *file, const char *function, int line);
extern NSDictionary *FileFunctionLineDict(const char *file, const char *function, int line);

#define FileFunctionLine_() \
	FileFunctionLine(__FILE__, __PRETTY_FUNCTION__, __LINE__)

#define FileFunctionLineDict_() \
	FileFunctionLineDict(__FILE__, __PRETTY_FUNCTION__, __LINE__)
