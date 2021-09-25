<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
 doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
 method="html" encoding="utf-8"/>

  <xsl:template match="/encodingindex">
    <html>

    <head>
      <link rel="stylesheet" type="text/css" href="insn.css"/>
      <meta name="generator" content="encodingindex.xsl"/>
      <title>
        <xsl:choose>
          <xsl:when test="@instructionset">
            <xsl:value-of select="@instructionset"/>
          </xsl:when>
          <xsl:when test="@title">
            <xsl:value-of select="@title"/>
          </xsl:when>
        </xsl:choose>
        <xsl:text> - Index by Encoding</xsl:text>
      </title>
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

    <!-- the <hierarchy> element contains all of the information to
         build up the decode tree. 
    -->
    <xsl:apply-templates select="hierarchy"/>

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
        ; Build timestamp: 2020-04-15T13:24
    </p>
    <p class="copyconf">
      Copyright &#169; 2010-2020 Arm Limited or its affiliates. All rights reserved.
      This document is Non-Confidential.
    </p>
    </body>

    </html>
  </xsl:template>

  <xsl:template name="decode_table">
    <!-- a decode table for the <hierarchy> and <node> elements is
         built using this template. 
    -->
    
    <xsl:variable name="CHILDREN" select="node"/>
    <xsl:variable name="HASVERSION"> 
      <!-- do ANY of the rows in this table need an Architecture version column? 
      Yes if both (1) an instruction bubbles up from its iclass into this table, AND 
      (2) if >=1 instruction encoding row has an arch_version attribute. -->
      <xsl:for-each select="$CHILDREN"> 
        <xsl:variable name="URHERE" select="@iclass"/>
        <xsl:if test="//iclass_sect[@id = $URHERE]/instructiontable/tbody[count(tr) = 1]">
          <xsl:if test="//iclass_sect[@id = $URHERE]/instructiontable/tbody/tr/@arch_version">
            <xsl:copy-of select="."/>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    
    <div class="instructiontable">
      <table class="instructiontable">
        <tr>
          <!-- we are trying to construct a table with the following
               sort of header:

               |     Decode fields     |                     |
               | op0 | op1 | op2 | op3 | Instruction details |

          -->
          <xsl:element name="th">
            <xsl:attribute name="colspan">
              <xsl:value-of select="count(regdiagram/box[@name])"/>
            </xsl:attribute>
            <xsl:text>Decode fields</xsl:text>
          </xsl:element>
          <th rowspan="2">
            Instruction details
          </th>
          <xsl:if test="$HASVERSION != ''">
            <!-- Note test="$HASVERSION" always evaluates TRUE, so we need to check contents. -->
            <th rowspan="2">
              Architecture version
            </th>
          </xsl:if>
        </tr>
        
        <tr>
          <xsl:for-each select="regdiagram/box[@name]">
            <th class="bitfields"><xsl:value-of select="@name"/></th>
          </xsl:for-each>
        </tr>
        <xsl:for-each select="node">
          <xsl:variable name="NODE" select="."/>
          <tr class="instructiontable">
            <xsl:for-each select="../regdiagram/box[@name]">
              <xsl:variable name="NAME" select="@name"/>
              <td class="bitfield">
                <xsl:choose>
                  <xsl:when test="$NODE/decode/box[@name = $NAME]">
                    <xsl:value-of select="$NODE/decode/box[@name = $NAME]"/>
                  </xsl:when>
                  <xsl:otherwise>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </xsl:for-each>
            <xsl:if test="@groupname">
              <td class="iformname">
                  <a href="#{@groupname}"><xsl:apply-templates select="$NODE/header"/></a>
              </td>
              <xsl:if test="$HASVERSION != ''">                
                <!-- Note test="$HASVERSION" always evaluates TRUE, so we need to check contents.
                If there are arch_versions elsewhere in the table, we need a hyphen for the corresponding column here. -->
                <td>
                  <xsl:text>-</xsl:text>
                </td>
              </xsl:if>
            </xsl:if>
            
            <xsl:if test="@iclass">
              <xsl:variable name="ICLASS" select="@iclass"/>
              <td class="iformname">
                <!-- is this a link to an iclass containing a single instruction? -->
                <xsl:choose>
                  <xsl:when test="count(/encodingindex/iclass_sect[@id = $ICLASS]/instructiontable/tbody/tr) = 1">
                    <!-- yes, it is, so link directly to the instruction now... -->
                    <xsl:variable name="ROW" select="/encodingindex/iclass_sect[@id = $ICLASS]/instructiontable/tbody/tr"/>
                    <xsl:variable name="FILE" select="$ROW/@iformfile"/>
                    <a href="{$FILE}">
                      <xsl:value-of select="/encodingindex/iclass_sect[@id = $ICLASS]/instructiontable/tbody/tr/td[@class = 'iformname']"/>
                    </a>
                    <!-- are there multiple links to this instruction across 
                         the whole encoding index? if so, then include the 
                         variant in the link, since there may be multiple 
                         links to the same instruction in the same table. -->
                    <xsl:if test="count(/encodingindex/iclass_sect/instructiontable/tbody/tr[@iformfile = $FILE]) > 1">
                      <!-- unicode/latin-1 &#8212; character is an em-dash.
                           If we were only targetting HTML we could
                           write &mdash;, which might be clearer; but some 
                           XSL processors complain -->
                      &#8212;
                      <xsl:choose>
                        <xsl:when test="$ROW/@encoding">
                          <!-- having an 'encoding' allows us to link the label
                               to an encoding on the page. -->
                          <a href="{$FILE}#{$ROW/@encoding}">
                            <xsl:value-of select="$ROW/td[@class = 'enctags']"/>
                          </a>
                        </xsl:when>
                        <xsl:when test="$ROW/@encname">
                          <!-- having an 'encname' allows us to link the label
                               directly to a variant on the page. -->
                          <a href="{$FILE}#{$ROW/@encname}">
                            <xsl:value-of select="$ROW/td[@class = 'enctags']"/>
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <!-- otherwise we can only display the label. -->
                          <xsl:value-of select="$ROW/td[@class = 'enctags']"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="@iclass and not (@unpredictable = '1' or @unallocated = '1')">
                    <a href="#{@iclass}"><xsl:apply-templates select="$NODE/header"/></a>
                  </xsl:when>
                  <xsl:when test="@unpredictable = '1'">
                    <xsl:text>CONSTRAINED UNPREDICTABLE</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="$NODE/header"/>
                  </xsl:otherwise>
                </xsl:choose>
              </td> <!-- class="iformname" -->
              <xsl:if test="$HASVERSION != ''">                
                <!-- Note test="$HASVERSION" always evaluates TRUE, so we need to check contents. -->
                <xsl:variable name="VROW" select="/encodingindex/iclass_sect[@id = $ICLASS]/instructiontable/tbody/tr"/>
                <td>
                <xsl:choose>
                  <!-- is this encoding from Armv8.1 or later? If so,
                  then render the architecture version in which it
                  was introduced. -->
                  <xsl:when test="$VROW/@arch_version">
                    <xsl:if test="substring($VROW/@arch_version,1,1) = 'v'">
                      <xsl:text>Arm</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="$VROW/@arch_version"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>-</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
                </td>
              </xsl:if>
            </xsl:if>
          </tr>
        </xsl:for-each>
      </table>
    </div>
  </xsl:template>

  <xsl:template name="decode_unpredictables">
    <!-- a callout to the behaviors of CONSTRAINED UNPREDICTABLE encodings -->
    <p>
      <xsl:text>The behavior of the CONSTRAINED UNPREDICTABLE encodings in this table is described in </xsl:text>            
      <xsl:element name="a">
        <xsl:attribute name="class"><xsl:text>armarm-xref</xsl:text></xsl:attribute>
        <xsl:attribute name="title"><xsl:text>Reference to Armv8 ARM section</xsl:text></xsl:attribute>
        <xsl:text>CONSTRAINED UNPREDICTABLE behavior for A32 and T32 instruction encodings</xsl:text>
      </xsl:element>
    </p>
  </xsl:template>
  
  <xsl:template match="hierarchy">
    <h1 class="topleveltable">
      <a name="top"/>
      <xsl:text>Top-level encodings for </xsl:text>
      <xsl:value-of select="/encodingindex/@instructionset"/>
    </h1>

    <!-- top-level is easy, you have the encoding diagram, the decode
         table, any CONSTRAINED UNPREDICTABLE callout needed, and the children.
    -->
    <xsl:apply-templates select="regdiagram"/>
    <xsl:apply-templates select="decode_constraints"/>
    <xsl:call-template name="decode_table"/>
    <xsl:if test="node/@unpredictable">
      <xsl:call-template name="decode_unpredictables"/>
    </xsl:if>
    <xsl:apply-templates select="node"/>
  </xsl:template>

  <xsl:template match="node">
    <xsl:variable name="ID">
      <xsl:choose>
        <xsl:when test="@groupname">
          <xsl:value-of select="@groupname"/>
        </xsl:when>
        <xsl:when test="@iclass">
          <xsl:value-of select="@iclass"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!-- if this is a group, then produce the header, register diagram,
         decode table and CONSTRAINED UNPREDICTABLE callout here... 
    -->
    <xsl:if test="@groupname">
      <hr/>
      
      <h2>
        <a name="{$ID}"/>
        <xsl:apply-templates select="header"/>
      </h2>

      <div class="decode_navigation">
        <xsl:choose>
          <xsl:when test="../@groupname">
            <p>These instructions are under <a href="#{../@groupname}"><xsl:value-of select="../header"/></a>.</p>
          </xsl:when>
          <xsl:otherwise>
            <p>These instructions are under the <a href="#top">top-level</a>.</p>
          </xsl:otherwise>
        </xsl:choose>
      </div>
          
      <xsl:apply-templates select="regdiagram"/>
      <xsl:apply-templates select="decode_constraints"/>
    
      <xsl:call-template name="decode_table"/>      
      <xsl:if test="node/@unpredictable">
        <xsl:call-template name="decode_unpredictables"/>
      </xsl:if>
    </xsl:if>

    <!-- ...but if it's an iclass, go to the iclass_sect and do it
         there. 

         when there's only a single instruction in the iclass, then
         the table will be pointing directly at the instruction, so 
         don't need to display this iclass.
    -->
    <xsl:if test="count(/encodingindex/iclass_sect[@id = $ID]/instructiontable/tbody/tr) &gt; 1">
      <hr/>
      
      <xsl:apply-templates select="/encodingindex/iclass_sect[@id = $ID]">
        <xsl:with-param name="group" select="../@groupname"/>
        <xsl:with-param name="groupheader" select="../header"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:apply-templates select="node"/>
  </xsl:template>

  <xsl:template match="decode_constraints">
    <div class="decode_constraints">
      <p>
        The following constraints also apply to this encoding: 
        <xsl:for-each select="decode_constraint">
          <xsl:value-of select="@name"/><xsl:text> </xsl:text>
          <xsl:value-of select="@op"/><xsl:text> </xsl:text>
          <xsl:value-of select="@val"/><xsl:text> </xsl:text>
          <xsl:if test="position() != last()">
            <xsl:text>&amp;&amp; </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </p>
    </div>
  </xsl:template>
    
  <xsl:template match="col">
    <!-- table 'col' elements are no use for browsing -->
  </xsl:template>

  <xsl:template match="encodingindex/iclass_sect">
    <xsl:param name="group"/>
    <xsl:param name="groupheader"/>
    <div class="iclass" id="{@id}">
      <xsl:choose>
        <xsl:when test="count(./regdiagram) > 1">
          <a name="{@id}"></a>
          <xsl:variable name="iclass" select="@id"/>
          <xsl:for-each select="//encodingindex/mappings/mapping[@from = $iclass]">
            <!-- where multiple encodings are described, need to include 
                 anchors for them all. -->
            <a name="{@to}"></a>
          </xsl:for-each>
          <h3 class="iclass"><xsl:value-of select="@title"/></h3>
        </xsl:when>
        <xsl:otherwise>
          <a name="{@id}"></a>
          <h3 class="iclass"><xsl:value-of select="@title"/></h3>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$group">
        <p>These instructions are under <a href="#{$group}"><xsl:value-of select="$groupheader"/></a>.</p>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="instructiontable/tbody/tr/@unpred">
        <xsl:call-template name="decode_unpredictables"/>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="regdiagram">
    <xsl:if test="count(../regdiagram) > 1">
      <!-- where more than one diagram, need to output the instruction
           set to differentiate them. -->
      <h4><xsl:value-of select="@isa"/></h4>
    </xsl:if>
    <div class="regdiagram-{@form}">
    <table class="regdiagram">
      <thead>
        <tr>
          <xsl:choose>
            <xsl:when test="@form = '16x2'">
              <td>15</td><td>14</td><td>13</td><td>12</td><td>11</td><td>10</td><td>9</td><td>8</td><td>7</td><td>6</td><td>5</td><td>4</td><td>3</td><td>2</td><td>1</td><td>0</td><td>15</td><td>14</td><td>13</td><td>12</td><td>11</td><td>10</td><td>9</td><td>8</td><td>7</td><td>6</td><td>5</td><td>4</td><td>3</td><td>2</td><td>1</td><td>0</td>
            </xsl:when>
            <xsl:when test="@form = '16'">
              <td>15</td><td>14</td><td>13</td><td>12</td><td>11</td><td>10</td><td>9</td><td>8</td><td>7</td><td>6</td><td>5</td><td>4</td><td>3</td><td>2</td><td>1</td><td>0</td>
            </xsl:when>
            <xsl:otherwise>
              <td>31</td><td>30</td><td>29</td><td>28</td><td>27</td><td>26</td><td>25</td><td>24</td><td>23</td><td>22</td><td>21</td><td>20</td><td>19</td><td>18</td><td>17</td><td>16</td><td>15</td><td>14</td><td>13</td><td>12</td><td>11</td><td>10</td><td>9</td><td>8</td><td>7</td><td>6</td><td>5</td><td>4</td><td>3</td><td>2</td><td>1</td><td>0</td>
            </xsl:otherwise>
          </xsl:choose>
        </tr>
      </thead>
      <tbody>
        <tr class="firstrow">
          <xsl:for-each select="./box">
            <xsl:choose>
              <xsl:when test="@usename and not (@settings)">
                <td>
                  <xsl:if test="@width > 1">
                    <xsl:attribute name="colspan"><xsl:value-of select="@width"/></xsl:attribute>
                  </xsl:if>
                  <xsl:attribute name="class">lr</xsl:attribute>
                  <xsl:value-of select="@name"/>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="./c">
                  <td>
                    <xsl:if test="@colspan">
                      <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                      <xsl:when test="position() = 1 and last() = 1">
                        <xsl:attribute name="class">lr</xsl:attribute>
                      </xsl:when>
                      <xsl:when test="position() = 1">
                        <xsl:attribute name="class">l</xsl:attribute>
                      </xsl:when>
                      <xsl:when test="position() = last()">
                        <xsl:attribute name="class">r</xsl:attribute>
                      </xsl:when>
                    </xsl:choose>
                    <xsl:value-of select="."/>
                  </td>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </tr>
        <xsl:if test="@tworows">
          <tr class="secondrow">
            <xsl:for-each select="./box">
              <td>
                <xsl:if test="@width > 1">
                  <xsl:attribute name="colspan">
                    <xsl:value-of select="@width"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="@settings and @usename">
                  <xsl:attribute name="class">droppedname</xsl:attribute>
                  <xsl:value-of select="@name"/>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="../@usename">
                    <xsl:value-of select="."/>
                  </xsl:when>
                </xsl:choose>
              </td>
            </xsl:for-each>
          </tr>
        </xsl:if>
      </tbody>
    </table>
    </div>
    <xsl:if test="@constraint">
      <div>
        Additionally, the following constraints must also be satisfied: 
        <xsl:value-of select="@constraint"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="instructiontable">
    <div class="instructiontable">
      <table class="instructiontable" id="{@iclass}">
        <xsl:apply-templates/>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="instructiontable/thead">
    <thead class="{@class}">
      <xsl:apply-templates/>
    </thead>
  </xsl:template>

  <xsl:template match="instructiontable/tbody">
    <tbody>
      <xsl:apply-templates/>
    </tbody>
  </xsl:template>

  <xsl:template match="instructiontable/*/tr">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="instructiontable/thead/tr/th">
    <xsl:if test="@class!='enctags'">
      <th class="{@class}" rowspan="{@rowspan}" colspan="{@colspan}">
        <xsl:choose>
          <xsl:when test="@class = 'iformname'">
            Instruction Details
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </th>
    </xsl:if>
    <xsl:if test="@class = 'iformname' and ../../../tbody/tr/@arch_version">
      <th rowspan="{@rowspan}">
        <xsl:text>Architecture Version</xsl:text>
      </th>
    </xsl:if>
  </xsl:template>

  <xsl:template match="instructiontable/tbody/tr/td">
    <xsl:if test="@class!='enctags'">
    <td>
      <xsl:if test="@rowspan > 1">
        <xsl:attribute name="rowspan">
          <xsl:value-of select="@rowspan"/>
        </xsl:attribute>
        <xsl:attribute name="valign">center</xsl:attribute>
      </xsl:if>
      <xsl:if test="@class">
        <xsl:attribute name="class">
          <xsl:value-of select="@class"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@iformid">
          <a name="{@iformid}" href="{../@iformfile}">
            <xsl:value-of select="."/>
          </a>

          <!-- unicode/latin-1 &#8212; character is an em-dash.  If we
               were only targetting HTML we could write &mdash;, which might
               be clearer; but some XSL processors complain -->
          <xsl:if test="../@oneofthismnem > 1 and ../@label">
            &#8212;
            <xsl:choose>
              <xsl:when test="../@encoding">
                <!-- having an 'encoding' allows us to link the label
                     directly to an encoding on the page. -->
                <a href="{../@iformfile}#{../@encoding}">
                  <xsl:value-of select="../@label"/>
                </a>
              </xsl:when>
              <xsl:when test="../@encname">
                <!-- having an 'encname' allows us to link the label
                     directly to a variant on the page. -->
                <a href="{../@iformfile}#{../@encname}">
                  <xsl:value-of select="../@label"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <!-- otherwise we can only display the label. -->
                <xsl:value-of select="../@label"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:when>
        <xsl:when test="@note">
          <a title="{@note}">
            <xsl:value-of select="."/>
          </a>
        </xsl:when>
        <xsl:when test="@class = 'enctags'">
          <a href="{../@iformfile}#{../@encname}">
            <xsl:value-of select="."/>
          </a>
        </xsl:when>
        <xsl:when test="@class = 'iformname' and ../@unpred = '1'">
          <xsl:text>CONSTRAINED UNPREDICTABLE</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>         
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <xsl:if test="@class = 'iformname' and ../../tr/@arch_version">
      <td>
        <xsl:choose>
          <xsl:when test="../@arch_version">
            <!-- is this encoding from Armv8.1 or later? If so,
            then render the architecture version in which it
            was introduced. -->
            <xsl:if test="substring(../@arch_version,1,1) = 'v'">
              <xsl:text>Arm</xsl:text>
            </xsl:if>
            <xsl:value-of select="../@arch_version"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </xsl:if>
  </xsl:if>
  </xsl:template>

  <xsl:template match="instructiontable/tbody/tr/box">
    <xsl:for-each select="./c">
      <td>
        <xsl:if test="@colspan">
          <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="position() = 1 and last() = 1">
            <xsl:attribute name="class">bits_lr</xsl:attribute>
          </xsl:when>
          <xsl:when test="position() = 1">
            <xsl:attribute name="class">bits_l</xsl:attribute>
          </xsl:when>
          <xsl:when test="position() = last()">
            <xsl:attribute name="class">bits_r</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">bits</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="."/>
      </td>
    </xsl:for-each>
  </xsl:template>

  <!-- single-element templates, at the end so they're used by default -->

  <xsl:template match="th">
    <th>
      <xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
      <xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute></xsl:if>
      <xsl:if test="@rowspan"><xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute></xsl:if>
      <xsl:apply-templates/>
    </th>
  </xsl:template>

  <xsl:template match="td">
    <td>
      <xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
      <xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute></xsl:if>
      <xsl:if test="@ingroup"><xsl:attribute name="bgcolor">yellow</xsl:attribute></xsl:if>
      <xsl:choose>
        <xsl:when test="@href">
          <a href="{@href}"><xsl:apply-templates/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </xsl:template>

  <xsl:template match="tr">
    <tr>
      <xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
      <xsl:if test="@iclass"><xsl:attribute name="iclass"><xsl:value-of select="@iclass"/></xsl:attribute></xsl:if>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="a[@classid]">
    <a href="#{@classid}"><xsl:value-of select="."/></a>
  </xsl:template>

</xsl:stylesheet>
