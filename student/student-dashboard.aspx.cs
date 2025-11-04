using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WebApplication.student
{
    public partial class student_dashboard : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Assume user is logged in and stored in session
                if (Session["UserID"] == null)
                {
                    Response.Redirect("../login.aspx");
                    return;
                }

                int studentId = Convert.ToInt32(Session["UserID"]);

                LoadStudentInfo(studentId);
                LoadDashboardStats(studentId);
                LoadRecentMaterials();
            }
        }

        private void LoadStudentInfo(int studentId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Username FROM Users WHERE Id = @Id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", studentId);
                conn.Open();

                object name = cmd.ExecuteScalar();
                lblStudentName.Text = name != null ? name.ToString() : "Student";
            }
        }

        private void LoadDashboardStats(int studentId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Count completed quizzes
                string quizCountQuery = "SELECT COUNT(*) FROM QuizAttempts WHERE StudentID = @ID AND IsSubmitted = 1";
                SqlCommand cmdQuiz = new SqlCommand(quizCountQuery, conn);
                cmdQuiz.Parameters.AddWithValue("@ID", studentId);
                int completedQuizzes = Convert.ToInt32(cmdQuiz.ExecuteScalar());

                // Count materials (optional: total or personal later)
                string materialsCountQuery = "SELECT COUNT(*) FROM Materials WHERE IsActive = 1";
                SqlCommand cmdMaterials = new SqlCommand(materialsCountQuery, conn);
                int materialsViewed = Convert.ToInt32(cmdMaterials.ExecuteScalar());

                // Count notes (if exists)
                int notesCreated = 0;
                try
                {
                    string notesCountQuery = "SELECT COUNT(*) FROM Notes WHERE UserID = @ID";
                    SqlCommand cmdNotes = new SqlCommand(notesCountQuery, conn);
                    cmdNotes.Parameters.AddWithValue("@ID", studentId);
                    notesCreated = Convert.ToInt32(cmdNotes.ExecuteScalar());
                }
                catch { /* if table doesn't exist yet, ignore */ }

                lblCompletedQuizzes.Text = completedQuizzes.ToString();
                lblMaterialsViewed.Text = materialsViewed.ToString();
                lblNotesCreated.Text = notesCreated.ToString();
            }
        }

        private void LoadRecentMaterials()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT TOP 5 Title FROM Materials WHERE IsActive = 1 ORDER BY UploadDate DESC";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvRecentMaterials.DataSource = dt;
                gvRecentMaterials.DataBind();
            }
        }
    }
}
