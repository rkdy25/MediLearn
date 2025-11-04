<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="manage-users.aspx.cs" Inherits="WebApplication.admin.manage_users" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Users | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <link rel="stylesheet" href="../assets/css/admin-manage-users.css" />
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
                <a href="manage-users.aspx" class="active">👥 Manage Users</a>
                <a href="manage-materials.aspx">📂 Manage Materials</a>
                <a href="../index.aspx" class="logout">🚪 Logout</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="dashboard-main">
            <header class="dashboard-header">
                <h1>👥 Manage Users</h1>
                <p>Add, edit, or remove users from the MediLearn system.</p>
            </header>

            <section class="admin-section" style="display:flex; flex-direction:column; gap:30px;">

                <!-- Add User Button -->
                <div class="admin-card add-user-card">
                    <h2>Add New User</h2>
                    <asp:Button ID="btnGoToRegister" runat="server" CssClass="btn btn-primary"
                        Text="➕ Go to Registration Page" OnClick="btnGoToRegister_Click"
                        CausesValidation="False" />
                </div>

               <!-- Search / Filter Users -->
<div class="admin-card search-users-card">
    <h2>Search / Filter Users</h2>
    <div class="user-search-form" style="display:flex; gap:10px; align-items:center;">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                     placeholder="Search by Name, Email, or Role" />
        <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary"
                    Text="🔍 Search" OnClick="btnSearch_Click" />
        <asp:Button ID="btnResetSearch" runat="server" CssClass="btn btn-secondary"
                    Text="Reset" OnClick="btnResetSearch_Click" />
    </div>
</div>


                <!-- Users List -->
                <div class="admin-card user-list-card">
                    <h2>Existing Users</h2>
                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table"
                                  OnRowCommand="gvUsers_RowCommand">
                        <Columns>
                            <asp:BoundField HeaderText="User ID" DataField="UserID" />
                            <asp:BoundField HeaderText="Name" DataField="Name" />
                            <asp:BoundField HeaderText="Email" DataField="Email" />
                            <asp:BoundField HeaderText="Role" DataField="Role" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger"
                                        Text="Delete" CommandName="DeleteUser"
                                        CommandArgument='<%# Eval("UserID") %>'
                                        OnClientClick="return confirm('Are you sure you want to delete this user?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    
<asp:Panel ID="pnlPager" runat="server" CssClass="pager-panel" />
                </div>

            </section>
        </main>
    </form>
</body>
</html>
