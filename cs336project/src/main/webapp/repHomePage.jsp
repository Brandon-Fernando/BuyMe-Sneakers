<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Timestamp" %>




<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin Home</title>

</head>
<body>
	<h1 style="text-align: center"> BuyMe Sneakers Customer Representative Home Page</h1>
	<nav style="text-align: center">
		<a href="repHomePage.jsp">Home</a> |
		<a href="questions.jsp">Q & A</a> |
		<a href="editAccounts.jsp">Edit Accounts</a> |
		<a href="adminHomePage.jsp">Edit Listings/Bids</a> |
		<a href="logout.jsp">Log Out</a>
	</nav>
	
	<hr width="100%" size="2">
	
	<%try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		String selectQuery = "SELECT * FROM createListing";
		PreparedStatement ps = con.prepareStatement(selectQuery);
		ResultSet getListings = ps.executeQuery();
		
		
	%>
	<h2>All Listings</h2>
	<table style="border-collapse: collapse; width: 100%">
	 	<tr> 
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Status</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Name</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Brand</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Gender</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Size</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Starting Price</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Closing Date and Time</td>
	 	</tr>
	 	
	 <%while(getListings.next()){ %>
	 
	 	<tr>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("status")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("name")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("brand")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("gender")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("size")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= String.format("%.2f", getListings.getDouble("startingPrice"))%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("closingDateTime")%></td>
	 	</tr>
	 	<%} %>
	 </table>
		
	 <% 
	 db.closeConnection(con);
	 } catch(Exception e){
	 }%>
	 
	
   
    
    
    
	
</body>
</html>