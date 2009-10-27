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

from google.appengine.ext import db

class Service(db.Model):
	created = db.DateTimeProperty(required=False)
	modified = db.DateTimeProperty(required=False)
	identifier = db.StringProperty(required=False)
	owner = db.UserProperty()

# class Log(db.Model):
# 	created = db.DateTimeProperty(required=False)

class Upload(db.Model):
	created = db.DateTimeProperty(required=False)
	modified = db.DateTimeProperty(required=False)
	serviceIdentifier = db.StringProperty(required=False)
	service = db.ReferenceProperty(Service)
	contentType = db.StringProperty(required=False)
	headers = db.TextProperty(required=False)
	environ = db.TextProperty(required=False)
	remoteAddress = db.StringProperty(required=False)
	bodyLength = db.IntegerProperty()
	body = db.StringProperty(required=True)
#	body = db.BlobProperty(required=True)
	serviced = db.DateTimeProperty(required=False)

