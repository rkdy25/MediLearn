<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="quiz.aspx.cs" Inherits="WebApplication.student.quiz" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quiz | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <link rel="stylesheet" href="../assets/css/quiz.css" />
</head>
<body class="dashboard-body">
    <form id="form1" runat="server">
        <!-- WRAPPER to hold sidebar and content side by side -->
        <div style="display: flex; min-height: 100vh;">
            <!-- Sidebar -->
            <aside class="sidebar" style="flex: 0 0 260px;">
                <div class="sidebar-header">
                    <img src="../assets/images/logo.png" alt="MediLearn Hub" class="sidebar-logo" />
                    <h2>MediLearn Hub</h2>
                </div>
                <nav class="sidebar-nav">
                    <a href="student-dashboard.aspx">🏠 Dashboard</a>
                    <a href="profile.aspx">👤 Profile</a>
                    <a href="materials.aspx">📚 Learning Materials</a>
                    <a href="quiz.aspx" class="active">🧠 Quizzes</a>
                    <a href="anatomy.aspx">👨🏽‍🔬 3D Anatomy</a>
                    <a href="notes.aspx">📝 My Notes</a>
                    <a href="quiz-summary.aspx">🥇Quizz results summary</a>
                    <a href="../index.aspx" class="logout">🚪 Logout</a>
                </nav>
            </aside>
            
            <!-- Main Content -->
            <main class="dashboard-main" style="flex: 1; padding: 20px;">
                <header class="dashboard-header">
                    <h1>🧠 Medical Quiz</h1>
                    <p>Select a quiz and start testing your knowledge.</p>
                </header>
                
                <!-- QUIZ SELECTION -->
                <section class="quiz-section">
                    <div class="quiz-card">
                        <h2>Select a Quiz</h2>
                        <asp:DropDownList ID="ddlQuizList" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                        <br />
                        <asp:Button ID="btnStartQuiz" runat="server" 
                            CssClass="btn btn-primary" 
                            Text="Start Quiz" 
                            OnClick="btnStartQuiz_Click" />
                    </div>
                </section>
                
                <!-- ACTIVE QUIZ -->
                <section class="quiz-section" id="quizContainer" runat="server" visible="false">
                    <div class="quiz-card">
                        <div class="quiz-top">
                            <asp:Label ID="lblQuestionCount" runat="server" CssClass="question-count" />
                            <div class="quiz-progress">
                                <div id="progressBar" runat="server" class="progress-bar" style="width: 0%; background: #667eea; height: 8px; border-radius: 4px; transition: width 0.3s;"></div>
                            </div>
                        </div>
                        
                        <div class="quiz-question">
                            <asp:Label ID="lblQuestionText" runat="server" CssClass="question-text" />
                            <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="quiz-options">
                            </asp:RadioButtonList>
                        </div>
                        
                        <div class="quiz-actions" style="margin-top: 20px;">
                            <asp:Button ID="btnPrevious" runat="server" 
                                CssClass="btn btn-ghost" 
                                Text="Previous" 
                                OnClick="btnPrevious_Click" />
                            <asp:Button ID="btnNext" runat="server" 
                                CssClass="btn btn-primary" 
                                Text="Next" 
                                OnClick="btnNext_Click" />
                        </div>
                        
                        <div class="quiz-submit" style="margin-top: 20px; text-align: center;">
                            <asp:Button ID="btnSubmit" runat="server" 
                                CssClass="btn btn-primary" 
                                Text="Submit Quiz" 
                                OnClick="btnSubmit_Click" 
                                Visible="false" />
                        </div>
                    </div>
                </section>
            </main>
        </div>
    </form>
</body>
</html>