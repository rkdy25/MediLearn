using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Collections.Generic;

namespace WebApplication.lecturer
{
    public partial class view_quiz : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["quizid"] != null)
                {
                    int quizID = Convert.ToInt32(Request.QueryString["quizid"]);
                    LoadQuizQuestions(quizID);
                }
            }
        }

        private void LoadQuizQuestions(int quizID)
        {
            // Table to hold questions + options
            DataTable dt = new DataTable();
            dt.Columns.Add("QuestionText");
            dt.Columns.Add("OptionA");
            dt.Columns.Add("OptionB");
            dt.Columns.Add("OptionC");
            dt.Columns.Add("OptionD");
            dt.Columns.Add("CorrectAnswer");

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 1. Load all questions for this quiz
                string queryQuestions = "SELECT QuestionID, QuestionText FROM Questions WHERE QuizID = @QuizID ORDER BY OrderNo";
                SqlDataAdapter daQ = new SqlDataAdapter(queryQuestions, conn);
                daQ.SelectCommand.Parameters.AddWithValue("@QuizID", quizID);
                DataTable questions = new DataTable();
                daQ.Fill(questions);

                // 2. Load all choices for these questions
                string queryChoices = "SELECT QuestionID, ChoiceText, IsCorrect FROM Choices WHERE QuestionID IN (SELECT QuestionID FROM Questions WHERE QuizID = @QuizID) ORDER BY ChoiceID";
                SqlDataAdapter daC = new SqlDataAdapter(queryChoices, conn);
                daC.SelectCommand.Parameters.AddWithValue("@QuizID", quizID);
                DataTable choices = new DataTable();
                daC.Fill(choices);

                // 3. Combine questions with choices
                foreach (DataRow q in questions.Rows)
                {
                    int qID = Convert.ToInt32(q["QuestionID"]);
                    string questionText = q["QuestionText"].ToString();

                    DataRow[] choiceRows = choices.Select("QuestionID = " + qID);
                    string optionA = choiceRows.Length > 0 ? choiceRows[0]["ChoiceText"].ToString() : "";
                    string optionB = choiceRows.Length > 1 ? choiceRows[1]["ChoiceText"].ToString() : "";
                    string optionC = choiceRows.Length > 2 ? choiceRows[2]["ChoiceText"].ToString() : "";
                    string optionD = choiceRows.Length > 3 ? choiceRows[3]["ChoiceText"].ToString() : "";
                    string correctAnswer = "";

                    foreach (DataRow c in choiceRows)
                    {
                        if (Convert.ToBoolean(c["IsCorrect"]))
                        {
                            correctAnswer = c["ChoiceText"].ToString();
                            break;
                        }
                    }

                    dt.Rows.Add(questionText, optionA, optionB, optionC, optionD, correctAnswer);
                }
            }

            gvQuestions.DataSource = dt;
            gvQuestions.DataBind();
        }
    }
}
