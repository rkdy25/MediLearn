<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="anatomy.aspx.cs" Inherits="WebApplication.student.anatomy" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>3D Anatomy | MediLearn Hub</title>
   
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <link rel="stylesheet" href="../assets/css/anatomy.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<body>
    <form id="form1" runat="server">
        <div class="dashboard-body">

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
<a href="anatomy.aspx" class="active">👨🏽‍🔬 3D Anatomy</a>
<a href="notes.aspx">📝 My Notes</a>
<a href="quiz-summary.aspx">🥇 Results</a>
<a href="../index.aspx" class="logout">🚪 Logout</a
                </nav>
            </aside>

            <!-- Main -->
            <main class="dashboard-main">
                <header class="dashboard-header">
                    <h1>👨🏽‍🔬 3D Anatomy Viewer</h1>
                    <p>Explore educational anatomy videos uploaded by professors.</p>
                </header>

                <!-- Content -->
                <section class="anatomy-section">
                    <div class="anatomy-viewer">
                        <video id="videoPlayer" runat="server" class="model-frame" width="100%" height="480" controls>
       
                        </video>
                    </div>

                    <div class="anatomy-info text-center">
                        <h2><asp:Label ID="lblMaterialTitle" runat="server" Text="Material Title"></asp:Label></h2>
                        <p><strong>Professor:</strong> <asp:Label ID="lblProfessor" runat="server" Text="Professor Name"></asp:Label></p>
                        <p class="text-muted">
                            <asp:Label ID="lblCounter" runat="server" Text=""></asp:Label>
                        </p>

                        <div class="anatomy-actions">
                            <asp:Button ID="btnPrev" runat="server" CssClass="btn btn-outline-secondary" Text="⏮ Previous" OnClick="btnPrev_Click" />
                            <asp:Button ID="btnNext" runat="server" CssClass="btn btn-primary" Text="Next ⏭" OnClick="btnNext_Click" />
                        </div>
                    </div>
                </section>
            </main>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
