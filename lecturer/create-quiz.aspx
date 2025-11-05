<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="create-quiz.aspx.cs" Inherits="WebApplication.lecturer.create_quiz" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create Quiz | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <style>
        .btn-primary {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-primary:hover { background-color: #0056b3; }

        .btn-success {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-success:hover { background-color: #218838; }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-danger:hover { background-color: #c82333; }

        .btn-ghost {
            background-color: transparent;
            color: #007bff;
            border: 1px solid #007bff;
            padding: 6px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-ghost:hover { background-color: #007bff; color: white; }

        .quiz-section {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  margin-top: 2rem;
}

.quiz-card, .quiz-list {
  background: #ffffff;
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  transition: all 0.3s ease;
}

.quiz-card:hover, .quiz-list:hover {
  transform: translateY(-3px);
}

.quiz-card h2, .quiz-list h2 {
  font-size: 1.3rem;
  margin-bottom: 1rem;
  color: #0a3d62;
}

.form-control {
  width: 100%;
  padding: 0.7rem;
  margin-bottom: 0.8rem;
  border: 1px solid #ccc;
  border-radius: 10px;
  transition: border-color 0.2s ease;
}

.form-control:focus {
  border-color: #0078ff;
  outline: none;
}

.btn {
  padding: 0.6rem 1.2rem;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: 0.2s;
}

.btn-primary {
  background: #0078ff;
  color: white;
}

.btn-primary:hover {
  background: #005ec2;
}

.btn-success {
  background: #2ecc71;
  color: white;
}

.btn-danger {
  background: #e74c3c;
  color: white;
}

.btn-secondary {
  background: #95a5a6;
  color: white;
}

.table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 1rem;
}

.table th, .table td {
  padding: 10px 15px;
  border-bottom: 1px solid #ddd;
  text-align: left;
}

.table tr:hover {
  background-color: #f9f9f9;
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
                            <asp:BoundField HeaderText="Date Created" DataField="CreatedDate" DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <%# (bool)Eval("IsActive") ? "✅ Published" : "❌ Unpublished" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnEdit" runat="server" CssClass="btn btn-ghost" Text="Edit" CommandName="EditQuiz" CommandArgument='<%# Eval("QuizID") %>' />
                                    <asp:Button ID="btnToggleAvailability" runat="server"
                                        CssClass="btn btn-primary"
                                        Text='<%# (bool)Eval("IsActive") ? "Unpublish" : "Publish" %>'
                                        CommandName="ToggleAvailability"
                                        CommandArgument='<%# Eval("QuizID") %>' />
                                    <asp:Button ID="btnDelete" runat="server"
                                        CssClass="btn btn-danger"
                                        Text="Delete"
                                        CommandName="DeleteQuiz"
                                        CommandArgument='<%# Eval("QuizID") %>'
                                        OnClientClick="return confirm('Are you sure you want to delete this quiz?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </section>
        </main>
    </form>
</body>
</html>
