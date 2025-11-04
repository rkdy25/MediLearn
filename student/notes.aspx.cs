using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WebApplication.student
{
    public partial class notes : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["MediLearnDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadNotes();
        }

        private void LoadNotes()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Notes WHERE UserID=@UserID", con);
                da.SelectCommand.Parameters.AddWithValue("@UserID", Session["UserID"]);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvNotes.DataSource = dt;
                gvNotes.DataBind();
            }
        }

        protected void btnSaveOrUpdate_Click(object sender, EventArgs e)
        {
            if (ViewState["EditNoteID"] == null)
            {
                // Insert new note
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO Notes (UserID, Title, Content, CreatedAt) VALUES (@UserID, @Title, @Content, GETDATE())", con);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@Title", txtNoteTitle.Text);
                    cmd.Parameters.AddWithValue("@Content", txtNoteContent.Text);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            else
            {
                // Update existing note
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Notes SET Title=@Title, Content=@Content WHERE NoteID=@NoteID", con);
                    cmd.Parameters.AddWithValue("@NoteID", ViewState["EditNoteID"]);
                    cmd.Parameters.AddWithValue("@Title", txtNoteTitle.Text);
                    cmd.Parameters.AddWithValue("@Content", txtNoteContent.Text);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                lblFormTitle.Text = "Create a New Note";
                btnSaveNote.Text = "Save Note";
                btnCancel.Visible = false;
                ViewState["EditNoteID"] = null;
            }

            txtNoteTitle.Text = "";
            txtNoteContent.Text = "";
            LoadNotes();
        }

        protected void gvNotes_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int noteId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditNote")
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM Notes WHERE NoteID=@NoteID", con);
                    cmd.Parameters.AddWithValue("@NoteID", noteId);
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        txtNoteTitle.Text = dr["Title"].ToString();
                        txtNoteContent.Text = dr["Content"].ToString();
                        ViewState["EditNoteID"] = noteId;
                        lblFormTitle.Text = "✏️ Edit Note";
                        btnSaveNote.Text = "Update Note";
                        btnCancel.Visible = true;
                    }
                }
            }
            else if (e.CommandName == "DeleteNote")
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Notes WHERE NoteID=@NoteID", con);
                    cmd.Parameters.AddWithValue("@NoteID", noteId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                LoadNotes();
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ViewState["EditNoteID"] = null;
            txtNoteTitle.Text = "";
            txtNoteContent.Text = "";
            lblFormTitle.Text = "Create a New Note";
            btnSaveNote.Text = "Save Note";
            btnCancel.Visible = false;
        }
    }
}
