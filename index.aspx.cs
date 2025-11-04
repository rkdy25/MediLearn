using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WebApplication
{
    public partial class index : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLatestResources();

                string q = Request.QueryString["q"];
                if (!string.IsNullOrEmpty(q))
                {
                    SearchMaterials(q);
                }
            }
        }

        // Load latest 5 resources
        private void LoadLatestResources()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 5 Title, FilePath, UploadedBy
                    FROM Materials
                    WHERE IsActive = 1
                    ORDER BY UploadDate DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptResources.DataSource = dt;
                rptResources.DataBind();
            }
        }

        // Search resources by keyword
        private void SearchMaterials(string keyword)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT Title, FilePath, UploadedBy
                    FROM Materials
                    WHERE IsActive = 1 AND Title LIKE @keyword
                    ORDER BY UploadDate DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@keyword", "%" + keyword + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptResources.DataSource = dt;
                rptResources.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
             string searchTerm = txtSearch.Text.Trim();

    if (!string.IsNullOrEmpty(searchTerm))
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            string query = @"
                SELECT Title, FilePath, UploadedBy
                FROM Materials
                WHERE IsActive = 1 AND Title LIKE @SearchTerm
                ORDER BY UploadDate DESC";

            SqlDataAdapter da = new SqlDataAdapter(query, conn);
            da.SelectCommand.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

            DataTable dt = new DataTable();
            da.Fill(dt);

            rptSearchResults.DataSource = dt;
            rptSearchResults.DataBind();

            searchResults.Visible = true;
        }
    }

        }

        protected void rptSearchResults_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {

        }
    }
}
