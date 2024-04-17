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
    <xsl:template match="@*|node()"> 
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!--Checks for invalid roman numerals using matches function with regex and displays log-message-->
    <xsl:template match="roman">
        <xsl:copy-of select="."/>
        <arab>
        <xsl:choose>
            <xsl:when test="matches(., '[^IVXLCDM]|II[^I]|IIII+|XXXX+|CCCC+|V[^I]|[^I]?I[VX][IVXLCDM]|[^I]?I[^VIX]|MMMM|LC|VIV|VV|LL|DD')">
                <xsl:comment>Please enter valid roman numerals</xsl:comment>
                <xsl:message terminate="no">Please enter valid roman numerals</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="num:romToInt(., 0)"></xsl:value-of>
            </xsl:otherwise>
        </xsl:choose>
        </arab>
    </xsl:template>

    <xsl:function name="num:romToInt" as="xs:integer">
    <xsl:param name="rom" as="xs:string"/>
    <xsl:param name="total" as="xs:integer"/>
    <xsl:choose>
        <xsl:when test="$rom = ''">
            <xsl:sequence select="$total"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'M')">
            <xsl:sequence select="num:romToInt(substring($rom, 2), $total + 1000)"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'CM')">
            <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 900)"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'D')">
            <xsl:sequence select="num:romToInt(substring($rom, 2), $total + 500)"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'CD')">
            <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 400)"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'C')">
            <xsl:choose>
                <xsl:when test="starts-with(substring($rom, 2), 'M')">
                    <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 900)"/>
                </xsl:when>
                <xsl:when test="starts-with(substring($rom, 2), 'D')">
                    <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 400)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="num:romToInt(substring($rom, 2), $total + 100)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'XC')">
            <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 90)"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'L')">
            <xsl:sequence select="num:romToInt(substring($rom, 2), $total + 50)"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'XL')">
            <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 40)"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'X')">
            <xsl:choose>
                <xsl:when test="starts-with(substring($rom, 2), 'C')">
                    <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 90)"/>
                </xsl:when>
                <xsl:when test="starts-with(substring($rom, 2), 'L')">
                    <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 40)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="num:romToInt(substring($rom, 2), $total + 10)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'IX')">
            <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 9)"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'V')">
            <xsl:sequence select="num:romToInt(substring($rom, 2), $total + 5)"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'IV')">
            <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 4)"/>
        </xsl:when>
        <xsl:when test="starts-with($rom, 'I')">
            <xsl:choose>
                <xsl:when test="starts-with(substring($rom, 2), 'X')">
                    <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 9)"/>
                </xsl:when>
                <xsl:when test="starts-with(substring($rom, 2), 'V')">
                    <xsl:sequence select="num:romToInt(substring($rom, 3), $total + 4)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="num:romToInt(substring($rom, 2), $total + 1)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
            <xsl:sequence select="0"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

</xsl:transform>