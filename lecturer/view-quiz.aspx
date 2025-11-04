<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="view-quiz.aspx.cs" Inherits="WebApplication.lecturer.view_quiz" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>View Quiz | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
</head>
<body>
    <form id="form1" runat="server" class="dashboard-body">
        <main class="dashboard-main">
            <header class="dashboard-header">
                <h1>🧠 Quiz Details</h1>
            </header>

            <asp:GridView ID="gvQuestions" runat="server" AutoGenerateColumns="False" CssClass="table">
                <Columns>
                    <asp:BoundField HeaderText="Question" DataField="QuestionText" />
                    <asp:BoundField HeaderText="Option A" DataField="OptionA" />
                    <asp:BoundField HeaderText="Option B" DataField="OptionB" />
                    <asp:BoundField HeaderText="Option C" DataField="OptionC" />
                    <asp:BoundField HeaderText="Option D" DataField="OptionD" />
                    <asp:BoundField HeaderText="Correct Answer" DataField="CorrectAnswer" />
                </Columns>
            </asp:GridView>
        </main>
    </form>
</body>
</html>
