<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="courses.aspx.cs" Inherits="WebApplication.student.courses" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Courses | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ================================
           Professional Courses Dashboard
        ================================= */
        :root {
            --primary: #0078d4;
            --primary-dark: #0056b3;
            --primary-light: #e3f2fd;
            --secondary: #28a745;
            --accent: #ff6b6b;
            --dark: #00325f;
            --light: #f4f8fb;
            --text: #5b6b7a;
            --white: #ffffff;
            --border: #e1e8f0;
            --shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .dashboard-body {
            display: flex;
            min-height: 100vh;
            background: #f4f8fb;
            margin: 0;
            padding: 0;
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
            box-shadow: 2px 0 12px rgba(0,0,0,0.15);
            position: fixed;
            left: 0;
            top: 0;
            height: 100vh;
            z-index: 1000;
        }

        /* Main Content */
        .dashboard-main {
            flex: 1;
            margin-left: 240px;
            padding: 0;
            background: #f9fbfd;
            min-height: 100vh;
            width: calc(100vw - 240px);
        }

        /* Professional Header */
        .courses-header {
            background: linear-gradient(135deg, #0078d4, #0056b3);
            color: #fff;
            padding: 30px 40px 25px 40px;
            width: 100%;
            position: relative;
            overflow: hidden;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .courses-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: radial-gradient(circle at 90% 10%, rgba(255,255,255,0.08) 0%, transparent 50%);
        }

        .header-content {
            position: relative;
            z-index: 2;
            max-width: 100%;
        }

        .welcome-title {
            font-size: 1.8rem;
            color: #fff;
            margin-bottom: 8px;
            font-weight: 600;
            line-height: 1.3;
        }

        .welcome-subtitle {
            color: rgba(255,255,255,0.85);
            font-size: 1rem;
            margin-bottom: 0;
            line-height: 1.5;
        }

        .student-name {
            color: #fff;
            font-weight: 600;
        }

        /* Stats Overview - Compact */
        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 40px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: var(--shadow);
            text-align: center;
            transition: all 0.3s;
            border: 1px solid var(--border);
            border-top: 4px solid #0078d4;
        }

        .stat-card:nth-child(2) {
            border-top-color: #28a745;
        }

        .stat-card:nth-child(3) {
            border-top-color: #ffc107;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
            font-size: 1.2rem;
            color: white;
            background: #0078d4;
        }

        .stat-card:nth-child(2) .stat-icon {
            background: #28a745;
        }

        .stat-card:nth-child(3) .stat-icon {
            background: #ffc107;
        }

        .stat-value {
            font-size: 1.8rem;
            font-weight: 700;
            color: #00325f;
            margin-bottom: 4px;
            line-height: 1;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #5b6b7a;
            font-weight: 500;
        }

        /* Quick Actions - Compact */
        .quick-actions {
            background: white;
            padding: 25px;
            margin: 0 40px 30px 40px;
            border-radius: 12px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
        }

        .section-title {
            font-size: 1.3rem;
            color: #00325f;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }

        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 15px;
        }

        .action-card {
            background: #f8fafc;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            border: 1px solid transparent;
            text-decoration: none;
            color: inherit;
        }

        .action-card:hover {
            background: #0078d4;
            color: white;
            transform: translateY(-2px);
            border-color: #0078d4;
        }

        .action-card:hover .action-icon {
            color: white;
        }

        .action-card:hover .action-text {
            color: white;
        }

        .action-icon {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #0078d4;
        }

        .action-text {
            font-weight: 600;
            color: #00325f;
            font-size: 0.9rem;
        }

        /* Courses Section */
        .courses-section {
            padding: 0 40px 40px 40px;
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
        }

        .course-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: all 0.3s;
            border: 1px solid var(--border);
            cursor: pointer;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .course-header {
            background: linear-gradient(135deg, #0078d4, #0056b3);
            padding: 20px;
            color: white;
            position: relative;
        }

        .course-icon {
            font-size: 1.8rem;
            margin-bottom: 12px;
            display: block;
        }

        .course-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 6px;
            line-height: 1.3;
        }

        .course-description {
            font-size: 0.85rem;
            opacity: 0.9;
            line-height: 1.4;
        }

        .course-content {
            padding: 20px;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
        }

        .lecturer-info {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #5b6b7a;
            font-size: 0.85rem;
        }

        .enroll-date {
            color: #8a9ba8;
            font-size: 0.8rem;
        }

        .course-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-bottom: 15px;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px;
            background: #f8fafc;
            border-radius: 8px;
            font-size: 0.8rem;
            color: #5b6b7a;
        }

        .stat-item i {
            color: #0078d4;
            font-size: 0.9rem;
        }

        .course-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            flex: 1;
            padding: 10px 16px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            font-size: 0.85rem;
            text-align: center;
        }

        .btn-primary {
            background: #0078d4;
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-1px);
        }

        .btn-outline {
            background: transparent;
            border: 1.5px solid #0078d4;
            color: #0078d4;
        }

        .btn-outline:hover {
            background: #0078d4;
            color: white;
        }

        /* No Courses State */
        .no-courses {
            text-align: center;
            padding: 60px 40px;
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow);
            margin: 0 40px;
        }

        .no-courses-icon {
            font-size: 3rem;
            color: #dee2e6;
            margin-bottom: 15px;
        }

        .no-courses h3 {
            color: #00325f;
            margin-bottom: 8px;
            font-size: 1.3rem;
        }

        .no-courses p {
            color: #5b6b7a;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }

        /* Responsive Design */
        @media (max-width: 900px) {
            .dashboard-body {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                position: relative;
                height: auto;
                flex-direction: row;
                justify-content: space-around;
            }

            .dashboard-main {
                margin-left: 0;
                width: 100%;
            }

            .stats-overview {
                margin: 20px;
                grid-template-columns: 1fr;
            }

            .quick-actions {
                margin: 0 20px 20px 20px;
            }

            .courses-section {
                padding: 0 20px 20px 20px;
            }

            .courses-grid {
                grid-template-columns: 1fr;
            }

            .courses-header {
                padding: 25px 20px 20px 20px;
            }

            .welcome-title {
                font-size: 1.6rem;
            }
        }

        @media (max-width: 768px) {
            .action-grid {
                grid-template-columns: 1fr 1fr;
            }

            .course-stats {
                grid-template-columns: 1fr;
            }

            .course-actions {
                flex-direction: column;
            }

            .course-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
        }

        @media (max-width: 480px) {
            .courses-header {
                padding: 20px 15px 15px 15px;
            }

            .stats-overview {
                margin: 15px;
            }

            .quick-actions {
                margin: 0 15px 15px 15px;
                padding: 20px;
            }

            .courses-section {
                padding: 0 15px 15px 15px;
            }

            .action-grid {
                grid-template-columns: 1fr;
            }

            .no-courses {
                margin: 0 15px;
                padding: 40px 20px;
            }
        }

        .quiz-item {
    display: flex;
    align-items: center;
    gap: 10px;
    background: #f8fafc;
    border: 1px solid #e0e6ed;
    padding: 10px 15px;
    border-radius: 8px;
    margin-bottom: 8px;
    transition: all 0.3s ease;
}
.quiz-item:hover {
    background: #0078d4;
    color: #fff;
    transform: translateY(-2px);
}
.quiz-item i {
    color: #0078d4;
}
.quiz-item:hover i {
    color: #fff;
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
                <a href="../index.aspx" class="logout">🚪 Logout</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="dashboard-main">
            <!-- Professional Header -->
            <div class="courses-header">
                <div class="header-content">
                    <h1 class="welcome-title">🎓 My Learning Journey</h1>
                    <p class="welcome-subtitle">
                        Welcome back, <span class="student-name"><asp:Label ID="lblStudentName" runat="server" Text="Student"></asp:Label></span>! Continue your medical education.
                    </p>
                </div>
            </div>

            <!-- Stats Overview -->
            <div class="stats-overview">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-book-open"></i>
                    </div>
                    <div class="stat-value"><asp:Label ID="lblEnrolledCourses" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Enrolled Courses</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="stat-value"><asp:Label ID="lblCompletedCourses" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Completed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="stat-value"><asp:Label ID="lblAvgProgress" runat="server" Text="0%"></asp:Label></div>
                    <div class="stat-label">Progress</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <h3 class="section-title"><i class="fas fa-bolt"></i> Quick Actions</h3>
                <div class="action-grid">
                    <a href="materials.aspx" class="action-card">
                        <div class="action-icon"><i class="fas fa-book-medical"></i></div>
                        <div class="action-text">Study Materials</div>
                    </a>
                    <a href="quiz.aspx" class="action-card">
                        <div class="action-icon"><i class="fas fa-brain"></i></div>
                        <div class="action-text">Take Quiz</div>
                    </a>
                    <a href="anatomy.aspx" class="action-card">
                        <div class="action-icon"><i class="fas fa-user-md"></i></div>
                        <div class="action-text">3D Anatomy</div>
                    </a>
                    <a href="notes.aspx" class="action-card">
                        <div class="action-icon"><i class="fas fa-sticky-note"></i></div>
                        <div class="action-text">My Notes</div>
                    </a>
                </div>
            </div>

            <!-- Courses Section -->
            <section class="courses-section">
                <h3 class="section-title"><i class="fas fa-graduation-cap"></i> My Enrolled Courses</h3>

                <!-- Courses Grid -->
                <div class="courses-grid">
                    <asp:Repeater ID="rptCourses" runat="server">
    <ItemTemplate>
        <div class="course-card">
            <div class="course-header">
                <i class="fas fa-heartbeat course-icon"></i>
                <h3 class="course-title"><%# Eval("CourseName") %></h3>
                <p class="course-description"><%# Eval("Description") %></p>
            </div>
            <div class="course-content">
                <div class="course-meta">
                    <div class="lecturer-info">
                        <i class="fas fa-user-tie"></i>
                        <span>Prof. <%# Eval("LecturerName") %></span>
                    </div>
                    <div class="enroll-date">
                        <i class="fas fa-calendar"></i>
                        <%# Eval("EnrollDate", "{0:MMM dd, yyyy}") %>
                    </div>
                </div>

                <div class="course-stats">
                    <div class="stat-item">
                        <i class="fas fa-book"></i>
                        <span><%# Eval("TotalMaterials") %> Materials</span>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-brain"></i>
                        <span><%# Eval("TotalQuizzes") %> Quizzes</span>
                    </div>
                </div>

                <!-- Quiz List -->
                <asp:Repeater ID="rptQuizzes" runat="server">
                    <ItemTemplate>
                        <div class="quiz-item">
                            <i class="fas fa-question-circle"></i>
                            <span><%# Eval("QuizTitle") %></span>
                            <a href='quiz-details.aspx?quizId=<%# Eval("QuizID") %>' class="btn btn-outline" style="margin-left:auto;">Start</a>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="course-actions">
                    <a href='learning.aspx?courseId=<%# Eval("CourseId") %>' class="btn btn-primary">
                        <i class="fas fa-play"></i> Continue
                    </a>
                </div>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>

                </div>

                <!-- No Courses Message -->
                <asp:Panel ID="pnlNoCourses" runat="server" CssClass="no-courses" Visible="false">
                    <i class="fas fa-book-open no-courses-icon"></i>
                    <h3>No Courses Enrolled Yet</h3>
                    <p>Contact your lecturer to get started with your medical learning journey.</p>
                    <a href="student-dashboard.aspx" class="btn btn-primary" style="display: inline-flex; width: auto; padding: 10px 20px;">
                        <i class="fas fa-home"></i> Back to Dashboard
                    </a>
                </asp:Panel>
            </section>
        </div>
    </form>
</body>
</html>