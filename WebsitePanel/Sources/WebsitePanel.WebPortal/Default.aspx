<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebsitePanel.WebPortal.DefaultPage" %>

<!DOCTYPE html>
<html>
<head runat="server">
<meta http-equiv="X-UA-Compatible" content="IE=9">
    <title>Untitled Page</title>
    <link runat="server" rel="stylesheet" href="~/Styles/Import.css" type="text/css" id="AdaptersInvariantImportCSS" />
<!--[if lt IE 7]>
    <link runat="server" rel="stylesheet" href="~/Styles/BrowserSpecific/IEMenu6.css" type="text/css" id="IEMenu6CSS" />
<![endif]--> 
<!--[if gt IE 6]>
    <link runat="server" rel="stylesheet" href="~/Styles/BrowserSpecific/IEMenu7.css" type="text/css" id="IEMenu7CSS" />
<![endif]--> 
</head>
<body>
    <form id="form1" runat="server"  autocomplete="off">
        <asp:PlaceHolder ID="skinPlaceHolder" runat="server"></asp:PlaceHolder>
    </form>
</body>
</html>
