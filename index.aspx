<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="WebApplication.index" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>MediLearn Hub — Home</title>
    <link rel="stylesheet" href="assets/css/style.css" />
    <link rel="stylesheet" href="assets/css/search-latest-index.css" />
    
    <style>
        /* Enhanced Course Cards - Respecting Original Colors */
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 40px;
            padding: 0 20px;
        }
        
        .course-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,51,102,0.1);
            transition: all 0.3s cubic-bezier(0.23, 1, 0.320, 1);
            position: relative;
            border: 2px solid transparent;
        }
        
        .course-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #0078d4, #00457c);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }
        
        .course-card:hover::before {
            transform: scaleX(1);
        }
        
        .course-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,51,102,0.2);
            border-color: rgba(0,120,212,0.3);
        }
        
        .course-icon-wrapper {
            background: linear-gradient(135deg, #0078d4 0%, #00457c 100%);
            padding: 30px 20px 15px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .course-icon-wrapper::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
            animation: shimmer 3s infinite;
        }
        
        @keyframes shimmer {
            0% { transform: translateX(-100%) translateY(-100%) rotate(0deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(0deg); }
        }
        
        .course-icon {
            width: 60px;
            height: 60px;
            background: white;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            margin: 0 auto;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            position: relative;
            z-index: 1;
            animation: iconFloat 3s ease-in-out infinite;
        }
        
        @keyframes iconFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }
        
        .course-content {
            padding: 20px;
        }
        
        .course-title {
            font-size: 1.3rem;
            color: #00457c;
            margin-bottom: 10px;
            font-weight: 700;
            line-height: 1.3;
        }
        
        .course-lecturer {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #0078d4;
            font-size: 0.9rem;
            margin-bottom: 12px;
            font-weight: 600;
        }
        
        .course-lecturer::before {
            content: '👨‍🏫';
            font-size: 1.1rem;
        }
        
        .course-description {
            color: #5b6b7a;
            line-height: 1.5;
            margin-bottom: 15px;
            font-size: 0.9rem;
        }
        
        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 12px;
            border-top: 2px solid #f0f0f0;
        }
        
        .course-students {
            display: flex;
            align-items: center;
            gap: 5px;
            color: #888;
            font-size: 0.85rem;
        }
        
        .course-students::before {
            content: '👥';
        }
        
        .btn-view-course {
            padding: 8px 18px;
            background: linear-gradient(135deg, #0078d4, #00457c);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            font-size: 0.9rem;
        }
        
        .btn-view-course:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,120,212,0.4);
        }
        
        /* Enhanced Search Results */
        .search-results {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-top: 30px;
            box-shadow: 0 8px 30px rgba(0,51,102,0.1);
            animation: slideDown 0.4s ease;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .search-results h3 {
            color: #00457c;
            font-size: 1.8rem;
            margin-bottom: 25px;
            position: relative;
            padding-bottom: 15px;
        }
        
        .search-results h3::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #0078d4, #00457c);
            border-radius: 2px;
        }
        
        .search-results ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .result-item {
            background: linear-gradient(135deg, rgba(0,120,212,0.05), rgba(0,69,124,0.05));
            border-left: 4px solid #0078d4;
            padding: 18px;
            margin-bottom: 12px;
            border-radius: 10px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .result-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(0,120,212,0.1), transparent);
            transition: left 0.5s;
        }
        
        .result-item:hover::before {
            left: 100%;
        }
        
        .result-item:hover {
            transform: translateX(10px);
            box-shadow: 0 5px 20px rgba(0,120,212,0.2);
            border-left-width: 6px;
        }
        
        .result-item a {
            color: #0078d4;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 12px;
            position: relative;
            z-index: 1;
        }
        
        .result-item a::before {
            content: '📖';
            font-size: 1.5rem;
            animation: iconBounce 2s ease-in-out infinite;
        }
        
        @keyframes iconBounce {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.2); }
        }
        
        .result-item em {
            color: #00457c;
            font-style: normal;
            font-size: 0.9rem;
        }
        
        .no-results {
            text-align: center;
            padding: 50px 20px;
            color: #888;
        }
        
        .no-results-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        /* Latest Resources Section Enhancement */
        .latest-resources {
            background: #f4f8fb;
            padding: 60px 0;
        }
        
        .latest-resources h2 {
            color: #00457c;
            font-size: 2.5rem;
            text-align: center;
            margin-bottom: 50px;
            position: relative;
        }
        
        .latest-resources h2::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(90deg, #0078d4, #00457c);
            border-radius: 2px;
        }
        
        /* Enhanced Search Bar */
        .search-strip {
            background: linear-gradient(135deg, #003366, #004e92);
            padding: 40px 0;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        .search-form {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .search-wrapper {
            display: flex;
            gap: 15px;
            background: white;
            padding: 8px;
            border-radius: 50px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        
        .search-input {
            flex: 1;
            border: none;
            padding: 15px 25px;
            font-size: 1rem;
            border-radius: 50px;
            outline: none;
        }
        
        .search-btn {
            padding: 15px 35px;
            background: linear-gradient(135deg, #0078d4, #00457c);
            color: white;
            border: none;
            border-radius: 50px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(0,120,212,0.3);
        }
        
        .search-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 25px rgba(0,120,212,0.5);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .courses-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Site header -->
    <header class="site-header">
        <div class="container header-inner">
            <a class="brand" href="index.aspx">
                <img src="assets/images/logo.png" alt="MediLearn Hub logo" class="logo" />
                <span class="brand-name">MediLearn Hub</span>
            </a>

            <button id="navToggle" class="nav-toggle" aria-expanded="false" aria-controls="mainNav">
                ☰ <span class="sr-only">Toggle navigation</span>
            </button>

            <nav id="mainNav" class="main-nav" aria-label="Primary navigation">
                <ul>
                    <li><a href="index.aspx" class="active">Home</a></li>
                    <li><a href="Login.aspx">Login </a></li>
                    <li><a href="guest/news.aspx">Latest News</a></li>
                    <li><a href="guest/preview-quiz.aspx">Quizzes</a></li>
                    <li><a href="guest/explore-3d.aspx">Explore 3D</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Hero -->
    <section class="hero">
        <div class="container hero-inner">
            <div class="hero-content">
                <h1>Learn medicine faster with interactive resources</h1>
                <p>Access lecture notes, case studies, quizzes and 3D anatomy — all in one place for medical students.</p>
                <div class="hero-actions">
                    <a href="Login.aspx" class="btn btn-primary">Get Started</a>
                    <a href="guest/explore-3d.aspx" class="btn btn-ghost">Explore 3D Anatomy (Guest)</a>
                </div>
            </div>
            <div class="hero-image" aria-hidden="true">
                <img src="assets/images/medicine.jpg" alt="" />
            </div>
        </div>
    </section>

    <!-- Quick search -->
    <section class="search-strip">
        <div class="container">
            <form id="formSearch" runat="server" class="search-form" role="search">
                <div class="search-wrapper">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" Placeholder="🔍 Search courses by name or lecturer..."></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="search-btn" OnClick="btnSearch_Click" />
                </div>
            </form>

            <!-- Search results -->
            <div id="searchResults" runat="server" visible="false" class="search-results">
                <h3>🎯 Search Results</h3>
                <asp:Panel ID="pnlSearchResults" runat="server">
                    <ul>
                        <asp:Repeater ID="rptSearchResults" runat="server">
                            <ItemTemplate>
                                <li class="result-item">
                                    <a href='Login.aspx'>
                                        <span><%# Eval("CourseName") %></span>
                                        <em>by <%# Eval("LecturerName") %></em>
                                    </a>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </asp:Panel>
                
                <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="no-results">
                    <div class="no-results-icon">🔍</div>
                    <h3>No courses found</h3>
                    <p>Try searching with different keywords</p>
                </asp:Panel>
            </div>
        </div>
    </section>

    <!-- Features / audience entry points -->
    <section class="features">
        <div class="container features-grid">
            <article class="card">
                <img src="assets/images/student-card.png" alt="Student" class="card-img" />
                <h3>Students</h3>
                <p>Personal dashboard, progress tracking, quizzes, and discussion forums.</p>
                <a class="card-link" href="login.aspx">Open student dashboard →</a>
            </article>

            <article class="card">
                <img src="assets/images/lecturer-card.png" alt="Lecturer" class="card-img" />
                <h3>Lecturers</h3>
                <p>Upload materials, create assessments, and review student performance.</p>
                <a class="card-link" href="login.aspx">Open lecturer tools →</a>
            </article>

            <article class="card">
                <img src="assets/images/guest-card.png" alt="Guest" class="card-img" />
                <h3>Guests</h3>
                <p>Preview public resources and explore sample 3D anatomy models.</p>
                <a class="card-link" href="guest/explore-3d.aspx">Explore 3D models →</a>
            </article>
        </div>
    </section>

    <!-- Available Courses -->
    <section class="latest-resources">
        <div class="container">
            <h2>🎓 Latest Courses</h2>
            
            <div class="courses-grid">
                <asp:Repeater ID="rptCourses" runat="server">
                    <ItemTemplate>
                        <div class="course-card">
                            <div class="course-icon-wrapper">
                                <div class="course-icon">📚</div>
                            </div>
                            <div class="course-content">
                                <h3 class="course-title"><%# Eval("CourseName") %></h3>
                                <p class="course-lecturer"><%# Eval("LecturerName") %></p>
                                <p class="course-description"><%# Eval("Description") %></p>
                                <div class="course-footer">
                                    <span class="course-students"><%# Eval("EnrolledCount") %> students</span>
                                    <a href="Login.aspx" class="btn-view-course">View Course →</a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="site-footer">
        <div class="container footer-inner">
            <div class="footer-left">
                <p>© <span id="year"></span> MediLearn Hub</p>
            </div>
            <div class="footer-right">
                <nav aria-label="Footer links">
                    <a href="about.html">About</a>
                    <a href="privacy.html">Privacy</a>
                    <a href="contact.html">Contact</a>
                </nav>
            </div>
        </div>
    </footer>

    <script>
        // Mobile nav toggle and footer year
        (function () {
            const toggle = document.getElementById('navToggle');
            const nav = document.getElementById('mainNav');
            toggle.addEventListener('click', () => {
                const expanded = toggle.getAttribute('aria-expanded') === 'true' || false;
                toggle.setAttribute('aria-expanded', !expanded);
                nav.classList.toggle('open');
            });

            document.getElementById('year').textContent = new Date().getFullYear();
        })();
    </script>
</body>
</html>