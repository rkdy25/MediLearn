using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebApplication.student
{
    public partial class student_dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "student")
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                LoadStudentData();
                LoadEnrolledCourses();
                LoadLatestMaterials();
                UpdateDashboardStats();
            }
        }

        private void LoadStudentData()
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserID"]);
                string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT Username, LName FROM Users WHERE Id = @StudentId";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@StudentId", studentId);

                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        string firstName = reader["Username"].ToString();
                        string lastName = reader["LName"].ToString();
                        lblStudentName.Text = $"{firstName} {lastName}";
                    }
                    reader.Close();
                }
            }
            catch
            {
                lblStudentName.Text = "Student";
            }
        }

        private void LoadEnrolledCourses()
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserID"]);
                string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            c.CourseId,
                            c.CourseName,
                            c.Description,
                            u.Username as LecturerName,
                            e.EnrollDate,
                            ISNULL((SELECT COUNT(*) FROM Materials m WHERE m.CourseId = c.CourseId AND m.IsActive = 1), 0) as TotalMaterials,
                            ISNULL((SELECT COUNT(*) FROM Quizzes q WHERE q.CourseId = c.CourseId), 0) as TotalQuizzes,
                            ISNULL((SELECT COUNT(DISTINCT q.QuizID) 
                             FROM QuizAttempts qa 
                             INNER JOIN Quizzes q ON qa.QuizID = q.QuizID 
                             WHERE qa.StudentID = @StudentId AND q.CourseId = c.CourseId), 0) as CompletedQuizzes
                        FROM Courses c
                        INNER JOIN Enrollments e ON c.CourseId = e.CourseId
                        INNER JOIN Users u ON c.LecturerId = u.Id
                        WHERE e.StudentId = @StudentId
                        ORDER BY e.EnrollDate DESC";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@StudentId", studentId);

                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptCourses.DataSource = dt;
                    rptCourses.DataBind();
                    lblNoCourses.Visible = dt.Rows.Count == 0;
                }
            }
            catch
            {
                lblNoCourses.Visible = true;
            }
        }

        private void LoadLatestMaterials()
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserID"]);
                string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT TOP 5
                            m.Title,
                            m.FileType,
                            m.UploadDate,
                            c.CourseName
                        FROM Materials m
                        INNER JOIN Courses c ON m.CourseId = c.CourseId
                        INNER JOIN Enrollments e ON e.CourseId = c.CourseId
                        WHERE e.StudentId = @StudentId AND m.IsActive = 1
                        ORDER BY m.UploadDate DESC";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@StudentId", studentId);

                    con.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptLatestMaterials.DataSource = dt;
                    rptLatestMaterials.DataBind();
                    lblNoMaterials.Visible = dt.Rows.Count == 0;
                }
            }
            catch
            {
                lblNoMaterials.Visible = true;
            }
        }

        private void UpdateDashboardStats()
        {
            try
            {
                int studentId = Convert.ToInt32(Session["UserID"]);
                string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query1 = "SELECT COUNT(*) FROM Enrollments WHERE StudentId = @StudentId";
                    string query2 = @"
                        SELECT COUNT(*) FROM (
                            SELECT c.CourseId
                            FROM Courses c
                            INNER JOIN Enrollments e ON c.CourseId = e.CourseId
                            WHERE e.StudentId = @StudentId
                            AND (SELECT COUNT(*) FROM Quizzes q WHERE q.CourseId = c.CourseId) > 0
                            AND (SELECT COUNT(*) FROM Quizzes q WHERE q.CourseId = c.CourseId) = 
                                (SELECT COUNT(DISTINCT q.QuizID) 
                                 FROM QuizAttempts qa 
                                 INNER JOIN Quizzes q ON qa.QuizID = q.QuizID 
                                 WHERE qa.StudentID = @StudentId AND q.CourseId = c.CourseId)
                        ) as CompletedCourses";
                    string query3 = @"
                        SELECT COUNT(*) 
                        FROM Materials m
                        INNER JOIN Courses c ON m.CourseId = c.CourseId
                        INNER JOIN Enrollments e ON e.CourseId = c.CourseId
                        WHERE e.StudentId = @StudentId AND m.IsActive = 1";

                    SqlCommand cmd1 = new SqlCommand(query1, con);
                    SqlCommand cmd2 = new SqlCommand(query2, con);
                    SqlCommand cmd3 = new SqlCommand(query3, con);
                    cmd1.Parameters.AddWithValue("@StudentId", studentId);
                    cmd2.Parameters.AddWithValue("@StudentId", studentId);
                    cmd3.Parameters.AddWithValue("@StudentId", studentId);

                    con.Open();
                    lblEnrolledCourses.Text = cmd1.ExecuteScalar().ToString();
                    lblCompletedCourses.Text = cmd2.ExecuteScalar().ToString();
                    lblMaterialsAvailable.Text = cmd3.ExecuteScalar().ToString();
                }
            }
            catch
            {
                lblEnrolledCourses.Text = "0";
                lblCompletedCourses.Text = "0";
                lblMaterialsAvailable.Text = "0";
            }
        }

        public string GetFileTypeIcon(string fileType)
        {
            switch (fileType.ToLower())
            {
                case "pdf": return "file-pdf";
                case "doc":
                case "docx": return "file-word";
                case "ppt":
                case "pptx": return "file-powerpoint";
                case "mp4":
                case "avi":
                case "mov": return "video";
                case "jpg":
                case "png":
                case "gif": return "file-image";
                default: return "file";
            }
        }
    }
}
