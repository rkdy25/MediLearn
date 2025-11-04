<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="quiz-results.aspx.cs" Inherits="WebApplication.student.QuizResults" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quiz Results | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <style>
        .results-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .score-display {
            text-align: center;
            padding: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            margin-bottom: 30px;
        }
        .score-number {
            font-size: 72px;
            font-weight: bold;
            margin: 20px 0;
        }
        .score-label {
            font-size: 24px;
            opacity: 0.9;
        }
        .results-summary {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .summary-card h3 {
            margin: 0 0 10px 0;
            color: #666;
            font-size: 14px;
        }
        .summary-card .value {
            font-size: 32px;
            font-weight: bold;
            color: #333;
        }
        .question-review {
            margin-top: 30px;
        }
        .review-item {
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 8px;
            border-left: 4px solid #ddd;
        }
        .review-item.correct {
            background: #d4edda;
            border-color: #28a745;
        }
        .review-item.incorrect {
            background: #f8d7da;
            border-color: #dc3545;
        }
        .review-question {
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }
        .review-answer {
            margin: 5px 0;
            padding-left: 20px;
        }
        .review-answer.your-answer {
            color: #666;
        }
        .review-answer.correct-answer {
            color: #28a745;
            font-weight: 600;
        }
        .action-buttons {
            text-align: center;
            margin-top: 30px;
        }
        .btn {
            padding: 12px 30px;
            margin: 0 10px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: #667eea;
            color: white;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="results-container">
            <h1 style="text-align: center; margin-bottom: 30px;">🎯 Quiz Results</h1>

            <!-- Score Display -->
            <div class="score-display">
                <div class="score-label">Your Score</div>
                <div class="score-number">
                    <asp:Label ID="lblScore" runat="server" Text="0" />%
                </div>
                <div class="score-label">
                    <asp:Label ID="lblGrade" runat="server" Text="Grade" />
                </div>
            </div>

            <!-- Summary Stats -->
            <div class="results-summary">
                <div class="summary-card">
                    <h3>Correct Answers</h3>
                    <div class="value">
                        <asp:Label ID="lblCorrectCount" runat="server" Text="0" />
                    </div>
                </div>
                <div class="summary-card">
                    <h3>Incorrect Answers</h3>
                    <div class="value">
                        <asp:Label ID="lblIncorrectCount" runat="server" Text="0" />
                    </div>
                </div>
                <div class="summary-card">
                    <h3>Total Questions</h3>
                    <div class="value">
                        <asp:Label ID="lblTotalQuestions" runat="server" Text="0" />
                    </div>
                </div>
            </div>

            <!-- Detailed Review -->
            <div class="question-review">
                <h2>Question Review</h2>
                <asp:Repeater ID="rptQuestionReview" runat="server">
                    <ItemTemplate>
                        <div class='review-item <%# (bool)Eval("IsCorrect") ? "correct" : "incorrect" %>'>
                            <div class="review-question">
                                Question <%# Eval("QuestionNumber") %>: <%# Eval("QuestionText") %>
                            </div>
                            <div class="review-answer your-answer">
                                <strong>Your Answer:</strong> <%# Eval("YourAnswer") %>
                                <%# (bool)Eval("IsCorrect") ? "✓" : "✗" %>
                            </div>
                            <%# !(bool)Eval("IsCorrect") ? 
                                "<div class='review-answer correct-answer'><strong>Correct Answer:</strong> " + Eval("CorrectAnswer") + "</div>" 
                                : "" %>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="quiz.aspx" class="btn btn-primary">Take Another Quiz</a>
                <a href="student-dashboard.aspx" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        </div>
    </form>
</body>
</html>