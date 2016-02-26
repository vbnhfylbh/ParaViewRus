<?xml version="1.0" encoding="utf8"?>
<!-- XSL used to generate XML DOM from ServerManager xmls as well as GUI
    configuration xmls for sources/filters/etc.
    to run use : xmlpatterns <xsl> <xml> -output <html>
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8"/>
<xsl:template match="ServerManagerConfiguration/ProxyGroup">
  <xsl:for-each select="CompoundSourceProxy|SourceProxy|Proxy|PWriterProxy|WriterProxy|PSWriterProxy">
    <proxy>
      <group><xsl:value-of select="../@name" /></group>
      <name><xsl:value-of select="@name" /></name>
      <label>
        <xsl:choose>
          <xsl:when test="@label"> <xsl:value-of select="@label" /> </xsl:when>
          <xsl:otherwise> <xsl:value-of select="@name" /> </xsl:otherwise>
        </xsl:choose>
      </label>
      <xsl:apply-templates select="Documentation" />
      <xsl:for-each select="DoubleVectorProperty|InputProperty|IntVectorProperty|StringVectorProperty|ProxyProperty|IdTypeVectorProperty">
      <property>
        <name><xsl:value-of select="@name" /></name>
        <label>
          <xsl:choose>
            <xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
          </xsl:choose>
        </label>
        <xsl:apply-templates select="Documentation" />
        <defaults><xsl:call-template name="WriteDefaults" /> </defaults>
        <domains><xsl:call-template name="WriteDomain" /></domains>
      </property>
    </xsl:for-each>
    <xsl:if test="Hints/ReaderFactory">
      <xsl:copy-of select="Hints/ReaderFactory" />
    </xsl:if>
    <xsl:if test="Hints/WriterFactory">
      <xsl:copy-of select="Hints/WriterFactory" />
    </xsl:if>
    </proxy>
  </xsl:for-each>
</xsl:template>

<!-- Defaults Handler -->
<xsl:template name="WriteDefaults">
  <xsl:if test="@default_values">
    <xsl:value-of select="@default_values" />
  </xsl:if>
</xsl:template>

<!-- Domains Handler -->
<xsl:template name="WriteDomain">
  <xsl:apply-templates select="ArrayListDomain" />
  <xsl:apply-templates select="ArrayRangeDomain" />
  <xsl:apply-templates select="ArraySelectionDomain" />
  <xsl:apply-templates select="BooleanDomain" />
  <xsl:apply-templates select="BoundsDomain" />
  <xsl:apply-templates select="DataTypeDomain" />
  <xsl:apply-templates select="DoubleRangeDomain" />
  <xsl:apply-templates select="IntRangeDomain" />
  <xsl:apply-templates select="EnumerationDomain" />
  <xsl:apply-templates select="ExtentDomain" />
  <xsl:apply-templates select="FieldDataDomain" />
  <xsl:apply-templates select="FileListDomain" />
  <xsl:apply-templates select="FixedTypeDomain" />
  <xsl:apply-templates select="InputArrayDomain" />
  <xsl:apply-templates select="ProxyGroupDomain" />
  <xsl:apply-templates select="ProxyListDomain" />
  <xsl:apply-templates select="StringListDomain" />
</xsl:template>

<xsl:template match="StringListDomain">
  <domain>
    <text>Только из следующего списка:</text>
    <list>
      <xsl:for-each select="String">
        <item><xsl:value-of select="@value"/></item>
      </xsl:for-each>
    </list>
  </domain>
</xsl:template>

<xsl:template match="ProxyListDomain">
  <domain>
    <text>Только из следующего списка:</text>
    <list>
      <xsl:for-each select="Proxy">
        <item>
          <xsl:value-of select="@name"/> (<xsl:value-of select="@group"/>)
        </item>
      </xsl:for-each>
    </list>
  </domain>
</xsl:template>

<xsl:template match="ProxyGroupDomain">
  <!-- ugh, ignore this domain. It's pretty pointless anyways.-->
</xsl:template>

<xsl:template match="ExtentDomain">
  <domain>
    <text>Значения должны лежать внутри структуры входного набора данных.</text>
  </domain>
</xsl:template>

<xsl:template match="FieldDataDomain">
  <domain>
    <text>Имя массива поля.</text>
  </domain>
</xsl:template>

<xsl:template match="FileListDomain">
  <domain>
    <text>Имя файла или файлов.</text>
  </domain>
</xsl:template>

<xsl:template match="FixedTypeDomain">
  <domain>
    <text>Входной набора данных неизменен.</text>
  </domain>
</xsl:template>

<xsl:template match="InputArrayDomain">
  <domain>
    <text>
      Набора данных должен содержать массив поля (<xsl:value-of select="@attribute_type"/>)
      <xsl:if test="@number_of_components">
        with <xsl:value-of select="@number_of_components"/> component(s).
      </xsl:if>
    </text>
  </domain>
</xsl:template>

<xsl:template match="EnumerationDomain">
  <domain>
    <text>Перечисление:</text>
    <list>
      <xsl:for-each select="Entry">
        <item><xsl:value-of select="@text"/> (<xsl:value-of select="@value"/>)</item>
      </xsl:for-each>
    </list>
  </domain>
</xsl:template>


<xsl:template match="ArrayListDomain[@attribute_type='Scalars']">
  <!-- Handle ArrayListDomain -->
  <domain><text>Массив скаляров.</text></domain>
</xsl:template>

<xsl:template match="ArrayListDomain[@attribute_type='Vectors']">
  <!-- Handle ArrayListDomain -->
  <domain><text>Массив векторов.</text></domain>
</xsl:template>

<xsl:template match="ArrayRangeDomain">
  <domain><text>Значения должны быть в диапазоне выбранного массива данных.</text></domain>
</xsl:template>

<xsl:template match="ArraySelectionDomain">
  <domain><text>Список имен массивов предосталвяется модулем загрузки из файла.</text></domain>
</xsl:template>

<xsl:template match="BoundsDomain[@mode='normal']">
  <domain><text>
      Значение должны лежать в границах параллелепипеда набора данных.
      <xsl:if test="@default_mode">
        Значение по-умолчанию это <xsl:value-of select="@default_mode" /> для каждой оси.
      </xsl:if>
  </text></domain>
</xsl:template>

<xsl:template match="BoundsDomain[@mode='magnitude']">
  <domain><text>
  Определяет длину диагонали набора данных.
  Значение должно быть в пределах -длина диагонали до +длина диагонали.
  </text></domain>
</xsl:template>

<xsl:template match="BoundsDomain[@mode='scaled_extent']">
  <domain><text>
  Значение должно быть меньше чем наибольшее измерение
  набора данных, умноженное на коэффициент масштабирования
  <xsl:value-of select="@scale_factor" />.
  </text></domain>
</xsl:template>

<xsl:template match="DoubleRangeDomain">
  <xsl:call-template name="RangeDomain"/>
</xsl:template>

<xsl:template match="IntRangeDomain">
  <xsl:call-template name="RangeDomain"/>
</xsl:template>

<xsl:template name="RangeDomain">
  Значения должны быть в диапазоне (
    <xsl:value-of select="@min"/>,
    <xsl:value-of select="@max"/>).
</xsl:template>

<xsl:template match="DataTypeDomain">
  <domain>
    <text>Принимает на вход типы:</text>
    <list>
      <xsl:for-each select="DataType">
        <item><xsl:value-of select="@value" /> </item>
      </xsl:for-each>
    </list>
  </domain>
</xsl:template>

<xsl:template match="BooleanDomain">
  <domain><text>Принимает будевы значения (0 или 1).</text></domain>
</xsl:template>

<!-- Documentation Handler -->
<xsl:template match="Documentation">
  <documentation>
    <brief>
      <xsl:choose>
        <xsl:when test="@long_help">
          <xsl:value-of select="@long_help" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="@short_help">
             <xsl:value-of select="@short_help" />
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </brief>
    <long><xsl:value-of select="." /></long>
  </documentation>
</xsl:template>

<xsl:template match="ParaViewSources">
  <categoryindex>
    <label>Sources</label>
    <xsl:call-template name="GenerateCategoryIndex" />
  </categoryindex>
</xsl:template>

<xsl:template match="ParaViewFilters">
  <categoryindex>
    <label>Filters</label>
    <xsl:call-template name="GenerateCategoryIndex" />
  </categoryindex>
</xsl:template>

<xsl:template name="GenerateCategoryIndex" >
  <xsl:for-each select="//Proxy">
    <xsl:element name="item">
      <xsl:attribute name="proxy_name"><xsl:value-of select="@name"/></xsl:attribute>
      <xsl:attribute name="proxy_group"><xsl:value-of select="@group"/></xsl:attribute>
    </xsl:element>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
