<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="search-resources.aspx.cs" Inherits="WebApplication.lecturer.search_resources" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Search Resources | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <link rel="stylesheet" href="../assets/css/search-resources.css" />
</head>
<body>
    <form id="form1" runat="server" class="dashboard-body">

        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <img src="../assets/images/logo.png" alt="MediLearn Hub" class="sidebar-logo" />
                <h2>MediLearn Hub</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="profile.aspx">👤 Profile</a>
<a href="my-courses.aspx">📘 Manage Courses</a>
<a href="search-resources.aspx" class="active">🔍 Search Resources</a>
                <a href="view-grades.aspx">📊 View Grades</a>
<a href="../index.aspx">🚪 Logout</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="dashboard-main">
            <header class="dashboard-header">
                <h1>🔍 Search Learning Resources</h1>
                <p>Find materials by title, type, or description.</p>
            </header>

            <section class="search-section">

                <!-- Search Bar -->
                <div class="search-bar">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="Search by title or keyword..." />
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control">
                        <asp:ListItem Text="All Types" Value="" />
                        <asp:ListItem Text="PDF" Value="pdf" />
                        <asp:ListItem Text="Video" Value="video" />
                        <asp:ListItem Text="Presentation" Value="pptx" />
                        <asp:ListItem Text="Image" Value="jpg" />
                        <asp:ListItem Text="Text file" Value="txt" />
                        <asp:ListItem Text="Document" Value="docx" />
                    </asp:DropDownList>
                    <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="Search" OnClick="btnSearch_Click" />
                </div>

                <!-- Search Results -->
                <div class="results-grid">
                    <asp:GridView ID="gvResources" runat="server" AutoGenerateColumns="False" CssClass="styled-grid"
    OnRowCommand="gvResources_RowCommand">
    <Columns>
        <asp:BoundField DataField="Title" HeaderText="Title" />
        <asp:BoundField DataField="Type" HeaderText="Type" />
        <asp:BoundField DataField="Lecturer" HeaderText="Lecturer" />
        <asp:BoundField DataField="UploadDate" HeaderText="Uploaded On" DataFormatString="{0:yyyy-MM-dd}" />
        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:Button ID="btnView" runat="server" CssClass="btn btn-ghost" Text="View"
                    CommandName="View" CommandArgument='<%# Eval("MaterialID") %>' />
                <asp:Button ID="btnDownload" runat="server" CssClass="btn btn-primary" Text="Download"
                    CommandName="Download" CommandArgument='<%# Eval("MaterialID") %>' />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

                </div>

            </section>
        </main>

    </form>
</body>
</html>