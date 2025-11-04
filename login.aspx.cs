using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both email and password.";
                return;
            }

            string hashedPassword = HashPassword(password);
            string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // 🟢 FIXED: Now getting Id, Username, and Role
                string query = "SELECT Id, Username, Role FROM Users WHERE Email = @Email AND Password = @Password";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", hashedPassword);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    // 🟢 CRITICAL FIX: Store UserID
                    int userId = Convert.ToInt32(reader["Id"]);
                    string username = reader["Username"].ToString();
                    string role = reader["Role"].ToString().Trim();

                    // 🟢 Store user info in Session (with proper casing for Role)
                    Session["UserID"] = userId;           // ✅ Added UserID
                    Session["UserEmail"] = email;
                    Session["UserName"] = username;
                    Session["Role"] = role;               // ✅ Changed from "UserRole" to "Role"

                    reader.Close();

                    // Redirect based on role (case-insensitive comparison)
                    string roleLower = role.ToLower();
                    switch (roleLower)
                    {
                        case "student":
                            Response.Redirect("~/student/student-dashboard.aspx");
                            break;
                        case "lecturer":
                            Response.Redirect("~/lecturer/profile.aspx");
                            break;
                        case "admin":
                            Response.Redirect("~/admin/dashboard.aspx");
                            break;
                        default:
                            lblMessage.Text = "Unknown user role.";
                            break;
                    }
                }
                else
                {
                    lblMessage.Text = "Invalid email or password.";
                }

                con.Close();
            }
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (var b in bytes)
                    builder.Append(b.ToString("x2"));
                return builder.ToString();
            }
        }
    }
}