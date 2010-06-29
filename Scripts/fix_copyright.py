#!/usr/bin/python

import os
import re
import subprocess

import sys
import traceback

########################################################################

P1 = '''(?P<block>//
//  (?P<filename>.*)
//  (?P<project>.*)
//
//  Created by (?P<creator>.*) on (?P<date>.*)\.
//  Copyright (?P<copyright>.*)
//

)'''

########################################################################

P2 = '''(?P<block>//
//  (?P<filename>.*)
//
//  Created by (?P<creator>.*) on (?P<date>.*)\.
//  Copyright (?P<copyright>.*)
//

)'''

########################################################################

P3 = '''(?P<block>/\*
 \*  (?P<filename>.*)
 \*  (?P<project>.*)
 \*
 \*  Created by (?P<creator>.*) on (?P<date>.*)\.
 \*  Copyright (?P<copyright>.*)
 \*
 \*/

)'''

########################################################################

P4 = '''(?P<block>//
//  (?P<filename>.*)
//  (?P<project>.*)
//
//  Created by (?P<creator>.*) on (?P<date>.*)\.
//  Copyright (?P<copyright>.*)
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files \(the "Software"\), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software\.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT\. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE\.
//

)'''

########################################################################

FORMAT = '''//
//  %(filename)s
//  %(project)s
//
//  Created by %(creator)s on %(date)s.
//  Copyright %(copyright)s
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

'''

########################################################################

thePatterns = [
	P1,
	P2,
	P3,
	P4,
	]

thePatterns = [thePattern.replace('  ', ' +') for thePattern in thePatterns]

thePatterns = [re.compile(thePattern, re.MULTILINE) for thePattern in thePatterns]

path = sys.argv[1]

def files():
	for root, dirs, files in os.walk(path):
		for theFile in files:
			theName, theExtension = os.path.splitext(theFile)
			if theExtension not in ['.m', '.h', '.c']:
				continue
			theFile = os.path.join(root, theFile)
			if re.match('.+/Externals/.+', theFile):
				continue
			if re.match('.+/TouchJSON/Benchmarking/.+', theFile):
				continue
			if re.match('.+/ISO-8601-parser-0.5/.+', theFile):
				continue

			yield theFile

########################################################################

theCopyrightPatterns = [
	re.compile(r'^(?P<year>\d\d\d\d) (?P<owner>.+)\. All rights reserved\.$', re.IGNORECASE),
	re.compile(r'^(?P<year>\d\d\d\d) (?P<owner>.+) All rights reserved\.$', re.IGNORECASE),
	re.compile(r'^(?P<owner>.+) (?P<year>\d\d\d\d)\. All rights reserved\.$', re.IGNORECASE),
	re.compile(r'^(?P<owner>.+) (?P<year>\d\d\d\d) +\. All rights reserved\.$', re.IGNORECASE),
	re.compile(r'^\(c\) (?P<year>\d\d\d\d) (?P<owner>.+)\. All rights reserved\.$', re.IGNORECASE),
	re.compile(r'^\(c\) (?P<year>\d\d\d\d) (?P<owner>.+)\.?$', re.IGNORECASE),
	]

# 2009 toxicsoftware.com All rights reserved.

def SanitizeCopyright(s):
	theMatches = [thePattern.match(s) for thePattern in theCopyrightPatterns]
	theMatches = [theMatch for theMatch in theMatches if theMatch]

	if not len(theMatches):
		raise Exception('Could not match copyright: %s' % s)

	theMatch = theMatches[0]
	d = theMatch.groupdict()
	if d['owner'] in ['Jonathan Wight', '__MyCompanyName__', 'Toxic Software', 'TouchCode']:
		d['owner'] = 'toxicsoftware.com'

	return '%(year)s %(owner)s. All rights reserved.' % d


########################################################################

for f in files():
	try:
		s = file(f).read()
		theMatches = [thePattern.search(s) for thePattern in thePatterns]
		theMatches = [theMatch for theMatch in theMatches if theMatch]

		theNewText = None
		if not len(theMatches):
			print 'NO MATCH:', f
			d = {}
			d['project'] = 'TouchCode'
			d['filename'] = os.path.split(f)[1]
			d['copyright'] = '2009 toxicsoftware.com. All rights reserved.' % d
			d['creator'] = 'Jonathan Wight'
			d['date'] = '20100422'
			theReplacement = FORMAT % d
			theNewText = theReplacement + s
		else:
			theMatches.sort(lambda X,Y:cmp(len(X.groups()[0]), len(Y.groups()[0])))
			theMatch = theMatches[-1]
			thePattern = theMatch.re

			d = theMatch.groupdict()

			if 'creator' not in d or not d['creator']:
				d['creator'] = 'Jonathan Wight'

			d['project'] = 'TouchCode'
			d['filename'] = os.path.split(f)[1]
			del d['block']

			d['copyright'] = SanitizeCopyright(d['copyright'])

			theReplacement = FORMAT % d
			theNewText = thePattern.sub(theReplacement, s)

		if theNewText and theNewText != s:
			print 'Rewriting, ', f
			file(f, 'w').write(theNewText)
# 		else:
# 			print 'Skipping, ', f
	except Exception, e:
		print 'Exception occured (%s). Skipping: %s' % (e, f)
#		traceback.print_tb(sys.exc_info()[2])
