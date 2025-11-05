using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace WebApplication.lecturer
{
    public partial class my_courses : Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || Session["Role"] == null)
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                string role = Session["Role"].ToString().Trim();
                if (!role.Equals("Lecturer", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                LoadMyCourses();
            }
        }

        private void LoadMyCourses()
        {
            int lecturerId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT CourseId, CourseName, Description 
                                 FROM Courses
                                 WHERE LecturerId = @LecturerId";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptCourses.DataSource = dt;
                    rptCourses.DataBind();
                    lblNoCourses.Visible = false;
                }
                else
                {
                    rptCourses.Visible = false;
                    lblNoCourses.Visible = true;
                }
            }
        }
    }
}
