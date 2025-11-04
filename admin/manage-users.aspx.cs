using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WebApplication.admin
{
    public partial class manage_users : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        private int PageSize = 5;

        private int TotalUsers
        {
            get { return ViewState["TotalUsers"] != null ? (int)ViewState["TotalUsers"] : 0; }
            set { ViewState["TotalUsers"] = value; }
        }

        private int TotalPages
        {
            get { return (int)Math.Ceiling((double)TotalUsers / PageSize); }
        }

        private int CurrentPage
        {
            get { return ViewState["CurrentPage"] != null ? (int)ViewState["CurrentPage"] : 0; }
            set { ViewState["CurrentPage"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CurrentPage = 0;
                LoadUsers(CurrentPage, txtSearch.Text.Trim());
            }
        }

        /// <summary>
        /// Load users with optional search and paging
        /// </summary>
        private void LoadUsers(int pageIndex = 0, string searchTerm = "")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Build filter
                string filter = "";
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    filter = "WHERE Username + ' ' + LName LIKE @Search OR Email LIKE @Search OR Role LIKE @Search";
                }

                // Get total count
                string countQuery = "SELECT COUNT(*) FROM Users " + (string.IsNullOrEmpty(filter) ? "" : filter);
                SqlCommand countCmd = new SqlCommand(countQuery, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    countCmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                }

                conn.Open();
                TotalUsers = Convert.ToInt32(countCmd.ExecuteScalar());

                // Get paged users
                string query = $@"
                    SELECT *
                    FROM
                    (
                        SELECT ROW_NUMBER() OVER (ORDER BY Id) AS RowNum,
                               Id AS UserID,
                               Username + ' ' + LName AS Name,
                               Email,
                               Role
                        FROM Users
                        {filter}
                    ) AS T
                    WHERE RowNum BETWEEN @StartRow AND @EndRow
                    ORDER BY RowNum";

                int startRow = pageIndex * PageSize + 1;
                int endRow = startRow + PageSize - 1;

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StartRow", startRow);
                cmd.Parameters.AddWithValue("@EndRow", endRow);
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvUsers.DataSource = dt;
                gvUsers.DataBind();

                conn.Close();
            }

            CurrentPage = pageIndex;
            RenderPager(pageIndex);
        }

        /// <summary>
        /// Render Previous / Next pager buttons
        /// </summary>
        private void RenderPager(int currentPage)
        {
            pnlPager.Controls.Clear();

            // Previous
            if (currentPage > 0)
            {
                LinkButton prev = new LinkButton();
                prev.ID = "lnkPrev";
                prev.Text = "« Previous";
                prev.CommandArgument = (currentPage - 1).ToString();
                prev.Click += Pager_Click;
                pnlPager.Controls.Add(prev);
            }

            // Page info
            Literal pageInfo = new Literal();
            pageInfo.Text = $" <span>Page {currentPage + 1} of {TotalPages}</span> ";
            pnlPager.Controls.Add(pageInfo);

            // Next
            if (currentPage < TotalPages - 1)
            {
                LinkButton next = new LinkButton();
                next.ID = "lnkNext";
                next.Text = "Next »";
                next.CommandArgument = (currentPage + 1).ToString();
                next.Click += Pager_Click;
                pnlPager.Controls.Add(next);
            }
        }

        /// <summary>
        /// Pager button click event
        /// </summary>
        protected void Pager_Click(object sender, EventArgs e)
        {
            LinkButton btn = sender as LinkButton;
            int pageIndex = Convert.ToInt32(btn.CommandArgument);
            LoadUsers(pageIndex, txtSearch.Text.Trim());
        }

        /// <summary>
        /// Delete user
        /// </summary>
        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteUser")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                DeleteUser(userId);
                // Reload current page (or go back if last row deleted)
                int lastPage = CurrentPage;
                if (CurrentPage > 0 && (TotalUsers - 1) <= CurrentPage * PageSize)
                    lastPage = CurrentPage - 1;

                LoadUsers(lastPage, txtSearch.Text.Trim());
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

        // Navigation
        protected void btnGoToRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("register.aspx");
        }

        // Search
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadUsers(0, txtSearch.Text.Trim());
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers(0, txtSearch.Text.Trim());
        }

        protected void btnResetSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            LoadUsers(0);
        }
    }
}
