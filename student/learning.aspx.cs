using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Web.UI.WebControls;

namespace WebApplication.student
{
    public partial class learning : System.Web.UI.Page
    {
        // Pagination settings
        private const int PageSize = 3; // 3 items per page
        private int CurrentMatPage
        {
            get => ViewState["CurrentMatPage"] != null ? (int)ViewState["CurrentMatPage"] : 1;
            set => ViewState["CurrentMatPage"] = value;
        }

        private int CurrentQuizPage
        {
            get => ViewState["CurrentQuizPage"] != null ? (int)ViewState["CurrentQuizPage"] : 1;
            set => ViewState["CurrentQuizPage"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "student")
                {
                    Response.Redirect("../index.aspx");
                    return;
                }

                if (Request.QueryString["courseId"] == null)
                {
                    Response.Redirect("courses.aspx");
                    return;
                }

                LoadCourseDetails();
                LoadMaterialsPage(CurrentMatPage);
                LoadQuizzesPage(CurrentQuizPage);
            }
        }

        private void LoadCourseDetails()
        {
            try
            {
                int courseId = Convert.ToInt32(Request.QueryString["courseId"]);
                string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                         SELECT c.CourseName, c.Description, u.Username AS LecturerFName, u.LName AS LecturerLName
                            FROM Courses c
                            INNER JOIN Users u ON c.LecturerId = u.Id
                            WHERE c.CourseId = @CourseId";


                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblCourseTitle.Text = reader["CourseName"].ToString();
                        lblCourseDesc.Text = $"{reader["Description"]} • Lecturer: {reader["LecturerFName"]} {reader["LecturerLName"]}";

                    }
                    reader.Close();
                }
            }
            catch
            {
                lblCourseTitle.Text = "Course Not Found";
                lblCourseDesc.Text = "Unable to load course details.";
            }
        }

        // -----------------------------
        // Materials Pagination
        // -----------------------------
        private void LoadMaterialsPage(int page)
        {
            try
            {
                int courseId = Convert.ToInt32(Request.QueryString["courseId"]);
                string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT *
                        FROM (
                            SELECT ROW_NUMBER() OVER(ORDER BY UploadDate DESC) AS RowNum, *
                            FROM Materials
                            WHERE CourseId = @CourseId AND IsActive = 1
                        ) AS RowConstrainedResult
                        WHERE RowNum BETWEEN @StartRow AND @EndRow
                        ORDER BY RowNum";

                    int startRow = (page - 1) * PageSize + 1;
                    int endRow = page * PageSize;

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.Parameters.AddWithValue("@StartRow", startRow);
                    cmd.Parameters.AddWithValue("@EndRow", endRow);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    pnlNoMaterials.Visible = dt.Rows.Count == 0;
                    rptMaterials.DataSource = dt;
                    rptMaterials.DataBind();

                    lblPageMat.Text = $"Page {CurrentMatPage}";
                    btnPrevMat.Enabled = CurrentMatPage > 1;

                    // Determine if Next should be enabled
                    string countQuery = "SELECT COUNT(*) FROM Materials WHERE CourseId=@CourseId AND IsActive=1";
                    SqlCommand countCmd = new SqlCommand(countQuery, con);
                    countCmd.Parameters.AddWithValue("@CourseId", courseId);
                    con.Open();
                    int total = (int)countCmd.ExecuteScalar();
                    btnNextMat.Enabled = page * PageSize < total;
                }
            }
            catch
            {
                pnlNoMaterials.Visible = true;
            }
        }

        protected void btnPrevMat_Click(object sender, EventArgs e)
        {
            if (CurrentMatPage > 1)
            {
                CurrentMatPage--;
                LoadMaterialsPage(CurrentMatPage);
            }
        }

        protected void btnNextMat_Click(object sender, EventArgs e)
        {
            CurrentMatPage++;
            LoadMaterialsPage(CurrentMatPage);
        }

        // -----------------------------
        // Quizzes Pagination
        // -----------------------------
        private void LoadQuizzesPage(int page)
        {
            try
            {
                int courseId = Convert.ToInt32(Request.QueryString["courseId"]);
                string connectionString = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT *
                        FROM (
                            SELECT ROW_NUMBER() OVER(ORDER BY CreatedDate DESC) AS RowNum, q.*, 
                            (SELECT COUNT(*) FROM Questions qs WHERE qs.QuizID = q.QuizID) AS QuestionCount
                            FROM Quizzes q
                            WHERE q.CourseId = @CourseId AND q.IsActive = 1
                        ) AS RowConstrainedResult
                        WHERE RowNum BETWEEN @StartRow AND @EndRow
                        ORDER BY RowNum";

                    int startRow = (page - 1) * PageSize + 1;
                    int endRow = page * PageSize;

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.Parameters.AddWithValue("@StartRow", startRow);
                    cmd.Parameters.AddWithValue("@EndRow", endRow);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    pnlNoQuizzes.Visible = dt.Rows.Count == 0;
                    rptQuizzes.DataSource = dt;
                    rptQuizzes.DataBind();

                    lblPageQuiz.Text = $"Page {CurrentQuizPage}";
                    btnPrevQuiz.Enabled = CurrentQuizPage > 1;

                    // Determine if Next should be enabled
                    string countQuery = "SELECT COUNT(*) FROM Quizzes WHERE CourseId=@CourseId AND IsActive=1";
                    SqlCommand countCmd = new SqlCommand(countQuery, con);
                    countCmd.Parameters.AddWithValue("@CourseId", courseId);
                    con.Open();
                    int total = (int)countCmd.ExecuteScalar();
                    btnNextQuiz.Enabled = page * PageSize < total;
                }
            }
            catch
            {
                pnlNoQuizzes.Visible = true;
            }
        }

        protected void btnPrevQuiz_Click(object sender, EventArgs e)
        {
            if (CurrentQuizPage > 1)
            {
                CurrentQuizPage--;
                LoadQuizzesPage(CurrentQuizPage);
            }
        }

        protected void btnNextQuiz_Click(object sender, EventArgs e)
        {
            CurrentQuizPage++;
            LoadQuizzesPage(CurrentQuizPage);
        }

        // -----------------------------
        // File type icon helper
        // -----------------------------
        public string GetFileTypeIcon(string fileType)
        {
            switch (fileType.ToLower())
            {
                case "pdf": return "file-pdf";
                case "doc":
                case "docx": return "file-word";
                case "ppt":
                case "pptx": return "file-powerpoint";
                case "mp4":
                case "avi":
                case "mov": return "video";
                case "jpg":
                case "png":
                case "gif": return "file-image";
                default: return "file";
            }
        }
    }
}
