<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="edit-quiz.aspx.cs" Inherits="WebApplication.lecturer.edit_quiz" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Edit Quiz | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <style>
        .quiz-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-top: 2rem;
        }

        .quiz-card {
            background: #fff;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .form-control {
            width: 100%;
            padding: 0.7rem;
            margin-bottom: 0.8rem;
            border: 1px solid #ccc;
            border-radius: 10px;
        }

        .btn {
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            cursor: pointer;
            border: none;
            font-weight: 600;
        }

        .btn-primary { background: #0078ff; color: #fff; }
        .btn-success { background: #2ecc71; color: #fff; }
        .btn-danger { background: #e74c3c; color: #fff; }
        .btn-secondary { background: #95a5a6; color: #fff; }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .table th, .table td {
            padding: 10px 15px;
            border-bottom: 1px solid #ddd;
        }

        .table tr:hover { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="dashboard-body">
        <aside class="sidebar">
            <div class="sidebar-header">
                <img src="../assets/images/logo.png" alt="MediLearn Hub" class="sidebar-logo" />
                <h2>MediLearn Hub</h2>
            </div>
            <nav class="sidebar-nav">
                <a href="profile.aspx">👤 Profile</a>
<a href="my-courses.aspx" class="active">📘 Manage Courses</a>
<a href="search-resources.aspx">🔍 Search Resources</a>
                <a href="view-grades.aspx">📊 View Grades</a>
<a href="../index.aspx">🚪 Logout</a>
            </nav>
        </aside>

        <main class="dashboard-main">
            <header class="dashboard-header">
                <h1>✏ Edit Quiz</h1>
                <p>Modify quiz details and manage its questions.</p>
            </header>

            <section class="quiz-section">
                <div class="quiz-card">
                    <h2>Quiz Details</h2>
                    <label for="txtQuizTitle">Quiz Title</label>
                    <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="form-control" />

                    <asp:Button ID="btnUpdateQuiz" runat="server" CssClass="btn btn-primary" Text="Update Title" OnClick="btnUpdateQuiz_Click" />
                </div>

                <div class="quiz-card">
                    <h2>Add / Edit Question</h2>
                    <label>Question</label>
                    <asp:TextBox ID="txtQuestion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />

                    <label>Options (2–4)</label>
                    <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control" placeholder="Option A" />
                    <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control" placeholder="Option B" />
                    <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control" placeholder="Option C (optional)" />
                    <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control" placeholder="Option D (optional)" />

                    <label>Correct Answer</label>
                    <asp:DropDownList ID="ddlCorrectAnswer" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Select..." Value="" />
                        <asp:ListItem Text="A" Value="A" />
                        <asp:ListItem Text="B" Value="B" />
                        <asp:ListItem Text="C" Value="C" />
                        <asp:ListItem Text="D" Value="D" />
                    </asp:DropDownList>

                    <asp:Button ID="btnAddQuestion" runat="server" CssClass="btn btn-success" Text="Add Question" OnClick="btnAddQuestion_Click" />
                </div>
            </section>

            <section class="quiz-card" style="margin-top: 2rem;">
                <h2>Existing Questions</h2>
                <asp:GridView ID="gvQuestions" runat="server" AutoGenerateColumns="False" CssClass="table"
                    OnRowCommand="gvQuestions_RowCommand" EmptyDataText="No questions yet.">
                    <Columns>
                        <asp:BoundField DataField="QuestionText" HeaderText="Question" />
                        <asp:BoundField DataField="ChoiceCount" HeaderText="Choices" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button ID="btnEditQ" runat="server" CssClass="btn btn-primary" Text="Edit"
                                    CommandName="EditQ" CommandArgument='<%# Eval("QuestionID") %>' />
                                <asp:Button ID="btnDeleteQ" runat="server" CssClass="btn btn-danger" Text="Delete"
                                    CommandName="DeleteQ" CommandArgument='<%# Eval("QuestionID") %>'
                                    OnClientClick="return confirm('Delete this question?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </section>
        </main>
    </form>
</body>
</html>
