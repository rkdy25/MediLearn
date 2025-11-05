<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="learning.aspx.cs" Inherits="WebApplication.student.learning" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Learning Portal | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Dashboard Layout */
        body, html {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background: #f4f8fb;
        }

        .dashboard-body {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 240px;
            background: linear-gradient(180deg, #003366, #004e92);
            color: #fff;
            padding: 25px 15px;
            display: flex;
            flex-direction: column;
            align-items: center;
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            box-shadow: 2px 0 12px rgba(0,0,0,0.15);
            z-index: 1000;
        }

        .sidebar-logo {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-bottom: 10px;
            background: #fff;
            object-fit: cover;
        }

        .sidebar h2 {
            font-size: 1.2rem;
            margin-bottom: 25px;
            text-align: center;
        }

        .sidebar-nav {
            display: flex;
            flex-direction: column;
            width: 100%;
            flex: 1;
        }

        .sidebar-nav a {
            display: block;
            color: #dfe9f3;
            padding: 12px 18px;
            border-radius: 10px;
            margin-bottom: 6px;
            transition: 0.3s;
            font-weight: 500;
            text-decoration: none;
        }

        .sidebar-nav a.active,
        .sidebar-nav a:hover {
            background: rgba(255,255,255,0.15);
        }

        .sidebar-nav .logout {
            margin-top: auto;
            background: rgba(255,255,255,0.1);
            color: #ffbebe;
        }

        /* Main content */
        .dashboard-main {
            margin-left: 240px;
            padding: 40px;
            flex: 1;
            background: #f9fbfd;
            min-height: 100vh;
            box-sizing: border-box;
            width: 100%;
        }

        /* Header */
        .learning-header {
            background: linear-gradient(135deg, #0078d4, #0056b3);
            padding: 10px 15px;
            border-radius: 16px;
            color: #fff;
            margin-bottom: 40px;
            box-shadow: 0 8px 24px rgba(0, 120, 212, 0.2);
            max-width: 1200px;
        }

        .learning-header h1 {
            margin: 0 0 12px 0;
            font-size: 2.2rem;
            font-weight: 700;
        }

        .learning-header p {
            margin: 0;
            opacity: 0.95;
            font-size: 1.05rem;
        }

        /* Section Titles */
        .learning-section {
            margin-bottom: 50px;
        }

        .learning-section h2 {
            font-size: 1.6rem;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #00325f;
            font-weight: 700;
        }

        .learning-section h2 i {
            color: #0078d4;
        }

        /* Grid Layout - side by side */
        .materials-grid,
        .quiz-list {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            width: 100%;
        }

        /* Card styling - square cards */
        .material-card,
        .quiz-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
            border-radius: 16px;
            flex: 1 1 30px; /* flexible width, min 250px */
            max-width: 380px;
            aspect-ratio: auto; /* square card */
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            padding: 25px;
            box-shadow: 0 6px 20px rgba(0, 50, 95, 0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .material-card:hover,
        .quiz-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 36px rgba(0, 120, 212, 0.15);
        }

        .material-icon {
            font-size: 3rem;
            color: #0078d4;
            background: linear-gradient(135deg, #e3f2ff, #cfe7ff);
            padding: 15px;
            border-radius: 16px;
            margin-bottom: 15px;
        }

        .material-title,
        .quiz-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #00325f;
            text-align: center;
            margin-bottom: 8px;
        }

        .material-description,
        .quiz-description {
            font-size: 0.95rem;
            color: #5a6c7d;
            text-align: center;
            margin-bottom: 12px;
        }

        .material-actions,
        .quiz-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0078d4, #0056b3);
            color: #fff;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #0056b3, #003d82);
        }

        .btn-outline {
            background: transparent;
            border: 2px solid #0078d4;
            color: #0078d4;
        }

        .btn-outline:hover {
            background: #0078d4;
            color: #fff;
        }

        /* No content placeholder */
        .no-content {
            background: #fff;
            padding: 60px 30px;
            text-align: center;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            color: #5b6b7a;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin-top: 35px;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .dashboard-main {
                margin-left: 0;
                padding: 20px;
            }

            .material-card,
            .quiz-card {
                max-width: 100%;
                flex: 1 1 100%;
                aspect-ratio: auto; /* allow stacking */
            }

            .material-actions,
            .quiz-actions {
                flex-direction: column;
                width: 100%;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body class="dashboard-body">
    <form id="form1" runat="server">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <img src="../assets/images/logo.png" alt="MediLearn Hub" class="sidebar-logo" />
                <h2>MediLearn Hub</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="student-dashboard.aspx">🏠 Dashboard</a>
<a href="courses.aspx" class="active">📚 My Courses</a>
<a href="profile.aspx">👤 Profile</a>
<a href="materials.aspx">📖 Materials</a>
<a href="quiz.aspx">🧠 Quizzes</a>
<a href="anatomy.aspx">👨🏽‍🔬 3D Anatomy</a>
<a href="notes.aspx">📝 My Notes</a>
<a href="quiz-summary.aspx">🥇 Results</a>
<a href="../index.aspx" class="logout">🚪 Logout</a
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="dashboard-main">
            <div class="learning-header">
                <h1><asp:Label ID="lblCourseTitle" runat="server" Text="Loading..."></asp:Label></h1>
                <p><asp:Label ID="lblCourseDesc" runat="server" Text="Loading course details..."></asp:Label></p>
            </div>

            <!-- Materials Section -->
            <div class="learning-section">
                <h2><i class="fas fa-book"></i> Learning Materials</h2>

                <asp:Panel ID="pnlNoMaterials" runat="server" CssClass="no-content" Visible="false">
                    <i class="fas fa-book-open"></i>
                    <h3>No Learning Materials Available</h3>
                    <p>Your lecturer will add learning materials soon.</p>
                </asp:Panel>

                <div class="materials-grid">
                    <asp:Repeater ID="rptMaterials" runat="server">
                        <ItemTemplate>
                            <div class="material-card">
                                <div class="material-icon">
                                    <i class="fas fa-<%# GetFileTypeIcon(Eval("FileType").ToString()) %>"></i>
                                </div>
                                <div class="material-content">
                                    <h3 class="material-title"><%# Eval("Title") %></h3>
                                    <p class="material-description">
                                        <i class="fas fa-tag"></i> <%# Eval("Category") %>
                                    </p>
                                </div>
                                <div class="material-actions">
                                    <a href='<%# ResolveUrl(Eval("FilePath").ToString()) %>' target="_blank" class="btn btn-primary">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                    <a href='<%# ResolveUrl(Eval("FilePath").ToString()) %>' download="<%# Eval("Title") %>" class="btn btn-outline">
                                        <i class="fas fa-download"></i> Download
                                    </a>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="pagination">
                    <asp:Button ID="btnPrevMat" runat="server" Text="← Prev" CssClass="btn btn-outline" OnClick="btnPrevMat_Click" />
                    <asp:Label ID="lblPageMat" runat="server" Text="Page 1" />
                    <asp:Button ID="btnNextMat" runat="server" Text="Next →" CssClass="btn btn-outline" OnClick="btnNextMat_Click" />
                </div>
            </div>

            <!-- Quizzes Section -->
            <div class="learning-section">
                <h2><i class="fas fa-brain"></i> Quizzes & Assessments</h2>

                <asp:Panel ID="pnlNoQuizzes" runat="server" CssClass="no-content" Visible="false">
                    <i class="fas fa-brain"></i>
                    <h3>No Quizzes Available</h3>
                    <p>Your lecturer will add quizzes soon.</p>
                </asp:Panel>

                <div class="quiz-list">
                    <asp:Repeater ID="rptQuizzes" runat="server">
                        <ItemTemplate>
                            <div class="quiz-card">
                                <div class="material-icon">
                                    <i class="fas fa-brain"></i>
                                </div>
                                <div class="material-content">
                                    <h4 class="quiz-title"><%# Eval("Title") %></h4>
                                    <p class="quiz-description"><%# Eval("Description") %></p>
                                </div>
                                <div class="quiz-actions">
                                    <a href='quiz.aspx?quizId=<%# Eval("QuizID") %>&courseId=<%# Request.QueryString["courseId"] %>' class="btn btn-primary">
                                        <i class="fas fa-play"></i> Start Quiz
                                    </a>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="pagination">
                    <asp:Button ID="btnPrevQuiz" runat="server" Text="← Prev" CssClass="btn btn-outline" OnClick="btnPrevQuiz_Click" />
                    <asp:Label ID="lblPageQuiz" runat="server" Text="Page 1" />
                    <asp:Button ID="btnNextQuiz" runat="server" Text="Next →" CssClass="btn btn-outline" OnClick="btnNextQuiz_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
