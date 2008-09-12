typedef enum {
	RSSElementNameCode_RSS = 1,
	RSSElementNameCode_Channel = 2,
	RSSElementNameCode_Item = 3,

	RSSElementNameCode_Title = 4,
	RSSElementNameCode_Link = 5,
	RSSElementNameCode_Description = 6,
	RSSElementNameCode_Language = 7,
	RSSElementNameCode_PubDate = 8,
	RSSElementNameCode_LastBuildDate = 9,
	RSSElementNameCode_Docs = 10,
	RSSElementNameCode_Generator = 11,
	RSSElementNameCode_ManagingEditor = 12,
	RSSElementNameCode_TTL = 13,

	RSSElementNameCode_GUID = 14,


} ERSSElementNameCode;


extern ERSSElementNameCode CodeForElementName(const xmlChar *inElementName);

extern SEL SelectorForElementName(const char *inElementName, int inLength);
