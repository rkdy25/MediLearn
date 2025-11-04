<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="manage-materials.aspx.cs" Inherits="WebApplication.admin.manage_materials" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Materials | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <link rel="stylesheet" href="../assets/css/admin-manage-materials.css" />
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
                <a href="dashboard.aspx">🏠 Dashboard</a>
                <a href="manage-users.aspx">👥 Manage Users</a>
                <a href="manage-materials.aspx" class="active">📂 Manage Materials</a>
                <a href="../index.aspx" class="logout">🚪 Logout</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="dashboard-main">
            <header class="dashboard-header">
                <h1>📂 Manage Uploaded Materials</h1>
                <p>View, search, or delete uploaded materials from the MediLearn Hub database.</p>
            </header>

            <section class="admin-section" style="display:flex; flex-direction:column; gap:20px;">

                <!-- Search / Filter -->
                <div class="admin-card search-materials-card">
                    <h2>Search / Filter Materials</h2>
                    <div class="material-search-form" style="display:flex; gap:10px; flex-wrap:wrap; align-items:center;">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                                     placeholder="Search by title or uploader..." />
                        <asp:DropDownList ID="ddlTypeFilter" runat="server" CssClass="form-control">
                            <asp:ListItem Text="All Types" Value="" />
<asp:ListItem Text="PDF" Value="pdf" />
<asp:ListItem Text="Video" Value="video" />
<asp:ListItem Text="Presentation" Value="pptx" />
<asp:ListItem Text="Image" Value="jpg" />
<asp:ListItem Text="Text file" Value="txt" />
<asp:ListItem Text="Document" Value="docx" />
                        </asp:DropDownList>
                        <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary"
                                    Text="🔍 Search" OnClick="btnSearch_Click" />
                    </div>
                </div>

                <!-- Materials List -->
                <div class="admin-card materials-list-card">
                    <h2>Uploaded Materials</h2>
                    <asp:GridView ID="gvMaterials" runat="server" AutoGenerateColumns="False" CssClass="table"
                                  OnRowCommand="gvMaterials_RowCommand">
                        <Columns>
                            <asp:BoundField HeaderText="ID" DataField="MaterialID" />
                            <asp:BoundField HeaderText="Title" DataField="Title" />
                            <asp:BoundField HeaderText="Uploader" DataField="UploadedBy" />
                            <asp:BoundField HeaderText="Type" DataField="FileType" />
                            <asp:BoundField HeaderText="Upload Date" DataField="UploadDate" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnDownload" runat="server" CssClass="btn btn-ghost"
                                                Text="Download" CommandName="DownloadMaterial"
                                                CommandArgument='<%# Eval("MaterialID") %>' />
                                    <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger"
                                                Text="Delete" CommandName="DeleteMaterial"
                                                CommandArgument='<%# Eval("MaterialID") %>'
                                                OnClientClick="return confirm('Are you sure you want to delete this material?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <!-- Pager Panel -->
                    <asp:Panel ID="pnlPager" runat="server" CssClass="pager-panel" style="margin-top:15px;" />
                </div>

            </section>
        </main>
    </form>
</body>
</html>
