/*
 *  FileFunctionLine.c
 *  Logging
 *
 *  Created by Jonathan Wight on 8/18/07.
 *  Copyright 2009 Small Society. All rights reserved.
 *
 */

#include "FileFunctionLine.h"

SFileFunctionLine FileFunctionLine(const char *file, const char *function, int line)
{
const SFileFunctionLine theFileFunctionLine = { .file = file, .function = function, .line = line };
return(theFileFunctionLine);
}

NSDictionary *FileFunctionLineDict(const char *file, const char *function, int line)
{
return([NSDictionary dictionaryWithObjectsAndKeys:
	[NSString stringWithUTF8String:file], @"File",
	[NSString stringWithUTF8String:function], @"Function",
	[NSNumber numberWithInt:line], @"Line",
	NULL]);
}
