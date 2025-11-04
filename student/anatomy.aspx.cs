using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WebApplication.student
{
    public partial class anatomy : System.Web.UI.Page
    {
        private static DataTable materialsTable;
        private static int currentIndex = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMaterials();
                DisplayMaterial(currentIndex);
            }
        }

        private void LoadMaterials()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT MaterialID, Title, FilePath, UploadedBy, FileType FROM Materials WHERE FileType = 'mp4' AND IsActive = 1 ORDER BY UploadDate DESC";
                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    materialsTable = new DataTable();
                    da.Fill(materialsTable);
                }
            }
        }

        private void DisplayMaterial(int index)
        {
            if (materialsTable == null || materialsTable.Rows.Count == 0)
            {
                lblMaterialTitle.Text = "No anatomy materials available.";
                lblProfessor.Text = "";
                videoPlayer.Attributes["src"] = "";
                lblCounter.Text = "";
                return;
            }

            if (index < 0) index = 0;
            if (index >= materialsTable.Rows.Count) index = materialsTable.Rows.Count - 1;

            DataRow row = materialsTable.Rows[index];
            lblMaterialTitle.Text = row["Title"].ToString();
            lblProfessor.Text = row["UploadedBy"].ToString();
            videoPlayer.Attributes["src"] = ResolveUrl(row["FilePath"].ToString());
            lblCounter.Text = $"Video {index + 1} of {materialsTable.Rows.Count}";

            ViewState["currentIndex"] = index;
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            currentIndex = (int)(ViewState["currentIndex"] ?? 0);
            if (currentIndex < materialsTable.Rows.Count - 1)
                currentIndex++;
            DisplayMaterial(currentIndex);
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            currentIndex = (int)(ViewState["currentIndex"] ?? 0);
            if (currentIndex > 0)
                currentIndex--;
            DisplayMaterial(currentIndex);
        }
    }
}
