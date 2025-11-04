<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="create-quiz.aspx.cs" Inherits="WebApplication.lecturer.create_quiz" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create Quiz | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <link rel="stylesheet" href="../assets/css/create-quiz.css" />
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
                <a href="upload-materials.aspx">📂 Upload Materials</a>
                <a href="create-quiz.aspx" class="active">🧠 Create Quiz</a>
                <a href="search-resources.aspx">🔍 Search Resources</a>
                <a href="../index.aspx" class="logout">🚪 Logout</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="dashboard-main">
            <header class="dashboard-header">
                <h1>🧠 Create and Manage Quizzes</h1>
                <p>Design your assessments and manage existing quizzes easily.</p>
            </header>

            <section class="quiz-section">

                <!-- Create Quiz Form -->
                <div class="quiz-card">
                    <h2>Create a New Quiz</h2>
                    <asp:Panel ID="pnlCreateQuiz" runat="server">
                        <div class="quiz-form">
                            <label for="txtQuizTitle">Quiz Title</label>
                            <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="form-control" placeholder="Enter quiz title..." />

                            <label for="txtQuizQuestion">Question</label>
                            <asp:TextBox ID="txtQuizQuestion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Enter question..." />

                            <label>Options</label>
                            <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control" placeholder="Option A" />
                            <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control" placeholder="Option B" />
                            <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control" placeholder="Option C" />
                            <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control" placeholder="Option D" />

                            <label for="ddlCorrectAnswer">Correct Answer</label>
                            <asp:DropDownList ID="ddlCorrectAnswer" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Select correct option..." Value="" />
                                <asp:ListItem Text="A" Value="A" />
                                <asp:ListItem Text="B" Value="B" />
                                <asp:ListItem Text="C" Value="C" />
                                <asp:ListItem Text="D" Value="D" />
                            </asp:DropDownList>

                            <asp:Button ID="btnAddQuestion" runat="server" CssClass="btn btn-primary" Text="Add Question" OnClick="btnAddQuestion_Click" />
                            <asp:Button ID="btnFinishQuiz" runat="server" CssClass="btn btn-success" Text="Finish Quiz" OnClick="btnFinishQuiz_Click" style="margin-left: 10px;" />
                        </div>
                    </asp:Panel>
                </div>

                <!-- Existing Quizzes -->
                <div class="quiz-list">
                    <h2>Existing Quizzes</h2>
                    <asp:GridView ID="gvQuizzes" runat="server" 
    AutoGenerateColumns="False" 
    CssClass="table"
    AllowPaging="True" PageSize="5"
    OnPageIndexChanging="gvQuizzes_PageIndexChanging"
    OnRowCommand="gvQuizzes_RowCommand"
    EmptyDataText="No quizzes created yet.">
    <Columns>
        <asp:BoundField HeaderText="Title" DataField="Title" />
        <asp:BoundField HeaderText="Questions" DataField="QuestionCount" />
        <asp:BoundField HeaderText="Date Created" DataField="DateCreated" DataFormatString="{0:yyyy-MM-dd}" />
        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <asp:Button ID="btnViewQuiz" runat="server" 
                    CssClass="btn btn-ghost" 
                    Text="View" 
                    CommandName="ViewQuiz" 
                    CommandArgument='<%# Eval("QuizID") %>' />
                <asp:Button ID="btnDeleteQuiz" runat="server" 
                    CssClass="btn btn-danger" 
                    Text="Delete" 
                    CommandName="DeleteQuiz" 
                    CommandArgument='<%# Eval("QuizID") %>' 
                    OnClientClick="return confirm('Are you sure you want to delete this quiz?');" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

                        </Columns>
                    </asp:GridView>
                </div>

            </section>
        </main>

    </form>
</body>
</html>