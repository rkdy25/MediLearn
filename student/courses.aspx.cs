using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebApplication.student
{
    public partial class courses : System.Web.UI.Page
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
                        lblStudentName.Text = $"{reader["Username"]} {reader["LName"]}";
                    }
                }
            }
            catch
            {
                lblStudentName.Text = "Future Doctor";
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
                            ISNULL(c.Description, 'No description available') as Description,
                            u.Username as LecturerName,
                            e.EnrollDate,
                            ISNULL((SELECT COUNT(*) FROM Materials m WHERE m.CourseId = c.CourseId), 0) as TotalMaterials,
                            ISNULL((SELECT COUNT(*) FROM Quizzes q WHERE q.CourseId = c.CourseId), 0) as TotalQuizzes
                        FROM Courses c
                        INNER JOIN Enrollments e ON c.CourseId = e.CourseId
                        INNER JOIN Users u ON c.LecturerId = u.Id
                        WHERE e.StudentId = @StudentId
                        ORDER BY e.EnrollDate DESC";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptCourses.DataSource = dt;
                        rptCourses.DataBind();
                        pnlNoCourses.Visible = false;
                        UpdateDashboardStats(dt);
                    }
                    else
                    {
                        pnlNoCourses.Visible = true;
                        ResetDashboardStats();
                    }

                    // Bind quizzes inside each course repeater item
                    rptCourses.ItemDataBound += RptCourses_ItemDataBound;
                }
            }
            catch
            {
                pnlNoCourses.Visible = true;
                ResetDashboardStats();
            }
        }

        private void RptCourses_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int courseId = Convert.ToInt32(drv["CourseId"]);

                Repeater rptQuizzes = (Repeater)e.Item.FindControl("rptQuizzes");

                DataTable quizData = GetQuizzesForCourse(courseId);
                rptQuizzes.DataSource = quizData;
                rptQuizzes.DataBind();
            }
        }

        private DataTable GetQuizzesForCourse(int courseId)
        {
            DataTable dt = new DataTable();
            string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT QuizID, QuizTitle
                    FROM Quizzes
                    WHERE CourseId = @CourseId
                    ORDER BY CreatedAt DESC";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            return dt;
        }

        private void UpdateDashboardStats(DataTable dt)
        {
            lblEnrolledCourses.Text = dt.Rows.Count.ToString();
            lblCompletedCourses.Text = "0";
            lblAvgProgress.Text = "0%";
        }

        private void ResetDashboardStats()
        {
            lblEnrolledCourses.Text = "0";
            lblCompletedCourses.Text = "0";
            lblAvgProgress.Text = "0%";
        }
    }
}
