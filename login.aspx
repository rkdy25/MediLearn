<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="WebApplication.login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Login | MediLearn Hub</title>
    <link rel="stylesheet" href="assets/css/style.css" />
</head>
<body>
    <!-- Header -->
    <header class="site-header">
        <div class="container header-inner">
            <a href="index.aspx" class="brand">
                <img src="assets/images/logo.png" alt="MediLearn Hub" class="logo" />
                <span class="brand-name">MediLearn Hub</span>
            </a>
        </div>
    </header>

    <!-- Main Login -->
    <main class="auth-page">
        <div class="container auth-container">
            <div class="auth-card">
                <h2>Welcome Back 👋</h2>
                <p class="auth-subtitle">Log in to access your learning dashboard</p>

                <!-- ASP.NET Login Form -->
                <form id="formLogin" runat="server" class="auth-form">
                    <label for="txtEmail">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Enter your email" />

                    <label for="txtPassword">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" ClientIDMode="Static" TextMode="Password" placeholder="Enter your password" />

                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
                    <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>

                    <p class="auth-switch">
                        Don’t have an account? Join us by contacting admin at administrators@mail.medilearn.com
                    </p>
                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="site-footer">
        <p>© <span id="year"></span> MediLearn Hub</p>
    </footer>

    <script>
        document.getElementById("year").textContent = new Date().getFullYear();
    </script>
</body>
</html>