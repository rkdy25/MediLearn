<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="upload-materials.aspx.cs" Inherits="WebApplication.lecturer.upload_materials" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Upload Materials | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <link rel="stylesheet" href="../assets/css/upload-materials.css" />
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
                <a href="upload-materials.aspx" class="active">📂 Upload Materials</a>
                <a href="create-quiz.aspx">🧠 Create Quiz</a>
                <a href="search-resources.aspx">🔍 Search Resources</a>
                <a href="../index.aspx" class="logout">🚪 Logout</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="dashboard-main">
            <header class="dashboard-header">
                <h1>📂 Manage Learning Materials</h1>
                <p>Upload, view, and delete course resources easily.</p>
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
                                <asp:ListItem Text="Cardiology" Value="Cardiology" />
                                 <asp:ListItem Text="Anatomy" Value="Anatomy" />
                                <asp:ListItem Text="Microbiology" Value="Microbiology" />
                                  <asp:ListItem Text="Biochemistry" Value="Biochemistry" />
                                 <asp:ListItem Text="Pharmacology" Value="Pharmacology" />
                                 <asp:ListItem Text="3D Video" Value="3D Video" />
                                
                       </asp:DropDownList>


                        <label for="fileUpload">Choose File</label>
                        <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" />

                        <asp:Button ID="btnUpload" runat="server" CssClass="btn btn-primary" Text="Upload Material" OnClick="btnUpload_Click" />

                    </asp:Panel>
                </div>

                <!-- Uploaded List -->
                <div class="materials-list">
                    <h2>Uploaded Materials</h2>
                  
<asp:GridView ID="gvMaterials" runat="server" AutoGenerateColumns="False" CssClass="table"
    AllowPaging="True" PageSize="3"
    OnPageIndexChanging="gvMaterials_PageIndexChanging"
    OnRowCommand="gvMaterials_RowCommand">
    <Columns>
        <asp:BoundField DataField="Title" HeaderText="Title" />
        <asp:BoundField DataField="Category" HeaderText="Category" />
        <asp:BoundField DataField="FileType" HeaderText="File Type" />
        <asp:BoundField DataField="UploadedBy" HeaderText="Uploaded By" />
        <asp:BoundField DataField="UploadDate" HeaderText="Date Uploaded" DataFormatString="{0:yyyy-MM-dd}" />
        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:Button ID="btnDownload" runat="server" CssClass="btn btn-ghost" Text="Download"
                            CommandName="DownloadMaterial" CommandArgument='<%# Eval("MaterialID") %>' />
                
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