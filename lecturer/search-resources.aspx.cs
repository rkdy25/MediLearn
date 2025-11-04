using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

namespace WebApplication.lecturer
{
    public partial class search_resources : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadResources(); // Load all on first view
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadResources();
        }

        private void LoadResources()
        {
            string search = txtSearch.Text.Trim();
            string type = ddlType.SelectedValue;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT MaterialID, Title, FileType AS Type, UploadedBy AS Lecturer, UploadDate
                    FROM Materials
                    WHERE IsActive = 1";

                // Filter logic
                if (!string.IsNullOrEmpty(search))
                    query += " AND (Title LIKE @search OR Category LIKE @search)";

                if (!string.IsNullOrEmpty(type))
                    query += " AND FileType = @type";

                query += " ORDER BY UploadDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);

                if (!string.IsNullOrEmpty(search))
                    cmd.Parameters.AddWithValue("@search", "%" + search + "%");

                if (!string.IsNullOrEmpty(type))
                    cmd.Parameters.AddWithValue("@type", type);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvResources.DataSource = dt;
                gvResources.DataBind();
            }
        }

        protected void gvResources_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "View")
            {
                ViewFile(id);
            }
            else if (e.CommandName == "Download")
            {
                DownloadFile(id);
            }
        }

        private void ViewFile(int materialId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT FilePath FROM Materials WHERE MaterialID = @id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", materialId);

                con.Open();
                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    string filePath = result.ToString();
                    string physicalPath = Server.MapPath(filePath);
                    string ext = Path.GetExtension(physicalPath).ToLower();

                    if (File.Exists(physicalPath))
                    {
                        // Inline view for PDF or video
                        if (ext == ".pdf" || ext == ".mp4")
                        {
                            Response.ContentType = ext == ".pdf" ? "application/pdf" : "video/mp4";
                            Response.WriteFile(physicalPath);
                            Response.End();
                        }
                        else
                        {
                            Response.Redirect(filePath); // For others, just redirect
                        }
                    }
                }
            }
        }

        private void DownloadFile(int materialId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT FilePath, Title FROM Materials WHERE MaterialID = @id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", materialId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    string filePath = reader["FilePath"].ToString();
                    string title = reader["Title"].ToString();

                    string fullPath = Server.MapPath(filePath);
                    if (File.Exists(fullPath))
                    {
                        Response.Clear();
                        Response.ContentType = "application/octet-stream";
                        Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(fullPath));
                        Response.WriteFile(fullPath);
                        Response.End();
                    }
                }
            }
        }
    }
}
