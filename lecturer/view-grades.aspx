<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="view-grades.aspx.cs" Inherits="WebApplication.lecturer.view_grades" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>📊 View Student Grades | MediLearn Hub</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
    <link rel="stylesheet" href="../assets/css/dashboard.css" />
    <style>
        .grades-header {
            background: #0078d7;
            color: white;
            padding: 15px 25px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        .grades-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 25px;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .btn {
            padding: 8px 14px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
        }
        .btn-primary { background: #0078d7; color: white; }
        .btn-primary:hover { background: #005fa3; }
        .btn-ghost { background: #f1f1f1; color: #333; }
        .btn-ghost:hover { background: #e2e6ea; }

        .nice-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border: 1px solid #ddd;
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            font-family: 'Segoe UI', sans-serif;
        }

        .nice-table th {
            background: #0078d7;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }

        .nice-table td {
            padding: 10px 14px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }

        .nice-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .nice-table tr:hover {
            background-color: #e9f5ff;
            transition: background 0.3s;
        }

        .grid-pager {
            padding: 12px;
            background: #f1f1f1;
            border-top: 1px solid #ddd;
            text-align: center;
        }

        .grid-pager a, .grid-pager span {
            margin: 0 5px;
            padding: 6px 10px;
            text-decoration: none;
            color: #0078d7;
            border-radius: 6px;
        }

        .grid-pager span {
            background: #0078d7;
            color: white;
        }

        .filter-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .filter-row label {
            font-weight: 600;
        }

        .message {
            display: block;
            margin-bottom: 15px;
            font-weight: 500;
            color: #333;
        }
    </style>
</head>
<body>
<form id="form1" runat="server" class="dashboard-body">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <img src="../assets/images/logo.png" alt="MediLearn Hub" class="sidebar-logo" />
            <h2>MediLearn Hub</h2>
        </div>
        <nav class="sidebar-nav">
            <a href="profile.aspx">👤 Profile</a>
            <a href="my-courses.aspx">📘 Manage Courses</a>
            <a href="upload-materials.aspx">📂 Upload Materials</a>
            <a href="view-grades.aspx" class="active">📊 View Grades</a>
            <a href="../index.aspx">🚪 Logout</a>
        </nav>
    </aside>

    <!-- Main Dashboard -->
    <main class="dashboard-main">
        <header class="grades-header">
            <h1>📊 Student Grades Overview</h1>
        </header>

        <section class="grades-section">

            <!-- Filter Panel -->
            <div class="grades-card">
                <h2>Filter by Quiz</h2>
                <div class="filter-row">
                    <label for="ddlQuizzes">Select Quiz:</label>
                    <asp:DropDownList ID="ddlQuizzes" runat="server" CssClass="form-control"></asp:DropDownList>
                    <asp:Button ID="btnView" runat="server" Text="View Grades" CssClass="btn btn-primary" OnClick="btnView_Click" />
                </div>
                <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
            </div>

            <!-- Grades Table -->
            <div class="grades-card">
                <h2>All Student Scores</h2>
                <asp:GridView ID="gvGrades" runat="server" AutoGenerateColumns="False" CssClass="nice-table" AllowPaging="True" PageSize="10">
                    <Columns>
                        <asp:BoundField DataField="AttemptID" HeaderText="Attempt ID" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                        <asp:BoundField DataField="Score" HeaderText="Score (%)" />
                        <asp:BoundField DataField="StartTime" HeaderText="Start Time" DataFormatString="{0:g}" />
                        <asp:BoundField DataField="EndTime" HeaderText="End Time" DataFormatString="{0:g}" />
                    </Columns>
                    <PagerStyle CssClass="grid-pager" HorizontalAlign="Center" />
                </asp:GridView>
            </div>
        </section>
    </main>

</form>
</body>
</html>
