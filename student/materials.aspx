<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="materials.aspx.cs" Inherits="WebApplication.student.materials" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Learning Materials | MediLearn Hub</title>
  <link rel="stylesheet" href="../assets/css/style.css" />
  <link rel="stylesheet" href="../assets/css/dashboard.css" />
  <style>
    .materials-top-bar {
      display: flex;
      justify-content: space-between;
      margin-bottom: 15px;
    }
    .search-box {
      flex: 1;
      padding: 10px;
      border-radius: 6px;
      border: 1px solid #ccc;
      margin-right: 10px;
    }
    .materials-table {
      width: 100%;
      border-collapse: collapse;
      text-align: left;
    }
    .materials-table th, .materials-table td {
      padding: 10px;
      border-bottom: 1px solid #ddd;
    }
    .btn {
      padding: 6px 12px;
      border-radius: 5px;
      cursor: pointer;
      border: none;
    }
    .btn-primary { background-color: #007bff; color: #fff; }
    .btn-ghost { background-color: transparent; color: #007bff; border: 1px solid #007bff; }
  </style>
</head>

<body class="dashboard-body">
  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="sidebar-header">
      <img src="../assets/images/logo.png" alt="MediLearn Hub" class="sidebar-logo" />
      <h2>MediLearn Hub</h2>
    </div>
    <nav class="sidebar-nav">
      <a href="student-dashboard.aspx">🏠 Dashboard</a>
      <a href="profile.aspx">👤 Profile</a>
      <a href="materials.aspx" class="active">📚 Learning Materials</a>
      <a href="quiz.aspx">🧠 Quizzes</a>
      <a href="anatomy.aspx">👨🏽‍🔬 3D Anatomy</a>
      <a href="notes.aspx">📝 My Notes</a>
   <a href="quiz-summary.aspx">🥇Quizz results summary</a>
      <a href="../index.aspx" class="logout">🚪 Logout</a>
    </nav>
  </aside>

  <!-- Main Content -->
  <form id="form1" runat="server" class="dashboard-main">
    <header class="dashboard-header">
      <h1>📚 Learning Materials</h1>
      <p>View and download shared study materials.</p>
    </header>

    <div class="materials-top-bar">
      <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" Placeholder="🔍 Search materials..."></asp:TextBox>
      <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="Search" OnClick="btnSearch_Click" />
    </div>

    <section class="materials-section">
      <asp:GridView ID="gvMaterials" runat="server" AutoGenerateColumns="False"
        AllowPaging="True" PageSize="5"
        OnPageIndexChanging="gvMaterials_PageIndexChanging"
        OnRowCommand="gvMaterials_RowCommand"
        CssClass="materials-table">
        <Columns>
          <asp:BoundField DataField="Title" HeaderText="Title" />
          <asp:BoundField DataField="Category" HeaderText="Category" />
          <asp:BoundField DataField="FileType" HeaderText="Type" />
          <asp:BoundField DataField="UploadedBy" HeaderText="Uploaded by" />
          <asp:TemplateField HeaderText="Action">
            <ItemTemplate>
              <asp:Button ID="btnView" runat="server" Text="View" CssClass="btn btn-ghost"
                CommandName="ViewMaterial" CommandArgument='<%# Eval("MaterialID") %>' />
              <asp:Button ID="btnDownload" runat="server" Text="Download" CssClass="btn btn-primary"
                CommandName="DownloadMaterial" CommandArgument='<%# Eval("MaterialID") %>' />
            </ItemTemplate>
          </asp:TemplateField>
        </Columns>
      </asp:GridView>
    </section>
  </form>
</body>
</html>
