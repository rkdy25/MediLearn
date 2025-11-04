<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="preview-quiz.aspx.cs" Inherits="WebApplication.guest.preview_quiz" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Mini Quiz (Guest Preview) | MediLearn Hub</title>
  <link rel="stylesheet" href="../assets/css/style.css" />
  <link rel="stylesheet" href="../assets/css/guest-quiz.css" />
</head>
<body>
  <!-- Header -->
  <header class="site-header">
    <div class="container header-inner">
      <a class="brand" href="../index.aspx">
        <img src="../assets/images/logo.png" alt="MediLearn Hub logo" class="logo">
        <span class="brand-name">MediLearn Hub</span>
      </a>
      <nav class="main-nav">
        <ul>
          <li><a href="../index.aspx">Home</a></li>
          <li><a href="resources.aspx">Resources</a></li>
          <li><a href="Explore-3D.aspx">Explore 3D</a></li>
          <li><a href="../Login.aspx" class="btn btn-primary">Login</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <!-- Hero -->
  <section class="hero">
    <div class="container hero-inner">
      <div class="hero-content">
        <h1>Mini Medical Quiz (Guest Preview)</h1>
        <p>Try a short quiz and experience interactive learning. Registered users get full access to topic-based quizzes and progress tracking.</p>
      </div>
      <div class="hero-image">
        <img src="../assets/images/quiz-banner.png" alt="Quiz illustration">
      </div>
    </div>
  </section>

  <!-- Quiz Preview -->
  <section class="quiz-preview">
    <div class="container">
      <asp:Repeater ID="rptQuestions" runat="server">
        <ItemTemplate>
          <div class="quiz-card">
            <h2><%# "Question " + (Container.ItemIndex + 1) %></h2>
            <p><%# Eval("QuestionText") %></p>
            <ul class="quiz-options">
              <%# Eval("ChoicesHtml") %>
            </ul>
          </div>
        </ItemTemplate>
      </asp:Repeater>

      <div class="locked-card">
        <div class="lock-overlay">
          <i>🔒</i>
          <p>Login to Unlock Full Quiz</p>
        </div>
        <h2>More Questions Locked</h2>
        <p>Register or login to access complete topic quizzes and track your progress.</p>
      </div>
    </div>
  </section>

  <!-- CTA -->
  <section class="cta">
    <div class="container">
      <h2>Continue Your Learning Journey</h2>
      <p>Sign up to access full-length quizzes, answer tracking, and personalized feedback.</p>
    </div>
  </section>

  <!-- Footer -->
  <footer class="site-footer">
    <div class="container footer-inner">
      <div class="footer-left">
        <p>© <span id="year"></span> MediLearn Hub</p>
      </div>
      <div class="footer-right">
        <nav>
          <a href="../About.aspx">About</a>
          <a href="../Privacy.aspx">Privacy</a>
          <a href="../Contact.aspx">Contact</a>
        </nav>
      </div>
    </div>
  </footer>

  <script>
      document.getElementById("year").textContent = new Date().getFullYear();

      // handle clicks
      document.addEventListener("click", function (e) {
          if (e.target.classList.contains("option")) {
              const isCorrect = e.target.dataset.correct === "true";
              if (isCorrect) {
                  alert("✅ Correct!");
                  e.target.classList.add("correct");
              } else {
                  alert("❌ Wrong!");
                  e.target.classList.add("wrong");
              }
          }
      });
  </script>
</body>
</html>
