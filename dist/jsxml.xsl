<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:jsx="https://github.com/sebastien/jsxml">
  <xsl:output method="text" encoding="UTF-8" indent="no" />
  <xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:template match="jsx:*">
    <xsl:text>(console.error("&lt;</xsl:text>     
    <xsl:value-of select="name()" /><xsl:text>&gt;&#x0020;element not supported"))</xsl:text>
  </xsl:template>
  <xsl:template match="@jsx:*">
    <xsl:text>/*</xsl:text>     
    <xsl:value-of select="name()" /><xsl:text>=</xsl:text>     
    <xsl:value-of select="." /><xsl:text>*/null</xsl:text>
  </xsl:template>
  <xsl:template match="jsx:Component" name="component">
    <xsl:param name="prefix" select="'exports.'" />
    <xsl:param name="postamble">
      <xsl:call-template name="umd-postamble" />
    </xsl:param>
    <xsl:param name="preamble">
      <xsl:call-template name="umd-preamble" />
    </xsl:param>
    <xsl:param name="helpers">
      <xsl:call-template name="helpers" />
    </xsl:param>
    <xsl:value-of select="$preamble" /><xsl:text>&#x000A;</xsl:text>     
    <xsl:value-of select="$helpers" /><xsl:text>var STYLES={};</xsl:text>     
    <xsl:text>&#x000A;</xsl:text>     
    <xsl:for-each select="//*[@style]">
      <xsl:text>STYLES["</xsl:text>       
      <xsl:value-of select="generate-id(@style)" /><xsl:text>"]=_parseStyle("</xsl:text>       
      <xsl:value-of select="@style" /><xsl:text>");</xsl:text>       
      <xsl:text>&#x000A;</xsl:text>
    </xsl:for-each>
    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="concat('View', @name)" />
    </xsl:call-template>
    <xsl:value-of select="$prefix" />
    <xsl:choose>
      <xsl:when test="@name">
        <xsl:value-of select="@name" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>View</xsl:text>
      </xsl:otherwise>
    </xsl:choose><xsl:text>=function(data,component){</xsl:text>     
    <xsl:text>var state=data;</xsl:text>     
    <xsl:apply-templates select="jsx:Template" />
    <xsl:variable name="content" select="*[not(self::jsx:Template) and not(self::jsx:import)]" />
    <xsl:choose>
      <xsl:when test="count($content)=0">
        <xsl:text />
      </xsl:when>
      <xsl:when test="count($content)=1">
        <xsl:text>return (</xsl:text>         
        <xsl:apply-templates select="$content" /><xsl:text>&#x000A;</xsl:text>         
        <xsl:text>)};</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>return (React.createElement("div",{"className":"component"},</xsl:text>         
        <xsl:for-each select="$content">
          <xsl:apply-templates select="." />
          <xsl:if test="position()!=last()">
            <xsl:text>,</xsl:text>
          </xsl:if>
        </xsl:for-each><xsl:text>&#x000A;</xsl:text>         
        <xsl:text>))};</xsl:text>
      </xsl:otherwise>
    </xsl:choose><xsl:text>&#x000A;</xsl:text>     
    <xsl:text>&#x000A;</xsl:text>     
    <xsl:value-of select="$postamble" />
  </xsl:template>
  <xsl:template match="jsx:Template">
    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="concat('Template ', @name)" />
    </xsl:call-template><xsl:text>var _t_</xsl:text>     
    <xsl:variable name="param">
      <xsl:choose>
        <xsl:when test="@params">
          <xsl:value-of select="@params" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'_'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="@name" /><xsl:text>=function(</xsl:text>     
    <xsl:value-of select="$param" /><xsl:text>){return (</xsl:text>     
    <xsl:call-template name="element-children" /><xsl:text>)};</xsl:text>     
    <xsl:text>&#x000A;</xsl:text>
  </xsl:template>
  <xsl:template match="jsx:import" />
  <xsl:template match="jsx:component">
    <xsl:choose>
      <xsl:when test="@jsx:class">
        <xsl:call-template name="create-element">
          <xsl:with-param name="name">
            <xsl:value-of select="@jsx:class" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>console.error("&lt;jsx:component&gt; tag missing a jsx:class attribute")</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="jsx:apply" name="jsx-apply">
    <xsl:variable name="template" select="@template" />
    <xsl:variable name="argument">
      <xsl:choose>
        <xsl:when test="@params">
          <xsl:value-of select="@params" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>_</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="//jsx:Template[@name=$template]">
        <xsl:text>(_t_</xsl:text>         
        <xsl:value-of select="$template" /><xsl:text>(</xsl:text>         
        <xsl:value-of select="$argument" /><xsl:text>))</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>(console.log.error("Missing &lt;jsx:Template name='</xsl:text>         
        <xsl:value-of select="$template" /><xsl:text>'&gt;"))</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="jsx:for" name="jsx-for">
    <xsl:choose>
      <xsl:when test="@in">
        <xsl:text>(</xsl:text>         
        <xsl:value-of select="@in" /><xsl:text>||new Array(0)).map(function(</xsl:text>         
        <xsl:choose>
          <xsl:when test="@each">
            <xsl:value-of select="@each" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>_</xsl:text>
          </xsl:otherwise>
        </xsl:choose><xsl:text>,i){return (</xsl:text>         
        <xsl:apply-templates select="*" />
        <xsl:text>        )})
        </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>        console.error("&lt;jsx:for&gt; is missing its `in` attribute")
        </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="jsx:if" name="jsx-if">
    <xsl:param name="node" select="." />
    <xsl:for-each select="$node">
      <xsl:choose>
        <xsl:when test="@test">
          <xsl:text>&#x000A;/* &lt;jsx:</xsl:text><xsl:value-of select="local-name()" /><xsl:text> test=</xsl:text><xsl:value-of select="@test" /><xsl:text> &gt;*/ </xsl:text>           
          <xsl:text>((</xsl:text>           
          <xsl:value-of select="@test" /><xsl:text>) ? [</xsl:text>           
          <xsl:call-template name="element-children" /><xsl:text>] : </xsl:text>           
          <xsl:choose>
            <xsl:when test="following-sibling::*[1][self::jsx:elif]">
              <xsl:call-template name="jsx-if">
                <xsl:with-param name="node" select="following-sibling::*[1]" />
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="following-sibling::*[1][self::jsx:else]">
              <xsl:call-template name="jsx-else">
                <xsl:with-param name="node" select="following-sibling::*[1]" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>null</xsl:text>
            </xsl:otherwise>
          </xsl:choose><xsl:text>)</xsl:text>           
          <xsl:text>&#x000A;/* &lt;/jsx:</xsl:text>           
          <xsl:value-of select="local-name()" /><xsl:text>&gt; */&#x000A;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>console.error("&lt;jsx:</xsl:text>           
          <xsl:value-of select="local-name()" /><xsl:text>if&gt; is missing its `test` attribute")</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="jsx-else">
    <xsl:param name="node" select="." />
    <xsl:for-each select="$node">
      <xsl:text>&#x000A;/* &lt;jsx:else&gt; */</xsl:text>       
      <xsl:text>[</xsl:text>       
      <xsl:call-template name="element-children" /><xsl:text>]</xsl:text>       
      <xsl:text>&#x000A;/* &lt;/jsx:else&gt; */&#x000A;</xsl:text>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="jsx:else|jsx:elif">
    <xsl:text>/* jsx:</xsl:text>     
    <xsl:value-of select="local-name()" /><xsl:text> out of scope */</xsl:text>
  </xsl:template>
  <xsl:template match="*[@jsx:if]" name="jsx-if-attribute">
    <xsl:text>/* @jsx:if= */</xsl:text>     
    <xsl:text>((</xsl:text>     
    <xsl:value-of select="@jsx:if" /><xsl:text>) ? (</xsl:text>     
    <xsl:call-template name="create-element" /><xsl:text>) : null)</xsl:text>     
    <xsl:text>/* =@jsx:if */</xsl:text>
  </xsl:template>
  <xsl:template match="jsx:value">
    <xsl:text>(</xsl:text>     
    <xsl:value-of select="normalize-space(.)" /><xsl:text>)</xsl:text>
  </xsl:template>
  <xsl:template match="jsx:attribute" name="jsx-attribute">
    <xsl:text>    /* &lt;jsx:attribute&gt; */
    </xsl:text>
    <xsl:if test="@when">
      <xsl:text>((</xsl:text>       
      <xsl:value-of select="@when" /><xsl:text>) ? (</xsl:text>
    </xsl:if><xsl:text>{add:</xsl:text>     
    <xsl:choose>
      <xsl:when test="@do='add'">
        <xsl:text>true</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>false</xsl:text>
      </xsl:otherwise>
    </xsl:choose><xsl:text>,name:</xsl:text>     
    <xsl:choose>
      <xsl:when test="@name='class'">
        <xsl:text>"className"</xsl:text>
      </xsl:when>
      <xsl:when test="@name">
        <xsl:call-template name="string-value">
          <xsl:with-param name="text">
            <xsl:value-of select="@name" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>        console.warn("&lt;jsx:attribute&gt; is missing its @name attribute")
        </xsl:text>
      </xsl:otherwise>
    </xsl:choose><xsl:text>,value:</xsl:text>     
    <xsl:value-of select="normalize-space(.)" /><xsl:text>}</xsl:text>     
    <xsl:if test="@when">
      <xsl:text>) : null)</xsl:text>
    </xsl:if>
    <xsl:text>    /* &lt;/jsx:attribute&gt; */
    </xsl:text>
  </xsl:template>
  <xsl:template match="jsx:style" name="jsx-style">
    <xsl:text>/* &lt;jsx:style&gt; */</xsl:text>     
    <xsl:text>{name:"style",value:{"</xsl:text>     
    <xsl:value-of select="normalize-space(@name)" /><xsl:text>":(</xsl:text>     
    <xsl:value-of select="normalize-space(.)" /><xsl:text>)}}</xsl:text>     
    <xsl:text>    /* &lt;/jsx:style&gt; */
    </xsl:text>
  </xsl:template>
  <xsl:template match="jsx:children">
    <xsl:text>/* &lt;jsx:children&gt; */</xsl:text>     
    <xsl:text>component.props.children</xsl:text>     
    <xsl:text>/* &lt;/jsx:children&gt; */</xsl:text>
  </xsl:template>
  <xsl:template match="jsx:T">
    <xsl:if test="count(*)&gt;0">
      <xsl>text:(console.warn("jsx:T should only contain text nodes")) || </xsl>
    </xsl:if><xsl:text>(T(</xsl:text>     
    <xsl:call-template name="string-value">
      <xsl:with-param name="text">
        <xsl:value-of select="text()" />
      </xsl:with-param>
    </xsl:call-template><xsl:text>))</xsl:text>
  </xsl:template>
  <xsl:template match="*[@jsx:map]">
    <xsl:text>(</xsl:text>     
    <xsl:value-of select="@jsx:map" /><xsl:text>||new Array(0))</xsl:text>     
    <xsl:text>.map(function(</xsl:text>     
    <xsl:choose>
      <xsl:when test="@jsx:each">
        <xsl:value-of select="@jsx:each" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>_</xsl:text>
      </xsl:otherwise>
    </xsl:choose><xsl:text>,i,l){return</xsl:text>     
    <xsl:text>&#x0020;(</xsl:text>     
    <xsl:choose>
      <xsl:when test="self::jsx:apply">
        <xsl:call-template name="jsx-apply" />
      </xsl:when>
      <xsl:when test="self::jsx:*">
        <xsl:text>console.error("jsx:map applied to unsupported jsx:</xsl:text>         
        <xsl:value-of select="name()" /><xsl:text> element")</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create-element">
          <xsl:with-param name="key">
            <xsl:text>i</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose><xsl:text>);})</xsl:text>
  </xsl:template>
  <xsl:template match="*" name="create-element">
    <xsl:param name="name">
      <xsl:text>"</xsl:text>       
      <xsl:value-of select="name()" /><xsl:text>"</xsl:text>
    </xsl:param>
    <xsl:param name="content" />
    <xsl:param name="key" /><xsl:text>&#x000A;</xsl:text>     
    <xsl:choose>
      <xsl:when test="jsx:if|jsx:else|jsx:elif">
        <xsl:text>React.createElement.apply(React, __flatten([</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>React.createElement(</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="create-element-name">
      <xsl:with-param name="name">
        <xsl:value-of select="$name" />
      </xsl:with-param>
    </xsl:call-template><xsl:text>,</xsl:text>     
    <xsl:call-template name="create-element-attributes">
      <xsl:with-param name="key" select="$key" />
    </xsl:call-template>
    <xsl:call-template name="create-element-content">
      <xsl:with-param name="content" select="$content" />
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="jsx:if|jsx:else|jsx:elif">
        <xsl:text>],2))</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="create-element-name">
    <xsl:param name="name">
      <xsl:text>"</xsl:text>       
      <xsl:value-of select="name()" /><xsl:text>"</xsl:text>
    </xsl:param>
    <xsl:value-of select="$name" />
  </xsl:template>
  <xsl:template name="create-element-attributes">
    <xsl:param name="attributes" select="@*[namespace-uri()!='https://github.com/sebastien/jsxml']|@jsx:as|@jsx:ref" />
    <xsl:param name="key" />
    <xsl:if test="jsx:attribute|jsx:style">
      <xsl:text>(_mergeAttributes(</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$attributes">
        <xsl:text>{</xsl:text>         
        <xsl:if test="not(@key) and $key">
          <xsl:text>key:</xsl:text>           
          <xsl:value-of select="$key" /><xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:for-each select="$attributes">
          <xsl:choose>
            <xsl:when test="local-name()='style'">
              <xsl:text>style:(STYLES["</xsl:text>               
              <xsl:value-of select="generate-id(.)" /><xsl:text>"])</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." />
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="position()!=last()">
            <xsl:text>,</xsl:text>
          </xsl:if>
        </xsl:for-each><xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:when test="not(@key) and $key">
        <xsl:text>{key:</xsl:text>         
        <xsl:value-of select="$key" /><xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>null</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="jsx:attribute|jsx:style">
      <xsl:text>,[</xsl:text>       
      <xsl:for-each select="jsx:attribute|jsx:style">
        <xsl:choose>
          <xsl:when test="self::jsx:attribute">
            <xsl:call-template name="jsx-attribute" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="jsx-style" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position()!=last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each><xsl:text>]))</xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template name="create-element-content">
    <xsl:param name="content" />
    <xsl:choose>
      <xsl:when test="$content">
        <xsl:text>,</xsl:text>         
        <xsl:value-of select="$content" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="children" select="*[not(self::jsx:import) and not(self::jsx:style) and not(self::jsx:attribute) and not(self::jsx:else) and not(self::jsx:elif)]|text()[string-length(normalize-space(.))>0]" />
        <xsl:if test="count($children)>0">
          <xsl:text>,</xsl:text>           
          <xsl:call-template name="element-children">
            <xsl:with-param name="children" select="$children" />
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="element-children">
    <xsl:param name="children" select="*[not(self::jsx:import) and not(self::jsx:style) and not(self::jsx:attribute) and not(self::jsx:else) and not(self::jsx:elif)]|text()[string-length(normalize-space(.))>0]" />
    <xsl:for-each select="$children">
      <xsl:choose>
        <xsl:when test="self::jsx:*">
          <xsl:apply-templates select="." />
        </xsl:when>
        <xsl:when test="@jsx:*">
          <xsl:apply-templates select="." />
        </xsl:when>
        <xsl:when test="self::text()">
          <xsl:call-template name="string" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="text( )" name="string">
    <xsl:text>"</xsl:text>     
    <xsl:variable name="text">
      <xsl:value-of select="." />
    </xsl:variable>
    <xsl:value-of select="normalize-space($text)" />
    <xsl:if test="substring(.,string-length(.))=' '">
      <xsl:text> </xsl:text>
    </xsl:if><xsl:text>"</xsl:text>
  </xsl:template>
  <xsl:template match="@jsx:as|@jsx:ref">
    <xsl:text>"ref":</xsl:text>     
    <xsl:text>"</xsl:text>     
    <xsl:value-of select="." /><xsl:text>"</xsl:text>
  </xsl:template>
  <xsl:template match="*[@jsx:value]">
    <xsl:choose>
      <xsl:when test="@jsx:map">
        <xsl:text>        console.error("jsx:value attribute used along jsx:map. Transform the jsx:value to a child node")
        </xsl:text>
      </xsl:when>
      <xsl:when test="count(*|text())>0">
        <xsl:text>&#x000A;</xsl:text>         
        <xsl:text>(function(){var __=</xsl:text>         
        <xsl:value-of select="@jsx:value" /><xsl:text>;</xsl:text>         
        <xsl:text>return (</xsl:text>         
        <xsl:call-template name="create-element">
          <xsl:with-param name="content">
            <xsl:text> (__ != null &amp;&amp; typeof(__) != 'undefined') ? </xsl:text>             
            <xsl:value-of select="@jsx:value" /><xsl:text> : [</xsl:text>             
            <xsl:call-template name="element-children" /><xsl:text>]</xsl:text>
          </xsl:with-param>
        </xsl:call-template><xsl:text>)} () )</xsl:text>         
        <xsl:text>&#x000A;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create-element">
          <xsl:with-param name="content">
            <xsl:value-of select="@jsx:value" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@*">
    <xsl:text>"</xsl:text>     
    <xsl:value-of select="local-name()" /><xsl:text>":</xsl:text>     
    <xsl:call-template name="string-value" />
  </xsl:template>
  <xsl:template match="@*[name()='class']">
    <xsl:text>"</xsl:text>     
    <xsl:text>className</xsl:text>     
    <xsl:text>":</xsl:text>     
    <xsl:call-template name="string-value" />
  </xsl:template>
  <xsl:template match="@*[substring-before(name(),':')='on']">
    <xsl:text>"on</xsl:text>     
    <xsl:call-template name="capitalize">
      <xsl:with-param name="text" select="local-name()" />
    </xsl:call-template><xsl:text>":</xsl:text>     
    <xsl:value-of select="." />
  </xsl:template>
  <xsl:template name="string-value">
    <xsl:param name="text">
      <xsl:value-of select="." />
    </xsl:param>
    <xsl:choose>
      <xsl:when test="substring($text,1,1)='{' and substring($text,string-length($text),1)='}'">
        <xsl:text>(</xsl:text>         
        <xsl:value-of select="translate(substring($text,2,string-length($text)-2),'&#xA;',' ')" /><xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>"</xsl:text>         
        <xsl:value-of select="translate(normalize-space($text),'&#xA;', ' ')" /><xsl:text>"</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="comment">
    <xsl:param name="text" /><xsl:text>&#x000A;</xsl:text>     
    <xsl:text>/* </xsl:text>     
    <xsl:value-of select="$text" /><xsl:text> */</xsl:text>     
    <xsl:text>&#x000A;</xsl:text>
  </xsl:template>
  <xsl:template name="capitalize">
    <xsl:param name="text" />
    <xsl:variable name="head" select="translate(substring($text,1,1), $LOWERCASE, $UPPERCASE)" />
    <xsl:variable name="tail" select="substring($text,2)" />
    <xsl:value-of select="concat($head,$tail)" />
  </xsl:template>
  <xsl:template name="umd-preamble">
    <xsl:variable name="imports">
      <xsl:for-each select="//jsx:import">
        <xsl:text>,"</xsl:text>         
        <xsl:value-of select="@from" /><xsl:text>"</xsl:text>
      </xsl:for-each>
    </xsl:variable>    (function (global, factory) { if (typeof define === "function" &amp;&amp; define.amd) { define(["exports", "react" 
    <xsl:value-of select="$imports" />    ], factory); } else if (typeof exports !== "undefined") { factory(exports, require("react" 
    <xsl:value-of select="$imports" />    )); } else { var mod = { exports: {} }; factory(mod.exports, global.uis); global.componentEs6 = mod.exports; } })(this, function (exports, react 
    <xsl:for-each select="//jsx:import">
      <xsl:choose>
        <xsl:when test="@from">
          <xsl:text>, </xsl:text>           
          <xsl:value-of select="translate(@from,'.','_')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>          console.error("jsx:import is missing its from='MODULE' parameter")
          </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>    ) { 
    <xsl:text>&#x000A;</xsl:text>     "use strict" 
    <xsl:text>&#x000A;</xsl:text>     Object.defineProperty(exports, "__esModule", {value:true}); var React  = react; /* Imported components */ 
    <xsl:for-each select="//jsx:import">
      <xsl:choose>
        <xsl:when test="jsx:symbol">
          <xsl:variable name="module">
            <xsl:choose>
              <xsl:when test="@from">
                <xsl:value-of select="translate(@from,'.','_')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>                (console.error("jsx:import tags is missing the from='module' attribute"))
                </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:for-each select="jsx:symbol">
            <xsl:call-template name="symbol-import">
              <xsl:with-param name="origin">
                <xsl:value-of select="$module" /><xsl:text>.</xsl:text>                 
                <xsl:value-of select="@name" />
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="symbol-import" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="symbol-import">
    <xsl:param name="name">
      <xsl:choose>
        <xsl:when test="@as">
          <xsl:value-of select="@as" />
        </xsl:when>
        <xsl:when test="@name">
          <xsl:value-of select="@name" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>          (console.error("jsx:import tag is missing the name='symbol' attribute"))
          </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="origin">
      <xsl:choose>
        <xsl:when test="@from">
          <xsl:value-of select="translate(@from,'.','_')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>          (console.error("jsx:import tags is missing the from='module' attribute"))
          </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="@name">
          <xsl:text>.</xsl:text>           
          <xsl:value-of select="@name" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>          (console.error("jsx:import tag is missing the name='symbol' attribute"))
          </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param><xsl:text>var </xsl:text>     
    <xsl:value-of select="$name" /><xsl:text>=</xsl:text>     
    <xsl:value-of select="$origin" /><xsl:text>;</xsl:text>     
    <xsl:text>&#x000A;</xsl:text>
  </xsl:template>
  <xsl:template name="helpers">
        /** * Merges the attributes list `b` `[{name,value,add:bool}]` * into the attribute map `a` `{
    <name />    :
    <value>Any</value>    }`, with * a special handling of style attributes. */ var _mergeAttributes = function(a,b) { var r = {}; Object.assign(r,a || {}); var res = (b||[]).reduce(function(r,v){ if (v) { var k=v.name; if (k === "style") { r[k] = r[k] || {}; Object.assign(r[k], v.value); } else if (v.add) { r[k] = r[k] ? r[k] + ' ' + v.value : v.value; } else { r[k] = v.value; } } return r; }, r); return res; }; /** * Parses the given CSS line into a style attribute map. */ var _parseStyle = function(style){ var n = document.createElement("div"); n.setAttribute("style", style); var res = {}; for (var i=0 ; i&lt;n.style.length ; i++) { var k  = n.style[i]; var p  = k.split("-").map(function(v,i){return i == 0 ? v : v[0].toUpperCase() + v.substring(1)}).join(""); res[p] = n.style[k]; } return res; }; /** * Flattens at one level the list argument starting after the `skip`ed * element */ var __flatten = function(list,skip){ skip = skip || 0; var res = list.reduce(function(r,e,i){ if (i &lt; skip) { r.push(e); } else if (e instanceof Array) { r = r.concat(e); } else { r.push(e); } return r; }, []); return res; }
  </xsl:template>
  <xsl:template name="umd-postamble">  });
  </xsl:template>
</xsl:stylesheet>