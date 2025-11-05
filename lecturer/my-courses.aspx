<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="my-courses.aspx.cs" Inherits="WebApplication.lecturer.my_courses" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Courses | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <style>
        .course-card {
            background: #fff;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }
        .course-card h3 {
            margin-bottom: 5px;
            color: #0078d7;
        }
        .course-actions a {
            display: inline-block;
            background: #0078d7;
            color: white;
            padding: 8px 14px;
            border-radius: 6px;
            margin-right: 10px;
            text-decoration: none;
        }
        .course-actions a:hover {
            background: #005fa3;
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
        <header class="dashboard-header">
            <h1>📘 My Courses</h1>
            <p>View and manage all your assigned courses.</p>
        </header>

        <section class="materials-section">
            <asp:Repeater ID="rptCourses" runat="server">
                <ItemTemplate>
                    <div class="course-card">
                        <h3><%# Eval("CourseName") %></h3>
                        <p><%# Eval("Description") %></p>
                        <div class="course-actions">
                            <a href='upload-materials.aspx?courseId=<%# Eval("CourseId") %>'>📂 Manage Materials</a>
                            <a href='create-quiz.aspx?courseId=<%# Eval("CourseId") %>'>🧠 Manage Quizzes</a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Label ID="lblNoCourses" runat="server" Text="No courses assigned yet." Visible="false" CssClass="empty-label"></asp:Label>
        </section>
    </main>

</form>
</body>
</html>
