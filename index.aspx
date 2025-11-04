<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="WebApplication.index" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>MediLearn Hub — Home</title>
    <link rel="stylesheet" href="assets/css/style.css" />
    <link rel="stylesheet" href="assets/css/search-latest-index.css" />
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
                    <li><a href="guest/resources.aspx">Resources</a></li>
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
                <img src="assets/images/hero-anatomy.png" alt="" />
            </div>
        </div>
    </section>

    <!-- Quick search -->
    <section class="search-strip">
    <div class="container">
        <form id="formSearch" runat="server" class="search-form" role="search">
            <div class="search-wrapper">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" Placeholder="🔍 Search lecture notes, case studies, quizzes…" Height="32px" Width="689px"></asp:TextBox>
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn search-btn" OnClick="btnSearch_Click" Height="38px" />
            </div>
        </form>

        <!-- Search results -->
        <div id="searchResults" runat="server" visible="false" class="search-results">
            <ul>
            <h3>Search Results:</h3>
                <asp:Repeater ID="rptSearchResults" runat="server" OnItemCommand="rptSearchResults_ItemCommand">
                    <ItemTemplate>
                        <li class="resource-item">
                            <a href='<%# Eval("FilePath") %>'
                               onclick='<%# (Session["UserID"] == null ? "alert(\"Please login to access this resource.\"); return false;" : "") %>'>
                                <%# Eval("Title") %> — <em><%# Eval("UploadedBy") %></em>
                            </a>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
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

    <!-- Latest resources preview -->
<section class="latest-resources">
    <div class="container">
        <h2>Latest Resources</h2>

        <asp:Repeater ID="rptResources" runat="server">
            <ItemTemplate>
                <li>
                    <a href='<%# Eval("FilePath") %>'
                       onclick='<%# (Session["UserID"] == null ? "alert(\"Please login to access this resource.\"); return false;" : "") %>'>
                        <%# Eval("Title") %> — <em><%# Eval("UploadedBy") %></em>
                    </a>
                </li>
            </ItemTemplate>
        </asp:Repeater>

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
