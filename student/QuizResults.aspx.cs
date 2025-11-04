using System;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication.student
{
    public partial class QuizResults : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Basic checks
                if (Session["UserID"] == null || Session["Role"] == null)
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                if (Request.QueryString["attemptid"] == null)
                {
                    Response.Redirect("quiz.aspx");
                    return;
                }

                if (!int.TryParse(Request.QueryString["attemptid"], out int attemptID))
                {
                    Response.Redirect("quiz.aspx");
                    return;
                }

                LoadQuizResults(attemptID);
            }
        }

        private void LoadQuizResults(int attemptID)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // 1) Get the quiz id and stored score from QuizAttempts
                int quizID = 0;
                decimal storedScore = 0m;
                string quizTitle = "";

                string attemptQuery = "SELECT QuizID, Score FROM QuizAttempts WHERE AttemptID = @AttemptID";
                using (SqlCommand cmd = new SqlCommand(attemptQuery, con))
                {
                    cmd.Parameters.AddWithValue("@AttemptID", attemptID);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            quizID = r["QuizID"] != DBNull.Value ? Convert.ToInt32(r["QuizID"]) : 0;
                            storedScore = r["Score"] != DBNull.Value ? Convert.ToDecimal(r["Score"]) : 0m;
                        }
                    }
                }

                if (quizID == 0)
                {
                    // nothing to show
                    ShowErrorAndRedirect("Quiz attempt not found.", "quiz.aspx");
                    return;
                }

                // get quiz title (optional)
                using (SqlCommand cmd = new SqlCommand("SELECT Title FROM Quizzes WHERE QuizID = @QuizID", con))
                {
                    cmd.Parameters.AddWithValue("@QuizID", quizID);
                    object t = cmd.ExecuteScalar();
                    quizTitle = t != null ? t.ToString() : "";
                }

                // 2) Count total questions for the quiz (source of truth)
                int totalQuestions = 0;
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Questions WHERE QuizID = @QuizID", con))
                {
                    cmd.Parameters.AddWithValue("@QuizID", quizID);
                    totalQuestions = Convert.ToInt32(cmd.ExecuteScalar());
                }

                // 3) Count correct answers for this attempt
                int correctCount = 0;
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT COUNT(*) 
                    FROM QuizAnswers a
                    INNER JOIN Choices c ON a.ChoiceID = c.ChoiceID
                    WHERE a.AttemptID = @AttemptID AND c.IsCorrect = 1", con))
                {
                    cmd.Parameters.AddWithValue("@AttemptID", attemptID);
                    correctCount = Convert.ToInt32(cmd.ExecuteScalar());
                }

                // 4) Use a single query to pull one row per question with user's answer (if any) and the correct answer
                string reviewQuery = @"
                    SELECT 
                        q.QuestionID,
                        q.QuestionText,
                        ISNULL(cUser.ChoiceText, '(no answer)') AS YourAnswer,
                        ISNULL(cCorr.ChoiceText, '') AS CorrectAnswer,
                        CASE WHEN a.IsCorrect = 1 THEN 1 ELSE 0 END AS IsCorrect,
                        q.OrderNo
                    FROM Questions q
                    LEFT JOIN QuizAnswers a ON q.QuestionID = a.QuestionID AND a.AttemptID = @AttemptID
                    LEFT JOIN Choices cUser ON a.ChoiceID = cUser.ChoiceID
                    LEFT JOIN Choices cCorr ON cCorr.QuestionID = q.QuestionID AND cCorr.IsCorrect = 1
                    WHERE q.QuizID = @QuizID
                    ORDER BY ISNULL(q.OrderNo, q.QuestionID), q.QuestionID";

                DataTable reviewTable = new DataTable();
                reviewTable.Columns.Add("QuestionNumber", typeof(int));
                reviewTable.Columns.Add("QuestionText", typeof(string));
                reviewTable.Columns.Add("YourAnswer", typeof(string));
                reviewTable.Columns.Add("CorrectAnswer", typeof(string));
                reviewTable.Columns.Add("IsCorrect", typeof(bool));

                using (SqlCommand cmd = new SqlCommand(reviewQuery, con))
                {
                    cmd.Parameters.AddWithValue("@AttemptID", attemptID);
                    cmd.Parameters.AddWithValue("@QuizID", quizID);

                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        int qIndex = 0;
                        while (r.Read())
                        {
                            qIndex++;
                            string qText = r["QuestionText"] != DBNull.Value ? r["QuestionText"].ToString() : "";
                            string yourAns = r["YourAnswer"] != DBNull.Value ? r["YourAnswer"].ToString() : "(no answer)";
                            string corrAns = r["CorrectAnswer"] != DBNull.Value ? r["CorrectAnswer"].ToString() : "";
                            bool isCorrect = r["IsCorrect"] != DBNull.Value && Convert.ToInt32(r["IsCorrect"]) == 1;

                            reviewTable.Rows.Add(qIndex, qText, yourAns, corrAns, isCorrect);
                        }
                    }
                }

                // 5) Fill UI labels
                lblScore.Text = storedScore.ToString("0.##");
                lblGrade.Text = GetGradeText(storedScore);
                lblCorrectCount.Text = correctCount.ToString();
                lblTotalQuestions.Text = totalQuestions.ToString();
                lblIncorrectCount.Text = (totalQuestions - correctCount).ToString();

                // 6) Bind the repeater for review
                rptQuestionReview.DataSource = reviewTable;
                rptQuestionReview.DataBind();

                con.Close();
            }
        }

        private string GetGradeText(decimal score)
        {
            if (score >= 90) return "Excellent 🌟";
            if (score >= 75) return "Good Job 👍";
            if (score >= 60) return "Fair 👏";
            return "Needs Improvement 💪";
        }

        private void ShowErrorAndRedirect(string message, string redirectUrl)
        {
            string script = $"alert('{message.Replace("'", "\\'")}'); window.location = '{redirectUrl}';";
            ScriptManager.RegisterStartupScript(this, GetType(), "err", script, true);
        }
    }
}
