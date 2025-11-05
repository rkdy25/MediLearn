<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="quiz-summary.aspx.cs" Inherits="WebApplication.student.quiz_summary" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Quiz Summary | MediLearn Hub</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

  <!-- Custom Styles -->
  <link rel="stylesheet" href="../assets/css/style.css" />
  <link rel="stylesheet" href="../assets/css/dashboard.css" />

  <style>
    .dashboard-main {
      padding: 30px;
      background-color: #f8f9fa;
      min-height: 100vh;
    }

    .results-summary {
      background: #fff;
      border-radius: 10px;
      padding: 25px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      margin-bottom: 25px;
    }

    .results-summary h2 {
      color: #007bff;
      margin-bottom: 10px;
    }

    .score-pill {
      padding: 6px 14px;
      border-radius: 25px;
      color: #fff;
      font-weight: bold;
    }

    .score-pill.high { background-color: #28a745; }
    .score-pill.medium { background-color: #ffc107; color: #333; }
    .score-pill.low { background-color: #dc3545; }

    .gridview-pager {
      text-align: center;
      margin-top: 20px;
    }

    .gridview-pager a,
    .gridview-pager span {
      display: inline-block;
      margin: 0 5px;
      padding: 5px 12px;
      border-radius: 20px;
      border: 1px solid #007bff;
      color: #007bff;
      text-decoration: none;
      font-weight: 500;
    }

    .gridview-pager a:hover {
      background-color: #007bff;
      color: white;
    }

    .gridview-pager span {
      background-color: #007bff;
      color: white;
    }

    .dashboard-header h1 {
      color: #007bff;
    }

  </style>
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
<a href="courses.aspx">📚 My Courses</a>
<a href="profile.aspx">👤 Profile</a>
<a href="materials.aspx">📖 Materials</a>
<a href="quiz.aspx">🧠 Quizzes</a>
<a href="anatomy.aspx">👨🏽‍🔬 3D Anatomy</a>
<a href="notes.aspx">📝 My Notes</a>
<a href="quiz-summary.aspx" class="active">🥇 Results</a>
<a href="../index.aspx" class="logout">🚪 Logout</a
    </nav>
  </aside>

  <!-- Main -->
  <form id="form1" runat="server" class="dashboard-main">
    <header class="dashboard-header mb-4">
      <h1>🧠 Quiz Summary</h1>
      <p>View your quiz results and track your performance.</p>
    </header>

    <!-- Summary Container -->
    <div class="results-summary">
      <h2>📋 Attempt History</h2>
      <asp:GridView 
        ID="gvQuizResults" 
        runat="server" 
        AutoGenerateColumns="False"
        CssClass="table table-bordered table-hover table-striped"
        AllowPaging="True"
        PageSize="5"
        PagerStyle-CssClass="gridview-pager"
        OnPageIndexChanging="gvQuizResults_PageIndexChanging">

        <Columns>
          <asp:BoundField DataField="Title" HeaderText="Quiz Title" />
          <asp:BoundField DataField="AttemptDate" HeaderText="Attempt Date" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
          <asp:TemplateField HeaderText="Score">
            <ItemTemplate>
              <span class='score-pill <%# Eval("ScoreClass") %>'><%# Eval("DisplayScore") %></span>
            </ItemTemplate>
          </asp:TemplateField>
        </Columns>

        <PagerSettings 
          Mode="NumericFirstLast" 
          FirstPageText="« First" 
          LastPageText="Last »"
          NextPageText="Next ›" 
          PreviousPageText="‹ Prev" />
      </asp:GridView>
    </div>

  </form>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
