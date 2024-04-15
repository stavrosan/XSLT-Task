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

</xsl:transform>