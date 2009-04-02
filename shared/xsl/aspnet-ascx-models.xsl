<xsl:stylesheet version='1.0' 
				xmlns:xsl='http://www.w3.org/1999/XSL/Transform' 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
				xmlns:Dalc="urn:remove"
				xmlns:NReco="urn:remove"
				xmlns:asp="urn:remove"
				exclude-result-prefixes="msxsl">

	<xsl:output method='xml' indent='yes' />

	<xsl:template match='/model'>
		<files>
			<xsl:apply-templates select="layouts/*"/>
		</files>
	</xsl:template>
	
	<xsl:template match="form">
		<file name="templates/generated/{@name}.ascx">
			<content>
<!-- form control header -->
@@lt;%@ Control Language="c#" AutoEventWireup="false" Inherits="System.Web.UI.UserControl" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %@@gt;

				<xsl:variable name="mainDsId">
					<xsl:choose>
						<xsl:when test="@datasource"><xsl:value-of select="@datasource"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="datasources/*[position()=1]/@id"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:apply-templates select="datasources/*" mode="form-view-datasource"/>
				<NReco:ActionDataSource runat="server" id="mainActionDataSource" DataSourceID="{$mainDsId}"/>

				<script language="c#" runat="server">
				public void FormViewInsertedHandler(object sender, FormViewInsertedEventArgs e) {
					Response.Redirect(this.GetRouteUrl("<xsl:value-of select="@route-name"/>", e.Values), false);
				}
				protected override void OnLoad(EventArgs e) {
					var context = this.GetPageContext();
					if (context.ContainsKey("id")) {
						<xsl:value-of select="$mainDsId"/>.Condition = (QField)"id" == new QConst(context["id"]);
					} else {
						FormView.DefaultMode = FormViewMode.Insert;
					}
					base.OnLoad(e);
				}
				</script>
				
				<xsl:apply-templates select="." mode="form-view"/>
			</content>
		</file>
	</xsl:template>
	
	<xsl:template match="form[not(@update-panel) or @update-panel='true' or @update-panel='1']" name="layout-update-panel-form" mode="form-view">
		<asp:UpdatePanel runat="server" UpdateMode="Conditional">
			<ContentTemplate>
				<xsl:call-template name="layout-form"/>
			</ContentTemplate>
		</asp:UpdatePanel>
	</xsl:template>
	
	<xsl:template match="form" name="layout-form" mode="form-view">
		<xsl:variable name="caption" select="@caption"/>
		<fieldset>
			<asp:formview id="FormView"
				oniteminserted="FormViewInsertedHandler"
				datasourceid="mainActionDataSource"
				allowpaging="false"
				datakeynames="id"
				Width="100%"
				runat="server">
				
				<itemtemplate>
					<legend><xsl:value-of select="$caption"/></legend>
					
					<table class="FormView" width="100%">
						<xsl:apply-templates select="field" mode="plain-form-view-table-row"/>
					</table>
					
					<div class="toolboxContainer buttons">
						<span class="Edit">
							<asp:linkbutton id="Edit" text="Edit" commandname="Edit" runat="server"/> 
						</span>
						<span class="Delete">
							<asp:linkbutton id="Delete" text="Delete" commandname="Delete" runat="server"/> 
						</span>
					</div>
				</itemtemplate>
				<edititemtemplate>
					<legend>Edit <xsl:value-of select="$caption"/></legend>
					<table class="FormView" width="100%">
						<xsl:apply-templates select="field" mode="edit-form-view-table-row"/>
					</table>
					<div class="toolboxContainer buttons">
						<span class="Save">	
							<asp:linkbutton id="Update" text="@@lt;%$ label: Save %@@gt;" commandname="Update" runat="server"/> 
						</span>
						<span class="Cancel">
							<asp:linkbutton id="Cancel" text="@@lt;%$ label: Cancel %@@gt;" commandname="Cancel" runat="server" CausesValidation="false"/> 
						</span>
					</div>
				</edititemtemplate>
				<insertitemtemplate>
					<legend>Create <xsl:value-of select="$caption"/></legend>
					<table class="FormView" width="100%">
						<xsl:apply-templates select="field" mode="edit-form-view-table-row"/>
					</table>
					<div class="toolboxContainer buttons">
						<span class="Save">	
							<asp:linkbutton id="Insert" text="@@lt;%$ label: Create %@@gt;" commandname="Insert" runat="server"/> 	
						</span>
					</div>					
				</insertitemtemplate>

			</asp:formview>
			
		</fieldset>
	</xsl:template>
	
	<xsl:template match="field" mode="plain-form-view-table-row">
		<tr>
			<th><xsl:value-of select="@caption"/>:</th>
			<td>
				<xsl:apply-templates select="." mode="form-view-renderer"/>
			</td>
		</tr>		
	</xsl:template>

	<xsl:template match="field" mode="edit-form-view-table-row">
		<tr>
			<th><xsl:value-of select="@caption"/>:</th>
			<td>
				<xsl:apply-templates select="." mode="form-view-editor"/>
				<xsl:apply-templates select="." mode="form-view-validator"/>
			</td>
		</tr>		
	</xsl:template>
	
	<xsl:template match="field" mode="form-view-renderer">
		@@lt;%# Eval("<xsl:value-of select="@name"/>") %@@gt;
	</xsl:template>
	
	<xsl:template match="field[editor/textbox]" mode="form-view-editor">
		<asp:TextBox id="{@name}" runat="server" Text='@@lt;%# Bind("{@name}") %@@gt;'/>
	</xsl:template>

	<xsl:template match="field[editor/dropdownlist]" mode="form-view-editor">
		<xsl:variable name="lookupPrvName" select="editor/dropdownlist/@lookup"/>
		<xsl:variable name="valueName">
			<xsl:choose>
				<xsl:when test="editor/dropdownlist/@value"><xsl:value-of select="editor/dropdownlist/@value"/></xsl:when>
				<xsl:otherwise>Key</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="textName">
			<xsl:choose>
				<xsl:when test="editor/dropdownlist/@text"><xsl:value-of select="editor/dropdownlist/@text"/></xsl:when>
				<xsl:otherwise>Value</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<asp:DropDownList runat="server" id="{@name}" SelectedValue='@@lt;%# Bind("{@name}") %@@gt;'
			DataSource='@@lt;%# WebManager.GetService@@lt;IProvider@@lt;object,IEnumerable@@gt;@@gt;("{$lookupPrvName}").Provide(null) %@@gt;'
			DataValueField="{$valueName}"
			DataTextField="{$textName}"/>
	</xsl:template>

	
	<xsl:template match="field" mode="form-view-validator">
		<xsl:apply-templates select="editor/validators/*" mode="form-view-validator">
			<xsl:with-param name="controlId" select="@name"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="required" mode="form-view-validator">
		<xsl:param name="controlId" select="@ctrl-id"/>
		<asp:requiredfieldvalidator runat="server" Display="Dynamic"
			ErrorMessage="@@lt;%$ label: Required Field %@@gt;" controltovalidate="{$controlId}" EnableClientScript="true"/>	
	</xsl:template>

	<xsl:template match="regex" mode="form-view-validator">
		<xsl:param name="controlId" select="@ctrl-id"/>
		<asp:RegularExpressionValidator runat="server" Display="Dynamic"
			ValidationExpression="{.}"
			ErrorMessage="@@lt;%$ label: Invalid value %@@gt;" controltovalidate="{$controlId}" EnableClientScript="true"/>	
	</xsl:template>
	
	<xsl:template match="dalc" mode="form-view-datasource">
		
		<xsl:variable name="dalcName" select="/model/dalc/@name"/>
		<xsl:variable name="dataSourceId" select="@id"/>
		<xsl:variable name="sourceName" select="@sourcename"/>
		
		<Dalc:DalcDataSource runat="server" id="{@id}" 
			Dalc='&lt;%$ service:{$dalcName} %>' SourceName="{$sourceName}" 
			DataSetMode="true" AutoIncrementNames="id" DataKeyNames="id"
			/>
	</xsl:template>
	
</xsl:stylesheet>