#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#			http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

import wsgiref.handlers
from google.appengine.ext import webapp
import datetime
from google.appengine.ext import db
from google.appengine.api import users
import logging
import simplejson as json
import hmac
import hashlib
from google.appengine.api import xmpp

from model import *

class AuthError(Exception):
	pass

class UploadHandler(webapp.RequestHandler):
	def get(self):
		self.response.out.write('Hello world!')
	def post(self):
		try:
#			logging.debug(self.request)

			theHeaders = self.request.headers

			theSecurityHeaderKey = 'x-hmac-body-hexdigest'
			theHMACKey = 'sekret'

			if theSecurityHeaderKey not in theHeaders:
				raise AuthError('Security failure')

			body = self.request.body_file.read()

			theSuppliedHMACDigest = theHeaders[theSecurityHeaderKey].strip().lower()
			theBodyHMACDigest = hmac.new(theHMACKey, body, hashlib.sha1).hexdigest().lower()
#			logging.debug('DIGESTS: %s %s', theSuppliedHMACDigest, theBodyHMACDigest)
			if theSuppliedHMACDigest != theBodyHMACDigest:
				raise AuthError('Security failure')

			### Get Body

# 			logging.info('#' * 80)
# 			logging.info('Request: %s' % self.request)
# 			logging.info('BODY: ' + body)

			theContentType = theHeaders['Content-Type'] if 'Content-Type' in theHeaders else None
			theServiceIdentifier = theHeaders['x-service-identifier']
			theRemoteAddress = self.request.environ['REMOTE_ADDR']

			args = dict(
				created = datetime.datetime.utcnow(),
				serviceIdentifier = theServiceIdentifier,
				contentType = theContentType,
				body = body,
				remoteAddress = theRemoteAddress,
				bodyLength = len(body))

			if False:
				theDict = dict(
					headers = json.dumps(dict(theHeaders)),
					environ = str(self.request.environ),
					)
				args.update(theDict)

			if theServiceIdentifier:
				theService = Service.gql("WHERE identifier = :1", theServiceIdentifier).get()
				args['service'] = theService

			f = Upload(**args)
			db.put(f)

# 			user_address = 'jwight@gmail.com'
# 			chat_message_sent = False
# 			status_code = None
# 			if xmpp.get_presence(user_address):
# 				msg = "This is a test"
# 				status_code = xmpp.send_message(user_address, msg)
# 				chat_message_sent = (status_code != xmpp.NO_ERROR)
# 			else:
# 				logging.error('Could not get presence')
# 			if not chat_message_sent:
# 				logging.error('Could not send XMPP message: %s' % str(status_code))
# 				# Send an email message instead...


			self.response.out.write(json.dumps(dict(status = 'OK')))
#		except DeadlineExceededError:
#			self.response.clear()
#			self.response.set_status(500)
#			self.response.out.write("This operation could not be completed in time...")
		except AuthError:
			self.response.clear()
			self.response.set_status(403)
			self.response.out.write("Forbidden")
		except Exception, e:
			self.response.clear()
			self.response.set_status(500)
			self.response.out.write(str(e))

