<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" version="1.0" encoding="utf-8" doctype-public="-//Apple//DTD PLIST 1.0//EN" doctype-system="http://www.apple.com/DTDs/PropertyList-1.0.dtd"/>

<xsl:template match="/">
	<plist version="1.0">
		<xsl:apply-templates/>
	</plist>
</xsl:template>

<xsl:template match="menu">
	<dict>
		<key>title</key>
		<string><xsl:value-of select="@title"/></string>
		<xsl:apply-templates/>
	</dict>
</xsl:template>

<xsl:template match="items">
	<key>items</key>
	<array>
		<xsl:apply-templates/>
	</array>
</xsl:template>

<xsl:template match="item">
	<dict>
		<xsl:if test="@title">
			<key>title</key>
			<string><xsl:value-of select="@title"/></string>
		</xsl:if>
		<xsl:apply-templates/>
	</dict>
</xsl:template>

<xsl:template match="separator">
	<dict>
		<key>className</key>
		<string>CMenuSeparatorItem</string>
	</dict>
</xsl:template>


<xsl:template match="submenu">
	<key>submenu</key>
	<dict>
		<xsl:if test="@title">
			<key>title</key>
			<string><xsl:value-of select="@title"/></string>
		</xsl:if>
		<xsl:apply-templates/>
	</dict>
</xsl:template>

<xsl:template match="image">
	<key>iconName</key>
	<string><xsl:value-of select="@href"/></string>
</xsl:template>

<xsl:template match="controller">
	<key>controller</key>
	<string><xsl:value-of select="@name"/></string>
</xsl:template>

<xsl:template match="action">
	<key>action</key>
	<string><xsl:value-of select="@selector"/></string>
	<key>targetPath</key>
	<string><xsl:value-of select="@targetPath"/></string>
</xsl:template>

</xsl:stylesheet>
