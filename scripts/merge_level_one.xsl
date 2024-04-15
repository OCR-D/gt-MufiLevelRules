<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:pc="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns:pt="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
    xmlns:in="http://www.intern.de" xmlns:gt="http://www.ocr-d.de/GT/"
    xmlns:mets="http://www.loc.gov/METS/" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:ns3="http://www.loc.gov/METS/" exclude-result-prefixes="#all" version="3.0">
    <xsl:output indent="yes" omit-xml-declaration="no" method="xml"/>


    <xsl:param name="repoName"/>
    <xsl:param name="repoBase"/>
    <xsl:param name="bagitDumpNum"/>
    <xsl:param name="releaseTag"/>
    <xsl:param name="rulesetxml">megalevelrules.xml</xsl:param>
    <xsl:param name="levelsetxml">norm_level_one.xml</xsl:param>
    <xsl:param name="rulesetPath">.</xsl:param>
    <xsl:param name="exception">exception.xml</xsl:param>

    <xsl:variable name="excep">
        <xsl:copy-of select="document($exception)"/>
    </xsl:variable>


    <xsl:variable name="ruleset">
        <xsl:copy-of select="document($rulesetPath/$rulesetxml)"/>
    </xsl:variable>

    <xsl:variable name="levelset">
        <xsl:copy-of select="document($rulesetPath/$levelsetxml)"/>
    </xsl:variable>



    <xsl:template match="/">
        <levelrules>

            <xsl:for-each select="$ruleset//ruleset">
                <xsl:variable name="megadesc" select="desc"/>
                <xsl:variable name="rpositio" select="fn:position()"/>
                <xsl:variable name="leveldesc">
                    <xsl:for-each select="$levelset//l1/@t"><xsl:value-of select="."/></xsl:for-each>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$megadesc = $excep//exception/desc[@t = 'CombDiaMk']"/>
                    <xsl:when test="$megadesc = $excep//exception/desc[@t = 'BasLat']"/>
                    <xsl:when test="$megadesc = $excep//exception/desc[@t = 'GenPunct']"/>
                    <xsl:when test="$megadesc = $excep//exception/desc[@t = 'Lat1Suppl']"/>
                    <!--<xsl:when test="$megadesc = $excep//exception/desc[@t = 'GeomShap']"/>-->
                    <xsl:otherwise>
                        <ruleset>
                            <xsl:copy-of select="range"/>
                            <xsl:copy-of select="desc"/>
                            <!--<xsl:if test="$megadesc = $leveldesc">
                            <rule>
                                <xsl:value-of select="$levelset//l1[$rpositio]"/>
                            </rule>
                        </xsl:if>-->

                            <xsl:choose>
                                <xsl:when test="//$levelset//l1[@t = $megadesc]">
                                    <rule>
                                        <xsl:value-of select="//$levelset//l1[@t = $megadesc]"/>
                                    </rule>
                                </xsl:when>
                                <xsl:otherwise>

                                    <xsl:choose>
                                        <xsl:when
                                            test="$megadesc = $excep//exception/desc[contains(@t, 'PUA')]">
                                            <rule/>
                                        </xsl:when>
                                        <xsl:when
                                            test="$megadesc = $excep//exception/desc[contains(@t, 'PUNCTUATION')]">
                                            <xsl:copy-of select="rule[1]"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="$megadesc = $excep//exception/desc[@t = 'AncSymb']">
                                            <xsl:copy-of select="rule[1]"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="$megadesc = $excep//exception/desc[@t = 'CurrSymb']">
                                            <xsl:copy-of select="rule[1]"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:copy-of select="rule[1]"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:copy-of select="rule[2]"/>
                            <xsl:copy-of select="rule[3]"/>
                            <xsl:copy-of select="type"/>
                        </ruleset>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </levelrules>
    </xsl:template>





</xsl:stylesheet>
