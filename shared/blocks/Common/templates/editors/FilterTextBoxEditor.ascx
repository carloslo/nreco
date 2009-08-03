﻿<%@ Control Language="c#" AutoEventWireup="false" CodeFile="FilterTextBoxEditor.ascx.cs" Inherits="FilterTextBoxEditor" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<%@ Register TagPrefix="Dalc" Namespace="NI.Data.Dalc.Web" assembly="NI.Data.Dalc" %>
<asp:TextBox id="textbox" runat="server" Text='@@lt;%# Text %@@gt;'/>
<div style="display:none"><asp:LinkButton id="lazyFilter" runat="server" onclick="HandleLazyFilter"/></div>
<script type="text/javascript">
var filterTextBox<%=ClientID %>Last = null;
jQuery('#<%=textbox.ClientID %>').keydown( function(e) {
	if (e.keyCode==13) {
		filterTextBox<%=ClientID %>Last = new Date();
		<%=Page.ClientScript.GetPostBackEventReference(new PostBackOptions(lazyFilter)) %>;
		return false;
	} else if (e.keyCode>=32) {
		var datetimenow = new Date();
		filterTextBox<%=ClientID %>Last = datetimenow;
		setTimeout( function() {
			if (filterTextBox<%=ClientID %>Last <= datetimenow)
				<%=Page.ClientScript.GetPostBackEventReference(new PostBackOptions(lazyFilter)) %>;
		},1000);
	}
} );
jQuery(function(){
	if (<%=LazyFilterHandled.ToString().ToLower() %>)
		setTimeout( function() { jQuery('#<%=textbox.ClientID %>').focus(); }, 50 );
});
</script>