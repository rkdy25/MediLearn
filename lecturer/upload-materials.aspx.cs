using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication.lecturer
{
    public partial class upload_materials : System.Web.UI.Page
    {

        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMaterials();
            }
        }


        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile && ddlCategory.SelectedValue != "")
            {
                string title = txtTitle.Text.Trim();
                string category = ddlCategory.SelectedValue;
                string fileName = Path.GetFileName(fileUpload.FileName);
                string extension = Path.GetExtension(fileName);
                string fileType = extension.Replace(".", "").ToUpper();

                // Lecturer email/name from session
                string uploadedBy = Session["UserName"] != null ? Session["UserName"].ToString() : "Unknown";



                // Save to uploads/materials
                string folderPath = Server.MapPath("~/uploads/materials/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                // Ensure unique file name
                string uniqueFileName = $"{Guid.NewGuid()}_{fileName}";
                string filePath = Path.Combine(folderPath, uniqueFileName);
                fileUpload.SaveAs(filePath);

                // Save DB record
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO Materials 
                                    (Title, Category, FilePath, FileType, UploadedBy, IsActive)
                                     VALUES (@Title, @Category, @FilePath, @FileType, @UploadedBy, 1)";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@FilePath", "~/uploads/materials/" + uniqueFileName);
                    cmd.Parameters.AddWithValue("@FileType", fileType);
                    cmd.Parameters.AddWithValue("@UploadedBy", uploadedBy);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }

                txtTitle.Text = "";
                ddlCategory.SelectedIndex = 0;

                LoadMaterials();
            }
        }

        private void LoadMaterials()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT MaterialID, Title, Category, FileType, UploadDate, UploadedBy 
                                 FROM Materials WHERE IsActive = 1 ORDER BY UploadDate DESC";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvMaterials.DataSource = dt;
                gvMaterials.DataBind();
            }
        }

        protected void gvMaterials_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteMaterial")
            {
                int materialId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Materials SET IsActive = 0 WHERE MaterialID = @MaterialID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@MaterialID", materialId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadMaterials(); // refresh the grid
            }


            if (e.CommandName == "DownloadMaterial")
            {
                int materialId = Convert.ToInt32(e.CommandArgument);

                string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT FilePath FROM Materials WHERE MaterialID = @MaterialID";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@MaterialID", materialId);

                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        string filePath = reader["FilePath"].ToString();
                        string fullPath = Server.MapPath(filePath);
                        string fileName = Path.GetFileName(fullPath); // ✅ extract filename here

                        if (File.Exists(fullPath))
                        {
                            Response.Clear();
                            Response.ContentType = "application/octet-stream";
                            Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileName);
                            Response.TransmitFile(fullPath);
                            Response.End();
                        }
                        else
                        {
                            Response.Write("<script>alert('File not found on server.');</script>");
                        }
                    }

                }
            }
        }

        protected void gvMaterials_SelectedIndexChanged(object sender, EventArgs e)
        {

        }


        protected void gvMaterials_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMaterials.PageIndex = e.NewPageIndex;
            LoadMaterials(); // reload data for the new page
        }

    }
}
        