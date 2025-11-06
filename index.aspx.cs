using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebApplication
{
    public partial class index : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAvailableCourses();

                string q = Request.QueryString["q"];
                if (!string.IsNullOrEmpty(q))
                {
                    SearchCourses(q);
                }
            }
        }

        // Load all available courses with enrollment count
        private void LoadAvailableCourses()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT TOP 3
                            c.CourseId,
                            c.CourseName,
                            ISNULL(c.Description, 'Explore this comprehensive medical course') AS Description,
                            u.Username + ' ' + ISNULL(u.LName, '') AS LecturerName,
                            COUNT(e.EnrollmentId) AS EnrolledCount
                        FROM Courses c
                        INNER JOIN Users u ON c.LecturerId = u.Id
                        LEFT JOIN Enrollments e ON c.CourseId = e.CourseId
                        GROUP BY c.CourseId, c.CourseName, c.Description, u.Username, u.LName
                        ORDER BY EnrolledCount DESC, c.CourseName";

                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptCourses.DataSource = dt;
                    rptCourses.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadAvailableCourses Error: " + ex.Message);
            }
        }

        // Search courses by keyword (searches in course name, description, and lecturer name)
        private void SearchCourses(string keyword)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            c.CourseId,
                            c.CourseName,
                            ISNULL(c.Description, 'Explore this comprehensive medical course') AS Description,
                            u.Username + ' ' + ISNULL(u.LName, '') AS LecturerName,
                            COUNT(e.EnrollmentId) AS EnrolledCount
                        FROM Courses c
                        INNER JOIN Users u ON c.LecturerId = u.Id
                        LEFT JOIN Enrollments e ON c.CourseId = e.CourseId
                        WHERE c.CourseName LIKE @keyword 
                           OR c.Description LIKE @keyword 
                           OR u.Username LIKE @keyword 
                           OR u.LName LIKE @keyword
                        GROUP BY c.CourseId, c.CourseName, c.Description, u.Username, u.LName
                        ORDER BY EnrolledCount DESC, c.CourseName";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@keyword", "%" + keyword + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptSearchResults.DataSource = dt;
                        rptSearchResults.DataBind();
                        pnlSearchResults.Visible = true;
                        pnlNoResults.Visible = false;
                    }
                    else
                    {
                        pnlSearchResults.Visible = false;
                        pnlNoResults.Visible = true;
                    }

                    searchResults.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("SearchCourses Error: " + ex.Message);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();

            if (!string.IsNullOrEmpty(searchTerm))
            {
                SearchCourses(searchTerm);
            }
            else
            {
                // If search is empty, hide results and reload courses
                searchResults.Visible = false;
                LoadAvailableCourses();
            }
        }

        protected void rptSearchResults_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Handle any item commands if needed
        }
    }
}