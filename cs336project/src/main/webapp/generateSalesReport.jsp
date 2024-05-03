<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Generate Sales Report</title>
</head>
<body>
    <h1 style="text-align: center">Generate Sales Report</h1>
    <nav style="text-align: center">
        <a href="adminHomePage.jsp">Home</a> |
        <a href="questions.jsp">Q & A</a> |
        <a href="createRep.jsp">Create Customer Representative Accounts</a> |
        <a href="adminHomePage.jsp">Generate Sales Report</a> |
        <a href="logout.jsp">Log Out</a>
    </nav>
    <hr width="100%" size="2">
    
    <!-- Form to select the report type -->
    <form method="post" action="">
        <label>Select Report Type:</label>
        <select name="reportType">
            <option value="totalEarnings">Total Earnings</option>
            <option value="earningsPerItem">Earnings Per Item</option>
            <option value="earningsPerItemType">Earnings Per Item Type</option>
            <option value="earningsPerUser">Earnings Per User</option>
            <option value="bestsellingItems">Bestselling Items</option>
            <option value="bestsellingUsers">Bestselling Users</option>
        </select>
        <input type="submit" value="Generate Report">
    </form>

    <%
        String reportType = request.getParameter("reportType");
        if (reportType != null) {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String query = "";
            try {
                switch (reportType) {
                    case "totalEarnings":
                        query = "SELECT SUM(price) AS TotalEarnings FROM bids";
                        break;
                    case "earningsPerItem":
                        query = "SELECT name, SUM(price) AS Earnings FROM bids JOIN createListing ON bids.listID = createListing.listID GROUP BY createListing.listID";
                        break;
                    case "earningsPerItemType":
                        // Add appropriate query
                        break;
                    case "earningsPerUser":
                        query = "SELECT username, SUM(price) AS Earnings FROM bids GROUP BY username";
                        break;
                    case "bestsellingItems":
                        query = "SELECT name, COUNT(bidID) AS NumberOfSales FROM bids JOIN createListing ON bids.listID = createListing.listID GROUP BY createListing.listID ORDER BY NumberOfSales DESC";
                        break;
                    case "bestsellingUsers":
                        query = "SELECT username, COUNT(bidID) AS NumberOfBids FROM bids GROUP BY username ORDER BY NumberOfBids DESC";
                        break;
                }
                pstmt = con.prepareStatement(query);
                rs = pstmt.executeQuery();
                %><table border="1"><tr><th>Category</th><th>Value</th></tr><%
                while (rs.next()) {
                    %><tr><td><%= rs.getString(1) %></td><td><%= rs.getFloat(2) %></td></tr><%
                }
                %></table><%
            } catch (SQLException e) {
                out.println("Error fetching report: " + e.getMessage());
            } finally {
                db.closeConnection(con);
            }
        }
    %>
</body>
</html>
