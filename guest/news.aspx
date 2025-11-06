<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="news.aspx.cs" Inherits="WebApplication.news" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>MediLearn Hub — Latest Medical News</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <style>
        /* News Grid Styling */
        .news-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            max-width: 1400px;
            margin: 30px auto;
            padding: 0;
            list-style: none;
        }

        .news-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 120, 212, 0.1);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(0, 120, 212, 0.1);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .news-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, #0078d4 0%, #00bcf2 100%);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }

        .news-card:hover::before {
            transform: scaleY(1);
        }

        .news-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0, 120, 212, 0.2);
            border-color: #0078d4;
        }

        .news-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #0078d4 0%, #00bcf2 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            font-size: 20px;
            color: white;
            flex-shrink: 0;
        }

        .news-title {
            font-weight: 600;
            color: #2c3e50;
            text-decoration: none;
            font-size: 0.95rem;
            line-height: 1.5;
            display: block;
            margin-bottom: 12px;
            transition: color 0.3s ease;
            flex-grow: 1;
        }

        .news-title:hover {
            color: #0078d4;
        }

        .news-date {
            font-size: 0.8rem;
            color: #7f8c8d;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: auto;
        }

        .news-date::before {
            content: '📅';
            font-size: 0.85rem;
        }

        /* Pagination Styling */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            margin: 40px auto 60px;
            max-width: 1400px;
        }

        .pagination-btn {
            background: linear-gradient(135deg, #0078d4 0%, #00bcf2 100%);
            color: white !important;
            border: none;
            padding: 12px 24px;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 120, 212, 0.3);
            text-decoration: none;
        }

        .pagination-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 120, 212, 0.4);
            color: white !important;
        }

        .pagination-btn:active {
            transform: translateY(-1px);
        }

        .pagination-btn.disabled {
            background: linear-gradient(135deg, #ccc 0%, #ddd 100%);
            cursor: not-allowed;
            opacity: 0.6;
            box-shadow: none;
            pointer-events: none;
        }

        .pagination-btn svg {
            width: 20px;
            height: 20px;
        }

        .page-info {
            background: white;
            padding: 12px 24px;
            border-radius: 50px;
            border: 2px solid #0078d4;
            font-weight: 600;
            color: #0078d4;
            font-size: 1rem;
            box-shadow: 0 2px 10px rgba(0, 120, 212, 0.1);
        }

        /* Responsive Design */
        @media (max-width: 1400px) {
            .news-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }

        @media (max-width: 1100px) {
            .news-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 768px) {
            .news-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }

            .pagination-btn {
                padding: 10px 18px;
                font-size: 0.9rem;
            }

            .page-info {
                padding: 10px 18px;
                font-size: 0.9rem;
            }
        }

        @media (max-width: 500px) {
            .news-grid {
                grid-template-columns: 1fr;
            }

            .pagination-container {
                gap: 10px;
            }

            .pagination-btn {
                padding: 8px 16px;
                font-size: 0.85rem;
            }

            .page-info {
                padding: 8px 16px;
                font-size: 0.85rem;
            }
        }

        /* Error Label */
        .error-label {
            display: block;
            color: #e74c3c;
            background: linear-gradient(135deg, #ffebee 0%, #ffe0e0 100%);
            padding: 15px 25px;
            border-radius: 10px;
            margin: 20px auto;
            text-align: center;
            font-weight: 500;
            max-width: 600px;
            border: 1px solid #ffcdd2;
        }

        /* Section Header Enhancement */
        .latest-resources h2 {
            text-align: center;
            font-size: 2.2rem;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #0078d4 0%, #00bcf2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .latest-resources .section-subtitle {
            text-align: center;
            color: #7f8c8d;
            font-size: 1rem;
            margin-bottom: 30px;
        }

        /* Animation for cards appearing */
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

        .news-card {
            animation: fadeInUp 0.6s ease backwards;
        }

        .news-card:nth-child(1) { animation-delay: 0.1s; }
        .news-card:nth-child(2) { animation-delay: 0.15s; }
        .news-card:nth-child(3) { animation-delay: 0.2s; }
        .news-card:nth-child(4) { animation-delay: 0.25s; }
        .news-card:nth-child(5) { animation-delay: 0.3s; }
        .news-card:nth-child(6) { animation-delay: 0.35s; }
        .news-card:nth-child(7) { animation-delay: 0.4s; }
        .news-card:nth-child(8) { animation-delay: 0.45s; }
        .news-card:nth-child(9) { animation-delay: 0.5s; }
        .news-card:nth-child(10) { animation-delay: 0.55s; }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <!-- Site header -->
        <header class="site-header">
            <div class="container header-inner">
                <a class="brand" href="index.aspx">
                    <img src="../assets/images/logo.png" alt="MediLearn Hub logo" class="logo" />
                    <span class="brand-name">MediLearn Hub</span>
                </a>

                <button id="navToggle" class="nav-toggle" aria-expanded="false" aria-controls="mainNav">
                    ☰ <span class="sr-only">Toggle navigation</span>
                </button>

                <nav id="mainNav" class="main-nav" aria-label="Primary navigation">
                    <ul>
                        <li><a href="../index.aspx">Home</a></li>
                        <li><a href="../Login.aspx">Login </a></li>
                        <li><a href="news.aspx" class="active">Latest News</a></li>
                        <li><a href="preview-quiz.aspx">Quizzes</a></li>
                        <li><a href="explore-3d.aspx">Explore 3D</a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <!-- Page hero -->
        <section class="hero">
            <div class="container hero-inner">
                <div class="hero-content">
                    <h1>Stay Updated with the Latest Medical News</h1>
                    <p>Get the most recent medical breakthroughs, research updates, and health news from trusted sources.</p>
                </div>
                <div class="hero-image" aria-hidden="true">
                    <img src="../assets/images/news.jpg" alt="Medical News" />
                </div>
            </div>
        </section>

        <!-- Latest Medical News Section -->
        <section class="latest-resources">
            <div class="container">
                <h2>Latest Medical News</h2>
                <p class="section-subtitle">Breaking medical discoveries and health updates from around the world</p>
                <asp:Label ID="lblNewsError" runat="server" CssClass="error-label" Visible="false"></asp:Label>
                <ul id="ulNews" runat="server" class="news-grid"></ul>
                
                <!-- Pagination Controls -->
                <div id="paginationControls" runat="server" class="pagination-container" visible="false">
                    <asp:LinkButton ID="btnPrevious" runat="server" CssClass="pagination-btn" OnClick="btnPrevious_Click">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="15 18 9 12 15 6"></polyline>
                        </svg>
                        Previous
                    </asp:LinkButton>
                    
                    <div class="page-info">
                        <asp:Literal ID="litPageInfo" runat="server" Text="Page 1"></asp:Literal>
                    </div>
                    
                    <asp:LinkButton ID="btnNext" runat="server" CssClass="pagination-btn" OnClick="btnNext_Click">
                        Next
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </asp:LinkButton>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="site-footer">
            <div class="container footer-inner">
                <div class="footer-left">
                    <p>© <span id="year"></span> MediLearn Hub</p>
                </div>
                <div class="footer-right">
                    <nav aria-label="Footer links">
                        <a href="about.html">About</a>
                        <a href="privacy.html">Privacy</a>
                        <a href="contact.html">Contact</a>
                    </nav>
                </div>
            </div>
        </footer>

        <script>
            const toggle = document.getElementById('navToggle');
            const nav = document.getElementById('mainNav');
            toggle.addEventListener('click', () => {
                const expanded = toggle.getAttribute('aria-expanded') === 'true' || false;
                toggle.setAttribute('aria-expanded', !expanded);
                nav.classList.toggle('open');
            });

            document.getElementById('year').textContent = new Date().getFullYear();
        </script>
    </form>
</body>
</html>