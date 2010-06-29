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

from google.appengine.ext import webapp

import os
from google.appengine.ext.webapp import template

from google.appengine.ext import db
from google.appengine.api import users
import logging
import simplejson as json
import datetime

from model import *
import datetime
import PyRSS2Gen


class ServiceHandler(webapp.RequestHandler):
	def get(self):
		action = self.request.get('action')
		user = users.get_current_user()

		if action == 'create':
			identifier = self.request.get('identifier')
			args = dict(
				created = datetime.datetime.utcnow(),
				owner = user,
				identifier = identifier,
				)
			theRecord = Service(**args)
			db.put(theRecord)

#		services = db.GqlQuery("SELECT * FROM Service ORDER BY created DESC")
		services = Service.gql('ORDER BY created DESC')

		args = dict(
			action = action,
			user = user,
			headers = str(self.request.headers),
			environ = str(self.request.environ),
			services = services,
			)

		path = os.path.join(os.path.dirname(__file__), 'templates/services/index.html')
		self.response.out.write(template.render(path, args))

class ServiceRSSHandler(webapp.RequestHandler):
	def get(self):
# 		user = users.get_current_user()
		services = Service.gql('ORDER BY created DESC')

		theItems = []
		for service in services:
			theItem = PyRSS2Gen.RSSItem(
				title = service.identifier,
				link = "TODO",
				description = "TODO",
				guid = PyRSS2Gen.Guid("TODO"),
				pubDate = service.created
				)
			theItems.append(theItem)

		rss = PyRSS2Gen.RSS2(
			title = "TEST",
			link = "http://www.dalkescientific.com/Python/PyRSS2Gen.html",
			description = "TEST",
			lastBuildDate = datetime.datetime.now(),
			items = theItems,
			)

#		self.response.out.write(template.render(path, args))

		rss.write_xml(self.response.out)
