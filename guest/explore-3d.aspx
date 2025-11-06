<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="explore-3d.aspx.cs" Inherits="WebApplication.guest.explore_3d" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Explore 3D Anatomy | MediLearn Hub</title>
  <link rel="stylesheet" href="../assets/css/style.css" />
  <link rel="stylesheet" href="../assets/css/explore-3d.css" />
  
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f4f8fb;
      overflow-x: hidden;
    }
    
    /* Enhanced Navbar */
    .navbar {
      background: linear-gradient(135deg, #003366, #004e92);
      box-shadow: 0 8px 32px rgba(0,0,0,0.2);
      padding: 20px 0;
      position: sticky;
      top: 0;
      z-index: 1000;
      backdrop-filter: blur(10px);
    }
    
    .nav-inner {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    
    .nav-brand {
      display: flex;
      align-items: center;
      gap: 15px;
      color: white;
      font-size: 1.5rem;
      font-weight: 700;
    }
    
    .nav-brand img {
      width: 50px;
      height: 50px;
      border-radius: 50%;
      box-shadow: 0 0 20px rgba(0,120,212,0.6);
      animation: logoGlow 2s ease-in-out infinite;
    }
    
    @keyframes logoGlow {
      0%, 100% { box-shadow: 0 0 20px rgba(0,120,212,0.6); }
      50% { box-shadow: 0 0 30px rgba(0,120,212,0.9), 0 0 50px rgba(0,120,212,0.5); }
    }
    
    .main-nav ul {
      display: flex;
      gap: 30px;
      list-style: none;
    }
    
    .main-nav a {
      color: #dfe9f3;
      text-decoration: none;
      font-weight: 600;
      padding: 10px 20px;
      border-radius: 25px;
      transition: all 0.3s;
      position: relative;
    }
    
    .main-nav a::before {
      content: '';
      position: absolute;
      bottom: 0;
      left: 50%;
      transform: translateX(-50%);
      width: 0;
      height: 3px;
      background: #0078d4;
      transition: width 0.3s;
    }
    
    .main-nav a:hover::before,
    .main-nav a.active::before {
      width: 80%;
    }
    
    .main-nav a:hover,
    .main-nav a.active {
      background: rgba(255,255,255,0.1);
      color: white;
    }
    
    /* Crazy Hero Section */
    .hero {
      background: linear-gradient(135deg, #003366 0%, #004e92 50%, #0078d4 100%);
      padding: 80px 20px;
      position: relative;
      overflow: hidden;
    }
    
    .hero::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: 
        radial-gradient(circle at 20% 50%, rgba(0,120,212,0.3) 0%, transparent 50%),
        radial-gradient(circle at 80% 80%, rgba(0,69,124,0.3) 0%, transparent 50%);
      animation: bgPulse 10s ease-in-out infinite;
    }
    
    @keyframes bgPulse {
      0%, 100% { opacity: 0.5; }
      50% { opacity: 1; }
    }
    
    .hero-content {
      max-width: 1200px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 60px;
      align-items: center;
      position: relative;
      z-index: 1;
    }
    
    .hero-text h1 {
      font-size: 3.5rem;
      color: white;
      margin-bottom: 25px;
      line-height: 1.2;
      text-shadow: 0 5px 20px rgba(0,0,0,0.3);
      animation: fadeInUp 0.8s ease;
    }
    
    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
    
    .hero-text p {
      font-size: 1.2rem;
      color: #dfe9f3;
      margin-bottom: 35px;
      line-height: 1.8;
      animation: fadeInUp 0.8s ease 0.2s both;
    }
    
    .btn {
      display: inline-block;
      padding: 18px 40px;
      border-radius: 50px;
      text-decoration: none;
      font-weight: 700;
      font-size: 1.1rem;
      transition: all 0.4s cubic-bezier(0.23, 1, 0.320, 1);
      position: relative;
      overflow: hidden;
      animation: fadeInUp 0.8s ease 0.4s both;
    }
    
    .btn::before {
      content: '';
      position: absolute;
      top: 50%;
      left: 50%;
      width: 0;
      height: 0;
      border-radius: 50%;
      background: rgba(255,255,255,0.2);
      transform: translate(-50%, -50%);
      transition: width 0.6s, height 0.6s;
    }
    
    .btn:hover::before {
      width: 400px;
      height: 400px;
    }
    
    .btn-primary {
      background: white;
      color: #003366;
      box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    }
    
    .btn-primary:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 40px rgba(0,0,0,0.4);
    }
    
    .hero-illustration {
      position: relative;
      animation: fadeInRight 0.8s ease 0.3s both;
    }
    
    @keyframes fadeInRight {
      from {
        opacity: 0;
        transform: translateX(50px);
      }
      to {
        opacity: 1;
        transform: translateX(0);
      }
    }
    
    .hero-illustration img {
      width: 100%;
      height: auto;
      filter: drop-shadow(0 20px 40px rgba(0,0,0,0.3));
      animation: float 6s ease-in-out infinite;
    }
    
    @keyframes float {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-20px); }
    }
    
    /* Insane 3D Viewer Section */
    .viewer {
      padding: 80px 20px;
      background: white;
      position: relative;
    }
    
    .viewer::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: 
        radial-gradient(circle at 30% 50%, rgba(0,120,212,0.03) 0%, transparent 50%),
        radial-gradient(circle at 70% 50%, rgba(0,69,124,0.03) 0%, transparent 50%);
      pointer-events: none;
    }
    
    .viewer-grid {
      max-width: 1200px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: 2fr 1fr;
      gap: 50px;
      align-items: center;
      position: relative;
      z-index: 1;
    }
    
    .viewer-frame {
      background: linear-gradient(135deg, #003366, #004e92);
      border-radius: 25px;
      overflow: hidden;
      box-shadow: 0 20px 60px rgba(0,51,102,0.3);
      position: relative;
      animation: scaleIn 0.8s ease;
    }
    
    @keyframes scaleIn {
      from {
        opacity: 0;
        transform: scale(0.9);
      }
      to {
        opacity: 1;
        transform: scale(1);
      }
    }
    
    .viewer-frame::before {
      content: '';
      position: absolute;
      top: -2px;
      left: -2px;
      right: -2px;
      bottom: -2px;
      background: linear-gradient(45deg, #0078d4, #00457c, #0078d4);
      background-size: 300% 300%;
      border-radius: 25px;
      z-index: -1;
      animation: borderGlow 3s linear infinite;
    }
    
    @keyframes borderGlow {
      0%, 100% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
    }
    
    .viewer-frame video {
      width: 100%;
      height: auto;
      display: block;
      border-radius: 23px;
    }
    
    .viewer-info {
      animation: fadeInLeft 0.8s ease 0.3s both;
    }
    
    @keyframes fadeInLeft {
      from {
        opacity: 0;
        transform: translateX(-30px);
      }
      to {
        opacity: 1;
        transform: translateX(0);
      }
    }
    
    .viewer-info h2 {
      font-size: 2.5rem;
      color: #00457c;
      margin-bottom: 25px;
      position: relative;
      display: inline-block;
    }
    
    .viewer-info h2::after {
      content: '';
      position: absolute;
      bottom: -10px;
      left: 0;
      width: 80px;
      height: 5px;
      background: linear-gradient(90deg, #0078d4, #00457c);
      border-radius: 3px;
      animation: underlineGrow 2s ease-in-out infinite;
    }
    
    @keyframes underlineGrow {
      0%, 100% { width: 80px; }
      50% { width: 120px; }
    }
    
    .viewer-info p {
      font-size: 1.1rem;
      line-height: 1.8;
      color: #5b6b7a;
      margin-bottom: 30px;
    }
    
    /* Feature Cards */
    .features-list {
      display: flex;
      flex-direction: column;
      gap: 20px;
      margin-top: 30px;
    }
    
    .feature-item {
      background: linear-gradient(135deg, rgba(0,120,212,0.05), rgba(0,69,124,0.05));
      padding: 20px;
      border-radius: 15px;
      border-left: 4px solid #0078d4;
      transition: all 0.3s;
      cursor: pointer;
    }
    
    .feature-item:hover {
      transform: translateX(10px);
      box-shadow: 0 10px 30px rgba(0,120,212,0.2);
      border-left-width: 6px;
    }
    
    .feature-item h3 {
      color: #00457c;
      font-size: 1.3rem;
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    
    .feature-item h3::before {
      content: '✓';
      width: 30px;
      height: 30px;
      background: linear-gradient(135deg, #0078d4, #00457c);
      color: white;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
    }
    
    .feature-item p {
      color: #666;
      font-size: 0.95rem;
      margin-left: 40px;
    }
    
    /* Enhanced Footer */
    .footer {
      background: linear-gradient(135deg, #003366, #004e92);
      color: white;
      padding: 40px 20px;
      text-align: center;
      box-shadow: 0 -5px 20px rgba(0,0,0,0.2);
    }
    
    .footer p {
      font-size: 1rem;
      opacity: 0.9;
    }
    
    /* Responsive */
    @media (max-width: 968px) {
      .hero-content,
      .viewer-grid {
        grid-template-columns: 1fr;
        gap: 40px;
      }
      
      .hero-text h1 {
        font-size: 2.5rem;
      }
      
      .main-nav ul {
        gap: 15px;
      }
      
      .main-nav a {
        padding: 8px 15px;
        font-size: 0.9rem;
      }
    }
    
    @media (max-width: 600px) {
      .hero {
        padding: 50px 20px;
      }
      
      .hero-text h1 {
        font-size: 2rem;
      }
      
      .viewer {
        padding: 50px 20px;
      }
    }
  </style>
</head>
<body>
  <!-- Enhanced Navbar -->
  <header class="navbar">
    <div class="container nav-inner">
      <div class="nav-brand">
        <img src="../assets/images/logo.png" alt="MediLearn Hub Logo" />
        <span>MediLearn Hub</span>
      </div>
     
      <nav id="mainNav" class="main-nav" aria-label="Primary navigation">
        <ul>
          <li><a href="../index.aspx">Home</a></li>
          <li><a href="../Login.aspx">Login</a></li>
          <li><a href="news.aspx">Latest News</a></li>
          <li><a href="preview-quiz.aspx">Quizzes</a></li>
          <li><a href="explore-3d.aspx" class="active">Explore 3D</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <!-- Crazy Hero -->
  <section class="hero">
    <div class="container hero-content">
      <div class="hero-text">
        <h1>🧠 Explore Human Anatomy in 3D</h1>
        <p>Experience interactive anatomical models built for medical learning. Rotate, zoom, and dive into every system — no account needed!</p>
        <a href="../Login.aspx" class="btn btn-primary">Sign in for Full Access →</a>
      </div>
      <div class="hero-illustration">
        <img src="../assets/images/3d-banner.png" alt="3D Anatomy Illustration" />
      </div>
    </div>
  </section>

  <!-- Insane 3D Viewer -->
  <section class="viewer">
    <div class="container viewer-grid">
      <div class="viewer-frame">
        <video autoplay muted loop playsinline poster="../assets/images/anatomy-thumb.png">
          <source src="../assets/videos/body-3d.mp4" type="video/mp4">
          Your browser does not support the video tag.
        </video>
      </div>
      
      <div class="viewer-info">
        <h2>Interactive 3D Model</h2>
        <p>This comprehensive 3D anatomy visualization provides a continuous overview of human body systems including skeletal, muscular, and cardiovascular structures.</p>
        
        <div class="features-list">
          <div class="feature-item">
            <h3>High Quality</h3>
            <p>Crystal clear medical-grade 3D models</p>
          </div>
          
          <div class="feature-item">
            <h3>Auto-Play Demo</h3>
            <p>Seamless learning experience with automatic rotation</p>
          </div>
          
          <div class="feature-item">
            <h3>No Login Required</h3>
            <p>Access guest preview instantly, anytime</p>
          </div>
          
          <div class="feature-item">
            <h3>Multiple Systems</h3>
            <p>Explore skeletal, muscular & cardiovascular anatomy</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Enhanced Footer -->
  <footer class="footer">
    <p>© 2025 MediLearn Hub | Interactive Learning for Medical Students</p>
  </footer>
</body>
</html>