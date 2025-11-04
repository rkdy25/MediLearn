using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace WebApplication.lecturer
{
    public partial class profile : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 🔒 Make sure user is logged in
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

            if (string.IsNullOrEmpty(email))
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT Username, LName, Email, Password, PhotoPath FROM Users WHERE Email = @Email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtFirstName.Text = reader["Username"].ToString();
                    txtLastName.Text = reader["LName"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    txtPassword.Text = reader["Password"].ToString();

                    string photoPath = reader["PhotoPath"].ToString();
                    imgProfile.ImageUrl = !string.IsNullOrEmpty(photoPath)
                        ? photoPath
                        : "~/assets/images/lecturer-card.png";
                }

                reader.Close();
            }
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string hashedPassword = HashPassword(txtPassword.Text.Trim());

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE Users SET Password = @Password WHERE Email = @Email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Password", hashedPassword);
                cmd.Parameters.AddWithValue("@Email", email);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
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

                string savePath = Server.MapPath("~/uploads/ProfilesPhotos/");
                if (!Directory.Exists(savePath)) Directory.CreateDirectory(savePath);

                string filePath = Path.Combine(savePath, fileName);
                filePhoto.SaveAs(filePath);

                string relativePath = "~/uploads/ProfilesPhotos/" + fileName;

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
