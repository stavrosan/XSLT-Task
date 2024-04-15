<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:num="http://whatever"
    version="2.0" exclude-result-prefixes="xs num">

    <xsl:output method="xml" version="1.0"
        encoding="UTF-8" indent="yes"/>
    <!--To remove uneccessary space in the output-->
    <xsl:strip-space elements="*"/>


    <!-- identity transform to copy elements and attributes of the input xml -->
    <xsl:template match="@*|node()"> <!--The @* matches any attribute node-->
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/><!--Process all the attribute nodes as well as the child nodes-->
        </xsl:copy>
    </xsl:template>
    
    <!--Checks for invalid roman numerals using matches function with regex and displays log-message-->
    <xsl:template match="roman">
        <xsl:copy-of select="."/>
        <arab>
        <xsl:choose>
            <xsl:when test="matches(., '[^IVXLCDM]|II[^I]|IIII+|XXXX+|CCCC+|V[^I]|[^I]?I[VX][IVXLCDM]|[^I]?I[^VIX]|MMMM')">
                <xsl:comment>Please enter valid roman numerals</xsl:comment>
                <xsl:message terminate="no">Please enter valid roman numerals</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="num:romToInt(., 0)"></xsl:value-of>
            </xsl:otherwise>
        </xsl:choose>
        </arab>
    </xsl:template>
    
    <!--Convert roman numbers to arab function-->
    <xsl:function name="num:romToInt" as="xs:integer">
        <xsl:param name="rom" as="xs:string"/>
        <xsl:param name="val" as="xs:integer"/>
        <xsl:choose>
            <xsl:when test="ends-with($rom,'M')">
                <xsl:sequence select="1000+ num:romToInt(substring($rom,1,string-length($rom)-1), 1000)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'CM')">
                <xsl:sequence select="900+ num:romToInt(substring($rom,1,string-length($rom)-2), 900)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'D')">
                <xsl:sequence select="500+ num:romToInt(substring($rom,1,string-length($rom)-1), 500)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'CD')">
                <xsl:sequence select="400+ num:romToInt(substring($rom,1,string-length($rom)-2), 400)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'XC')">
                <xsl:sequence select="90+ num:romToInt(substring($rom,1,string-length($rom)-2), 90)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'C')">
                <xsl:sequence select="(if(100 ge number($val)) then 100 else -100)+ num:romToInt(substring($rom,1,string-length($rom)-1), 100)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'L')">
                <xsl:sequence select="50+ num:romToInt(substring($rom,1,string-length($rom)-1), 50)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'XL')">
                <xsl:sequence select="40+ num:romToInt(substring($rom,1,string-length($rom)-2), 40)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'X')">
                <xsl:sequence select="(if(10 ge number($val)) then 10 else -10) + num:romToInt(substring($rom,1,string-length($rom)-1), 10)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'IX')">
                <xsl:sequence select="9+ num:romToInt(substring($rom,1,string-length($rom)-2), 9)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'V')">
                <xsl:sequence select="5+ num:romToInt(substring($rom,1,string-length($rom)-1), 5)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'IV')">
                <xsl:sequence select="4+ num:romToInt(substring($rom,1,string-length($rom)-2), 4)"/>
            </xsl:when>
            <xsl:when test="ends-with($rom,'I')">
                <xsl:sequence select="(if(1 ge number($val)) then 1 else -1)+ num:romToInt(substring($rom,1,string-length($rom)-1), 1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:transform>