using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;

namespace WebApplication.student
{
    public partial class quiz : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        // Track quiz data
        private List<QuizQuestionData> QuizQuestions
        {
            get
            {
                if (ViewState["QuizQuestions"] == null)
                    ViewState["QuizQuestions"] = new List<QuizQuestionData>();
                return (List<QuizQuestionData>)ViewState["QuizQuestions"];
            }
            set
            {
                ViewState["QuizQuestions"] = value;
            }
        }

        private int CurrentQuestionIndex
        {
            get
            {
                if (ViewState["CurrentQuestionIndex"] == null)
                    ViewState["CurrentQuestionIndex"] = 0;
                return (int)ViewState["CurrentQuestionIndex"];
            }
            set
            {
                ViewState["CurrentQuestionIndex"] = value;
            }
        }

        private Dictionary<int, int> StudentAnswers
        {
            get
            {
                if (ViewState["StudentAnswers"] == null)
                    ViewState["StudentAnswers"] = new Dictionary<int, int>();
                return (Dictionary<int, int>)ViewState["StudentAnswers"];
            }
            set
            {
                ViewState["StudentAnswers"] = value;
            }
        }

        // ✅ Check if there is an ongoing quiz
        private bool HasActiveQuiz
        {
            get
            {
                return Session["CurrentAttemptID"] != null;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Authentication
                if (Session["UserID"] == null || Session["Role"] == null)
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                if (!Session["Role"].ToString().Trim().Equals("Student", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                LoadAvailableQuizzes();

                if (HasActiveQuiz)
                {
                    // Show ongoing quiz
                    ddlQuizList.Enabled = false;
                    btnStartQuiz.Enabled = false;
                    quizContainer.Visible = true;
                    DisplayCurrentQuestion();
                    ShowMessage("You must submit your current quiz before starting a new one.");
                }
                else
                {
                    quizContainer.Visible = false;
                }
            }
        }

        private void LoadAvailableQuizzes()
        {
            string query =
                "SELECT q.[QuizID], q.[Title], u.[Username] + ' ' + u.[LName] AS LecturerName " +
                "FROM [dbo].[Quizzes] q " +
                "INNER JOIN [dbo].[Users] u ON q.[LecturerID] = u.[Id] " +
                "WHERE q.[IsActive] = 1 " +
                "ORDER BY q.[CreatedDate] DESC";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                ddlQuizList.Items.Clear();
                ddlQuizList.Items.Add(new ListItem("-- Select a Quiz --", "0"));

                while (reader.Read())
                {
                    string quizId = reader["QuizID"].ToString();
                    string title = reader["Title"].ToString();
                    string lecturer = reader["LecturerName"].ToString();
                    ddlQuizList.Items.Add(new ListItem($"{title} (by {lecturer})", quizId));
                }
            }
        }

        protected void btnStartQuiz_Click(object sender, EventArgs e)
        {
            if (HasActiveQuiz)
            {
                ShowMessage("You must submit your current quiz before starting a new one.");
                return;
            }

            if (ddlQuizList.SelectedValue == "0")
            {
                ShowMessage("Please select a quiz to start.");
                return;
            }

            int quizID = Convert.ToInt32(ddlQuizList.SelectedValue);
            int studentID = Convert.ToInt32(Session["UserID"]);

            int attemptCount = GetAttemptCount(quizID, studentID);
            if (attemptCount >= 1)
            {
                ShowMessage("You have already attempted this quiz.");
                return;
            }

            int attemptID = CreateQuizAttempt(quizID, studentID);
            Session["CurrentAttemptID"] = attemptID;

            LoadQuizQuestions(quizID);
            CurrentQuestionIndex = 0;
            StudentAnswers = new Dictionary<int, int>();

            quizContainer.Visible = true;
            DisplayCurrentQuestion();

            ddlQuizList.Enabled = false;
            btnStartQuiz.Enabled = false;
        }

        private int GetAttemptCount(int quizID, int studentID)
        {
            string query = "SELECT COUNT(*) FROM [dbo].[QuizAttempts] WHERE [QuizID] = @QuizID AND [StudentID] = @StudentID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                cmd.Parameters.AddWithValue("@StudentID", studentID);

                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private int CreateQuizAttempt(int quizID, int studentID)
        {
            string query = @"
                INSERT INTO [dbo].[QuizAttempts] ([QuizID], [StudentID], [StartTime])
                VALUES (@QuizID, @StudentID, GETDATE());
                SELECT SCOPE_IDENTITY();";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                cmd.Parameters.AddWithValue("@StudentID", studentID);

                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private void LoadQuizQuestions(int quizID)
        {
            List<QuizQuestionData> questions = new List<QuizQuestionData>();
            string query = "SELECT QuestionID, QuestionText, Points FROM [dbo].[Questions] WHERE QuizID=@QuizID ORDER BY OrderNo, QuestionID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    QuizQuestionData q = new QuizQuestionData()
                    {
                        QuestionID = Convert.ToInt32(reader["QuestionID"]),
                        QuestionText = reader["QuestionText"].ToString(),
                        Points = Convert.ToInt32(reader["Points"]),
                        Choices = new List<ChoiceData>()
                    };
                    questions.Add(q);
                }
                reader.Close();

                foreach (QuizQuestionData q in questions)
                {
                    string choiceQuery = "SELECT ChoiceID, ChoiceText, IsCorrect FROM [dbo].[Choices] WHERE QuestionID=@QuestionID ORDER BY ChoiceID";
                    using (SqlCommand choiceCmd = new SqlCommand(choiceQuery, conn))
                    {
                        choiceCmd.Parameters.AddWithValue("@QuestionID", q.QuestionID);
                        SqlDataReader choiceReader = choiceCmd.ExecuteReader();
                        while (choiceReader.Read())
                        {
                            q.Choices.Add(new ChoiceData()
                            {
                                ChoiceID = Convert.ToInt32(choiceReader["ChoiceID"]),
                                ChoiceText = choiceReader["ChoiceText"].ToString(),
                                IsCorrect = Convert.ToBoolean(choiceReader["IsCorrect"])
                            });
                        }
                        choiceReader.Close();
                    }
                }
            }
            QuizQuestions = questions;
        }

        private void DisplayCurrentQuestion()
        {
            if (QuizQuestions.Count == 0)
            {
                ShowMessage("No questions found for this quiz.");
                return;
            }

            QuizQuestionData current = QuizQuestions[CurrentQuestionIndex];
            lblQuestionCount.Text = $"Question {CurrentQuestionIndex + 1} of {QuizQuestions.Count}";

            int progress = ((CurrentQuestionIndex + 1) * 100) / QuizQuestions.Count;
            progressBar.Style["width"] = progress + "%";

            lblQuestionText.Text = current.QuestionText;
            rblOptions.Items.Clear();
            foreach (var choice in current.Choices)
            {
                rblOptions.Items.Add(new ListItem(choice.ChoiceText, choice.ChoiceID.ToString()));
            }

            if (StudentAnswers.ContainsKey(current.QuestionID))
            {
                rblOptions.SelectedValue = StudentAnswers[current.QuestionID].ToString();
            }

            btnPrevious.Visible = CurrentQuestionIndex > 0;
            btnNext.Visible = CurrentQuestionIndex < QuizQuestions.Count - 1;
            btnSubmit.Visible = CurrentQuestionIndex == QuizQuestions.Count - 1;
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            SaveCurrentAnswer();
            if (CurrentQuestionIndex < QuizQuestions.Count - 1)
            {
                CurrentQuestionIndex++;
                DisplayCurrentQuestion();
            }
        }

        protected void btnPrevious_Click(object sender, EventArgs e)
        {
            SaveCurrentAnswer();
            if (CurrentQuestionIndex > 0)
            {
                CurrentQuestionIndex--;
                DisplayCurrentQuestion();
            }
        }

        private void SaveCurrentAnswer()
        {
            if (rblOptions.SelectedItem != null)
            {
                QuizQuestionData current = QuizQuestions[CurrentQuestionIndex];
                StudentAnswers[current.QuestionID] = Convert.ToInt32(rblOptions.SelectedValue);
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            SaveCurrentAnswer();

            try
            {
                int attemptID = Convert.ToInt32(Session["CurrentAttemptID"]);
                foreach (var ans in StudentAnswers)
                    SaveAnswerToDatabase(attemptID, ans.Key, ans.Value);

                decimal score = CalculateScore(attemptID);

                // Clear active quiz
                Session["CurrentAttemptID"] = null;

                Response.Redirect("QuizResults.aspx?attemptid=" + attemptID);
            }
            catch (Exception ex)
            {
                ShowMessage("Error submitting quiz: " + ex.Message);
            }
        }

        private void SaveAnswerToDatabase(int attemptID, int questionID, int choiceID)
        {
            bool isCorrect = false;
            string checkQuery = "SELECT IsCorrect FROM [dbo].[Choices] WHERE ChoiceID=@ChoiceID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(checkQuery, conn))
            {
                cmd.Parameters.AddWithValue("@ChoiceID", choiceID);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null) isCorrect = Convert.ToBoolean(result);
            }

            string insertQuery = "INSERT INTO [dbo].[QuizAnswers] (AttemptID, QuestionID, ChoiceID, IsCorrect) VALUES (@AttemptID,@QuestionID,@ChoiceID,@IsCorrect)";
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
            {
                cmd.Parameters.AddWithValue("@AttemptID", attemptID);
                cmd.Parameters.AddWithValue("@QuestionID", questionID);
                cmd.Parameters.AddWithValue("@ChoiceID", choiceID);
                cmd.Parameters.AddWithValue("@IsCorrect", isCorrect ? 1 : 0);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private decimal CalculateScore(int attemptID)
        {
            string query =
                @"DECLARE @TotalPoints INT, @EarnedPoints INT, @Score DECIMAL(5,2);
                SELECT @TotalPoints = SUM(q.Points)
                FROM Questions q
                INNER JOIN QuizAttempts qa ON q.QuizID = qa.QuizID
                WHERE qa.AttemptID = @AttemptID;
                SELECT @EarnedPoints = ISNULL(SUM(q.Points),0)
                FROM QuizAnswers ans
                INNER JOIN Questions q ON ans.QuestionID = q.QuestionID
                WHERE ans.AttemptID=@AttemptID AND ans.IsCorrect=1;
                IF @TotalPoints >0 SET @Score=(CAST(@EarnedPoints AS DECIMAL(5,2))/@TotalPoints)*100;
                ELSE SET @Score=0;
                UPDATE QuizAttempts SET EndTime=GETDATE(), Score=@Score, IsSubmitted=1 WHERE AttemptID=@AttemptID;
                SELECT @Score;";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@AttemptID", attemptID);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToDecimal(result) : 0;
            }
        }

        private void ShowMessage(string message)
        {
            string script = $"alert('{message.Replace("'", "\\'")}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowMessage", script, true);
        }

        [Serializable]
        public class QuizQuestionData
        {
            public int QuestionID { get; set; }
            public string QuestionText { get; set; }
            public int Points { get; set; }
            public List<ChoiceData> Choices { get; set; }
        }

        [Serializable]
        public class ChoiceData
        {
            public int ChoiceID { get; set; }
            public string ChoiceText { get; set; }
            public bool IsCorrect { get; set; }
        }
    }
}
