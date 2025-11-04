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

        // Store quiz data in ViewState
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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if student is logged in
                if (Session["UserID"] == null || Session["Role"] == null)
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                string userRole = Session["Role"].ToString().Trim();
                if (!userRole.Equals("Student", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                LoadAvailableQuizzes();
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
            {
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
                        string displayText = title + " (by " + lecturer + ")";

                        ddlQuizList.Items.Add(new ListItem(displayText, quizId));
                    }
                }
            }
        }

        protected void btnStartQuiz_Click(object sender, EventArgs e)
        {
            if (ddlQuizList.SelectedValue == "0")
            {
                ShowMessage("Please select a quiz to start.");
                return;
            }

            int quizID = Convert.ToInt32(ddlQuizList.SelectedValue);
            int studentID = Convert.ToInt32(Session["UserID"]);

            try
            {
                // 🔹 Check if student already has 3 attempts for this quiz
                int attemptCount = GetAttemptCount(quizID, studentID);
                if (attemptCount >= 3)
                {
                    ShowMessage("You have reached the maximum of 3 attempts for this quiz.");
                    return;
                }

                // 🔹 Create new attempt
                int attemptID = CreateQuizAttempt(quizID, studentID);
                Session["CurrentAttemptID"] = attemptID;

                // 🔹 Load quiz questions
                LoadQuizQuestions(quizID);

                // 🔹 Initialize session values
                CurrentQuestionIndex = 0;
                StudentAnswers = new Dictionary<int, int>();

                // 🔹 Show quiz
                quizContainer.Visible = true;
                DisplayCurrentQuestion();
            }
            catch (Exception ex)
            {
                ShowMessage("Error starting quiz: " + ex.Message);
            }
        }

        private int GetAttemptCount(int quizID, int studentID)
        {
            string query = "SELECT COUNT(*) FROM [dbo].[QuizAttempts] WHERE [QuizID] = @QuizID AND [StudentID] = @StudentID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizID", quizID);
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }


        private int CreateQuizAttempt(int quizID, int studentID)
        {
            string query = @"
        INSERT INTO [dbo].[QuizAttempts] ([QuizID], [StudentID], [StartTime])
        VALUES (@QuizID, @StudentID, GETDATE());
        SELECT SCOPE_IDENTITY();";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizID", quizID);
                    cmd.Parameters.AddWithValue("@StudentID", studentID);

                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }


        private void LoadQuizQuestions(int quizID)
        {
            List<QuizQuestionData> questions = new List<QuizQuestionData>();

            string query =
                "SELECT q.[QuestionID], q.[QuestionText], q.[Points] " +
                "FROM [dbo].[Questions] q " +
                "WHERE q.[QuizID] = @QuizID " +
                "ORDER BY q.[OrderNo], q.[QuestionID]";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizID", quizID);
                    conn.Open();

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        QuizQuestionData question = new QuizQuestionData();
                        question.QuestionID = Convert.ToInt32(reader["QuestionID"]);
                        question.QuestionText = reader["QuestionText"].ToString();
                        question.Points = Convert.ToInt32(reader["Points"]);
                        question.Choices = new List<ChoiceData>();

                        questions.Add(question);
                    }
                    reader.Close();

                    // Load choices for each question
                    foreach (QuizQuestionData question in questions)
                    {
                        string choiceQuery =
                            "SELECT [ChoiceID], [ChoiceText], [IsCorrect] " +
                            "FROM [dbo].[Choices] " +
                            "WHERE [QuestionID] = @QuestionID " +
                            "ORDER BY [ChoiceID]";

                        using (SqlCommand choiceCmd = new SqlCommand(choiceQuery, conn))
                        {
                            choiceCmd.Parameters.AddWithValue("@QuestionID", question.QuestionID);

                            SqlDataReader choiceReader = choiceCmd.ExecuteReader();
                            while (choiceReader.Read())
                            {
                                ChoiceData choice = new ChoiceData();
                                choice.ChoiceID = Convert.ToInt32(choiceReader["ChoiceID"]);
                                choice.ChoiceText = choiceReader["ChoiceText"].ToString();
                                choice.IsCorrect = Convert.ToBoolean(choiceReader["IsCorrect"]);

                                question.Choices.Add(choice);
                            }
                            choiceReader.Close();
                        }
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

            QuizQuestionData currentQuestion = QuizQuestions[CurrentQuestionIndex];

            // Update question counter
            lblQuestionCount.Text = "Question " + (CurrentQuestionIndex + 1).ToString() + " of " + QuizQuestions.Count.ToString();

            // Update progress bar
            int progressPercent = ((CurrentQuestionIndex + 1) * 100) / QuizQuestions.Count;
            progressBar.Style["width"] = progressPercent.ToString() + "%";

            // Display question text
            lblQuestionText.Text = currentQuestion.QuestionText;

            // Load choices
            rblOptions.Items.Clear();
            foreach (ChoiceData choice in currentQuestion.Choices)
            {
                ListItem item = new ListItem(choice.ChoiceText, choice.ChoiceID.ToString());
                rblOptions.Items.Add(item);
            }

            // Restore previously selected answer if exists
            if (StudentAnswers.ContainsKey(currentQuestion.QuestionID))
            {
                int selectedChoiceID = StudentAnswers[currentQuestion.QuestionID];
                ListItem selectedItem = rblOptions.Items.FindByValue(selectedChoiceID.ToString());
                if (selectedItem != null)
                {
                    selectedItem.Selected = true;
                }
            }

            // Show/hide navigation buttons
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
                QuizQuestionData currentQuestion = QuizQuestions[CurrentQuestionIndex];
                int selectedChoiceID = Convert.ToInt32(rblOptions.SelectedValue);

                // Store answer in dictionary
                StudentAnswers[currentQuestion.QuestionID] = selectedChoiceID;
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {

            SaveCurrentAnswer();

            try
            {
                int attemptID = Convert.ToInt32(Session["CurrentAttemptID"]);

                // Save all answers to database
                foreach (KeyValuePair<int, int> answer in StudentAnswers)
                {
                    SaveAnswerToDatabase(attemptID, answer.Key, answer.Value);
                }

                // Calculate score
                decimal score = CalculateScore(attemptID);

                // Redirect to results page
                Response.Redirect("QuizResults.aspx?attemptid=" + attemptID.ToString());
            }
            catch (Exception ex)
            {
                ShowMessage("Error submitting quiz: " + ex.Message);
            }
        }

        private void SaveAnswerToDatabase(int attemptID, int questionID, int choiceID)
        {
            // Check if choice is correct
            bool isCorrect = false;
            string checkQuery = "SELECT [IsCorrect] FROM [dbo].[Choices] WHERE [ChoiceID] = @ChoiceID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(checkQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@ChoiceID", choiceID);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        isCorrect = Convert.ToBoolean(result);
                    }
                }
            }

            // Insert answer
            string insertQuery =
                "INSERT INTO [dbo].[QuizAnswers] ([AttemptID], [QuestionID], [ChoiceID], [IsCorrect]) " +
                "VALUES (@AttemptID, @QuestionID, @ChoiceID, @IsCorrect)";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
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
        }

        private decimal CalculateScore(int attemptID)
        {
            string query =
                "DECLARE @TotalPoints INT, @EarnedPoints INT, @Score DECIMAL(5,2); " +
                "SELECT @TotalPoints = SUM(q.[Points]) " +
                "FROM [dbo].[Questions] q " +
                "INNER JOIN [dbo].[QuizAttempts] qa ON q.[QuizID] = qa.[QuizID] " +
                "WHERE qa.[AttemptID] = @AttemptID; " +
                "SELECT @EarnedPoints = ISNULL(SUM(q.[Points]), 0) " +
                "FROM [dbo].[QuizAnswers] ans " +
                "INNER JOIN [dbo].[Questions] q ON ans.[QuestionID] = q.[QuestionID] " +
                "WHERE ans.[AttemptID] = @AttemptID AND ans.[IsCorrect] = 1; " +
                "IF @TotalPoints > 0 " +
                "    SET @Score = (CAST(@EarnedPoints AS DECIMAL(5,2)) / @TotalPoints) * 100; " +
                "ELSE " +
                "    SET @Score = 0; " +
                "UPDATE [dbo].[QuizAttempts] " +
                "SET [EndTime] = GETDATE(), [Score] = @Score, [IsSubmitted] = 1 " +
                "WHERE [AttemptID] = @AttemptID; " +
                "SELECT @Score;";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AttemptID", attemptID);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToDecimal(result) : 0;
                }
            }
        }

        private void ShowMessage(string message)
        {
            string script = "alert('" + message.Replace("'", "\\'") + "');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowMessage", script, true);
        }

        // Helper classes
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