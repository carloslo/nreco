<!--
NReco library (http://nreco.googlecode.com/)
Copyright 2008,2009 Vitaliy Fedorchenko
Distributed under the LGPL licence
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->	
<xsl:stylesheet version='1.0' 
				xmlns:e="urn:schemas-nreco:nreco:entity:v1"
				xmlns:l="urn:schemas-nreco:nreco:web:layout:v1"
				xmlns:xsl='http://www.w3.org/1999/XSL/Transform' 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
				xmlns:Dalc="urn:remove"
				xmlns:NReco="urn:remove"
				xmlns:asp="urn:remove"
				exclude-result-prefixes="msxsl">

	<xsl:output method='xml' indent='yes' />

	<xsl:template match="l:field[l:editor/l:checklist]" mode="register-editor-control">
		@@lt;%@ Register TagPrefix="Plugin" tagName="DropdownCheckListEditor" src="~/templates/editors/DropdownCheckListEditor.ascx" %@@gt;
	</xsl:template>	
	<xsl:template match="l:field[l:editor/l:checklist]" mode="register-editor-css">
		<link rel="stylesheet" type="text/css" href="css/dropdownchecklist/ui.dropdownchecklist.css" />
	</xsl:template>	
	
	<xsl:template match="l:field[l:editor/l:checklist]" mode="form-view-editor">
		<xsl:param name="context"/>	
		<xsl:variable name="ctrlId">
			<xsl:choose>
				<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
				<xsl:otherwise>editor<xsl:value-of select="generate-id(.)"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<Plugin:DropdownCheckListEditor id="{$ctrlId}" runat="server" xmlns:Plugin="urn:remove"
			DalcServiceName="{$dalcName}"
			DsFactoryServiceName="{$datasetFactoryName}"
			LookupServiceName="{l:editor/l:checklist/l:lookup/@name}"
			TextFieldName="{l:editor/l:checklist/l:lookup/@text}"
			ValueFieldName="{l:editor/l:checklist/l:lookup/@value}"
			RelationSourceName="{l:editor/l:checklist/l:relation/@sourcename}"
			LFieldName="{l:editor/l:checklist/l:relation/@left}"
			RFieldName="{l:editor/l:checklist/l:relation/@right}">
			<xsl:if test="@name or not(l:editor/l:checklist/l:relation)">
				<xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="l:editor/l:checklist/@id">
					<xsl:attribute name="EntityId">@@lt;%# Eval("<xsl:value-of select="l:editor/l:checklist/@id"/>") %@@gt;</xsl:attribute>
					<xsl:attribute name="EntityIdField"><xsl:value-of select="l:editor/l:checklist/@id"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="l:editor/l:checklist/l:relation/@id">
					<xsl:attribute name="EntityId">@@lt;%# Eval("<xsl:value-of select="l:editor/l:checklist/l:relation/@id"/>") %@@gt;</xsl:attribute>
					<xsl:attribute name="EntityIdField"><xsl:value-of select="l:editor/l:checklist/l:relation/@id"/></xsl:attribute>
				</xsl:when>
				<!--xsl:otherwise>
					<xsl:attribute name="EntityId">@@lt;%# FormView.DataKey.Value %@@gt;</xsl:attribute>
					<xsl:attribute name="EntityIdField">@@lt;%# FormView.DataKeyNames[0] %@@gt;</xsl:attribute>
				</xsl:otherwise-->
			</xsl:choose>
			<xsl:if test="l:editor/l:checklist/l:default/@provider">
				<xsl:attribute name="DefaultValueServiceName"><xsl:value-of select="l:editor/l:checklist/l:default/@provider"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="l:editor/l:checklist/@width">
				<xsl:attribute name="Width"><xsl:value-of select="l:editor/l:checklist/@width"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="l:editor/l:checklist/l:lookup/l:*">
				<xsl:variable name="contextExpr"><xsl:apply-templates select="l:editor/l:checklist/l:lookup/l:*" mode="csharp-expr"><xsl:with-param name="context" select="$context"/></xsl:apply-templates></xsl:variable>
				<xsl:attribute name="LookupDataContext">@@lt;%# <xsl:value-of select="$contextExpr"/> %@@gt;</xsl:attribute>
			</xsl:if>
			<xsl:if test="l:editor/l:checklist/l:default/l:*">
				<xsl:variable name="contextExpr"><xsl:apply-templates select="l:editor/l:checklist/l:default/l:*" mode="csharp-expr"><xsl:with-param name="context" select="$context"/></xsl:apply-templates></xsl:variable>
				<xsl:attribute name="DefaultDataContext">@@lt;%# <xsl:value-of select="$contextExpr"/> %@@gt;</xsl:attribute>
			</xsl:if>
		</Plugin:DropdownCheckListEditor>
	</xsl:template>		
	
</xsl:stylesheet>