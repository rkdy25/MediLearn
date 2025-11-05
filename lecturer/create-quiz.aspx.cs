using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication.lecturer
{
    public partial class create_quiz : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;
        private static int TempQuizId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("../login.aspx");
                return;
            }

            if (Request.QueryString["courseId"] == null)
            {
                Response.Redirect("my-courses.aspx");
                return;
            }

            ViewState["CourseId"] = Convert.ToInt32(Request.QueryString["courseId"]);

            if (!IsPostBack)
            {
                LoadQuizzes();
            }
        }

        private void LoadQuizzes()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT q.QuizID, q.Title, q.CreatedDate, q.IsActive,
                           COUNT(que.QuestionID) AS QuestionCount
                    FROM Quizzes q
                    LEFT JOIN Questions que ON q.QuizID = que.QuizID
                    WHERE q.LecturerID = @LecturerID AND q.CourseId = @CourseId
                    GROUP BY q.QuizID, q.Title, q.CreatedDate, q.IsActive
                    ORDER BY q.CreatedDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@LecturerID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@CourseId", ViewState["CourseId"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvQuizzes.DataSource = dt;
                gvQuizzes.DataBind();
            }
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            string title = txtQuizTitle.Text.Trim();
            string question = txtQuizQuestion.Text.Trim();
            string optionA = txtOptionA.Text.Trim();
            string optionB = txtOptionB.Text.Trim();
            string optionC = txtOptionC.Text.Trim();
            string optionD = txtOptionD.Text.Trim();
            string correct = ddlCorrectAnswer.SelectedValue;

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(question))
            {
                ShowAlert("Please fill in all required fields (title and question).");
                return;
            }

            if (string.IsNullOrEmpty(optionA) || string.IsNullOrEmpty(optionB))
            {
                ShowAlert("At least 2 options (A and B) are required.");
                return;
            }

            if (string.IsNullOrEmpty(correct))
            {
                ShowAlert("Please select the correct answer.");
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                if (TempQuizId == 0)
                {
                    string checkTitle = "SELECT COUNT(*) FROM Quizzes WHERE Title = @Title AND LecturerID = @LecturerID";
                    SqlCommand cmdCheck = new SqlCommand(checkTitle, con);
                    cmdCheck.Parameters.AddWithValue("@Title", title);
                    cmdCheck.Parameters.AddWithValue("@LecturerID", Session["UserID"]);
                    int exists = Convert.ToInt32(cmdCheck.ExecuteScalar());

                    if (exists > 0)
                    {
                        ShowAlert("A quiz with this title already exists.");
                        return;
                    }

                    string createQuiz = @"INSERT INTO Quizzes (Title, Description, LecturerID, IsActive, CreatedDate, CourseId)
                                          OUTPUT INSERTED.QuizID
                                          VALUES (@Title, '', @LecturerID, 0, GETDATE(), @CourseId)";

                    SqlCommand cmdQuiz = new SqlCommand(createQuiz, con);
                    cmdQuiz.Parameters.AddWithValue("@Title", title);
                    cmdQuiz.Parameters.AddWithValue("@LecturerID", Session["UserID"]);
                    cmdQuiz.Parameters.AddWithValue("@CourseId", ViewState["CourseId"]);
                    TempQuizId = Convert.ToInt32(cmdQuiz.ExecuteScalar());

                    txtQuizTitle.Enabled = false;
                }

                string insertQuestion = @"INSERT INTO Questions (QuizID, QuestionText, QuestionType, Points)
                                          OUTPUT INSERTED.QuestionID
                                          VALUES (@QuizID, @QuestionText, 'MCQ', 1)";
                SqlCommand cmdQ = new SqlCommand(insertQuestion, con);
                cmdQ.Parameters.AddWithValue("@QuizID", TempQuizId);
                cmdQ.Parameters.AddWithValue("@QuestionText", question);
                int questionId = Convert.ToInt32(cmdQ.ExecuteScalar());

                InsertChoice(con, questionId, optionA, correct == "A");
                InsertChoice(con, questionId, optionB, correct == "B");
                if (!string.IsNullOrEmpty(optionC))
                    InsertChoice(con, questionId, optionC, correct == "C");
                if (!string.IsNullOrEmpty(optionD))
                    InsertChoice(con, questionId, optionD, correct == "D");

                ShowAlert("Question added successfully! Quiz title is now locked.");
                ClearQuestionFields();
                LoadQuizzes();
            }
        }

        private void InsertChoice(SqlConnection con, int questionId, string text, bool isCorrect)
        {
            string insertChoice = "INSERT INTO Choices (QuestionID, ChoiceText, IsCorrect) VALUES (@QuestionID, @Text, @IsCorrect)";
            SqlCommand cmd = new SqlCommand(insertChoice, con);
            cmd.Parameters.AddWithValue("@QuestionID", questionId);
            cmd.Parameters.AddWithValue("@Text", text);
            cmd.Parameters.AddWithValue("@IsCorrect", isCorrect);
            cmd.ExecuteNonQuery();
        }

        protected void btnFinishQuiz_Click(object sender, EventArgs e)
        {
            TempQuizId = 0;
            txtQuizTitle.Text = "";
            txtQuizTitle.Enabled = true;
            txtQuizQuestion.Text = "";
            txtOptionA.Text = "";
            txtOptionB.Text = "";
            txtOptionC.Text = "";
            txtOptionD.Text = "";
            ddlCorrectAnswer.SelectedIndex = 0;

            ShowAlert("Quiz creation completed!");
            LoadQuizzes();
        }

        protected void gvQuizzes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvQuizzes.PageIndex = e.NewPageIndex;
            LoadQuizzes();
        }

        protected void gvQuizzes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int quizId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteQuiz")
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("DELETE FROM Quizzes WHERE QuizID = @QuizID", con);
                    cmd.Parameters.AddWithValue("@QuizID", quizId);
                    cmd.ExecuteNonQuery();
                }
                ShowAlert("Quiz deleted successfully.");
                LoadQuizzes();
            }
            else if (e.CommandName == "ToggleAvailability")
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("UPDATE Quizzes SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END WHERE QuizID=@QuizID", con);
                    cmd.Parameters.AddWithValue("@QuizID", quizId);
                    cmd.ExecuteNonQuery();
                }
                LoadQuizzes();
            }
            else if (e.CommandName == "EditQuiz")
            {
                Response.Redirect($"edit-quiz.aspx?quizId={quizId}");
            }
        }

        private void ShowAlert(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('{message}');", true);
        }

        private void ClearQuestionFields()
        {
            txtQuizQuestion.Text = "";
            txtOptionA.Text = "";
            txtOptionB.Text = "";
            txtOptionC.Text = "";
            txtOptionD.Text = "";
            ddlCorrectAnswer.SelectedIndex = 0;
        }
    }
}
