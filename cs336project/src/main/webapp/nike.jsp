<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Timestamp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Nike Shoes</title>

</head>
<body>
	<h1 style="text-align: center">Nike Shoes</h1> 
	<nav style="text-align: center">
		<a href="homePage.jsp">Home</a> |
    	<a href="nike.jsp">Nike Shoes</a> |
    	<a href="adidas.jsp">Adidas Shoes</a> |
    	<a href="jordan.jsp">Jordan Shoes</a> |
    	<a href="account.jsp">Account</a> 
    	
    </nav>
    
    <hr width="100%" size="2">
    
    <h2>All Nike Listings</h2>
   <%
   try{
	   ApplicationDB db = new ApplicationDB();
	   Connection con = db.getConnection();
	   
	   String selectQuery = "SELECT * FROM createListing WHERE brand = ?";
	   
	   PreparedStatement ps = con.prepareStatement(selectQuery);
	   ps.setString(1, "Nike");
	   ResultSet result = ps.executeQuery();
	   
	   java.sql.Timestamp currentTimestamp = new Timestamp(new java.util.Date().getTime());
	   
	 %>
	 
	 <table style="border-collapse: collapse; width: 100%">
	 	<tr> 
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;"></td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Status</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Name</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Brand</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Gender</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Size</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Starting Price</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Closing Date and Time</td>
	 	</tr>
	 	
	 	<%
	 		while(result.next()){
	 			int listID = result.getInt("listID");
	 			java.sql.Timestamp closingTimestamp = result.getTimestamp("closingDateTime");
	 			
	 			
	 			
	 			if(currentTimestamp.compareTo(closingTimestamp) > 0){
	 				String updateQuery = "UPDATE createListing SET status = 'Closed' WHERE listID = ?";
	 				PreparedStatement ps2 = con.prepareStatement(updateQuery);
	 				ps2.setInt(1, listID);
	 				ps2.executeUpdate();
	 			}
	 	%>
	 	<tr>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><a href="viewListing.jsp?listID=<%= result.getInt("listID") %>">View</a></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("status")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("name")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("brand")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("gender")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("size")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= String.format("%.2f", result.getDouble("startingPrice"))%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("closingDateTime")%></td>
	 	</tr>
	 	<% } %>
	 </table>
	 <% 
	 db.closeConnection(con);
   } catch (Exception e){
	   out.print(e);
   }
   
   
   %>
   
    
    
    
	
</body>
</html>