<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:pc="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns:pt="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
    xmlns:in="http://www.intern.de"
    xmlns:gt="http://www.ocr-d.de/GT/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:ns3="http://www.loc.gov/METS/"
    exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output indent="yes" omit-xml-declaration="yes" method="xml"/>
    
    
    <xsl:param name="repoName"/>
    <xsl:param name="repoBase"/>
    <xsl:param name="bagitDumpNum"/>
    <xsl:param name="releaseTag"/>
    
    
    
    
    <xsl:variable name="docMETADATA">
        <xsl:copy-of select="json-to-xml(unparsed-text('../CITATION.json'))"/>
    </xsl:variable>
    
    <xsl:param name="output"/>

    <xsl:template match="/">

<xsl:if test="$output = 'CITATION'">
    <xsl:variable name="Author">
        <xsl:if test="$docMETADATA//fn:map/fn:array/@key='authors'">authors:<xsl:for-each select="$docMETADATA//fn:map/fn:array[@key='authors']/fn:map">
                <xsl:variable name="combinedValue_name" select="fn:string[@key='name'] | fn:string[@key='given-names']"/>
                <xsl:variable name="combinedValue_surname" select="fn:string[@key='surname'] | fn:string[@key='family-names']"/>
                <xsl:if test="fn:string[@key='name'] or fn:string[@key='given-names'] !=''">
                  - given-names: <xsl:value-of select="$combinedValue_name"/></xsl:if>
                <xsl:if test="fn:string[@key='surname'] | fn:string[@key='family-names'] !=''">
                    family-names: <xsl:value-of select="$combinedValue_surname"/></xsl:if>
                <xsl:if test="fn:string[@key='orcid'] !=''">
                    orcid: 'https://orcid.org/<xsl:value-of select="fn:string[@key='orcid']"/>'</xsl:if>
            </xsl:for-each></xsl:if>
    </xsl:variable>cff-version: 1.2.0
title: <xsl:value-of select="$docMETADATA//fn:map/fn:string[@key='title']"/>
message: If you use this dataset, please cite it using the metadata from this file.
type: dataset
<xsl:value-of select="$Author"/>
repository-code: '<xsl:text>https://github.com/</xsl:text><xsl:value-of select="$repoName"/>'
url: '<xsl:text>https://github.com/</xsl:text><xsl:value-of select="$repoName"/>'
abstract: <xsl:value-of select="normalize-space($docMETADATA//fn:map/fn:string[@key='abstract'])"/>
keywords:<xsl:for-each select="$docMETADATA//fn:map/fn:array[@key='keywords']/fn:string">
 - <xsl:value-of select="."/>
    </xsl:for-each>
license: <xsl:value-of select="$docMETADATA//fn:map/fn:string[@key='license']"/>
commit: <xsl:value-of select="$releaseTag"/>
version: <xsl:value-of select="$bagitDumpNum"/>_<xsl:value-of select="$releaseTag"/>
date-released: '<xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>'</xsl:if>
</xsl:template>
</xsl:stylesheet>
