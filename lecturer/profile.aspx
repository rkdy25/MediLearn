<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="profile.aspx.cs" Inherits="WebApplication.lecturer.profile" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lecturer Profile | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <link rel="stylesheet" href="../assets/css/lecturer-profile.css" />
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
                            <a href="profile.aspx"class="active">👤 Profile</a>
<a href="my-courses.aspx" >📘 Manage Courses</a>
<a href="search-resources.aspx">🔍 Search Resources</a>
<a href="../index.aspx">🚪 Logout</a>
                        </nav>
        </aside>

        <!-- Main Content -->
        <main class="dashboard-main">
            <header class="dashboard-header">
                <h1>👩‍🏫 Lecturer Profile</h1>
                <p>Manage your personal and professional information here.</p>
            </header>

            <!-- Profile Section -->
            <section class="profile-section">
                <div class="profile-card">
                    <div class="profile-left">
                        <asp:Image ID="imgProfile" runat="server" CssClass="profile-pic" ImageUrl="../assets/images/lecturer-card.png" />
                        <asp:FileUpload ID="filePhoto" runat="server" CssClass="file-upload" />
                        <asp:Button ID="btnChangePhoto" runat="server" CssClass="btn-change" Text="Change Photo" OnClick="btnChangePhoto_Click" />
                    </div>

                    <div class="profile-right">
                        <asp:Panel ID="pnlProfile" runat="server" CssClass="profile-form">

                            <label for="txtFirstName">First Name</label>
                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" ReadOnly="true" />

                            <label for="txtLastName">Last Name</label>
                            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" ReadOnly="true" />

                            <label for="txtEmail">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" />

                            <label for="txtPassword">Password</label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" />

                            <div class="profile-actions">
                                <asp:Button ID="btnSaveChanges" runat="server" CssClass="btn btn-primary" Text="Save Changes" OnClick="btnSaveChanges_Click" />
                                <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-ghost" Text="Cancel" CausesValidation="False" />
                            </div>

                        </asp:Panel>
                    </div>
                </div>
            </section>
        </main>

    </form>
</body>
</html>
