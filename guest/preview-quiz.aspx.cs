using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace WebApplication.guest
{
    public partial class preview_quiz : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadLatestQuiz();
        }

        private void LoadLatestQuiz()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Get latest quiz ID
                string quizQuery = @"SELECT TOP 1 QuizID FROM Quizzes WHERE IsActive = 1 ORDER BY CreatedDate DESC";
                SqlCommand quizCmd = new SqlCommand(quizQuery, conn);
                object quizIdObj = quizCmd.ExecuteScalar();

                if (quizIdObj != null)
                {
                    int quizId = Convert.ToInt32(quizIdObj);

                    // Get first few questions
                    string questionQuery = @"SELECT TOP 2 QuestionID, QuestionText FROM Questions WHERE QuizID = @QuizID ORDER BY OrderNo ASC";
                    SqlCommand qCmd = new SqlCommand(questionQuery, conn);
                    qCmd.Parameters.AddWithValue("@QuizID", quizId);

                    SqlDataAdapter da = new SqlDataAdapter(qCmd);
                    DataTable dtQuestions = new DataTable();
                    da.Fill(dtQuestions);

                    // Add HTML for choices
                    dtQuestions.Columns.Add("ChoicesHtml", typeof(string));

                    foreach (DataRow row in dtQuestions.Rows)
                    {
                        int questionId = Convert.ToInt32(row["QuestionID"]);

                        string choiceQuery = "SELECT ChoiceText, IsCorrect FROM Choices WHERE QuestionID = @QID";
                        SqlCommand cCmd = new SqlCommand(choiceQuery, conn);
                        cCmd.Parameters.AddWithValue("@QID", questionId);

                        SqlDataReader reader = cCmd.ExecuteReader();
                        StringBuilder html = new StringBuilder();
                        while (reader.Read())
                        {
                            string text = reader["ChoiceText"].ToString();
                            bool isCorrect = Convert.ToBoolean(reader["IsCorrect"]);
                            html.Append($"<li><button class='option' data-correct='{isCorrect.ToString().ToLower()}'>{text}</button></li>");
                        }
                        reader.Close();

                        row["ChoicesHtml"] = html.ToString();
                    }

                    rptQuestions.DataSource = dtQuestions;
                    rptQuestions.DataBind();
                }

                conn.Close();
            }
        }
    }
}
