<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="WebApplication.register" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Register | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
</head>
<body>
    <!-- Header -->
    <header class="site-header">
        <div class="container header-inner">
            <a href="manage-users.aspx" class="brand">
                <img src="../assets/images/logo.png" alt="MediLearn Hub" class="logo" />
                <span class="brand-name">MediLearn Hub</span>
            </a>
        </div>
    </header>

    <!-- Main Registration -->
    <main class="auth-page">
        <div id="message" runat="server" class="auth-message"></div>
        <div class="container auth-container">
            <div class="auth-card">

                <h2>Create Your Account 🩺</h2>
                <p class="auth-subtitle">Join MediLearn Hub and start your medical journey</p>

                <!-- ASP.NET Form Controls -->
                <form id="formRegister" runat="server" class="auth-form">
                    <label for="txtFName">First Name</label>
                    <asp:TextBox ID="txtFName" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Your first name" />

                    <label for="txtLName">Last Name</label>
                    <asp:TextBox ID="txtLName" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Your last name" />

                    <label for="txtEmail">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ClientIDMode="Static" placeholder="Your email address" />

                    <label for="txtPassword">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" ClientIDMode="Static" TextMode="Password" placeholder="Create a password" />

                    <label for="txtConfirm">Confirm Password</label>
                    <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-control" ClientIDMode="Static" TextMode="Password" placeholder="Re-type your password" />

                    <label for="ddlRole">Role</label>
                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control" ClientIDMode="Static">
                        <asp:ListItem Text="Select your role" Value="" />
                        <asp:ListItem Text="Student" Value="student" />
                        <asp:ListItem Text="Lecturer" Value="lecturer" />
                        <asp:ListItem Text="Admin" Value="admin" />
                    </asp:DropDownList>

                    <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary" OnClick="btnRegister_Click" />
                </form>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="site-footer">
        <p>© <span id="year"></span> MediLearn Hub</p>
    </footer>

    <!-- Scripts -->
    <script>
        document.getElementById("year").textContent = new Date().getFullYear();
    </script>

    <script>
        const form = document.getElementById("formRegister");
        const password = document.getElementById("txtPassword");
        const confirm = document.getElementById("txtConfirm");
        const messageDiv = document.getElementById("<%= message.ClientID %>");

        form.addEventListener("submit", function (e) {
            let errors = [];

            const passVal = password.value.trim();

            // Check password rules
            if (passVal.length < 8) {
                errors.push("Password must be at least 8 characters long.");
            }
            if (!/[A-Z]/.test(passVal)) {
                errors.push("Password must contain at least one uppercase letter.");
            }
            if (!/[a-z]/.test(passVal)) {
                errors.push("Password must contain at least one lowercase letter.");
            }
            if (!/[0-9]/.test(passVal)) {
                errors.push("Password must contain at least one number.");
            }
            if (!/[\W_]/.test(passVal)) {
                errors.push("Password must contain at least one special character.");
            }
            if (password.value !== confirm.value) {
                errors.push("Passwords do not match.");
            }

            // Display errors
            if (errors.length > 0) {
                e.preventDefault();
                messageDiv.innerHTML = errors.map(e => `<p style='color:#ff6b6b;'>${e}</p>`).join("");
                messageDiv.style.display = "block";
                return false;
            }

            messageDiv.innerHTML = "";
            messageDiv.style.display = "none";
        });
    </script>

</body>
</html>
