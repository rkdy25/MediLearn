using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebApplication.admin
{
    public partial class dashboard : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOverviewCards();
                LoadUsers();
                LoadMaterials();
      
            }
        }

        #region Overview Cards
        private void LoadOverviewCards()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                lblTotalStudents.Text = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role='Student'", conn).ExecuteScalar().ToString();
                lblTotalLecturers.Text = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role='Lecturer'", conn).ExecuteScalar().ToString();
                lblTotalMaterials.Text = new SqlCommand("SELECT COUNT(*) FROM Materials WHERE IsActive=1", conn).ExecuteScalar().ToString();
                lblTotalQuizzes.Text = new SqlCommand("SELECT COUNT(*) FROM Quizzes WHERE IsActive=1", conn).ExecuteScalar().ToString();

                conn.Close();
            }
        }
        #endregion

        #region Users
        private void LoadUsers()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT Id AS UserID, Username + ' ' + LName AS Name, Role, Email, 'Active' AS Status FROM Users";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "EditUser":
                    Response.Redirect($"manage-users.aspx?Id={userId}");
                    break;
                case "DeleteUser":
                    DeleteUser(userId);
                    LoadUsers();
                    LoadOverviewCards();
                    break;
            }
        }

        private void DeleteUser(int id)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Users WHERE Id=@ID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }

        protected void btnGoToRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("register.aspx");
        }
        #endregion

        #region Materials
        private void LoadMaterials()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT MaterialID, Title, UploadedBy AS Lecturer, FileType AS Type, FORMAT(UploadDate,'yyyy-MM-dd') AS UploadDate
                                 FROM Materials WHERE IsActive=1";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvMaterials.DataSource = dt;
                gvMaterials.DataBind();
            }
        }

        protected void gvMaterials_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int materialId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "ViewMaterial":
                    Response.Redirect($"manage-materials.aspx?Id={materialId}");
                    break;
                case "DeleteMaterial":
                    DeleteMaterial(materialId);
                    LoadMaterials();
                    LoadOverviewCards();
                    break;
            }
        }

        private void DeleteMaterial(int id)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Materials WHERE MaterialID=@ID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }
        #endregion

        private void LoadUsers(int pageIndex = 0)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT *
            FROM
            (
                SELECT ROW_NUMBER() OVER (ORDER BY Id) AS RowNum,
                       Id AS UserID,
                       Username + ' ' + LName AS Name,
                       Role,
                       Email,
                       'Active' AS Status
                FROM Users
            ) AS T
            WHERE RowNum BETWEEN @StartRow AND @EndRow
            ORDER BY RowNum";

                int startRow = pageIndex * 5 + 1;
                int endRow = startRow + 4;

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StartRow", startRow);
                cmd.Parameters.AddWithValue("@EndRow", endRow);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
        }

        protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUsers.PageIndex = e.NewPageIndex;
            LoadUsers(e.NewPageIndex);
        }

        private void LoadMaterials(int pageIndex = 0)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT *
            FROM
            (
                SELECT ROW_NUMBER() OVER (ORDER BY MaterialID) AS RowNum,
                       MaterialID,
                       Title,
                       UploadedBy AS Lecturer,
                       FileType AS Type,
                       FORMAT(UploadDate,'yyyy-MM-dd') AS UploadDate
                FROM Materials
                WHERE IsActive=1
            ) AS T
            WHERE RowNum BETWEEN @StartRow AND @EndRow
            ORDER BY RowNum";

                int startRow = pageIndex * 5 + 1;
                int endRow = startRow + 4;

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StartRow", startRow);
                cmd.Parameters.AddWithValue("@EndRow", endRow);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvMaterials.DataSource = dt;
                gvMaterials.DataBind();
            }
        }

        protected void gvMaterials_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMaterials.PageIndex = e.NewPageIndex;
            LoadMaterials(e.NewPageIndex);
        }


    }
}
