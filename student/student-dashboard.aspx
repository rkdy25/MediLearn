<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="student-dashboard.aspx.cs" Inherits="WebApplication.student.student_dashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/dashboard.css">
</head>
<body class="dashboard-body">
    <form id="form1" runat="server">

        <!-- Wrapper to align sidebar and main content -->
        <div style="display: flex; min-height: 100vh;">

            <!-- Sidebar -->
            <aside class="sidebar" style="flex: 0 0 260px;">
                <div class="sidebar-header">
                    <img src="../assets/images/logo.png" alt="MediLearn Hub" class="sidebar-logo">
                    <h2>MediLearn Hub</h2>
                </div>
                <nav class="sidebar-nav">
                    <a href="student-dashboard.aspx" class="active">🏠 Dashboard</a>
                    <a href="profile.aspx">👤 Profile</a>
                    <a href="materials.aspx">📚 Learning Materials</a>
                    <a href="quiz.aspx">🧠 Quizzes</a>
                    <a href="anatomy.aspx">👨🏽‍🔬 3D Anatomy</a>
                    <a href="notes.aspx">📝 My Notes</a>
                    <a href="quiz-summary.aspx">🥇Quizz results summary</a>
                    <a href="../index.aspx" class="logout">🚪 Logout</a>
                </nav>
            </aside>

            <!-- Main content -->
            <main class="dashboard-main" style="flex: 1; padding: 20px;">

                <header class="dashboard-header">
                    <h1>Welcome, <asp:Label ID="lblStudentName" runat="server" Text="Student"></asp:Label> 👋</h1>
                    <p>Let’s continue your medical learning journey.</p>
                </header>

                <!-- Overview Cards -->
                <section class="dashboard-cards">
                    <div class="dash-card">
                        <h3>Completed Quizzes</h3>
                        <asp:Label ID="lblCompletedQuizzes" runat="server" Text="0"></asp:Label>
                    </div>
                    <div class="dash-card">
                        <h3>Materials available</h3>
                        <asp:Label ID="lblMaterialsViewed" runat="server" Text="0"></asp:Label>
                    </div>
                    <div class="dash-card">
                        <h3>Notes Created</h3>
                        <asp:Label ID="lblNotesCreated" runat="server" Text="0"></asp:Label>
                    </div>
                </section>

                <!-- Recent Materials -->
                <section class="dashboard-section">
                    <h2>Recent Learning Materials</h2>
                    <asp:GridView ID="gvRecentMaterials" runat="server" AutoGenerateColumns="False" CssClass="resource-list"
                        GridLines="None" ShowHeader="false">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <li>
                                        <a href='materials.aspx'>📘 <%# Eval("Title") %></a>
                                    </li>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </section>

                <!-- Quick Links -->
                <section class="dashboard-section">
                    <h2>Quick Actions</h2>
                    <div class="quick-links">
                        <a href="quiz.aspx" class="btn btn-primary">Start Quiz</a>
                        <a href="anatomy.aspx" class="btn btn-ghost">Explore 3D Anatomy</a>
                    </div>
                </section>

            </main>
        </div>
    </form>
</body>
</html>