<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
  method="html" encoding="utf-8"/>

<xsl:template match="/instructionsection">
    <html>

    <head>
      <link rel="stylesheet" type="text/css" href="insn.css"/>
      <meta name="generator" content="instrsection.xsl"/>
      <title><xsl:value-of select="@title"/></title>
    </head>

    <body>
    <table align="center">
      <tr>
        <!-- autogenerator: header/footer start -->
        <!-- autogenerated -->
	<td><div class="topbar"><a href="index.xml">Base Instructions</a></div></td>
	<td><div class="topbar"><a href="fpsimdindex.xml">SIMD&amp;FP Instructions</a></div></td>
	<td><div class="topbar"><a href="sveindex.xml">SVE Instructions</a></div></td>
	<td><div class="topbar"><a href="encodingindex.xml">Index by Encoding</a></div></td>
	<td><div class="topbar"><a href="shared_pseudocode.xml">Shared Pseudocode</a></div></td>
	<td><div class="topbar"><a href="notice.xml">Proprietary Notice</a></div></td>
        <!-- autogenerator: header/footer end -->
      </tr>
    </table>  

    <hr/>

    <xsl:apply-templates/>

    <hr/>

    <table align="center">
      <tr>
        <!-- autogenerator: header/footer start -->
        <!-- autogenerated -->
	<td><div class="topbar"><a href="index.xml">Base Instructions</a></div></td>
	<td><div class="topbar"><a href="fpsimdindex.xml">SIMD&amp;FP Instructions</a></div></td>
	<td><div class="topbar"><a href="sveindex.xml">SVE Instructions</a></div></td>
	<td><div class="topbar"><a href="encodingindex.xml">Index by Encoding</a></div></td>
	<td><div class="topbar"><a href="shared_pseudocode.xml">Shared Pseudocode</a></div></td>
	<td><div class="topbar"><a href="notice.xml">Proprietary Notice</a></div></td>
        <!-- autogenerator: header/footer end -->
      </tr>
    </table>  
    <!-- version footer -->
    <p class="versions">
        Internal version only: isa v32.03, AdvSIMD v29.02, pseudocode v2020-03, sve v2020-03_rc1      
        ; Build timestamp: 2020-04-15T14:28
    </p>
    <p class="copyconf">
      Copyright &#169; 2010-2020 Arm Limited or its affiliates. All rights reserved.
      This document is Non-Confidential.
    </p>
    </body>

    </html>
  </xsl:template>

  <xsl:template match="/instructionsection/heading">
    <h2 class="instruction-section"><xsl:value-of select="."/></h2>
  </xsl:template>

  <xsl:template match="desc">
    <xsl:choose>
      <xsl:when test="./authored">
        <xsl:apply-templates select="./authored"/>
      </xsl:when>
      <xsl:otherwise>
        <p id="desc">
          <xsl:apply-templates/>.
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="desc/authored">
    <p id="desc">    
      <xsl:apply-templates select="./aml"/>
    </p>
  </xsl:template>

  <xsl:template match="desc/brief">
    <xsl:value-of select="."/>
    <xsl:if test="@orphanslink">
      .  See <a href="{@orphanslink}">orphan pseudocode</a> for pseudocode 
      which belongs to encodings but is not yet linked to instruction pages
    </xsl:if>
  </xsl:template>

  <xsl:template match="desc/alg">
    <xsl:choose>
      <xsl:when test="@howmany > 1"><br /></xsl:when>
      <xsl:otherwise>: </xsl:otherwise>
    </xsl:choose>
    <span class="desc-alg"><xsl:value-of select="."/></span>
  </xsl:template>

  <xsl:template match="desc/longer">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="/instructionsection/ps_section">
    <xsl:if test="@howmany > 1">
      <h2 class="pseudocode">Pseudocodes</h2>
    </xsl:if>
    <div class="ps_section">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="aml-para">
    <p class="aml-para">
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="aml-bullets">
    <ul class="aml-bullet">
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="aml-bullet">
    <li class="sml-bullet">
      <xsl:apply-templates />
    </li>
  </xsl:template>

  <xsl:template match="ps_section/codegroup">
    <xsl:if test="@heading">
      <a name="{@id}">
        <h3 class="ps.codegroup"><xsl:value-of select="@heading"/></h3>
      </a>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="codegroup/code">
    <xsl:if test="@heading">
      <h4 class="ps.code"><xsl:value-of select="@heading"/></h4>
    </xsl:if>
    <xsl:if test="./codeintro">
      <div class="psintro">
        <xsl:apply-templates select="./codeintro" />
      </div>
    </xsl:if>
    <p class="pseudocode">
      <xsl:apply-templates select="./asl_line"/>
    </p>
  </xsl:template>

  <xsl:template match="code/asl_line">
    <xsl:choose>
      <xsl:when test="@dontshow='1'">
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/><br />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="anchor">
    <a name="{@link}"><xsl:value-of select="."/></a>
  </xsl:template>

  <xsl:template match="a">
    <a href="{@file}#{@link}" title="{@hover}"><xsl:value-of select="."/></a>
  </xsl:template>
</xsl:stylesheet>
