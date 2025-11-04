<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="notes.aspx.cs" Inherits="WebApplication.student.notes" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>My Notes | MediLearn Hub</title>
  <link rel="stylesheet" href="../assets/css/style.css" />
  <link rel="stylesheet" href="../assets/css/dashboard.css" />
  <link rel="stylesheet" href="../assets/css/notes.css" />
</head>

<body class="dashboard-body">
  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="sidebar-header">
      <img src="../assets/images/logo.png" alt="MediLearn Hub" class="sidebar-logo" />
      <h2>MediLearn Hub</h2>
    </div>
    <nav class="sidebar-nav">
      <a href="student-dashboard.aspx">🏠 Dashboard</a>
      <a href="profile.aspx">👤 Profile</a>
      <a href="materials.aspx">📚 Learning Materials</a>
      <a href="quiz.aspx">🧠 Quizzes</a>
      <a href="anatomy.aspx">👨🏽‍🔬 3D Anatomy</a>
      <a href="notes.aspx" class="active">📝 My Notes</a>
    <a href="quiz-summary.aspx">🥇Quizz results summary</a>
      <a href="../index.aspx" class="logout">🚪 Logout</a>
    </nav>
  </aside>

  <!-- Main Content -->
  <form id="form1" runat="server" class="dashboard-main">
    <header class="dashboard-header">
      <h1>📝 My Notes</h1>
      <p>Write, save, and organize your study notes easily.</p>
    </header>

    <section class="notes-section">
      <!-- Note Creator -->
      <div class="note-creator">
        <h2><asp:Label ID="lblFormTitle" runat="server" Text="Create a New Note"></asp:Label></h2>

        <asp:TextBox ID="txtNoteTitle" runat="server" CssClass="form-control" Placeholder="Note Title..."></asp:TextBox>
        <asp:TextBox ID="txtNoteContent" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" Placeholder="Write your notes here..."></asp:TextBox>

        <div class="note-buttons">
          <asp:Button ID="btnSaveNote" runat="server" CssClass="btn btn-primary" Text="Save Note" OnClick="btnSaveOrUpdate_Click" />
          <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-secondary" Text="Cancel" OnClick="btnCancel_Click" Visible="False" />
        </div>
      </div>

      <!-- Saved Notes -->
      <div class="saved-notes">
        <h2>Saved Notes</h2>

        <asp:GridView ID="gvNotes" runat="server" AutoGenerateColumns="False" CssClass="notes-list"
          OnRowCommand="gvNotes_RowCommand">
          <Columns>
            <asp:TemplateField>
              <ItemTemplate>
                <div class="note-card">
                  <h3><%# Eval("Title") %></h3>
                  <p><%# Eval("Content") %></p>
                  <div class="note-actions">
                    <asp:Button ID="btnEdit" runat="server" CssClass="btn btn-ghost" Text="✏️ Edit"
                      CommandName="EditNote" CommandArgument='<%# Eval("NoteID") %>' />
                    <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger" Text="🗑️ Delete"
                      CommandName="DeleteNote" CommandArgument='<%# Eval("NoteID") %>' />
                  </div>
                </div>
              </ItemTemplate>
            </asp:TemplateField>
          </Columns>
        </asp:GridView>
      </div>
    </section>
  </form>
</body>
</html>
