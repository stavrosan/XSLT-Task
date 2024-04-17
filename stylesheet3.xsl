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
          
    <!--Avoid double roman elements-->
    <!-- <xsl:template match="calc[normalize-space(roman)]"/> -->

     <!-- Remove duplicate <calc> elements -->
  <!-- <xsl:template match="calc[(generate-id() = generate-id(key('distinct-calc', concat(calc[arab], '|', roman))[1]))]"/> -->

  <!-- Key to identify unique <calc> elements -->
  <!-- <xsl:key name="distinct-calc" match="calc" use="concat(calc[arab], '|', roman)" /> -->
    
    <!-- identity transform -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>   

    <!--Convert arab numbers to roman using the number format-->
    <xsl:template match="calc[arab]">
      <xsl:copy>
      <roman>
        <xsl:choose>
          <xsl:when test="1 le number(arab) and number(arab) le 3999">
                <xsl:number value="arab" format="I"/>  
          </xsl:when>
          <xsl:otherwise>
          <xsl:comment>Please enter a number between 1-3999</xsl:comment>
          <xsl:message terminate="no">Enter a number between 1-3999</xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </roman>
      <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template> 

   <!--Checks for invalid roman numerals using matches function with regex and displays log-message-->
   <xsl:template match="roman">
        <xsl:copy-of select="."/>
        <arab>
        <xsl:choose>
            <xsl:when test="matches(., '[^IVXLCDM]|II[^I]|IIII+|XXXX+|CCCC+|V[^I]|[^I]?I[VX][IVXLCDM]|[^I]?I[^VIX]|MMMM|LC|VIV|VV|LL|DD|DM')">
                <xsl:comment>Please enter valid roman numerals</xsl:comment>
                <xsl:message terminate="no">Please enter valid roman numerals</xsl:message>
            </xsl:when>
            <!--If numerals are valid a function is triggered-->
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