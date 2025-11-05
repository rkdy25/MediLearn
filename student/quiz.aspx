<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="quiz.aspx.cs" Inherits="WebApplication.student.quiz" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quiz | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body, html {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background: #f0f4ff;
        }

        .dashboard-body {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #4b6cb7, #182848);
            color: #fff;
            padding: 30px 15px;
            display: flex;
            flex-direction: column;
            align-items: center;
            position: fixed;
            top: 0;
            bottom: 0;
        }
        .sidebar-logo { width: 60px; height: 60px; border-radius: 50%; margin-bottom: 15px; }
        .sidebar-nav a { display: block; color: #dfe9f3; padding: 12px 18px; border-radius: 12px; margin-bottom: 8px; text-decoration: none; transition: 0.3s; }
        .sidebar-nav a.active, .sidebar-nav a:hover { background: rgba(255,255,255,0.2); }
        .sidebar-nav .logout { margin-top: auto; background: rgba(255,255,255,0.15); color: #ffbebe; }

        /* Main content full-width */
        main.dashboard-main {
            margin-left: 260px;
            flex: 1;
            padding: 40px;
        }

        .dashboard-header {
            text-align: center;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.25);
        }

            .dashboard-header p {
                color:snow;
            }

        .quiz-card {
            background: #fff;
            border-radius: 20px;
            padding: 35px 30px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            width: 100%;
        }

        .form-control { width: 100%; padding: 14px 18px; border-radius: 12px; border: 1px solid #ccc; font-size: 1rem; margin-top: 15px; margin-bottom: 20px; }

        .form-control:focus { outline: none; border-color: #764ba2; box-shadow: 0 0 0 4px rgba(118,75,162,0.2); }

        .btn { padding: 12px 28px; border-radius: 15px; font-weight: 600; cursor: pointer; border: none; display: inline-flex; align-items: center; gap: 10px; font-size: 1rem; transition: all 0.3s ease; }
        .btn-primary { background: linear-gradient(135deg, #667eea, #764ba2); color: #fff; }
        .btn-primary:hover { background: linear-gradient(135deg, #764ba2, #667eea); }
        .btn-ghost { background: transparent; color: #764ba2; border: 2px solid #764ba2; }
        .btn-ghost:hover { background: #764ba2; color: #fff; }

        .quiz-question { margin-top: 25px; }
        .question-text { font-size: 1.2rem; margin-bottom: 18px; font-weight: 600; color: #333; }
        .quiz-options { display: flex; flex-direction: column; gap: 15px; }

        .quiz-progress { background: #e0e4ff; border-radius: 10px; overflow: hidden; height: 10px; margin-top: 12px; }
        #progressBar { height: 10px; background: #764ba2; width: 0%; transition: width 0.4s ease; }

        /* Disable quiz dropdown while a quiz is active */
        .disabled { pointer-events: none; opacity: 0.6; }

        @media (max-width: 900px) {
            main.dashboard-main { margin-left: 0; padding: 20px; }
        }
    </style>
</head>
<body class="dashboard-body">
    <form id="form1" runat="server">
        <div style="display: flex; min-height: 100vh;">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="sidebar-header">
                    <img src="../assets/images/logo.png" alt="MediLearn Hub" class="sidebar-logo" />
                    <h2>MediLearn Hub</h2>
                </div>
                <nav class="sidebar-nav">
                    <a href="student-dashboard.aspx">🏠 Dashboard</a>
<a href="courses.aspx">📚 My Courses</a>
<a href="profile.aspx">👤 Profile</a>
<a href="materials.aspx">📖 Materials</a>
<a href="quiz.aspx" class="active">🧠 Quizzes</a>
<a href="anatomy.aspx">👨🏽‍🔬 3D Anatomy</a>
<a href="notes.aspx">📝 My Notes</a>
<a href="quiz-summary.aspx">🥇 Results</a>
<a href="../index.aspx" class="logout">🚪 Logout</a
                </nav>
            </aside>

            <!-- Main Content -->
            <main class="dashboard-main">
                <header class="dashboard-header">
                    <h1>🧠 Medical Quiz</h1>
                    <p>Select a quiz and start testing your knowledge.</p>
                </header>

                <!-- QUIZ SELECTION -->
                <section class="quiz-section">
                    <div class="quiz-card">
                        <h2>Select a Quiz</h2>
                        <asp:DropDownList ID="ddlQuizList" runat="server" CssClass="form-control"></asp:DropDownList>
                        <asp:Button ID="btnStartQuiz" runat="server" CssClass="btn btn-primary" Text="Start Quiz" OnClick="btnStartQuiz_Click" />
                    </div>
                </section>

                <!-- ACTIVE QUIZ -->
                <section class="quiz-section" id="quizContainer" runat="server" Visible="false">
                    <div class="quiz-card">
                        <div class="quiz-top">
                            <asp:Label ID="lblQuestionCount" runat="server" CssClass="question-count" />
                            <div class="quiz-progress"><div id="progressBar" runat="server"></div></div>
                        </div>

                        <div class="quiz-question">
                            <asp:Label ID="lblQuestionText" runat="server" CssClass="question-text" />
                            <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="quiz-options"></asp:RadioButtonList>
                        </div>

                        <div class="quiz-actions" style="margin-top: 25px; display: flex; gap: 15px;">
                            <asp:Button ID="btnPrevious" runat="server" CssClass="btn btn-ghost" Text="Previous" OnClick="btnPrevious_Click" />
                            <asp:Button ID="btnNext" runat="server" CssClass="btn btn-primary" Text="Next" OnClick="btnNext_Click" />
                        </div>

                        <div class="quiz-submit" style="margin-top: 25px; text-align: center;">
                            <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-primary" Text="Submit Quiz" OnClick="btnSubmit_Click" />
                        </div>
                    </div>
                </section>
            </main>
        </div>
    </form>
</body>
</html>
