using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebApplication.lecturer
{
    public partial class view_grades : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Ensure lecturer is logged in
                if (Session["UserID"] == null || Session["Role"] == null ||
                    !Session["Role"].ToString().Equals("Lecturer", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                LoadQuizList();
            }
        }

        private void LoadQuizList()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT QuizID, Title FROM Quizzes WHERE LecturerID = @LecturerID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@LecturerID", Session["UserID"]);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                ddlQuizzes.Items.Clear();
                ddlQuizzes.Items.Add(new ListItem("-- Select a Quiz --", "0"));
                while (reader.Read())
                {
                    ddlQuizzes.Items.Add(new ListItem(reader["Title"].ToString(), reader["QuizID"].ToString()));
                }
                reader.Close();
            }
        }

        protected void btnView_Click(object sender, EventArgs e)
        {
            int quizId;
            if (int.TryParse(ddlQuizzes.SelectedValue, out quizId) && quizId > 0)
            {
                LoadGrades(quizId);
            }
            else
            {
                lblMessage.Text = "Please select a quiz.";
            }
        }

        private void LoadGrades(int quizId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        qa.AttemptID,
                        u.Username AS FirstName,
                        u.LName AS LastName,
                        qa.Score,
                        qa.StartTime,
                        qa.EndTime
                    FROM QuizAttempts qa
                    INNER JOIN Users u ON qa.StudentID = u.Id
                    WHERE qa.QuizID = @QuizID
                    ORDER BY qa.EndTime DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvGrades.DataSource = dt;
                gvGrades.DataBind();

                lblMessage.Text = dt.Rows.Count > 0
                    ? $"Showing {dt.Rows.Count} results."
                    : "No grades found for this quiz.";
            }
        }
    }
}
