<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">
    <xsl:output indent="yes" omit-xml-declaration="no" method="xml" normalization-form="none"
        cdata-section-elements="ocr-d"/>


    <xsl:param name="exception">exception.xml</xsl:param>

    <xsl:variable name="excep">
        <xsl:copy-of select="document($exception)"/>
    </xsl:variable>

    <xsl:template match="levelrules">
        <root>
            <xsl:apply-templates/>
        </root>
    </xsl:template>

    <xsl:template match="ruleset">
        <xsl:choose>
            <xsl:when test="desc = $excep//exception/desc"/>
            <xsl:otherwise>
                <l1><xsl:attribute name="t"><xsl:value-of select="desc"/></xsl:attribute>
                <xsl:choose>
                    <xsl:when test="rule[1] = '&lt;'">&lt;</xsl:when>
                    <xsl:when test="rule[1] = '>'">&gt;</xsl:when>
                <xsl:otherwise><xsl:value-of select="rule[1]"/></xsl:otherwise>
                </xsl:choose></l1>
            </xsl:otherwise>
        </xsl:choose>

</xsl:template>


    <xsl:template match="/|@*|node()">
        <xsl:apply-templates/>
    </xsl:template>



</xsl:stylesheet>
