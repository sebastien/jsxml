<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:jsx="https://github.com/sebastien/jsxml">
  <xsl:output method="text" encoding="UTF-8" indent="no" />
  <xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
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
        <xsl:when test="@param">
          <xsl:value-of select="@param" />
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
  <xsl:template match="jsx:eval">
    <xsl:text>(</xsl:text>     
    <xsl:value-of select="normalize-space(.)" /><xsl:text>)</xsl:text>
  </xsl:template>
  <xsl:template match="jsx:T" />
  <xsl:template match="jsx:component">
    <xsl:call-template name="create-element">
      <xsl:with-param name="name">
        <xsl:value-of select="@jsx:class" />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="jsx:apply">
    <xsl:variable name="template" select="@template" />
    <xsl:variable name="argument" select="'_'" />
    <xsl:choose>
      <xsl:when test="//jsx:Template[@name=$template]">
        <xsl:text>[_t_</xsl:text>         
        <xsl:value-of select="$template" /><xsl:text>(</xsl:text>         
        <xsl:value-of select="$argument" /><xsl:text>)]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>_list(console.log.error("Missing &lt;jsx:Template name='</xsl:text>         
        <xsl:value-of select="$template" /><xsl:text>'&gt;"))</xsl:text>
      </xsl:otherwise>
    </xsl:choose><xsl:text>_list(</xsl:text>     
    <xsl:value-of select="normalize-space(.)" /><xsl:text>)</xsl:text>
  </xsl:template>
  <xsl:template match="jsx:import" />
  <xsl:template match="jsx:*">
    <xsl:text>(console.error("&lt;</xsl:text>     
    <xsl:value-of select="name()" /><xsl:text>&gt;&#x0020;element not supported"))</xsl:text>
  </xsl:template>
  <xsl:template match="*[@jsx:text]">
    <xsl:choose>
      <xsl:when test="*">
        <xsl:text>(</xsl:text>         
        <xsl:value-of select="@jsx:text" /><xsl:text>) ? (</xsl:text>         
        <xsl:value-of select="@jsx:text" /><xsl:text>) : (</xsl:text>         
        <xsl:apply-templates select="*" /><xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@jsx:text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*[@jsx:map]">
    <xsl:text>_list(</xsl:text>     
    <xsl:value-of select="@jsx:map" /><xsl:text>.map(function(_,i,l){</xsl:text>     
    <xsl:call-template name="create-element" /><xsl:text>})</xsl:text>
  </xsl:template>
  <xsl:template match="*" name="create-element">
    <xsl:param name="name">
      <xsl:text>"</xsl:text>       
      <xsl:value-of select="name()" /><xsl:text>"</xsl:text>
    </xsl:param><xsl:text>&#x000A;</xsl:text>     
    <xsl:text>React.createElement(</xsl:text>     
    <xsl:value-of select="$name" /><xsl:text>,</xsl:text>     
    <xsl:variable name="attributes" select="@*[namespace-uri()!='https://github.com/sebastien/jsxml']|@jsx:as|@jsx:ref|@jsx:value" />
    <xsl:choose>
      <xsl:when test="$attributes">
        <xsl:text>{</xsl:text>         
        <xsl:for-each select="$attributes">
          <xsl:apply-templates select="." />
          <xsl:if test="position()!=last()">
            <xsl:text>,</xsl:text>
          </xsl:if>
        </xsl:for-each><xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>null</xsl:text>
      </xsl:otherwise>
    </xsl:choose><xsl:text />     
    <xsl:variable name="children" select="*[not(self::jsx:import)]|text()[string-length(normalize-space(.))>0]" />
    <xsl:if test="count($children)>0">
      <xsl:text>,</xsl:text>       
      <xsl:call-template name="element-children">
        <xsl:with-param name="children" select="$children" />
      </xsl:call-template>
    </xsl:if><xsl:text>)</xsl:text>
  </xsl:template>
  <xsl:template name="element-children">
    <xsl:param name="children" select="*[not(self::jsx:import)]|text()[string-length(normalize-space(.))>0]" />
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
  <xsl:template match="@jsx:*">
    <xsl:text>/*</xsl:text>     
    <xsl:value-of select="name()" /><xsl:text>=</xsl:text>     
    <xsl:value-of select="." /><xsl:text>*/null</xsl:text>
  </xsl:template>
  <xsl:template match="@jsx:as|@jsx:ref">
    <xsl:text>"ref":</xsl:text>     
    <xsl:text>"</xsl:text>     
    <xsl:value-of select="." /><xsl:text>"</xsl:text>
  </xsl:template>
  <xsl:template match="@jsx:value">
    <xsl:text>"value":(</xsl:text>     
    <xsl:value-of select="." /><xsl:text>)</xsl:text>
  </xsl:template>
  <xsl:template match="@*">
    <xsl:text>"</xsl:text>     
    <xsl:value-of select="local-name()" /><xsl:text>":"</xsl:text>     
    <xsl:value-of select="." /><xsl:text>"</xsl:text>
  </xsl:template>
  <xsl:template match="@*[name()='class']">
    <xsl:text>"</xsl:text>     
    <xsl:text>className</xsl:text>     
    <xsl:text>":"</xsl:text>     
    <xsl:value-of select="." /><xsl:text>"</xsl:text>
  </xsl:template>
  <xsl:template match="@*[substring-before(name(),':')='on']">
    <xsl:text>"on</xsl:text>     
    <xsl:call-template name="capitalize">
      <xsl:with-param name="text" select="local-name()" />
    </xsl:call-template><xsl:text>":</xsl:text>     
    <xsl:value-of select="." />
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
      <xsl:text>, </xsl:text>       
      <xsl:value-of select="translate(@from,'.','_')" />
    </xsl:for-each>    ) { 
    <xsl:text>&#x000A;</xsl:text>     "use strict" 
    <xsl:text>&#x000A;</xsl:text>     Object.defineProperty(exports, "__esModule", {value:true}); var React  = react; 
    <xsl:for-each select="//jsx:import">
      <xsl:text>var </xsl:text>       
      <xsl:choose>
        <xsl:when test="@as">
          <xsl:value-of select="@as" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@value" />
        </xsl:otherwise>
      </xsl:choose><xsl:text>=</xsl:text>       
      <xsl:value-of select="translate(@from,'.','_')" /><xsl:text>.</xsl:text>       
      <xsl:value-of select="@value" /><xsl:text>;</xsl:text>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="helpers">
        var _empty = Object.freeze([]); var _type  = function(v){ if      (v === null)               {return 0} else if (v ==  [])                 {return 0} else if (!v)                       {return 0} else if (v.length== 0)             {return 0} else if (v === true)               {return 1} else if (typeof(v) === "number")   {return 'n'} else if (typeof(v) === "string")   {return 's'} else if (v instanceof Array)       {return 'a'} else if (v instanceof Object)      {return Object.getOwnPropertyNames(v).length > 0 ? 'o' : 0} else                               {return -1} }; var _flatten = function(){ var r = []; for (var i=0;i&lt;arguments.length;i++) { var v=arguments[i]; if (v instanceof Array) {r=r.concat(v)} else {r.push(v)} } return r; }; var _list  = function(v){ switch(_type(v)){ case 'n': case 's': return [v]; case 'a': return v; case 'o': return Object.getOwnPropertyNames(v).map(function(k){return v[k]}); default: return _empty; } };
  </xsl:template>
  <xsl:template name="umd-postamble">  });
  </xsl:template>
</xsl:stylesheet>