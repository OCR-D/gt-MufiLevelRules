<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:pc="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns:wt="https://github.com/dariok/w2tei"
     exclude-result-prefixes="#all" version="3.0">
    <xsl:output name="txt_out" indent="yes" omit-xml-declaration="yes" method="text" normalization-form="none"/>
    <xsl:output name="xml_out" indent="yes" omit-xml-declaration="no" method="xml" normalization-form="none" cdata-section-elements="ocr-d"/>
    

    
    <xsl:param name="output"/>
    <xsl:param name="release"/>
    <xsl:param name="merge"/>
    
    
    
    <xsl:variable name="MUFIEXPORT">
        <!--via mufi page-->
        <!--<xsl:copy-of select="json-to-xml(unparsed-text('https://mufi.info/m.php?p=mufiexport'))"/>-->
        <!--via local from GitHub Repo keyboardGT-->
        <xsl:copy-of select="json-to-xml(unparsed-text('../metadata/mufi.json'))"/>
    </xsl:variable>
    
    
    <xsl:variable name="OCRDrulesIMPORT">
        <xsl:copy-of select="json-to-xml(unparsed-text('../metadata/megarules.json'))"/>
    </xsl:variable>

    <!-- hexToDec from https://github.com/dariok/w2tei/blob/master/word-pack.xsl and 
        see https://stackoverflow.com/questions/22905134/convert-a-hexadecimal-number-to-an-integer-in-xslt/22907739#22907739
        Thank you Tobias Klevenz and Dario Kampkaspar
    -->

    <xsl:function name="wt:hexToDec">
        <xsl:param name="hex"/>
        <xsl:variable name="dec"
            select="string-length(substring-before('0123456789ABCDEF', substring($hex,1,1)))"/>
        <xsl:choose>
            <xsl:when test="matches($hex, '([0-9]*|[A-F]*)')">
                <xsl:value-of
                    select="if ($hex = '') then 0
                    else $dec * math:pow(16, string-length($hex) - 1) + wt:hexToDec(substring($hex,2))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Provided value is not hexadecimal...</xsl:message>
                <xsl:value-of select="$hex"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>



    <xsl:template match="/">
        <xsl:if test="$output = 'characters'">
                <xsl:call-template name="char"/>
        </xsl:if>
        <xsl:if test="$merge = 'yes'">
           <xsl:result-document format="xml_out" href="ghout/rules/megalevelrules.xml">
                <xsl:merge>
                    <xsl:merge-source for-each-item="collection('../ghout/rules/characters/?select=*.xml')" select="levelrules">
                        <xsl:merge-key select="range" order="ascending"/>
                    </xsl:merge-source>
                    <xsl:merge-action>
                        <xsl:sequence select="current-merge-group()"/>
                    </xsl:merge-action>
                </xsl:merge>
            </xsl:result-document>
        </xsl:if>
    </xsl:template>


    <xsl:template match="$MUFIEXPORT//fn:array" name="char">
        
        <xsl:for-each-group select="$MUFIEXPORT//fn:map" group-by="fn:string[@key = 'range']">
            <xsl:sort select="fn:current-grouping-key()"/>
            <xsl:result-document format="txt_out" href="ghout/rules/characters/{fn:current-grouping-key()}.json">
                {"ruleset":[
                <xsl:variable name="keys"><line>
                    <xsl:for-each-group select="fn:current-group()" group-by="fn:string[@key = 'alpha']">
                        <xsl:sort order="ascending" select="fn:string[@key = 'alpha']"/>
                        <xsl:for-each select="fn:current-group()">
                            <xsl:variable name="mufi">
                                <xsl:choose>
                                    <xsl:when test="fn:string[@key = 'mufichar'] = '&quot;'"><![CDATA[\"]]></xsl:when>
                                    <xsl:when test="fn:string[@key = 'mufichar'] = '\'"><![CDATA[\\]]></xsl:when>
                                    <xsl:when test="contains(fn:string[@key = 'mufichar'], '◌')"><xsl:value-of select="replace(fn:string[@key = 'mufichar'], '◌','')"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="fn:string[@key = 'mufichar']"/></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            
                            <xsl:variable name="c1">
                                <xsl:for-each select="$OCRDrulesIMPORT//fn:array">
                                    <xsl:choose><xsl:when test="fn:string[1] = $mufi"><xsl:value-of select="$mufi"/></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="fn:string[2] = $mufi"><xsl:value-of select="fn:string[1]"/></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="fn:string[3] = $mufi"><xsl:value-of select="fn:string[1]"/></xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:variable name="c2">
                                <xsl:for-each select="$OCRDrulesIMPORT//fn:array"><xsl:if test="fn:string[3] = $mufi"><xsl:choose><xsl:when test="fn:string[2] = $mufi">"<xsl:value-of select="$mufi"/>",</xsl:when><xsl:otherwise>"<xsl:value-of select="fn:string[2]"/>",</xsl:otherwise></xsl:choose></xsl:if></xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:variable name="mufic2">
                                <xsl:choose>
                                    <xsl:when test="contains(fn:string[@key = 'range'], 'PUA')">
                                        <xsl:choose>
                                            <xsl:when test="contains(fn:string[@key = 'codepointalt'], '+')">"<xsl:for-each select="fn:tokenize(fn:string[@key = 'codepointalt'], ' \+ ')">
                                                <xsl:value-of select="codepoints-to-string(wt:hexToDec(.))"/></xsl:for-each>",</xsl:when>
                                            <xsl:otherwise></xsl:otherwise>
                                        </xsl:choose></xsl:when>
                                    <xsl:otherwise>"<xsl:value-of select="$mufi"/>",</xsl:otherwise>
                                </xsl:choose></xsl:variable>
                            
                            <xsl:variable name="c3">
                                <xsl:for-each select="$OCRDrulesIMPORT//fn:array">
                                    <xsl:choose><xsl:when test="fn:string[3] = $mufi"><xsl:value-of select="$mufi"/></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="fn:string[2] = $mufi"><xsl:value-of select="fn:string[3]"/></xsl:when></xsl:choose></xsl:otherwise></xsl:choose>
                                </xsl:for-each>
                            </xsl:variable>
                            
                                {"rule": [<xsl:choose>
                                    <!-- level1 -->
                                    <xsl:when test="fn:string[@key = 'range'] ='BasLat'">"<xsl:value-of select="$mufi"/>",</xsl:when><xsl:otherwise><xsl:choose>
                                        <xsl:when test="$c1 !=''">"<xsl:value-of select="$c1"/>",</xsl:when><xsl:otherwise>"",</xsl:otherwise>
                                    </xsl:choose></xsl:otherwise>
                                </xsl:choose>
                            <!-- level2 -->
                            <xsl:choose>
                                <xsl:when test="$c2 = $mufic2"><xsl:choose>
                                    <xsl:when test="$mufic2 !=''"><xsl:value-of select="$mufic2"/></xsl:when><xsl:otherwise>"<xsl:value-of select="$mufi"/>",</xsl:otherwise>
                                </xsl:choose></xsl:when><xsl:otherwise><xsl:choose>
                                    <xsl:when test="$c2 !=''"><xsl:value-of select="$c2"/></xsl:when><xsl:otherwise><xsl:value-of select="$mufic2"/></xsl:otherwise>
                                </xsl:choose></xsl:otherwise>
                            </xsl:choose><!-- level3 -->
                            <xsl:choose>
                                <xsl:when test="fn:string[@key = 'range'] ='BasLat'">"<xsl:value-of select="$mufi"/>"], "type": "level"}<komma/></xsl:when><xsl:otherwise><xsl:choose>
                                <xsl:when test="$c3 !=''">"<xsl:value-of select="$c3"/>"], "type": "level"}<komma/></xsl:when><xsl:otherwise>"<xsl:value-of select="$mufi"/>"], "type": "level"}<komma/></xsl:otherwise>
                            </xsl:choose></xsl:otherwise></xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each-group>
                </line></xsl:variable>
                
                <xsl:for-each select="$keys/line">
                    <xsl:apply-templates/>
                </xsl:for-each>
                ]}
            </xsl:result-document>
            

            


        
            <xsl:result-document format="xml_out" href="ghout/rules/characters/{fn:current-grouping-key()}.xml">
                <xsl:variable name="keys">
                <olevelrules/>
                    <xsl:for-each-group select="fn:current-group()" group-by="fn:string[@key = 'alpha']">
                        <xsl:sort order="ascending" select="fn:string[@key = 'alpha']"/>
                        <xsl:for-each select="fn:current-group()">
                            <xsl:variable name="mufi">
                                <xsl:choose>
                                    <!--<xsl:when test="fn:string[@key = 'mufichar'] = '&quot;'"><![CDATA[\"]]></xsl:when>
                                    <xsl:when test="fn:string[@key = 'mufichar'] = '\'"><![CDATA[\\]]></xsl:when>-->
                                    <xsl:when test="contains(fn:string[@key = 'mufichar'], '◌')"><xsl:value-of select="replace(fn:string[@key = 'mufichar'], '◌','')"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="fn:string[@key = 'mufichar']"/></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            
                            <xsl:variable name="c1">
                                <xsl:for-each select="$OCRDrulesIMPORT//fn:array">
                                    <xsl:choose><xsl:when test="fn:string[1] = $mufi"><xsl:value-of select="$mufi"/></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="fn:string[2] = $mufi"><xsl:value-of select="fn:string[1]"/></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="fn:string[3] = $mufi"><xsl:value-of select="fn:string[1]"/></xsl:when></xsl:choose></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose>
                                </xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:variable name="c2">
                                <xsl:for-each select="$OCRDrulesIMPORT//fn:array"><xsl:if test="fn:string[3] = $mufi"><xsl:choose><xsl:when test="fn:string[2] = $mufi"><xsl:value-of select="$mufi"/></xsl:when><xsl:otherwise><xsl:value-of select="fn:string[2]"/></xsl:otherwise></xsl:choose></xsl:if></xsl:for-each>
                            </xsl:variable>
                            
                            <xsl:variable name="mufic2">
                                <xsl:choose>
                                    <xsl:when test="contains(fn:string[@key = 'range'], 'PUA')">
                                        <xsl:choose>
                                            <xsl:when test="contains(fn:string[@key = 'codepointalt'], '+')">"<xsl:for-each select="fn:tokenize(fn:string[@key = 'codepointalt'], ' \+ ')">
                                                <xsl:value-of select="codepoints-to-string(wt:hexToDec(.))"/></xsl:for-each>",</xsl:when>
                                            <xsl:otherwise></xsl:otherwise>
                                        </xsl:choose></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$mufi"/></xsl:otherwise>
                                </xsl:choose></xsl:variable>
                            
                            <xsl:variable name="c3">
                                <xsl:for-each select="$OCRDrulesIMPORT//fn:array">
                                    <xsl:choose><xsl:when test="fn:string[3] = $mufi"><xsl:value-of select="$mufi"/></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="fn:string[2] = $mufi"><xsl:value-of select="fn:string[3]"/></xsl:when></xsl:choose></xsl:otherwise></xsl:choose>
                                </xsl:for-each>
                            </xsl:variable>

                           


                            <!-- level1 -->
                            <xsl:choose>
                                <xsl:when test="fn:string[@key = 'range'] ='BasLat'"><olevel/><orange/><xsl:value-of select="fn:string[@key = 'range']"/><crange/><orule/><xsl:value-of select="$mufi"/><crule/></xsl:when><xsl:otherwise><xsl:choose>
                                    <xsl:when test="$c1 !=''"><olevel/><orange/><xsl:value-of select="fn:string[@key = 'range']"/><crange/><orule/><xsl:value-of select="$c1"/><crule/></xsl:when><xsl:otherwise><orange/><xsl:value-of select="fn:string[@key = 'range']"/><crange/><orule/><crule/></xsl:otherwise>
                                </xsl:choose></xsl:otherwise>
                            </xsl:choose>
                            <!-- level2 -->
                            <xsl:choose>
                                <xsl:when test="$c2 = $mufic2"><xsl:choose>
                                    <xsl:when test="$mufic2 !=''"><orule/><xsl:value-of select="$mufic2"/><crule/></xsl:when><xsl:otherwise><orule/><xsl:value-of select="$mufi"/><crule/></xsl:otherwise>
                                </xsl:choose></xsl:when><xsl:otherwise><xsl:choose>
                                    <xsl:when test="$c2 !=''"><orule/><xsl:value-of select="$c2"/><crule/></xsl:when><xsl:otherwise><orule/><xsl:value-of select="$mufic2"/><crule/></xsl:otherwise>
                                </xsl:choose></xsl:otherwise>
                            </xsl:choose>
                            <!-- level3 -->
                            <xsl:choose>
                                <xsl:when test="fn:string[@key = 'range'] ='BasLat'"><orule/><xsl:value-of select="$mufi"/><crule/><otype/>level<ctype/><clevel/></xsl:when><xsl:otherwise><xsl:choose>
                                    <xsl:when test="$c3 !=''"><orule/><xsl:value-of select="$c3"/><crule/><otype/>level<ctype/><clevel/></xsl:when><xsl:otherwise><orule/><xsl:value-of select="$mufi"/><crule/><otype/>level<ctype/><clevel/></xsl:otherwise>
                                </xsl:choose></xsl:otherwise></xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each-group>
                <clevelrules/></xsl:variable>
                
                <xsl:for-each select="$keys">
                    <xsl:apply-templates/>
                </xsl:for-each>
            </xsl:result-document>
        </xsl:for-each-group>
    </xsl:template>

   

    <xsl:template match="sp">
        <xsl:choose>
            <xsl:when test="following-sibling::sp">
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="komma[fn:position() &lt; last()]">,</xsl:template>
    <xsl:template match="olevel"><xsl:text disable-output-escaping="yes">&lt;ruleset&gt;</xsl:text></xsl:template>
    <xsl:template match="clevel"><xsl:text disable-output-escaping="yes">&lt;/ruleset&gt;</xsl:text></xsl:template>
    <xsl:template match="orule"><xsl:text disable-output-escaping="yes">&lt;rule&gt;</xsl:text></xsl:template>
    <xsl:template match="crule"><xsl:text disable-output-escaping="yes">&lt;/rule&gt;</xsl:text></xsl:template>
    <xsl:template match="otype"><xsl:text disable-output-escaping="yes">&lt;type&gt;</xsl:text></xsl:template>
    <xsl:template match="ctype"><xsl:text disable-output-escaping="yes">&lt;/type&gt;</xsl:text></xsl:template>
    <xsl:template match="olevelrules"><xsl:text disable-output-escaping="yes">&lt;levelrules&gt;</xsl:text></xsl:template>
    <xsl:template match="clevelrules"><xsl:text disable-output-escaping="yes">&lt;/levelrules&gt;</xsl:text></xsl:template>
    <xsl:template match="orange"><xsl:text disable-output-escaping="yes">&lt;range&gt;</xsl:text></xsl:template>
    <xsl:template match="crange"><xsl:text disable-output-escaping="yes">&lt;/range&gt;</xsl:text></xsl:template>




</xsl:stylesheet>