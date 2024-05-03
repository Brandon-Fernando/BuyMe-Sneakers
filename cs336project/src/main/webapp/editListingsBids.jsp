<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Edit Listings and Bids</title>
	
</head>
<body>
	
	
	<div style="text-align: center">
		<h1>Edit Listings and Bids</h1>
		<a href="repHomePage.jsp">Back</a>
	</div>
	
	<hr width="100%" size="2">
	
	
	<%
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		String listingsQuery = "SELECT * FROM createListing";
		PreparedStatement ps = con.prepareStatement(listingsQuery);
		ResultSet getListings = ps.executeQuery();
		
		
		
		
		
		
	%>
	
	<div style="text-align: center">
		<h2>All Listings</h2>
		
		<table align="center" style="border-collapse: collapse; width: 55%;">
	 	<tr> 
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;"></td>
	 		<td style="border: 3px solid #dddddd; text-align: center; padding: 8px;">Posted By</td>
	 		<td style="border: 3px solid #dddddd; text-align: center; padding: 8px;">Name</td>
	 		<td style="border: 3px solid #dddddd; text-align: center; padding: 8px;">Brand</td>
	 		<td style="border: 3px solid #dddddd; text-align: center; padding: 8px;">Starting Price</td>
	 	</tr>
	 	
		<%while(getListings.next()){ 
			String listID = getListings.getString("listID");
			String postedByQuery = "SELECT username FROM userPosts WHERE listID=?";
			PreparedStatement ps2 = con.prepareStatement(postedByQuery);
			ps2.setString(1, listID);
			ResultSet getPostedBy = ps2.executeQuery();
			
			String postedBy = null;
			while(getPostedBy.next()){
				postedBy = getPostedBy.getString("username");
			}
		%>
		
		<tr>
	 		<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;"><a href="viewEditListingsBids.jsp?listID=<%= getListings.getInt("listID") %>&username=<%= postedBy %>">EDIT</a></td>
	 		<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;"><%= postedBy%></td>
	 		<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;"><%= getListings.getString("name")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;"><%= getListings.getString("brand")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;"><%= String.format("%.2f", getListings.getDouble("startingPrice"))%></td>
	 	</tr>
	 	<%} %>
	 </table>
		
	</div>
	
	
	 <% 
	 db.closeConnection(con);
   } catch (Exception e){
	   out.print(e);
   }
   
   
   %>
	
	
	

</body>
</html>