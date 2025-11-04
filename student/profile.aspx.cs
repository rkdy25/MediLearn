using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace WebApplication.student
{
    public partial class profile : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserEmail"] == null)
                {
                    Response.Redirect("~/login.aspx");
                    return;
                }
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            string email = Session["UserEmail"]?.ToString();
            if (string.IsNullOrEmpty(email)) return;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT Username, LName, Email, PhotoPath FROM Users WHERE Email = @Email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtFirstName.Text = reader["Username"].ToString();
                    txtLastName.Text = reader["LName"].ToString();
                    txtEmail.Text = reader["Email"].ToString();

                    string photoPath = reader["PhotoPath"].ToString();
                    imgProfile.ImageUrl = !string.IsNullOrEmpty(photoPath)
                        ? photoPath
                        : "~/assets/images/avatar-student.png";
                }
                reader.Close();
            }
        }

        protected void btnChangePhoto_Click(object sender, EventArgs e)
        {
            if (Session["UserEmail"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            if (filePhoto.HasFile)
            {
                string extension = Path.GetExtension(filePhoto.FileName);
                string fileName = Path.GetFileNameWithoutExtension(filePhoto.FileName)
                                   + "_" + Guid.NewGuid().ToString("N").Substring(0, 6) + extension;

                string savePath = Server.MapPath("~/uploads/StudentPhotos/");
                if (!Directory.Exists(savePath)) Directory.CreateDirectory(savePath);

                string filePath = Path.Combine(savePath, fileName);
                filePhoto.SaveAs(filePath);

                string relativePath = "~/uploads/StudentPhotos/" + fileName;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Users SET PhotoPath = @PhotoPath WHERE Email = @Email";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@PhotoPath", relativePath);
                    cmd.Parameters.AddWithValue("@Email", Session["UserEmail"].ToString());

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                imgProfile.ImageUrl = relativePath;
            }
        }

        protected void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            string email = Session["UserEmail"]?.ToString();
            string currentPassword = txtCurrentPassword.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(currentPassword) || string.IsNullOrEmpty(newPassword))
                return;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string getPass = "SELECT Password FROM Users WHERE Email = @Email";
                SqlCommand getCmd = new SqlCommand(getPass, con);
                getCmd.Parameters.AddWithValue("@Email", email);
                con.Open();
                string dbPassword = getCmd.ExecuteScalar()?.ToString();
                con.Close();

                if (dbPassword == HashPassword(currentPassword))
                {
                    string update = "UPDATE Users SET Password = @Password WHERE Email = @Email";
                    SqlCommand updateCmd = new SqlCommand(update, con);
                    updateCmd.Parameters.AddWithValue("@Password", HashPassword(newPassword));
                    updateCmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    updateCmd.ExecuteNonQuery();
                }
            }
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder sb = new StringBuilder();
                foreach (var b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }
    }
}
