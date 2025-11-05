using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication.admin
{
    public partial class manage_enrollments : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

      
        protected void Page_Load(object sender, EventArgs e)
        {
            // ✅ Admin session check
            if (Session["UserID"] == null || Session["Role"] == null ||
                !Session["Role"].ToString().Trim().Equals("Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("../index.aspx"); // redirect to login page
                return;
            }

            if (!IsPostBack)
            {
                LoadCourses();
                LoadStudents();
                BindEnrollments();
            }
        }

        // Load all courses into dropdown
        private void LoadCourses()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT CourseId, CourseName FROM Courses ORDER BY CourseName";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlCourse.DataSource = dt;
                ddlCourse.DataTextField = "CourseName";
                ddlCourse.DataValueField = "CourseId";
                ddlCourse.DataBind();
                ddlCourse.Items.Insert(0, new ListItem("Select Course", "0"));
            }
        }

        // Load all students into dropdown
        private void LoadStudents()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Id, Username + ' ' + LName AS StudentName FROM Users WHERE Role='Student' ORDER BY Username";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlStudent.DataSource = dt;
                ddlStudent.DataTextField = "StudentName";
                ddlStudent.DataValueField = "Id";
                ddlStudent.DataBind();
                ddlStudent.Items.Insert(0, new ListItem("Select Student", "0"));
            }
        }

        // Enroll a student
        protected void btnEnroll_Click(object sender, EventArgs e)
        {
            if (ddlCourse.SelectedValue == "0" || ddlStudent.SelectedValue == "0")
            {
                string script = "alert('Please select both a course and a student.');";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "ValidationAlert", script, true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Check if enrollment already exists
                string checkQuery = "SELECT COUNT(*) FROM Enrollments WHERE CourseId=@course AND StudentId=@student";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@course", ddlCourse.SelectedValue);
                checkCmd.Parameters.AddWithValue("@student", ddlStudent.SelectedValue);

                conn.Open();
                int count = (int)checkCmd.ExecuteScalar();

                if (count > 0)
                {
                    // Enrollment already exists - show alert
                    string script = "alert('⚠️ This student is already enrolled in this course!');";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "DuplicateAlert", script, true);
                    return;
                }

                string insert = @"
                    INSERT INTO Enrollments (CourseId, StudentId)
                    VALUES (@course, @student)";
                SqlCommand cmd = new SqlCommand(insert, conn);
                cmd.Parameters.AddWithValue("@course", ddlCourse.SelectedValue);
                cmd.Parameters.AddWithValue("@student", ddlStudent.SelectedValue);
                cmd.ExecuteNonQuery();

                // Success message
                string successScript = "alert('✓ Student enrolled successfully!');";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "SuccessAlert", successScript, true);
            }

            ddlCourse.SelectedIndex = 0;
            ddlStudent.SelectedIndex = 0;
            BindEnrollments();
        }

        // Bind enrollments to GridView
        private void BindEnrollments(string searchTerm = "")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT e.EnrollmentId, e.CourseId, e.StudentId,
                           c.CourseName, 
                           u.Username + ' ' + u.LName AS StudentName, 
                           e.EnrollDate
                    FROM Enrollments e
                    JOIN Courses c ON e.CourseId = c.CourseId
                    JOIN Users u ON e.StudentId = u.Id";

                if (!string.IsNullOrEmpty(searchTerm))
                    query += " WHERE c.CourseName LIKE @search OR u.Username LIKE @search OR u.LName LIKE @search";

                query += " ORDER BY e.EnrollDate DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmd.Parameters.AddWithValue("@search", "%" + searchTerm + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvEnrollments.DataSource = dt;
                gvEnrollments.DataBind();
            }
        }

        // Search
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindEnrollments(txtSearch.Text.Trim());
        }

        // Clear search
        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            BindEnrollments();
        }

        // Paging
        protected void gvEnrollments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvEnrollments.PageIndex = e.NewPageIndex;
            BindEnrollments(txtSearch.Text.Trim());
        }

        // Edit enrollment
        protected void gvEnrollments_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvEnrollments.EditIndex = e.NewEditIndex;
            BindEnrollments(txtSearch.Text.Trim());
        }

        // Cancel edit
        protected void gvEnrollments_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvEnrollments.EditIndex = -1;
            BindEnrollments(txtSearch.Text.Trim());
        }

        // Update enrollment
        protected void gvEnrollments_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int enrollmentId = Convert.ToInt32(gvEnrollments.DataKeys[e.RowIndex]["EnrollmentId"]);

            DropDownList ddlEditCourse = (DropDownList)gvEnrollments.Rows[e.RowIndex].FindControl("ddlEditCourse");
            DropDownList ddlEditStudent = (DropDownList)gvEnrollments.Rows[e.RowIndex].FindControl("ddlEditStudent");

            if (ddlEditCourse != null && ddlEditStudent != null)
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Check if this combination already exists (excluding current enrollment)
                    string checkQuery = @"
                        SELECT COUNT(*) FROM Enrollments 
                        WHERE CourseId=@course AND StudentId=@student AND EnrollmentId!=@id";
                    SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                    checkCmd.Parameters.AddWithValue("@course", ddlEditCourse.SelectedValue);
                    checkCmd.Parameters.AddWithValue("@student", ddlEditStudent.SelectedValue);
                    checkCmd.Parameters.AddWithValue("@id", enrollmentId);

                    int count = (int)checkCmd.ExecuteScalar();

                    if (count > 0)
                    {
                        // Duplicate enrollment exists - cancel edit and show message
                        gvEnrollments.EditIndex = -1;
                        BindEnrollments(txtSearch.Text.Trim());
                        // You can add a label to show error: "This student is already enrolled in this course"
                        return;
                    }

                    string update = @"
                        UPDATE Enrollments 
                        SET CourseId = @course, StudentId = @student 
                        WHERE EnrollmentId = @id";

                    SqlCommand cmd = new SqlCommand(update, conn);
                    cmd.Parameters.AddWithValue("@course", ddlEditCourse.SelectedValue);
                    cmd.Parameters.AddWithValue("@student", ddlEditStudent.SelectedValue);
                    cmd.Parameters.AddWithValue("@id", enrollmentId);

                    cmd.ExecuteNonQuery();
                }
            }

            gvEnrollments.EditIndex = -1;
            BindEnrollments(txtSearch.Text.Trim());
        }

        // Delete enrollment using DataKey
        protected void gvEnrollments_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int enrollmentId = Convert.ToInt32(gvEnrollments.DataKeys[e.RowIndex]["EnrollmentId"]);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string delete = "DELETE FROM Enrollments WHERE EnrollmentId=@id";
                SqlCommand cmd = new SqlCommand(delete, conn);
                cmd.Parameters.AddWithValue("@id", enrollmentId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            BindEnrollments(txtSearch.Text.Trim());
        }

        // Bind courses for edit dropdown
        protected void gvEnrollments_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState & DataControlRowState.Edit) > 0)
            {
                DropDownList ddlEditCourse = (DropDownList)e.Row.FindControl("ddlEditCourse");
                DropDownList ddlEditStudent = (DropDownList)e.Row.FindControl("ddlEditStudent");

                if (ddlEditCourse != null)
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "SELECT CourseId, CourseName FROM Courses ORDER BY CourseName";
                        SqlDataAdapter da = new SqlDataAdapter(query, conn);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        ddlEditCourse.DataSource = dt;
                        ddlEditCourse.DataTextField = "CourseName";
                        ddlEditCourse.DataValueField = "CourseId";
                        ddlEditCourse.DataBind();

                        // Set selected value
                        int courseId = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "CourseId"));
                        ddlEditCourse.SelectedValue = courseId.ToString();
                    }
                }

                if (ddlEditStudent != null)
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "SELECT Id, Username + ' ' + LName AS StudentName FROM Users WHERE Role='Student' ORDER BY Username";
                        SqlDataAdapter da = new SqlDataAdapter(query, conn);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        ddlEditStudent.DataSource = dt;
                        ddlEditStudent.DataTextField = "StudentName";
                        ddlEditStudent.DataValueField = "Id";
                        ddlEditStudent.DataBind();

                        // Set selected value
                        int studentId = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "StudentId"));
                        ddlEditStudent.SelectedValue = studentId.ToString();
                    }
                }
            }
        }

        // Optional: Sorting
        protected void gvEnrollments_Sorting(object sender, GridViewSortEventArgs e)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT e.EnrollmentId, e.CourseId, e.StudentId,
                           c.CourseName, 
                           u.Username + ' ' + u.LName AS StudentName, 
                           e.EnrollDate
                    FROM Enrollments e
                    JOIN Courses c ON e.CourseId = c.CourseId
                    JOIN Users u ON e.StudentId = u.Id";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                da.Fill(dt);
            }

            if (dt.Rows.Count > 0)
            {
                DataView dv = dt.DefaultView;
                dv.Sort = e.SortExpression + " ASC";
                gvEnrollments.DataSource = dv;
                gvEnrollments.DataBind();
            }
        }
    }
}