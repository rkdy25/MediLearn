using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebApplication.student
{
    public partial class materials : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadMaterials();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadMaterials(txtSearch.Text.Trim());
        }

        private void LoadMaterials(string search = "")
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT MaterialID, Title, Category, FileType, UploadedBy, FilePath, UploadDate
                                 FROM Materials
                                 WHERE IsActive = 1 AND (Title LIKE @search OR Category LIKE @search OR UploadedBy LIKE @search)
                                 ORDER BY UploadDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@search", "%" + search + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Fix file paths (convert ~/ to proper URL)
                foreach (DataRow row in dt.Rows)
                {
                    string path = row["FilePath"].ToString();
                    if (path.StartsWith("~"))
                        row["FilePath"] = ResolveUrl(path);
                }

                gvMaterials.DataSource = dt;
                gvMaterials.DataBind();
            }
        }

        // Handle View/Download buttons
        protected void gvMaterials_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int materialId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ViewMaterial" || e.CommandName == "DownloadMaterial")
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT FilePath FROM Materials WHERE MaterialID = @MaterialID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@MaterialID", materialId);

                    con.Open();
                    string filePath = cmd.ExecuteScalar()?.ToString();
                    if (!string.IsNullOrEmpty(filePath))
                    {
                        string fullPath = Server.MapPath(filePath);
                        string fileName = System.IO.Path.GetFileName(fullPath);

                        if (System.IO.File.Exists(fullPath))
                        {
                            if (e.CommandName == "ViewMaterial")
                            {
                                // open in browser
                                Response.Redirect(ResolveUrl(filePath));
                            }
                            else if (e.CommandName == "DownloadMaterial")
                            {
                                // force download
                                Response.Clear();
                                Response.ContentType = "application/octet-stream";
                                Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileName);
                                Response.TransmitFile(fullPath);
                                Response.End();
                            }
                        }
                        else
                        {
                            Response.Write("<script>alert('File not found on server.');</script>");
                        }
                    }
                }
            }
        }

        protected void gvMaterials_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMaterials.PageIndex = e.NewPageIndex;
            LoadMaterials(txtSearch.Text.Trim());
        }
    }
}
