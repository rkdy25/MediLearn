using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebApplication.admin
{
    public partial class manage_courses : System.Web.UI.Page
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
                LoadLecturers();
                BindCourses();
            }
        }

        

        private void LoadLecturers()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Id, Username + ' ' + LName AS FullName FROM Users WHERE Role='Lecturer' ORDER BY Username";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlLecturer.DataSource = dt;
                ddlLecturer.DataTextField = "FullName";
                ddlLecturer.DataValueField = "Id";
                ddlLecturer.DataBind();
                ddlLecturer.Items.Insert(0, new ListItem("Select Lecturer", "0"));
            }
        }

        protected void btnAddCourse_Click(object sender, EventArgs e)
        {
            if (txtCourseName.Text.Trim() == "" || ddlLecturer.SelectedValue == "0")
            {
                string script = "alert('Please fill in the course name and select a lecturer.');";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "ValidationAlert", script, true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Check if course name already exists
                string checkQuery = "SELECT COUNT(*) FROM Courses WHERE CourseName=@name";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@name", txtCourseName.Text.Trim());
                int count = (int)checkCmd.ExecuteScalar();

                if (count > 0)
                {
                    string script = "alert('⚠️ A course with this name already exists!');";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "DuplicateAlert", script, true);
                    return;
                }

                string insert = "INSERT INTO Courses (CourseName, LecturerId, Description) VALUES (@name, @lecturer, @desc)";
                SqlCommand cmd = new SqlCommand(insert, conn);
                cmd.Parameters.AddWithValue("@name", txtCourseName.Text.Trim());
                cmd.Parameters.AddWithValue("@lecturer", ddlLecturer.SelectedValue);
                cmd.Parameters.AddWithValue("@desc", txtDescription.Text.Trim());
                cmd.ExecuteNonQuery();

                string successScript = "alert('✓ Course added successfully!');";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "SuccessAlert", successScript, true);
            }

            txtCourseName.Text = "";
            ddlLecturer.SelectedIndex = 0;
            txtDescription.Text = "";
            BindCourses();
        }

        private void BindCourses(string searchTerm = "")
        {
            string query = @"SELECT c.CourseID, c.CourseName, c.LecturerId, u.Username + ' ' + u.LName AS LecturerName, c.Description
                             FROM Courses c
                             JOIN Users u ON c.LecturerId = u.Id";
            if (!string.IsNullOrEmpty(searchTerm))
                query += " WHERE c.CourseName LIKE @search";

            query += " ORDER BY c.CourseID DESC";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmd.Parameters.AddWithValue("@search", "%" + searchTerm + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvCourses.DataSource = dt;
                gvCourses.DataBind();
            }
        }

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteCourse")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Check if course has enrollments
                    string checkQuery = "SELECT COUNT(*) FROM Enrollments WHERE CourseId=@id";
                    SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                    checkCmd.Parameters.AddWithValue("@id", courseId);
                    int enrollmentCount = (int)checkCmd.ExecuteScalar();

                    if (enrollmentCount > 0)
                    {
                        string script = "alert('⚠️ Cannot delete this course! It has " + enrollmentCount + " student(s) enrolled.');";
                        System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "DeleteErrorAlert", script, true);
                        return;
                    }

                    SqlCommand cmd = new SqlCommand("DELETE FROM Courses WHERE CourseID=@id", conn);
                    cmd.Parameters.AddWithValue("@id", courseId);
                    cmd.ExecuteNonQuery();

                    string successScript = "alert('✓ Course deleted successfully!');";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "DeleteSuccessAlert", successScript, true);
                }
                BindCourses(txtSearch.Text.Trim());
            }
        }

        protected void gvCourses_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvCourses.EditIndex = e.NewEditIndex;
            BindCourses(txtSearch.Text.Trim());

            GridViewRow row = gvCourses.Rows[e.NewEditIndex];
            DropDownList ddlEditLecturer = (DropDownList)row.FindControl("ddlEditLecturer");
            if (ddlEditLecturer != null)
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter(
                        "SELECT Id, Username + ' ' + LName AS FullName FROM Users WHERE Role='Lecturer' ORDER BY Username",
                        conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlEditLecturer.DataSource = dt;
                    ddlEditLecturer.DataTextField = "FullName";
                    ddlEditLecturer.DataValueField = "Id";
                    ddlEditLecturer.DataBind();

                    ddlEditLecturer.SelectedValue = gvCourses.DataKeys[e.NewEditIndex]["LecturerId"].ToString();
                }
            }
        }

        protected void gvCourses_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvCourses.EditIndex = -1;
            BindCourses(txtSearch.Text.Trim());
        }

        protected void gvCourses_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = gvCourses.Rows[e.RowIndex];
            int courseId = Convert.ToInt32(gvCourses.DataKeys[e.RowIndex]["CourseID"]);

            string courseName = ((TextBox)row.FindControl("txtEditCourseName")).Text.Trim();
            string description = ((TextBox)row.FindControl("txtEditDescription")).Text.Trim();
            int lecturerId = Convert.ToInt32(((DropDownList)row.FindControl("ddlEditLecturer")).SelectedValue);

            if (string.IsNullOrEmpty(courseName))
            {
                string script = "alert('⚠️ Course name cannot be empty!');";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "EmptyNameAlert", script, true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Check if course name already exists (excluding current course)
                string checkQuery = "SELECT COUNT(*) FROM Courses WHERE CourseName=@name AND CourseID!=@id";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@name", courseName);
                checkCmd.Parameters.AddWithValue("@id", courseId);
                int count = (int)checkCmd.ExecuteScalar();

                if (count > 0)
                {
                    gvCourses.EditIndex = -1;
                    BindCourses(txtSearch.Text.Trim());
                    string script = "alert('⚠️ A course with this name already exists!');";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "DuplicateEditAlert", script, true);
                    return;
                }

                SqlCommand cmd = new SqlCommand(
                    "UPDATE Courses SET CourseName=@name, LecturerId=@lecturer, Description=@desc WHERE CourseID=@id",
                    conn);
                cmd.Parameters.AddWithValue("@name", courseName);
                cmd.Parameters.AddWithValue("@lecturer", lecturerId);
                cmd.Parameters.AddWithValue("@desc", description);
                cmd.Parameters.AddWithValue("@id", courseId);
                cmd.ExecuteNonQuery();

                string successScript = "alert('✓ Course updated successfully!');";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "UpdateSuccessAlert", successScript, true);
            }

            gvCourses.EditIndex = -1;
            BindCourses(txtSearch.Text.Trim());
        }

        protected void gvCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCourses.PageIndex = e.NewPageIndex;
            BindCourses(txtSearch.Text.Trim());
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindCourses(txtSearch.Text.Trim());
        }

        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            BindCourses();
        }

        // Sorting
        private string GridSortDirection
        {
            get { return ViewState["SortDirection"] as string ?? "ASC"; }
            set { ViewState["SortDirection"] = value; }
        }

        private string GridSortExpression
        {
            get { return ViewState["SortExpression"] as string ?? "CourseID"; }
            set { ViewState["SortExpression"] = value; }
        }

        protected void gvCourses_Sorting(object sender, GridViewSortEventArgs e)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT c.CourseID, c.CourseName, c.LecturerId, u.Username + ' ' + u.LName AS LecturerName, c.Description FROM Courses c JOIN Users u ON c.LecturerId = u.Id",
                    conn);
                da.Fill(dt);
            }

            string sortDirection = GridSortDirection == "ASC" ? "DESC" : "ASC";
            dt.DefaultView.Sort = e.SortExpression + " " + sortDirection;
            gvCourses.DataSource = dt;
            gvCourses.DataBind();

            GridSortExpression = e.SortExpression;
            GridSortDirection = sortDirection;
        }
    }
}