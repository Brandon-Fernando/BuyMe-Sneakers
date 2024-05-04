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
            <option value="bestBuyers">Best Buyers</option>
        </select>
        <input type="submit" value="Generate Report">
    </form>

    <%
        String reportType = request.getParameter("reportType");
        if (reportType != null) {
            ApplicationDB db = new ApplicationDB();
            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String query = "";
            boolean hasRows = false;

            try {
                con = db.getConnection();

                switch (reportType) {
                    case "totalEarnings":
                        query = "SELECT 'Total Earnings' as Category, SUM(b.price) AS Earnings " +
                                "FROM bids b " +
                                "JOIN onListing ol ON b.bidID = ol.bidID " +
                                "JOIN createListing cl ON ol.listID = cl.listID " +
                                "WHERE cl.isWinner = true;";
                        pstmt = con.prepareStatement(query);
                        rs = pstmt.executeQuery();

                        out.println("<h2>Total Earnings</h2>");
                        out.println("<table border='1' cellpadding='5'><tr><th>Category</th><th>Earnings</th></tr>");
                        while (rs.next()) {
                            hasRows = true;
                            String category = rs.getString("Category");
                            float value = rs.getFloat("Earnings");
                            out.println("<tr><td>" + category + "</td><td>$" + String.format("%.2f", value) + "</td></tr>");
                        }
                        if (!hasRows) {
                            out.println("<tr><td colspan='2'>No data available for total earnings.</td></tr>");
                        }
                        out.println("</table>");
                        break;

                    case "earningsPer":
                    	query = "SELECT CONCAT(cl.brand, ' ', cl.name) AS Item, SUM(cl.startingPrice) AS Earnings " +
                    	        "FROM createListing cl " +
                    	        "WHERE cl.isWinner = true " +
                    	        "GROUP BY Item " +
                    	        "ORDER BY Earnings DESC";
                    	pstmt = con.prepareStatement(query);
                    	rs = pstmt.executeQuery();

                    	out.println("<h2>Earnings Per Item</h2>");
                    	out.println("<table border='1' cellpadding='5'><tr><th>Item</th><th>Earnings</th></tr>");
                    	hasRows = false;
                    	while (rs.next()) {
                    	    hasRows = true;
                    	    String item = rs.getString("Item");
                    	    float earnings = rs.getFloat("Earnings");
                    	    out.println("<tr><td>" + item + "</td><td>$" + String.format("%.2f", earnings) + "</td></tr>");
                    	}
                    	if (!hasRows) {
                    	    out.println("<tr><td colspan='2'>No data available for earnings per item.</td></tr>");
                    	}
                    	out.println("</table>");
                        
                        query = "SELECT cl.brand AS Type, SUM(b.price) AS Earnings " +
                                "FROM bids b " +
                                "LEFT JOIN onListing ol ON b.bidID = ol.bidID " +
                                "LEFT JOIN createListing cl ON ol.listID = cl.listID " +
                                "WHERE cl.isWinner = true " +
                                "GROUP BY cl.brand " +
                                "ORDER BY Earnings desc";
                        pstmt = con.prepareStatement(query);
                        rs = pstmt.executeQuery();

                        out.println("<h2>Earnings Per Item Type</h2>");
                        out.println("<table border='1' cellpadding='5'><tr><th>Type</th><th>Earnings</th></tr>");
                        hasRows = false;
                        while (rs.next()) {
                            hasRows = true;
                            String type = rs.getString("Type");
                            float earnings = rs.getFloat("Earnings");
                            out.println("<tr><td>" + type + "</td><td>$" + String.format("%.2f", earnings) + "</td></tr>");
                        }
                        if (!hasRows) {
                            out.println("<tr><td colspan='2'>No data available for earnings per item type.</td></tr>");
                        }
                        out.println("</table>");

						query = "SELECT u.username AS User, SUM(b.price) AS Earnings " +
                                "FROM bids b " +
                                "LEFT JOIN places p ON b.bidID = p.bidID " +
                                "LEFT JOIN onListing ol ON b.bidID = ol.bidID " +
                                "LEFT JOIN createListing cl ON ol.listID = cl.listID " +
                                "LEFT JOIN users u ON p.username = u.username " +
                                "WHERE cl.isWinner = true " +
                                "GROUP BY u.username " +
                                "ORDER BY Earnings desc";
                        pstmt = con.prepareStatement(query);
                        rs = pstmt.executeQuery();

                        out.println("<h2>Earnings Per User</h2>");
                        out.println("<table border='1' cellpadding='5'><tr><th>User</th><th>Earnings</th></tr>");
                        hasRows = false;
                        while (rs.next()) {
                            hasRows = true;
                            String user = rs.getString("User");
                            float earnings = rs.getFloat("Earnings");
                            out.println("<tr><td>" + user + "</td><td>$" + String.format("%.2f", earnings) + "</td></tr>");
                        }
                        if (!hasRows) {
                            out.println("<tr><td colspan='2'>No data available for earnings per user.</td></tr>");
                        }
                        out.println("</table>");
                        break;

                    case "bestsellingItems":
                        query = "SELECT CONCAT(cl.brand, ' ', cl.name) AS Item, COUNT(b.bidID) AS NumberOfSales, SUM(b.price) AS Earnings " +
                                "FROM bids b " +
                                "JOIN onListing ol ON b.bidID = ol.bidID " +
                                "JOIN createListing cl ON ol.listID = cl.listID " +
                                "WHERE cl.isWinner = true " +
                                "GROUP BY Item " +
                                "ORDER BY Earnings DESC " +
                                "LIMIT 3";
                        pstmt = con.prepareStatement(query);
                        rs = pstmt.executeQuery();

                        out.println("<h2>Bestselling Items</h2>");
                        out.println("<table border='1' cellpadding='5'><tr><th>Item</th><th>Earnings</th><th>Number of Sales</th></tr>");
                        hasRows = false;
                        while (rs.next()) {
                            hasRows = true;
                            String item = rs.getString("Item");
                            float earnings = rs.getFloat("Earnings");
                            int numSales = rs.getInt("NumberOfSales");
                            out.println("<tr><td>" + item + "</td><td>$" + String.format("%.2f", earnings) + "</td><td>" + numSales + "</td></tr>");
                        }
                        if (!hasRows) {
                            out.println("<tr><td colspan='3'>No data available for bestselling items.</td></tr>");
                        }
                        out.println("</table>");
                        break;

                    case "bestBuyers":
                        query = "SELECT u.username AS User, COUNT(DISTINCT cl.listID) AS NumberOfItemsWon, SUM(b.price) AS Earnings " +
                                "FROM bids b " +
                                "LEFT JOIN places p ON b.bidID = p.bidID " +
                                "LEFT JOIN onListing ol ON b.bidID = ol.bidID " +
                                "LEFT JOIN createListing cl ON ol.listID = cl.listID " +
                                "LEFT JOIN users u ON p.username = u.username " +
                                "WHERE cl.isWinner = true " +
                                "GROUP BY u.username " +
                                "ORDER BY Earnings DESC " + 
                                "LIMIT 3";
                        pstmt = con.prepareStatement(query);
                        rs = pstmt.executeQuery();

                        out.println("<h2>Best Buyers</h2>");
                        out.println("<table border='1' cellpadding='5'><tr><th>User</th><th>Earnings</th><th>Number of Items Won</th></tr>");
                        hasRows = false;
                        while (rs.next()) {
                            hasRows = true;
                            String user = rs.getString("User");
                            float earnings = rs.getFloat("Earnings");
                            int numItemsWon = rs.getInt("NumberOfItemsWon");
                            out.println("<tr><td>" + user + "</td><td>$" + String.format("%.2f", earnings) + "</td><td>" + numItemsWon + "</td></tr>");
                        }
                        if (!hasRows) {
                            out.println("<tr><td colspan='3'>No data available for best buyers.</td></tr>");
                        }
                        out.println("</table>");
                        break;
                    default:
                        out.println("<p>Unsupported report type selected.</p>");
                        break;
                }

            } catch (SQLException e) {
                out.println("<p>Error executing report query: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) {
                    try { rs.close(); } catch (SQLException ignored) {}
                }
                if (pstmt != null) {
                    try { pstmt.close(); } catch (SQLException ignored) {}
                }
                db.closeConnection(con);
            }
        } else {
            out.println("<p>No report type selected. Please choose a report type and click 'Generate Report'.</p>");
        }
    %>
</body>
</html>
