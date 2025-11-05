<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="upload-materials.aspx.cs" Inherits="WebApplication.lecturer.upload_materials" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Course Materials | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <style>
        .course-header {
            background: #0078d7;
            color: white;
            padding: 15px 25px;
            border-radius: 12px;
            margin-bottom: 25px;
        }
        .upload-card, .materials-list {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 25px;
        }
        .btn {
            padding: 6px 12px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
        }
        .btn-primary { background: #0078d7; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-ghost { background: #f1f1f1; color: #333; }
        .form-control { width: 100%; padding: 8px; margin-bottom: 10px; }

        .nice-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    border: 1px solid #ddd;
    border-radius: 12px;
    overflow: hidden;
    background: #fff;
    font-family: 'Segoe UI', sans-serif;
}

.nice-table th {
    background: #0078d7;
    color: white;
    padding: 12px;
    text-align: left;
    font-weight: 600;
}

.nice-table td {
    padding: 10px 14px;
    border-bottom: 1px solid #eee;
    vertical-align: middle;
}

.nice-table tr:nth-child(even) {
    background-color: #f8f9fa;
}

.nice-table tr:hover {
    background-color: #e9f5ff;
    transition: background 0.3s;
}

.nice-table .btn {
    padding: 6px 10px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.9rem;
}

.nice-table .btn-ghost {
    background: #eef3f8;
    color: #0078d7;
    margin-right: 6px;
}

.nice-table .btn-ghost:hover {
    background: #d9ecff;
}

.nice-table .btn-danger {
    background: #dc3545;
    color: white;
}

.nice-table .btn-danger:hover {
    background: #c82333;
}

.grid-pager {
    padding: 12px;
    background: #f1f1f1;
    border-top: 1px solid #ddd;
}

.grid-pager a, .grid-pager span {
    margin: 0 5px;
    padding: 6px 10px;
    text-decoration: none;
    color: #0078d7;
    border-radius: 6px;
}

.grid-pager span {
    background: #0078d7;
    color: white;
}

    </style>
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
<a href="my-courses.aspx" class="active">📘 Manage Courses</a>
<a href="search-resources.aspx">🔍 Search Resources</a>
<a href="../index.aspx">🚪 Logout</a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="dashboard-main">
        <header class="course-header">
            <h1>📂 Manage Materials for: <asp:Label ID="lblCourseName" runat="server" /></h1>
        </header>

        <section class="materials-section">

            <!-- Upload Form -->
            <div class="upload-card">
                <h2>Upload New Material</h2>
                <asp:Panel ID="pnlUpload" runat="server" CssClass="upload-form">

                    <label for="txtTitle">Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" Placeholder="Enter material title..." />

                    <label for="ddlCategory">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Select a Category" Value="" />
                        <asp:ListItem Text="Document" Value="Document" />
                        <asp:ListItem Text="Power Point" Value="Power Point" />
                        <asp:ListItem Text="Image" Value="Image" />
                        <asp:ListItem Text="3D Video" Value="3D Video" />
                    </asp:DropDownList>

                    <label for="fileUpload">Choose File</label>
                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" />

                    <asp:Button ID="btnUpload" runat="server" CssClass="btn btn-primary" Text="Upload Material" OnClick="btnUpload_Click" />
                </asp:Panel>
            </div>

            <!-- Uploaded List -->
<div class="materials-list">
    <h2>All Uploaded Materials</h2>

    <asp:GridView ID="gvMaterials" runat="server" AutoGenerateColumns="False" CssClass="nice-table"
        AllowPaging="True" PageSize="5"
        OnPageIndexChanging="gvMaterials_PageIndexChanging"
        OnRowCommand="gvMaterials_RowCommand"
        EmptyDataText="No materials uploaded for this course.">

        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Title" />
            <asp:BoundField DataField="Category" HeaderText="Category" />
            <asp:BoundField DataField="FileType" HeaderText="File Type" />
            <asp:BoundField DataField="UploadDate" HeaderText="Uploaded On" DataFormatString="{0:yyyy-MM-dd}" />
           <asp:TemplateField HeaderText="Actions">
    <ItemTemplate>
        <asp:Button ID="btnDownload" runat="server" CssClass="btn btn-ghost" Text="⬇ Download"
            CommandName="DownloadMaterial" CommandArgument='<%# Eval("MaterialID") %>' />

        <asp:Button ID="btnEdit" runat="server" CssClass="btn btn-warning" Text="✏ Edit"
            CommandName="EditMaterial" CommandArgument='<%# Eval("MaterialID") %>' />

        <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger" Text="🗑 Delete"
            CommandName="DeleteMaterial" CommandArgument='<%# Eval("MaterialID") %>'
            OnClientClick="return confirm('Are you sure you want to delete this material?');" />
    </ItemTemplate>
</asp:TemplateField>

        </Columns>

        <PagerStyle CssClass="grid-pager" HorizontalAlign="Center" />
    </asp:GridView>
</div>


        </section>
    </main>

</form>
</body>
</html>
