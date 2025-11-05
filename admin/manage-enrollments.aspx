<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="manage-enrollments.aspx.cs" Inherits="WebApplication.admin.manage_enrollments" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Enrollments | Admin</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/admin-manage-course.css" />
    
    <!-- Select2 CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    
    <style>
        /* Select2 customization */
        .select2-container {
            width: 100% !important;
        }
        
        .select2-container--default .select2-selection--single {
            height: 40px;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 5px;
        }
        
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            line-height: 28px;
            padding-left: 10px;
        }
        
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 38px;
        }
        
        /* Dropdown width - makes it adaptive to content */
        .select2-container--default .select2-dropdown {
            min-width: 250px;
            width: auto !important;
            max-width: 500px;
        }
        
        .select2-container--default .select2-results__option {
            white-space: nowrap;
            padding: 8px 12px;
        }
        
        /* Make dropdown results list scrollable with max height */
        .select2-results__options {
            max-height: 250px;
            overflow-y: auto;
        }
        
        /* Search field styling */
        .select2-search--dropdown .select2-search__field {
            padding: 6px 10px;
            font-size: 14px;
            border: 2px solid #4CAF50;
            border-radius: 4px;
        }
        
        .select2-search--dropdown .select2-search__field:focus {
            outline: none;
            border-color: #45a049;
        }
        
        /* Edit mode styling */
        .edit-dropdown {
            width: 100%;
            padding: 8px;
            border: 2px solid #4CAF50;
            border-radius: 5px;
            font-size: 14px;
            background-color: #f9fff9;
        }
        
        .edit-dropdown:focus {
            outline: none;
            border-color: #45a049;
            box-shadow: 0 0 5px rgba(76, 175, 80, 0.3);
        }
        
        /* Action buttons styling */
        .action-buttons {
            display: flex;
            gap: 8px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .btn-edit {
            background-color: #2196F3;
            color: white;
        }
        
        .btn-edit:hover {
            background-color: #0b7dda;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(33, 150, 243, 0.3);
        }
        
        .btn-update {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-update:hover {
            background-color: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(76, 175, 80, 0.3);
        }
        
        .btn-cancel {
            background-color: #ff9800;
            color: white;
        }
        
        .btn-cancel:hover {
            background-color: #e68900;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(255, 152, 0, 0.3);
        }
        
        .btn-danger {
            background-color: #f44336;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #da190b;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(244, 67, 54, 0.3);
        }
        
        /* GridView row in edit mode */
        tr.edit-row {
            background-color: #f0f8ff !important;
            border-left: 4px solid #2196F3;
        }
        
        /* Responsive table */
        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<form id="form1" runat="server" class="dashboard-body">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <img src="../assets/images/logo.png" alt="Logo" class="sidebar-logo" />
            <h2>MediLearn Hub</h2>
        </div>
        <nav class="sidebar-nav">
            <a href="dashboard.aspx">🏠 Dashboard</a>
<a href="manage-users.aspx">👥 Manage Users</a>
<a href="manage-materials.aspx">📂 Manage Materials</a>
<a href="manage-courses.aspx">📚 Manage Courses</a>
<a href="manage-enrollments.aspx" class="active">📝 Enrollments</a>
<a href="../index.aspx" class="logout">🚪 Logout</a>
        </nav>
    </aside>

    <!-- Main -->
    <main class="dashboard-main">
        <header class="dashboard-header">
            <h1>Manage Enrollments</h1>
        </header>

        <!-- Enroll Student -->
        <div class="admin-card">
            <h2>➕ Enroll Student</h2>
            <div class="form-grid">
                <div class="form-group">
                    <asp:Label ID="lblCourse" runat="server" Text="Select Course"></asp:Label>
                    <asp:DropDownList ID="ddlCourse" runat="server" CssClass="form-control select2-dropdown">
                        <asp:ListItem Text="Select Course" Value="0" />
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <asp:Label ID="lblStudent" runat="server" Text="Select Student"></asp:Label>
                    <asp:DropDownList ID="ddlStudent" runat="server" CssClass="form-control select2-dropdown">
                        <asp:ListItem Text="Select Student" Value="0" />
                    </asp:DropDownList>
                </div>

                <div class="form-group" style="align-self:flex-end;">
                    <asp:Button ID="btnEnroll" runat="server" Text="Enroll" CssClass="btn-primary" OnClick="btnEnroll_Click" />
                </div>
            </div>
        </div>

        <!-- Search Enrollments -->
        <div class="admin-card">
            <h2>🔍 Search Enrollments</h2>
            <div class="form-grid">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="Enter course or student name"></asp:TextBox>
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-primary" OnClick="btnSearch_Click" />
                <asp:Button ID="btnClearSearch" runat="server" Text="Clear" CssClass="btn-secondary" OnClick="btnClearSearch_Click" />
            </div>
        </div>

        <!-- Enrollments Grid inside UpdatePanel -->
        <asp:UpdatePanel ID="upEnrollments" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="admin-card">
                    <h2>📝 Existing Enrollments</h2>
                    <asp:GridView ID="gvEnrollments" runat="server" AutoGenerateColumns="False" CssClass="table"
                        AllowPaging="True" PageSize="5" AllowSorting="True"
                        DataKeyNames="EnrollmentId,CourseId,StudentId"
                        OnPageIndexChanging="gvEnrollments_PageIndexChanging"
                        OnRowEditing="gvEnrollments_RowEditing"
                        OnRowCancelingEdit="gvEnrollments_RowCancelingEdit"
                        OnRowUpdating="gvEnrollments_RowUpdating"
                        OnRowDeleting="gvEnrollments_RowDeleting"
                        OnRowDataBound="gvEnrollments_RowDataBound"
                        OnSorting="gvEnrollments_Sorting">

                        <Columns>
                            <asp:BoundField DataField="EnrollmentId" HeaderText="ID" ReadOnly="True" SortExpression="EnrollmentId" />
                            
                           
                            <asp:TemplateField HeaderText="Course" SortExpression="CourseName">
                                <ItemTemplate>
                                    <%# Eval("CourseName") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditCourse" runat="server" CssClass="edit-dropdown">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>
                            
                            
                            <asp:TemplateField HeaderText="Student" SortExpression="StudentName">
                                <ItemTemplate>
                                    <%# Eval("StudentName") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditStudent" runat="server" CssClass="edit-dropdown">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:BoundField DataField="EnrollDate" HeaderText="Enroll Date" DataFormatString="{0:yyyy-MM-dd}" SortExpression="EnrollDate" ReadOnly="True" />

                            
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="action-buttons">
                                        <asp:LinkButton ID="lnkEdit" runat="server" 
                                            CommandName="Edit"
                                            CssClass="btn btn-edit">
                                            ✏️ Edit
                                        </asp:LinkButton>
                                        
                                        <asp:LinkButton ID="lnkDelete" runat="server" 
                                            CommandName="Delete"
                                            CssClass="btn btn-danger"
                                            OnClientClick="return confirm('Are you sure you want to remove this enrollment?');">
                                            🗑️ Delete
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="action-buttons">
                                        <asp:LinkButton ID="lnkUpdate" runat="server" 
                                            CommandName="Update"
                                            CssClass="btn btn-update">
                                            ✓ Update
                                        </asp:LinkButton>
                                        
                                        <asp:LinkButton ID="lnkCancel" runat="server" 
                                            CommandName="Cancel"
                                            CssClass="btn btn-cancel">
                                            ✕ Cancel
                                        </asp:LinkButton>
                                    </div>
                                </EditItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                        
                        <RowStyle CssClass="table-row" />
                        <EditRowStyle CssClass="edit-row" />
                    </asp:GridView>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

    </main>
</form>

<!-- jQuery (required for Select2) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!-- Select2 JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>

<script type="text/javascript">
    // Initialize Select2 on page load
    $(document).ready(function () {
        initializeSelect2();
    });

    // Re-initialize Select2 after UpdatePanel updates
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function () {
        initializeSelect2();
    });

    function initializeSelect2() {
        // Initialize Select2 for main dropdowns
        $('.select2-dropdown').select2({
            placeholder: 'Type to search...',
            allowClear: false,
            width: '100%',
            dropdownAutoWidth: true
        });

        // Initialize Select2 for edit dropdowns
        $('.edit-dropdown').select2({
            placeholder: 'Type to search...',
            allowClear: false,
            width: '100%',
            dropdownAutoWidth: true
        });
    }
</script>

</body>
</html>