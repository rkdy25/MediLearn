<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="profile.aspx.cs" Inherits="WebApplication.student.profile" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Profile | MediLearn Hub</title>
  <link rel="stylesheet" href="../assets/css/style.css" />
  <link rel="stylesheet" href="../assets/css/dashboard.css" />
  <link rel="stylesheet" href="../assets/css/profile.css" />
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
      <a href="profile.aspx" class="active">👤 Profile</a>
      <a href="materials.aspx">📚 Learning Materials</a>
      <a href="quiz.aspx">🧠 Quizzes</a>
      <a href="anatomy.aspx">👨🏽‍🔬 3D Anatomy</a>
      <a href="notes.aspx">📝 My Notes</a>
    <a href="quiz-summary.aspx">🥇Quizz results summary</a>
      <a href="../index.aspx" class="logout">🚪 Logout</a>
    </nav>
  </aside>

  <!-- Main Content -->
  <form id="form1" runat="server" class="dashboard-main" enctype="multipart/form-data">
    <header class="dashboard-header">
      <h1>👤 My Profile</h1>
      <p>View your information and update your password or profile picture.</p>
    </header>

    <section class="profile-section">
      <div class="profile-card">

        <!-- Left: Profile Image -->
        <div class="profile-left">
          <asp:Image ID="imgProfile" runat="server" CssClass="profile-pic"
                     ImageUrl="../assets/images/avatar-student.png"
                     AlternateText="Student Avatar" />

          <asp:FileUpload ID="filePhoto" runat="server" CssClass="file-upload" />
          <asp:Button ID="btnChangePhoto" runat="server" CssClass="btn btn-ghost"
                      Text="Change Photo" OnClick="btnChangePhoto_Click" />
        </div>

        <!-- Right: Profile Info -->
        <div class="profile-right">
          <div class="profile-form">

            <!-- Read-Only Info -->
            <label for="txtFirstName">First Name</label>
            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" ReadOnly="True"></asp:TextBox>

            <label for="txtLastName">Last Name</label>
            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" ReadOnly="True"></asp:TextBox>

            <label for="txtEmail">Email</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="True"></asp:TextBox>

            <!-- Password Update -->
            <h3 style="margin-top:20px;">🔒 Change Password</h3>

            <label for="txtCurrentPassword">Current Password</label>
            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>

            <label for="txtNewPassword">New Password</label>
            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>

            <!-- Buttons -->
            <div class="profile-actions">
              <asp:Button ID="btnUpdatePassword" runat="server" CssClass="btn btn-primary"
                          Text="Update Password" OnClick="btnUpdatePassword_Click" />
              <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-ghost"
                          Text="Cancel" CausesValidation="False" />
            </div>
          </div>
        </div>

      </div>
    </section>
  </form>
</body>
</html>
