using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;

namespace WebApplication.lecturer
{
    public partial class create_quiz : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        // Store questions temporarily in session
        private List<QuizQuestion> QuestionList
        {
            get
            {
                if (Session["TempQuestions"] == null)
                    Session["TempQuestions"] = new List<QuizQuestion>();
                return (List<QuizQuestion>)Session["TempQuestions"];
            }
            set
            {
                Session["TempQuestions"] = value;
            }
        }

            protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["UserID"] == null || Session["Role"] == null)
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                // Get role and trim any whitespace (handles NCHAR padding)
                string userRole = Session["Role"].ToString().Trim();

                // Case-insensitive role check
                if (!userRole.Equals("Lecturer", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                LoadExistingQuizzes();
            }
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate inputs - .NET 3.5 COMPATIBLE
                if (string.IsNullOrEmpty(txtQuizTitle.Text) || txtQuizTitle.Text.Trim().Length == 0)
                {
                    ShowMessage("Please enter a quiz title.", "error");
                    return;
                }

                if (string.IsNullOrEmpty(txtQuizQuestion.Text) || txtQuizQuestion.Text.Trim().Length == 0)
                {
                    ShowMessage("Please enter a question.", "error");
                    return;
                }

                if (string.IsNullOrEmpty(txtOptionA.Text) || txtOptionA.Text.Trim().Length == 0 ||
                    string.IsNullOrEmpty(txtOptionB.Text) || txtOptionB.Text.Trim().Length == 0 ||
                    string.IsNullOrEmpty(txtOptionC.Text) || txtOptionC.Text.Trim().Length == 0 ||
                    string.IsNullOrEmpty(txtOptionD.Text) || txtOptionD.Text.Trim().Length == 0)
                {
                    ShowMessage("Please fill in all options.", "error");
                    return;
                }

                if (string.IsNullOrEmpty(ddlCorrectAnswer.SelectedValue))
                {
                    ShowMessage("Please select the correct answer.", "error");
                    return;
                }

                // Create question object - .NET 3.5 style
                QuizQuestion question = new QuizQuestion();
                question.QuestionText = txtQuizQuestion.Text.Trim();
                question.Options = new Dictionary<string, string>();
                question.Options.Add("A", txtOptionA.Text.Trim());
                question.Options.Add("B", txtOptionB.Text.Trim());
                question.Options.Add("C", txtOptionC.Text.Trim());
                question.Options.Add("D", txtOptionD.Text.Trim());
                question.CorrectAnswer = ddlCorrectAnswer.SelectedValue;

                // Add to temporary list
                QuestionList.Add(question);

                // Save to database
                SaveQuizToDatabase(txtQuizTitle.Text.Trim());

                // Clear form
                ClearQuestionForm();

                // Refresh quiz list
                LoadExistingQuizzes();

                ShowMessage("Question added successfully! Total questions: " + QuestionList.Count.ToString(), "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error adding question: " + ex.Message, "error");
            }
        }

        private void SaveQuizToDatabase(string quizTitle)
        {
            int lecturerID = Convert.ToInt32(Session["UserID"]);
            int quizID = 0;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // Check if quiz already exists in session
                    if (Session["CurrentQuizID"] == null)
                    {
                        // Create new quiz
                        string insertQuizQuery =
                            "INSERT INTO [dbo].[Quizzes] ([Title], [Description], [LecturerID], [IsActive]) " +
                            "VALUES (@Title, @Description, @LecturerID, 1); " +
                            "SELECT SCOPE_IDENTITY();";

                        using (SqlCommand cmd = new SqlCommand(insertQuizQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Title", quizTitle);
                            cmd.Parameters.AddWithValue("@Description", "Quiz created on " + DateTime.Now.ToString("yyyy-MM-dd"));
                            cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                            quizID = Convert.ToInt32(cmd.ExecuteScalar());
                            Session["CurrentQuizID"] = quizID;
                        }
                    }
                    else
                    {
                        quizID = Convert.ToInt32(Session["CurrentQuizID"]);

                        // Update quiz title if changed
                        string updateQuizQuery = "UPDATE [dbo].[Quizzes] SET [Title] = @Title WHERE [QuizID] = @QuizID";
                        using (SqlCommand cmd = new SqlCommand(updateQuizQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Title", quizTitle);
                            cmd.Parameters.AddWithValue("@QuizID", quizID);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    // Insert the latest question
                    if (QuestionList.Count > 0)
                    {
                        QuizQuestion lastQuestion = QuestionList[QuestionList.Count - 1];

                        string insertQuestionQuery =
                            "INSERT INTO [dbo].[Questions] ([QuizID], [QuestionText], [QuestionType], [Points], [OrderNo]) " +
                            "VALUES (@QuizID, @QuestionText, 'MCQ', 1, @OrderNo); " +
                            "SELECT SCOPE_IDENTITY();";

                        int questionID;
                        using (SqlCommand cmd = new SqlCommand(insertQuestionQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@QuizID", quizID);
                            cmd.Parameters.AddWithValue("@QuestionText", lastQuestion.QuestionText);
                            cmd.Parameters.AddWithValue("@OrderNo", QuestionList.Count);

                            questionID = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        // Insert choices
                        string insertChoiceQuery =
                            "INSERT INTO [dbo].[Choices] ([QuestionID], [ChoiceText], [IsCorrect]) " +
                            "VALUES (@QuestionID, @ChoiceText, @IsCorrect);";

                        foreach (KeyValuePair<string, string> option in lastQuestion.Options)
                        {
                            using (SqlCommand cmd = new SqlCommand(insertChoiceQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@QuestionID", questionID);
                                cmd.Parameters.AddWithValue("@ChoiceText", option.Value);
                                cmd.Parameters.AddWithValue("@IsCorrect", option.Key == lastQuestion.CorrectAnswer ? 1 : 0);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }

                    transaction.Commit();
                }
                catch (Exception)
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }

        private void LoadExistingQuizzes()
        {
            int lecturerID = Convert.ToInt32(Session["UserID"]);

            string query =
                "SELECT " +
                "    q.[QuizID], " +
                "    q.[Title], " +
                "    q.[CreatedDate] AS DateCreated, " +
                "    COUNT(qs.[QuestionID]) AS QuestionCount " +
                "FROM [dbo].[Quizzes] q " +
                "LEFT JOIN [dbo].[Questions] qs ON q.[QuizID] = qs.[QuizID] " +
                "WHERE q.[LecturerID] = @LecturerID " +
                "GROUP BY q.[QuizID], q.[Title], q.[CreatedDate] " +
                "ORDER BY q.[CreatedDate] DESC";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    gvQuizzes.DataSource = dt;
                    gvQuizzes.DataBind();
                }
            }
        }

        protected void gvQuizzes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int quizID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ViewQuiz")
            {
                // Redirect to a new page to view quiz questions
                Response.Redirect("view-quiz.aspx?quizid=" + quizID.ToString());
            }
            else if (e.CommandName == "DeleteQuiz")
            {
                DeleteQuiz(quizID);
                LoadExistingQuizzes();
            }
        }


        private void DeleteQuiz(int quizID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string deleteQuery = "DELETE FROM [dbo].[Quizzes] WHERE [QuizID] = @QuizID";
                    using (SqlCommand cmd = new SqlCommand(deleteQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizID", quizID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowMessage("Quiz deleted successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting quiz: " + ex.Message, "error");
            }
        }

        protected void btnFinishQuiz_Click(object sender, EventArgs e)
        {
            try
            {
                // Clear session data
                Session["CurrentQuizID"] = null;
                Session["TempQuestions"] = null;

                // Clear form
                txtQuizTitle.Text = string.Empty;
                ClearQuestionForm();

                // Refresh list
                LoadExistingQuizzes();

                ShowMessage("Quiz completed successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error finishing quiz: " + ex.Message, "error");
            }
        }

        private void ClearQuestionForm()
        {
            txtQuizQuestion.Text = string.Empty;
            txtOptionA.Text = string.Empty;
            txtOptionB.Text = string.Empty;
            txtOptionC.Text = string.Empty;
            txtOptionD.Text = string.Empty;
            ddlCorrectAnswer.SelectedIndex = 0;
        }

        private void ShowMessage(string message, string type)
        {
            string script = "alert('" + message.Replace("'", "\\'") + "');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowMessage", script, true);
        }

        // Helper class for temporary question storage
        [Serializable]
        public class QuizQuestion
        {
            public string QuestionText { get; set; }
            public Dictionary<string, string> Options { get; set; }
            public string CorrectAnswer { get; set; }
        }

        protected void gvQuizzes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvQuizzes.PageIndex = e.NewPageIndex;
            LoadExistingQuizzes();
        }
    }




}