using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication.lecturer
{
    public partial class upload_materials : Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        // 🟢 Keep track of the file being edited
        private static int EditingMaterialId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                if (Request.QueryString["courseId"] == null)
                {
                    Response.Redirect("my-courses.aspx");
                    return;
                }

                ViewState["CourseId"] = Convert.ToInt32(Request.QueryString["courseId"]);
                LoadCourseName();
                LoadMaterials();
            }
        }

        private void LoadCourseName()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT CourseName FROM Courses WHERE CourseId = @CourseId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@CourseId", ViewState["CourseId"]);
                con.Open();
                lblCourseName.Text = cmd.ExecuteScalar()?.ToString() ?? "Unknown Course";
            }
        }

        private void LoadMaterials()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT MaterialID, Title, Category, FileType, UploadDate, UploadedBy, FilePath
                                 FROM Materials
                                 WHERE CourseId = @CourseId
                                 ORDER BY UploadDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@CourseId", ViewState["CourseId"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMaterials.DataSource = dt;
                gvMaterials.DataBind();
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            string title = txtTitle.Text.Trim();
            string category = ddlCategory.SelectedValue;

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(category))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please fill all fields.');", true);
                return;
            }

            string uploadedBy = Session["LecturerName"] != null
                ? Session["LecturerName"].ToString()
                : Session["UserName"] != null ? Session["UserName"].ToString() : "Unknown";

            string uploadDir = Server.MapPath("~/Uploads/");
            if (!Directory.Exists(uploadDir))
                Directory.CreateDirectory(uploadDir);

            string filePath = null;
            string fileType = null;

            if (fileUpload.HasFile)
            {
                string fileName = Path.GetFileName(fileUpload.FileName);
                fileType = Path.GetExtension(fileName);
                string savePath = Path.Combine(uploadDir, fileName);
                fileUpload.SaveAs(savePath);
                filePath = "~/Uploads/" + fileName;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // 🟢 If we are editing an existing material
                if (EditingMaterialId > 0)
                {
                    string updateQuery = @"UPDATE Materials
                                           SET Title = @Title,
                                               Category = @Category,
                                               " + (filePath != null ? "FileType = @FileType, FilePath = @FilePath," : "") + @"
                                               UploadDate = GETDATE()
                                           WHERE MaterialID = @MaterialID";

                    SqlCommand cmd = new SqlCommand(updateQuery, con);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Category", category);
                    if (filePath != null)
                    {
                        cmd.Parameters.AddWithValue("@FileType", fileType);
                        cmd.Parameters.AddWithValue("@FilePath", filePath);
                    }
                    cmd.Parameters.AddWithValue("@MaterialID", EditingMaterialId);
                    cmd.ExecuteNonQuery();

                    EditingMaterialId = 0;
                    btnUpload.Text = "Upload";
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Material updated successfully.');", true);
                }
                else
                {
                    // 🟢 Normal upload
                    if (filePath == null)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a file to upload.');", true);
                        return;
                    }

                    string query = @"INSERT INTO Materials 
                                     (Title, Category, FileType, FilePath, UploadDate, CourseId, UploadedBy)
                                     VALUES (@Title, @Category, @FileType, @FilePath, GETDATE(), @CourseId, @UploadedBy)";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@FileType", fileType);
                    cmd.Parameters.AddWithValue("@FilePath", filePath);
                    cmd.Parameters.AddWithValue("@CourseId", ViewState["CourseId"]);
                    cmd.Parameters.AddWithValue("@UploadedBy", uploadedBy);
                    cmd.ExecuteNonQuery();

                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Material uploaded successfully.');", true);
                }
            }

            txtTitle.Text = "";
            ddlCategory.SelectedIndex = 0;
            LoadMaterials();
        }

        protected void gvMaterials_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMaterials.PageIndex = e.NewPageIndex;
            LoadMaterials();
        }

        protected void gvMaterials_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int materialId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteMaterial")
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("DELETE FROM Materials WHERE MaterialID = @MaterialID", con);
                    cmd.Parameters.AddWithValue("@MaterialID", materialId);
                    cmd.ExecuteNonQuery();
                }
                LoadMaterials();
            }
            else if (e.CommandName == "DownloadMaterial")
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
                        if (File.Exists(fullPath))
                        {
                            Response.ContentType = "application/octet-stream";
                            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(fullPath));
                            Response.TransmitFile(fullPath);
                            Response.End();
                        }
                        else
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('File not found on server.');", true);
                        }
                    }
                }
            }
            else if (e.CommandName == "EditMaterial")
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT Title, Category FROM Materials WHERE MaterialID = @MaterialID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@MaterialID", materialId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        txtTitle.Text = reader["Title"].ToString();
                        ddlCategory.SelectedValue = reader["Category"].ToString();
                        btnUpload.Text = "Update Material";
                        EditingMaterialId = materialId;
                    }
                }
            }
        }
    }
}
