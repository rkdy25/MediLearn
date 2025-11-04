<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="resources.aspx.cs" Inherits="WebApplication.guest.resources" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Guest Learning Resources | MediLearn Hub</title>
  <link rel="stylesheet" href="../assets/css/style.css" />
  <link rel="stylesheet" href="../assets/css/guest-resources.css" />
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
          <li><a href="Explore-3d.aspx">Explore 3D</a></li>
          <li><a href="preview-quiz.aspx">Mini Quiz</a></li>
          <li><a href="../Login.aspx" class="btn btn-primary">Login</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <!-- Hero -->
  <section class="hero">
    <div class="container hero-inner">
      <div class="hero-content">
        <h1>Preview Medical Learning Resources</h1>
        <p>Discover a selection of high-quality study materials designed for medical students. Get a glimpse of what MediLearn Hub offers — from clinical cases to interactive anatomy models.</p>
      </div>
      <div class="hero-image">
        <img src="../assets/images/resources-banner.png" alt="Medical learning resources illustration">
      </div>
    </div>
  </section>

  <!-- Resources -->
  <section class="resources">
    <div class="container resources-grid">

      <article class="resource-card">
        <div class="image-wrapper">
          <img src="../assets/images/cardio.png" alt="Cardiology Fundamentals">
        </div>
        <h3>Cardiology — Heart Function Fundamentals</h3>
        <p>Review the essential concepts of cardiac anatomy and blood circulation through clear diagrams and brief explanations.</p>
        <a href="#" class="btn btn-primary">View Resource</a>
      </article>

      <article class="resource-card">
        <div class="image-wrapper">
          <img src="../assets/images/anatomy.png" alt="Skeletal Anatomy 3D">
        </div>
        <h3>Anatomy — 3D Skeletal System</h3>
        <p>Explore an interactive 3D skeletal model for a visual understanding of bone structure and landmarks.</p>
        <a href="explore-3d.aspx" class="btn btn-primary">Open 3D Viewer</a>
      </article>

      <article class="resource-card locked">
        <div class="image-wrapper">
          <img src="../assets/images/pharma.png" alt="Pharmacology Quiz">
          <div class="lock-overlay">
            <i>🔒</i>
            <p>Login to Unlock</p>
          </div>
        </div>
        <h3>Pharmacology — Drug Mechanisms</h3>
        <p>Interactive quizzes covering drug classifications, mechanisms, and therapeutic applications.</p>
      </article>

      <article class="resource-card locked">
        <div class="image-wrapper">
          <img src="../assets/images/neuro.png" alt="Neuroscience Overview">
          <div class="lock-overlay">
            <i>🔒</i>
            <p>Members Only</p>
          </div>
        </div>
        <h3>Neuroscience — Brain Pathways</h3>
        <p>In-depth visual guide to neural pathways and brain communication systems.</p>
      </article>

    </div>
  </section>

  <!-- Call to Action -->
  <section class="cta">
    <div class="container">
      <h2>Unlock the Complete Learning Experience</h2>
      <p>Join MediLearn Hub to gain full access to lectures, quizzes, and interactive tools across all medical disciplines.</p>
      

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
          <a href="../About.html">About</a>
          <a href="../Privacy.html">Privacy</a>
          <a href="../Contact.html">Contact</a>
        </nav>
      </div>
    </div>
  </footer>

  <script>
    document.getElementById('year').textContent = new Date().getFullYear();
  </script>
</body>
</html>