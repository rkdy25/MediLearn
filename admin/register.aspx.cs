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
    public partial class register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string Username = txtFName.Text.Trim();
            string lname = txtLName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirm = txtConfirm.Text.Trim();
            string role = ddlRole.SelectedValue;

            // Basic validation
            if (string.IsNullOrEmpty(Username) || string.IsNullOrEmpty(lname) ||
                string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) ||
                string.IsNullOrEmpty(confirm) || string.IsNullOrEmpty(role))
            {
                message.InnerHtml = "Please fill in all fields.";
                message.Style["color"] = "red";
                return;
            }

            if (password != confirm)
            {
                message.InnerHtml = "Passwords do not match.";
                message.Style["color"] = "red";
                return;
            }

            // Hash the password
            string hashedPassword = HashPassword(password);

            // Insert into database
            string connStr = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Users (Username, LName, Email, Password, Role) " +
               "VALUES (@FirstName, @LastName, @Email, @PasswordHash, @Role)";


                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FirstName", Username);
                    cmd.Parameters.AddWithValue("@LastName", lname);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);
                    cmd.Parameters.AddWithValue("@Role", role);


                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();

                        message.InnerHtml = "Registration successful!";
                        message.Style["color"] = "green";

                        // Clear fields
                        txtFName.Text = txtLName.Text = txtEmail.Text = "";
                        txtPassword.Text = txtConfirm.Text = "";
                        ddlRole.SelectedIndex = 0;
                    }
                    catch (Exception ex)
                    {
                        message.InnerHtml = "Error: " + ex.Message;
                        message.Style["color"] = "red";
                    }
                }
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