using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;

namespace WebApplication
{
    public partial class register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // ✅ Only allow admins to access registration page
            if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "admin")
            {
                Response.Redirect("../index.aspx");
                return;
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string firstName = txtFName.Text.Trim();
            string lastName = txtLName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirm = txtConfirm.Text.Trim();
            string role = ddlRole.SelectedValue;

            // ✅ Field validation
            if (string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName) ||
                string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) ||
                string.IsNullOrEmpty(confirm) || string.IsNullOrEmpty(role))
            {
                ShowMessage("Please fill in all fields.", "red");
                return;
            }

            // ✅ Password match
            if (password != confirm)
            {
                ShowMessage("Passwords do not match.", "red");
                return;
            }

            // ✅ Password strength enforcement
            if (!IsStrongPassword(password))
            {
                ShowMessage("Password must contain at least 8 characters, one uppercase, one lowercase, one number, and one special character.", "red");
                return;
            }

            // ✅ Hash password
            string hashedPassword = HashPassword(password);

            string connStr = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // ✅ Prevent duplicate accounts
                string checkQuery = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();

                    int exists = (int)checkCmd.ExecuteScalar();
                    if (exists > 0)
                    {
                        ShowMessage("An account with this email already exists.", "red");
                        conn.Close();
                        return;
                    }
                    conn.Close();
                }

                // ✅ Insert user
                string query = "INSERT INTO Users (Username, LName, Email, Password, Role) " +
                               "VALUES (@FirstName, @LastName, @Email, @PasswordHash, @Role)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FirstName", firstName);
                    cmd.Parameters.AddWithValue("@LastName", lastName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);
                    cmd.Parameters.AddWithValue("@Role", role);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        ShowMessage("✅ Registration successful!", "green");

                        // Clear inputs
                        txtFName.Text = txtLName.Text = txtEmail.Text = "";
                        txtPassword.Text = txtConfirm.Text = "";
                        ddlRole.SelectedIndex = 0;
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Database Error: " + ex.Message, "red");
                    }
                }
            }
        }

        // ✅ Helper for password hashing
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

        // ✅ Helper for strong password validation
        private bool IsStrongPassword(string password)
        {
            // at least 8 chars, 1 upper, 1 lower, 1 digit, 1 special char
            return Regex.IsMatch(password, @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$");
        }

        // ✅ Helper for clean message display
        private void ShowMessage(string text, string color)
        {
            message.InnerHtml = text;
            message.Style["color"] = color;
            message.Style["font-weight"] = "600";
            message.Style["margin-top"] = "10px";
        }
    }
}
