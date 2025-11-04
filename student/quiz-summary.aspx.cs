using System;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebApplication.student
{
    public partial class quiz_summary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    int studentID = Convert.ToInt32(Session["UserID"]);
                    LoadQuizResults(studentID);
                }
                else
                {
                    Response.Redirect("~/login.aspx");
                }
            }
        }

        private void LoadQuizResults(int studentID)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT q.Title, qa.Score, qa.EndTime AS AttemptDate
                    FROM QuizAttempts qa
                    INNER JOIN Quizzes q ON qa.QuizID = q.QuizID
                    WHERE qa.StudentID = @StudentID AND qa.IsSubmitted = 1
                    ORDER BY qa.EndTime DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StudentID", studentID);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Add display and color logic
                dt.Columns.Add("DisplayScore", typeof(string));
                dt.Columns.Add("ScoreClass", typeof(string));

                foreach (DataRow row in dt.Rows)
                {
                    decimal score = row["Score"] != DBNull.Value ? Convert.ToDecimal(row["Score"]) : 0;
                    row["DisplayScore"] = $"{score}%";
                    row["ScoreClass"] = score >= 80 ? "high" :
                                        score >= 50 ? "medium" : "low";
                }

                gvQuizResults.DataSource = dt;
                gvQuizResults.DataBind();
            }
        }

        protected void gvQuizResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvQuizResults.PageIndex = e.NewPageIndex;
            int studentID = Convert.ToInt32(Session["UserID"]);
            LoadQuizResults(studentID);
        }
    }
}
