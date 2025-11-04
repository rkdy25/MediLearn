<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="WebApplication.admin.dashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css" />
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
                <a href="dashboard.aspx" class="active">🏠 Dashboard</a>
                <a href="manage-users.aspx">👥 Manage Users</a>
                <a href="manage-materials.aspx">📂 Manage Materials</a>
                <a href="../index.aspx" class="logout">🚪 Logout</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="dashboard-main">
            <header class="dashboard-header">
                <h1>👨‍💼 Admin Dashboard</h1>
                <p>Monitor users, manage system data, and oversee platform performance.</p>
            </header>

            <!-- Overview Cards -->
            <section class="overview-cards">
                <div class="overview-card">
                    <h3>Total Students</h3>
                    <asp:Label ID="lblTotalStudents" runat="server" Text="0" CssClass="value"></asp:Label>
                </div>
                <div class="overview-card">
                    <h3>Total Lecturers</h3>
                    <asp:Label ID="lblTotalLecturers" runat="server" Text="0" CssClass="value"></asp:Label>
                </div>
                <div class="overview-card">
                    <h3>Total Materials</h3>
                    <asp:Label ID="lblTotalMaterials" runat="server" Text="0" CssClass="value"></asp:Label>
                </div>
                <div class="overview-card">
                    <h3>Total Quizzes</h3>
                    <asp:Label ID="lblTotalQuizzes" runat="server" Text="0" CssClass="value"></asp:Label>
                </div>
            </section>

            <!-- Management Tables -->
            <section class="admin-section">
                <!-- Users Table -->
                <div class="admin-card">
                    <h2>👥 User Management</h2>

                    <!-- Add User Button -->
                    <div style="margin-bottom:15px;">
                        <asp:Button ID="btnGoToRegister" runat="server" CssClass="btn btn-primary"
                            Text="➕ Add User" OnClick="btnGoToRegister_Click" />
                    </div>

                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table"
                        AllowPaging="True" PageSize="5" OnPageIndexChanging="gvUsers_PageIndexChanging"
                        OnRowCommand="gvUsers_RowCommand">
                        <Columns>
                            <asp:BoundField HeaderText="User ID" DataField="UserID" />
                            <asp:BoundField HeaderText="Name" DataField="Name" />
                            <asp:BoundField HeaderText="Role" DataField="Role" />
                            <asp:BoundField HeaderText="Email" DataField="Email" />
                            <asp:BoundField HeaderText="Status" DataField="Status" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnEdit" runat="server" CssClass="btn btn-ghost" Text="Edit"
                                        CommandName="EditUser" CommandArgument='<%# Eval("UserID") %>' />
                                    <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger" Text="Delete"
                                        CommandName="DeleteUser" CommandArgument='<%# Eval("UserID") %>'
                                        OnClientClick="return confirm('Are you sure you want to delete this user?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Materials Table -->
                <div class="admin-card">
                    <h2>📂 Uploaded Materials</h2>
                    <asp:GridView ID="gvMaterials" runat="server" AutoGenerateColumns="False" CssClass="table"
                        AllowPaging="True" PageSize="5" OnPageIndexChanging="gvMaterials_PageIndexChanging"
                        OnRowCommand="gvMaterials_RowCommand">
                        <Columns>
                            <asp:BoundField HeaderText="ID" DataField="MaterialID" />
                            <asp:BoundField HeaderText="Title" DataField="Title" />
                            <asp:BoundField HeaderText="Lecturer" DataField="Lecturer" />
                            <asp:BoundField HeaderText="Type" DataField="Type" />
                            <asp:BoundField HeaderText="Date" DataField="UploadDate" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnView" runat="server" CssClass="btn btn-ghost" Text="View"
                                        CommandName="ViewMaterial" CommandArgument='<%# Eval("MaterialID") %>' />
                                    <asp:Button ID="btnDeleteMaterial" runat="server" CssClass="btn btn-danger" Text="Delete"
                                        CommandName="DeleteMaterial" CommandArgument='<%# Eval("MaterialID") %>'
                                        OnClientClick="return confirm('Are you sure you want to delete this material?');" />
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
