DROP TABLE IF EXISTS version;

CREATE TABLE IF NOT EXISTS version (
	id INTEGER PRIMARY KEY ON CONFLICT REPLACE AUTOINCREMENT,
	version NOT NULL
	);

INSERT INTO version (id, version) VALUES(1, 1);

-- #####################################################################

DROP TABLE IF EXISTS feed;

CREATE TABLE IF NOT EXISTS feed (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	created DEFAULT CURRENT_TIMESTAMP,
	modified DEFAULT CURRENT_TIMESTAMP,
	lastChecked,
	url UNIQUE,
	title,
	subtitle,
	link
	);
	
INSERT INTO feed (url) VALUES("http://www.barackobama.com/rss/press/news.xml");
INSERT INTO feed (url) VALUES("http://www.barackobama.com/rss/press/press.xml");

-- #####################################################################


DROP TABLE IF EXISTS entry;

CREATE TABLE IF NOT EXISTS entry (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	created DEFAULT CURRENT_TIMESTAMP,
	modified DEFAULT CURRENT_TIMESTAMP,
	feed_id,
	identifier,
	title,
	subtitle,
	content,
	link,
	updated
--	eventInfo,
--	eventDate,
--	latitude,
--	longitude,
--	mediaThumbnailLink,
--	mediaLink
	);

DROP INDEX IF EXISTS entry_index_1;

CREATE UNIQUE INDEX IF NOT EXISTS entry_index_1 ON entry (feed_id, identifier);
