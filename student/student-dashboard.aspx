<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="student-dashboard.aspx.cs" Inherits="WebApplication.student.student_dashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ================================
           Enhanced Dashboard Styles
        ================================= */
        .dashboard-body {
            display: flex;
            min-height: 100vh;
            background: #f4f8fb;
            overflow-x: hidden;
        }

        .dashboard-main {
            flex: 1;
            padding: 40px;
            background: #f9fbfd;
        }

        /* Header */
        .dashboard-header h1 {
            font-size: 1.9rem;
            color: #00325f;
            margin-bottom: 5px;
        }

        .dashboard-header p {
            color: #5b6b7a;
            margin-bottom: 30px;
        }

        /* Stats Cards */
        .stats-container {
            display: flex;
            flex-wrap: wrap;
            gap: 25px;
            margin-bottom: 35px;
        }

        .stat-card {
            flex: 1 1 250px;
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s;
            border-left: 4px solid #0078d4;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0,0,0,0.1);
        }

        .stat-card:nth-child(1) { border-left-color: #0078d4; }
        .stat-card:nth-child(2) { border-left-color: #28a745; }
        .stat-card:nth-child(3) { border-left-color: #ffc107; }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 24px;
            color: white;
        }

        .stat-card:nth-child(1) .stat-icon { background: #0078d4; }
        .stat-card:nth-child(2) .stat-icon { background: #28a745; }
        .stat-card:nth-child(3) .stat-icon { background: #ffc107; }

        .stat-card h3 {
            font-size: 1rem;
            color: #00457c;
            margin-bottom: 8px;
        }

        .stat-card p {
            font-size: 2rem;
            font-weight: 700;
            color: #0078d4;
        }

        .stat-card:nth-child(2) p { color: #28a745; }
        .stat-card:nth-child(3) p { color: #ffc107; }

        /* Courses Section */
        .courses-section {
            margin-bottom: 40px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-header h2 {
            color: #00325f;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }

        .view-all {
            color: #0078d4;
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            transition: all 0.3s;
        }

        .view-all:hover {
            color: #0056b3;
        }

        .view-all i {
            margin-left: 5px;
            transition: transform 0.3s;
        }

        .view-all:hover i {
            transform: translateX(3px);
        }

        /* Courses Grid */
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
        }

        .course-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
            border: 1px solid #e1e8f0;
        }

        .course-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,120,212,0.15);
        }

        .course-banner {
            height: 140px;
            background: linear-gradient(135deg, #0078d4, #0056b3);
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }

        .course-banner::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.1);
        }

        .course-info {
            padding: 20px;
        }

        .course-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 10px;
            color: #00325f;
            line-height: 1.4;
        }

        .course-description {
            color: #5b6b7a;
            font-size: 0.9rem;
            margin-bottom: 15px;
            line-height: 1.5;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            color: #6c757d;
            font-size: 0.85rem;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .course-meta span {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Materials Available Section */
        .materials-available {
            margin-bottom: 15px;
        }

        .materials-count {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            background: #f8fafc;
            border-radius: 8px;
            border: 1px solid #e1e8f0;
        }

        .materials-count i {
            color: #0078d4;
            font-size: 1.2rem;
        }

        .materials-text {
            font-size: 0.9rem;
            color: #5b6b7a;
        }

        .materials-number {
            font-weight: 700;
            color: #0078d4;
            margin-left: auto;
        }

        .course-stats {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.8rem;
            color: #5b6b7a;
        }

        .stat-item i {
            color: #0078d4;
        }

        .course-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 10px 15px;
            border-radius: 8px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 0.9rem;
            flex: 1;
        }

        .btn i {
            margin-right: 5px;
        }

        .btn-primary {
            background: #0078d4;
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,120,212,0.3);
        }

        .btn-outline {
            background: transparent;
            border: 1px solid #0078d4;
            color: #0078d4;
        }

        .btn-outline:hover {
            background: rgba(0,120,212,0.1);
            transform: translateY(-2px);
        }

        /* Latest Materials Section */
        .latest-materials-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
            border: 1px solid #e1e8f0;
        }

        .materials-list {
            list-style: none;
        }

        .material-item {
            display: flex;
            padding: 15px 0;
            border-bottom: 1px solid #e9ecef;
            transition: background-color 0.3s;
        }

        .material-item:hover {
            background-color: #f8fafc;
            border-radius: 8px;
            padding-left: 10px;
            padding-right: 10px;
        }

        .material-item:last-child {
            border-bottom: none;
        }

        .material-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            background: #0078d4;
            color: white;
            font-size: 1rem;
            flex-shrink: 0;
        }

        .material-content {
            flex: 1;
        }

        .material-title {
            font-weight: 500;
            margin-bottom: 5px;
            color: #00325f;
            font-size: 0.95rem;
        }

        .material-meta {
            color: #6c757d;
            font-size: 0.8rem;
            display: flex;
            gap: 12px;
        }

        .material-course {
            color: #0078d4;
            font-weight: 500;
        }

        .material-date {
            color: #6c757d;
        }

        .material-type {
            background: #e3f2fd;
            color: #0078d4;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        /* No Content Messages */
        .no-content-message {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
            font-size: 1.1rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
            border: 1px solid #e1e8f0;
        }

        .no-content-message i {
            font-size: 3rem;
            color: #dee2e6;
            margin-bottom: 15px;
            display: block;
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .course-card {
            animation: fadeIn 0.6s ease-out;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .courses-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .dashboard-main {
                padding: 25px;
            }

            .stats-container {
                flex-direction: column;
            }

            .courses-grid {
                grid-template-columns: 1fr;
            }

            .course-actions {
                flex-direction: column;
            }

            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .course-stats {
                flex-direction: column;
                gap: 8px;
            }

            .material-item {
                flex-direction: column;
                text-align: center;
            }

            .material-icon {
                margin-right: 0;
                margin-bottom: 10px;
                align-self: center;
            }

            .material-meta {
                justify-content: center;
                flex-wrap: wrap;
            }
        }

        @media (max-width: 480px) {
            .dashboard-main {
                padding: 15px;
            }

            .dashboard-header h1 {
                font-size: 1.6rem;
            }
        }
    </style>
</head>
<body class="dashboard-body">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <img src="../assets/images/logo.png" alt="MediLearn Hub" class="sidebar-logo" />
            <h2>MediLearn Hub</h2>
        </div>
        <nav class="sidebar-nav">
            <a href="student-dashboard.aspx" class="active">🏠 Dashboard</a>
            <a href="courses.aspx">📚 My Courses</a>
            <a href="profile.aspx">👤 Profile</a>
            <a href="materials.aspx">📖 Learning Materials</a>
            <a href="quiz.aspx">🧠 Quizzes</a>
            <a href="anatomy.aspx">👨🏽‍🔬 3D Anatomy</a>
            <a href="notes.aspx">📝 My Notes</a>
            <a href="quiz-summary.aspx">🥇 Quiz Results</a>
            <a href="../index.aspx" class="logout">🚪 Logout</a>
        </nav>
    </aside>

    <!-- Main Content -->
    <form id="form1" runat="server" class="dashboard-main">
        <!-- Header -->
        <header class="dashboard-header">
            <h1>Welcome, <asp:Label ID="lblStudentName" runat="server" Text="Student"></asp:Label> 👋</h1>
            <p>Let's continue your medical learning journey.</p>
        </header>

        <!-- Stats Cards -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="stat-info">
                    <h3>Enrolled Courses</h3>
                    <p><asp:Label ID="lblEnrolledCourses" runat="server" Text="0"></asp:Label></p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3>Completed Courses</h3>
                    <p><asp:Label ID="lblCompletedCourses" runat="server" Text="0"></asp:Label></p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <div class="stat-info">
                    <h3>Materials Available</h3>
                    <p><asp:Label ID="lblMaterialsAvailable" runat="server" Text="0"></asp:Label></p>
                </div>
            </div>
        </div>

        <!-- My Courses Section -->
        <section class="courses-section">
            <div class="section-header">
                <h2>My Enrolled Courses</h2>
                <a href="courses.aspx" class="view-all">
                    View All Courses <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            
            <div class="courses-grid">
                <asp:Repeater ID="rptCourses" runat="server">
                    <ItemTemplate>
                        <div class="course-card">
                            <div class="course-banner">
                                <i class="fas fa-heartbeat"></i>
                            </div>
                            <div class="course-info">
                                <h3 class="course-title"><%# Eval("CourseName") %></h3>
                                <p class="course-description"><%# Eval("Description") %></p>
                                
                                <div class="course-meta">
                                    <span><i class="fas fa-user-tie"></i> <%# Eval("LecturerName") %></span>
                                    <span><i class="fas fa-calendar"></i> <%# Eval("EnrollDate", "{0:MMM dd, yyyy}") %></span>
                                </div>
                                
                                <!-- Materials Available -->
                                <div class="materials-available">
                                    <div class="materials-count">
                                        <i class="fas fa-book"></i>
                                        <span class="materials-text">Learning Materials Available</span>
                                        <span class="materials-number"><%# Eval("TotalMaterials") %></span>
                                    </div>
                                </div>
                                
                                <div class="course-stats">
                                    <div class="stat-item">
                                        <i class="fas fa-brain"></i>
                                        <span><%# Eval("CompletedQuizzes") %>/<%# Eval("TotalQuizzes") %> quizzes completed</span>
                                    </div>
                                </div>
                                
                                <div class="course-actions">
                                    <a href='learning.aspx?courseId=<%# Eval("CourseId") %>' class="btn btn-primary">
                                        <i class="fas fa-play"></i> Continue Learning
                                    </a>
                                    <a href='quiz.aspx?courseId=<%# Eval("CourseId") %>' class="btn btn-outline">
                                        <i class="fas fa-brain"></i> Take Quiz
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            
            <!-- No Courses Message -->
            <asp:Label ID="lblNoCourses" runat="server" Text="You are not enrolled in any courses yet." 
                CssClass="no-content-message" Visible="false">
                <i class="fas fa-book-open"></i>
                <br>
                You are not enrolled in any courses yet.
                <br>
                <small>Contact your lecturer to get enrolled in courses.</small>
            </asp:Label>
        </section>

        <!-- Latest Materials Section -->
        <section class="latest-materials-section">
            <div class="section-header">
                <h2>Latest Materials</h2>
                <a href="materials.aspx" class="view-all">
                    View All Materials <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            <ul class="materials-list">
                <asp:Repeater ID="rptLatestMaterials" runat="server">
                    <ItemTemplate>
                        <li class="material-item">
                            <div class="material-icon">
                                <i class="fas fa-<%# GetFileTypeIcon(Eval("FileType").ToString()) %>"></i>
                            </div>
                            <div class="material-content">
                                <div class="material-title"><%# Eval("Title") %></div>
                                <div class="material-meta">
                                    <span class="material-course"><%# Eval("CourseName") %></span>
                                    <span class="material-type"><%# Eval("FileType") %></span>
                                    <span class="material-date"><%# Eval("UploadDate", "{0:MMM dd, yyyy}") %></span>
                                </div>
                            </div>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            
            <!-- No Materials Message -->
            <asp:Label ID="lblNoMaterials" runat="server" Text="No recent materials available." 
                CssClass="no-content-message" Visible="false">
                <i class="fas fa-file-alt"></i>
                <br>
                No recent learning materials available.
                <br>
                <small>New materials will appear here when added by your lecturers.</small>
            </asp:Label>
        </section>
    </form>

    <script>
        // Add interactive animations
        document.addEventListener('DOMContentLoaded', function () {
            // Add hover effects to course cards
            const courseCards = document.querySelectorAll('.course-card');
            courseCards.forEach(card => {
                card.addEventListener('mouseenter', function () {
                    this.style.transform = 'translateY(-8px) scale(1.02)';
                });

                card.addEventListener('mouseleave', function () {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Add hover effects to material items
            const materialItems = document.querySelectorAll('.material-item');
            materialItems.forEach(item => {
                item.addEventListener('mouseenter', function () {
                    this.style.backgroundColor = '#f8fafc';
                });

                item.addEventListener('mouseleave', function () {
                    this.style.backgroundColor = '';
                });
            });
        });
    </script>
</body>
</html>