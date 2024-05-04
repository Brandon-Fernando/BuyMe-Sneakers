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
        <a href="generateSalesReport.jsp">Generate Sales Report</a> |
        <a href="logout.jsp">Log Out</a>
    </nav>
    <hr width="100%" size="2">
    
    <!-- Form to select the report type -->
    <form method="post" action="">
        <label>Select Report Type:</label>
        <select name="reportType">
            <option value="totalEarnings">Total Earnings</option>
            <option value="earningsPer">Earnings Per</option>
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
	                    query = "SELECT 'Total Earnings' AS Category, SUM(startingPrice) AS Value "
	                          + "FROM ("
	                          + "    SELECT cl.listID, cl.startingPrice, cl.minPrice, MAX(b.price) as maxPrice "
	                          + "    FROM createListing cl "
	                          + "    JOIN onListing ol ON ol.listID = cl.listID "
	                          + "    JOIN bids b ON b.bidID = ol.bidID "
	                          + "    GROUP BY cl.listID, cl.startingPrice, cl.minPrice"
	                          + ") AS subquery "
	                          + "WHERE subquery.maxPrice > subquery.minPrice";
	                    pstmt = con.prepareStatement(query);
	                    rs = pstmt.executeQuery();
	                    %><h2>Total Earnings</h2><table border="1"><tr><th>Category</th><th>Value</th></tr><%
	                    while (rs.next()) {
	                        %><tr><td><%= rs.getString("Category") %></td><td>$<%= String.format("%.2f", rs.getFloat("Value")) %></td></tr><%
	                    }
	                    %></table><%
	                    break;
	                case "earningsPerItem":
	                	// Earnings Per Item
	                    query = "SELECT name AS Item, SUM(startingPrice) AS Earnings "
	                          + "FROM ("
	                          + "    SELECT cl.listID, cl.name, cl.startingPrice, MAX(b.price) as maxPrice "
	                          + "    FROM createListing cl "
	                          + "    JOIN onListing ol ON ol.listID = cl.listID "
	                          + "    JOIN bids b ON b.bidID = ol.bidID "
	                          + "    GROUP BY cl.listID, cl.name, cl.startingPrice, cl.minPrice"
	                          + ") AS subquery "
	                          + "WHERE subquery.maxPrice > subquery.minPrice "
	                          + "GROUP BY subquery.name";
	                    pstmt = con.prepareStatement(query);
	                    rs = pstmt.executeQuery();
	                    %><h2>Earnings Per Item</h2><table border="1"><tr><th>Item</th><th>Earnings</th></tr><%
	                    while (rs.next()) {
	                        %><tr><td><%= rs.getString("Item") %></td><td>$<%= String.format("%.2f", rs.getFloat("Earnings")) %></td></tr><%
	                    }
	                    %></table><%

                        // Earnings Per Item Type
                        query = "SELECT itemType AS Type, SUM(price) AS Earnings FROM bids JOIN createListing ON bids.listID = createListing.listID GROUP BY itemType";
                        pstmt = con.prepareStatement(query);
                        rs = pstmt.executeQuery();
                        %><h2>Earnings Per Item Type</h2><table border="1"><tr><th>Type</th><th>Earnings</th></tr><%
                        while (rs.next()) {
                            %><tr><td><%= rs.getString("Type") %></td><td><%= rs.getFloat("Earnings") %></td></tr><%
                        }
                        %></table><%

                        // Earnings Per User
                        query = "SELECT username AS User, SUM(price) AS Earnings FROM bids GROUP BY username";
                        pstmt = con.prepareStatement(query);
                        rs = pstmt.executeQuery();
                        %><h2>Earnings Per User</h2><table border="1"><tr><th>User</th><th>Earnings</th></tr><%
                        while (rs.next()) {
                            %><tr><td><%= rs.getString("User") %></td><td><%= rs.getFloat("Earnings") %></td></tr><%
                        }
                        %></table><%
                        break;

                    case "bestsellingItems":
                        query = "SELECT name AS Item, COUNT(bidID) AS NumberOfSales FROM bids JOIN createListing ON bids.listID = createListing.listID GROUP BY createListing.listID ORDER BY NumberOfSales DESC";
                        pstmt = con.prepareStatement(query);
                        rs = pstmt.executeQuery();
                        %><h2>Bestselling Items</h2><table border="1"><tr><th>Item</th><th>Number Of Sales</th></tr><%
                        while (rs.next()) {
                            %><tr><td><%= rs.getString("Item") %></td><td><%= rs.getInt("NumberOfSales") %></td></tr><%
                        }
                        %></table><%
                        break;

                    case "bestsellingUsers":
                        query = "SELECT username AS User, COUNT(bidID) AS NumberOfBids FROM bids GROUP BY username ORDER BY NumberOfBids DESC";
                        pstmt = con.prepareStatement(query);
                        rs = pstmt.executeQuery();
                        %><h2>Bestselling Users</h2><table border="1"><tr><th>User</th><th>Number Of Bids</th></tr><%
                        while (rs.next()) {
                            %><tr><td><%= rs.getString("User") %></td><td><%= rs.getInt("NumberOfBids") %></td></tr><%
                        }
                        %></table><%
                        break;
                }
            } catch (SQLException e) {
                out.println("Error fetching report: " + e.getMessage());
            } finally {
                db.closeConnection(con);
            }
        }
    %>
</body>
</html>
