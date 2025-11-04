using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.IO;

namespace WebApplication.admin
{
    public partial class manage_materials : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;
        private int PageSize = 5;

        private int TotalMaterials
        {
            get { return ViewState["TotalMaterials"] != null ? (int)ViewState["TotalMaterials"] : 0; }
            set { ViewState["TotalMaterials"] = value; }
        }

        private int TotalPages => (int)Math.Ceiling((double)TotalMaterials / PageSize);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadMaterials(0, txtSearch.Text.Trim(), ddlTypeFilter.SelectedValue);
        }

        private void LoadMaterials(int pageIndex = 0, string searchTerm = "", string typeFilter = "")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string filter = "";
                if (!string.IsNullOrEmpty(searchTerm))
                    filter += "Title LIKE @Search OR UploadedBy LIKE @Search";
                if (!string.IsNullOrEmpty(typeFilter))
                    filter += (string.IsNullOrEmpty(filter) ? "" : " AND ") + "FileType=@Type";

                string countQuery = "SELECT COUNT(*) FROM Materials" + (string.IsNullOrEmpty(filter) ? "" : " WHERE " + filter);
                SqlCommand countCmd = new SqlCommand(countQuery, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    countCmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                if (!string.IsNullOrEmpty(typeFilter))
                    countCmd.Parameters.AddWithValue("@Type", typeFilter);

                conn.Open();
                TotalMaterials = Convert.ToInt32(countCmd.ExecuteScalar());

                string query = $@"
                SELECT *
                FROM
                (
                    SELECT ROW_NUMBER() OVER (ORDER BY MaterialID) AS RowNum,
                           MaterialID, Title, UploadedBy, FileType, UploadDate, FilePath
                    FROM Materials
                    {(string.IsNullOrEmpty(filter) ? "" : "WHERE " + filter)}
                ) AS T
                WHERE RowNum BETWEEN @StartRow AND @EndRow
                ORDER BY RowNum";

                int startRow = pageIndex * PageSize + 1;
                int endRow = startRow + PageSize - 1;

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StartRow", startRow);
                cmd.Parameters.AddWithValue("@EndRow", endRow);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                if (!string.IsNullOrEmpty(typeFilter))
                    cmd.Parameters.AddWithValue("@Type", typeFilter);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvMaterials.DataSource = dt;
                gvMaterials.DataBind();
                conn.Close();
            }

            RenderPager(pageIndex);
        }

        protected void gvMaterials_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int materialId = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "DeleteMaterial")
            {
                DeleteMaterial(materialId);
                LoadMaterials(0, txtSearch.Text.Trim(), ddlTypeFilter.SelectedValue);
            }
            else if (e.CommandName == "DownloadMaterial")
            {
                DownloadMaterial(materialId);
            }
        }

        private void DeleteMaterial(int id)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Materials WHERE MaterialID=@ID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", id);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }

        private void DownloadMaterial(int id)
        {
            string filePath = "";
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT FilePath, Title FROM Materials WHERE MaterialID=@ID", conn);
                cmd.Parameters.AddWithValue("@ID", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    filePath = dr["FilePath"].ToString();
                }
                conn.Close();
            }

            if (!string.IsNullOrEmpty(filePath) && File.Exists(Server.MapPath(filePath)))
            {
                string fileName = Path.GetFileName(filePath);
                Response.ContentType = "application/octet-stream";
                Response.AddHeader("Content-Disposition", $"attachment; filename={fileName}");
                Response.TransmitFile(Server.MapPath(filePath));
                Response.End();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadMaterials(0, txtSearch.Text.Trim(), ddlTypeFilter.SelectedValue);
        }

        #region Pager Rendering
        private void RenderPager(int currentPage)
        {
            pnlPager.Controls.Clear();

            if (currentPage > 0)
            {
                LinkButton prev = new LinkButton { Text = "« Previous", CommandArgument = (currentPage - 1).ToString() };
                prev.Command += Pager_Command;
                pnlPager.Controls.Add(prev);
            }

            Literal pageInfo = new Literal { Text = $" <span>Page {currentPage + 1} of {TotalPages}</span> " };
            pnlPager.Controls.Add(pageInfo);

            if (currentPage < TotalPages - 1)
            {
                LinkButton next = new LinkButton { Text = "Next »", CommandArgument = (currentPage + 1).ToString() };
                next.Command += Pager_Command;
                pnlPager.Controls.Add(next);
            }
        }

        private void Pager_Command(object sender, CommandEventArgs e)
        {
            int pageIndex = Convert.ToInt32(e.CommandArgument);
            LoadMaterials(pageIndex, txtSearch.Text.Trim(), ddlTypeFilter.SelectedValue);
        }
        #endregion
    }
}
