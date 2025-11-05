using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication.lecturer
{
    public partial class edit_quiz : Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("../index.aspx");
                return;
            }

            if (Request.QueryString["QuizID"] == null)
            {
                Response.Redirect("create-quiz.aspx");
                return;
            }

            if (!IsPostBack)
            {
                ViewState["QuizID"] = Convert.ToInt32(Request.QueryString["QuizID"]);
                ViewState["EditQuestionID"] = null;
                LoadQuiz();
                LoadQuestions();
            }
        }

        private void LoadQuiz()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT Title FROM Quizzes WHERE QuizID=@QuizID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@QuizID", ViewState["QuizID"]);
                con.Open();
                txtQuizTitle.Text = cmd.ExecuteScalar()?.ToString() ?? "";
            }
        }

        private void LoadQuestions()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT q.QuestionID, q.QuestionText, COUNT(c.ChoiceID) AS ChoiceCount
                                 FROM Questions q
                                 LEFT JOIN Choices c ON q.QuestionID = c.QuestionID
                                 WHERE q.QuizID = @QuizID
                                 GROUP BY q.QuestionID, q.QuestionText";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@QuizID", ViewState["QuizID"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvQuestions.DataSource = dt;
                gvQuestions.DataBind();
            }
        }

        protected void btnUpdateQuiz_Click(object sender, EventArgs e)
        {
            string newTitle = txtQuizTitle.Text.Trim();
            if (newTitle == "")
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Title cannot be empty.');", true);
                return;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "UPDATE Quizzes SET Title=@Title WHERE QuizID=@QuizID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Title", newTitle);
                cmd.Parameters.AddWithValue("@QuizID", ViewState["QuizID"]);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Quiz title updated.');", true);
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            string qText = txtQuestion.Text.Trim();
            string[] opts = { txtOptionA.Text.Trim(), txtOptionB.Text.Trim(), txtOptionC.Text.Trim(), txtOptionD.Text.Trim() };
            string correct = ddlCorrectAnswer.SelectedValue;

            if (qText == "" || string.IsNullOrEmpty(correct) || string.IsNullOrEmpty(opts[0]) || string.IsNullOrEmpty(opts[1]))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please fill question, at least 2 options, and correct answer.');", true);
                return;
            }

            if (ViewState["EditQuestionID"] == null)
            {
                // ADD NEW QUESTION
                int questionId;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string qQuery = "INSERT INTO Questions (QuizID, QuestionText) OUTPUT INSERTED.QuestionID VALUES (@QuizID, @Text)";
                    SqlCommand cmd = new SqlCommand(qQuery, con);
                    cmd.Parameters.AddWithValue("@QuizID", ViewState["QuizID"]);
                    cmd.Parameters.AddWithValue("@Text", qText);
                    questionId = (int)cmd.ExecuteScalar();

                    for (int i = 0; i < 4; i++)
                    {
                        if (string.IsNullOrEmpty(opts[i])) continue;
                        bool isCorrect = (correct == "A" && i == 0) || (correct == "B" && i == 1) ||
                                         (correct == "C" && i == 2) || (correct == "D" && i == 3);

                        string cQuery = "INSERT INTO Choices (QuestionID, ChoiceText, IsCorrect) VALUES (@QID, @Text, @Correct)";
                        SqlCommand cCmd = new SqlCommand(cQuery, con);
                        cCmd.Parameters.AddWithValue("@QID", questionId);
                        cCmd.Parameters.AddWithValue("@Text", opts[i]);
                        cCmd.Parameters.AddWithValue("@Correct", isCorrect);
                        cCmd.ExecuteNonQuery();
                    }
                }

                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Question added successfully.');", true);
            }
            else
            {
                // UPDATE EXISTING QUESTION
                int questionId = Convert.ToInt32(ViewState["EditQuestionID"]);
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string qUpdate = "UPDATE Questions SET QuestionText=@Text WHERE QuestionID=@ID";
                    SqlCommand cmd = new SqlCommand(qUpdate, con);
                    cmd.Parameters.AddWithValue("@Text", qText);
                    cmd.Parameters.AddWithValue("@ID", questionId);
                    cmd.ExecuteNonQuery();

                    // Delete old choices
                    string del = "DELETE FROM Choices WHERE QuestionID=@QID";
                    SqlCommand delCmd = new SqlCommand(del, con);
                    delCmd.Parameters.AddWithValue("@QID", questionId);
                    delCmd.ExecuteNonQuery();

                    // Reinsert updated choices
                    for (int i = 0; i < 4; i++)
                    {
                        if (string.IsNullOrEmpty(opts[i])) continue;
                        bool isCorrect = (correct == "A" && i == 0) || (correct == "B" && i == 1) ||
                                         (correct == "C" && i == 2) || (correct == "D" && i == 3);

                        string cQuery = "INSERT INTO Choices (QuestionID, ChoiceText, IsCorrect) VALUES (@QID, @Text, @Correct)";
                        SqlCommand cCmd = new SqlCommand(cQuery, con);
                        cCmd.Parameters.AddWithValue("@QID", questionId);
                        cCmd.Parameters.AddWithValue("@Text", opts[i]);
                        cCmd.Parameters.AddWithValue("@Correct", isCorrect);
                        cCmd.ExecuteNonQuery();
                    }
                }

                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Question updated successfully.');", true);
                ViewState["EditQuestionID"] = null;
                btnAddQuestion.Text = "Add Question";
            }

            ClearQuestionFields();
            LoadQuestions();
        }

        protected void gvQuestions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int questionId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteQ")
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "DELETE FROM Questions WHERE QuestionID=@ID";
                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@ID", questionId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadQuestions();
            }
            else if (e.CommandName == "EditQ")
            {
                LoadQuestionForEdit(questionId);
            }
        }

        private void LoadQuestionForEdit(int questionId)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string q = "SELECT QuestionText FROM Questions WHERE QuestionID=@ID";
                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@ID", questionId);
                con.Open();
                txtQuestion.Text = cmd.ExecuteScalar()?.ToString() ?? "";

                // load choices
                string c = "SELECT ChoiceText, IsCorrect FROM Choices WHERE QuestionID=@QID ORDER BY ChoiceID";
                SqlCommand cCmd = new SqlCommand(c, con);
                cCmd.Parameters.AddWithValue("@QID", questionId);
                SqlDataAdapter da = new SqlDataAdapter(cCmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                txtOptionA.Text = txtOptionB.Text = txtOptionC.Text = txtOptionD.Text = "";
                ddlCorrectAnswer.SelectedIndex = 0;

                for (int i = 0; i < dt.Rows.Count && i < 4; i++)
                {
                    string text = dt.Rows[i]["ChoiceText"].ToString();
                    bool correct = Convert.ToBoolean(dt.Rows[i]["IsCorrect"]);
                    if (i == 0) txtOptionA.Text = text;
                    else if (i == 1) txtOptionB.Text = text;
                    else if (i == 2) txtOptionC.Text = text;
                    else if (i == 3) txtOptionD.Text = text;

                    if (correct)
                    {
                        ddlCorrectAnswer.SelectedValue = i == 0 ? "A" : i == 1 ? "B" : i == 2 ? "C" : "D";
                    }
                }

                ViewState["EditQuestionID"] = questionId;
                btnAddQuestion.Text = "Update Question";
            }
        }

        private void ClearQuestionFields()
        {
            txtQuestion.Text = txtOptionA.Text = txtOptionB.Text = txtOptionC.Text = txtOptionD.Text = "";
            ddlCorrectAnswer.SelectedIndex = 0;
        }
    }
}
