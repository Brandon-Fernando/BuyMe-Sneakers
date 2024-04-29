<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Timestamp" %>




<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Home</title>

</head>
<body>
	<h1 style="text-align: center">BuyMe Sneakers</h1> 
	<nav style="text-align: center">
		<a href="homePage.jsp">Home</a> |
    	<a href="nike.jsp">Nike Shoes</a> |
    	<a href="adidas.jsp">Adidas Shoes</a> |
    	<a href="jordan.jsp">Jordan Shoes</a> |
    	<a href="account.jsp">Account</a> 
    	
    </nav>
    
    <hr width="100%" size = "2">
    
    <div class="container">
    	<form class="form-inline" method="post" action="search.jsp">
    		<input type="text" name="search" class="form-control" placeholder="Search listings here">
    		<button type="submit" name="save" class="btn btn-primary">Search</button>
    	</form>
    </div>
    
    
    <br>
    <h2>All Listings</h2>
    
    <form class="inline" method="post" action="homePage.jsp">
    	<select name="sortByOptions" id="sortByOptions">
    		<option value="None">---</option>
    		<option value="Name">Name</option>
    		<option value="Nike">Nike</option>
    		<option value="Adidas">Adidas</option>
    		<option value="Jordan">Jordan</option>
    		<option value="lowToHigh">Price (Low-High)</option>
    		<option value="highToLow">Price (High-Low)</option>
    		<option value="open">Status (Open)</option>
    		<option value="closed">Status (Closed)</option>
    	</select>
    	<button type="submit" name="sortBy">Sort By</button>
    </form>
    <br>
    
   <%
   try{
	   ApplicationDB db = new ApplicationDB();
	   Connection con = db.getConnection();
	   
	   String selectQuery = "SELECT * FROM createListing";
	   
	   Statement stmt = con.createStatement();
	   ResultSet result = stmt.executeQuery(selectQuery);
	   
	   
	   String sortOption = request.getParameter("sortByOptions");
	   String sortQuery = null;
	   if(sortOption == null){
		   sortQuery = "SELECT * FROM createListing";
	   }else if(sortOption.equals("Name")){
		   sortQuery = "SELECT * FROM createListing ORDER BY name";
	   }else if(sortOption.equals("Nike")){
		   sortQuery = "SELECT * FROM createListing WHERE brand = 'Nike'";
	   }else if(sortOption.equals("Adidas")){
		   sortQuery = "SELECT * FROM createListing WHERE brand = 'Adidas'";
	   }else if(sortOption.equals("Jordan")){
		   sortQuery = "SELECT * FROM createListing WHERE brand= 'Jordan'";
	   }else if(sortOption.equals("lowToHigh")){
		   sortQuery = "SELECT * FROM createListing ORDER BY startingPrice";
	   }else if(sortOption.equals("highToLow")){
		   sortQuery = "SELECT * FROM createListing ORDER BY startingPrice DESC";
	   }else if(sortOption.equals("open")){
		   sortQuery = "SELECT * FROM createListing WHERE status = 'Open'";
	   }else if(sortOption.equals("closed")){
		   sortQuery = "SELECT * FROM createListing WHERE status = 'Closed'";
	   }else{
		   sortQuery = "SELECT * FROM createListing";
	   }
	   
	   
	   			   
	   
	   
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
	 				PreparedStatement ps = con.prepareStatement(updateQuery);
	 				ps.setInt(1, listID);
	 				ps.executeUpdate();
	 			}
	 		}
	 		
	 		PreparedStatement ps = con.prepareStatement(sortQuery);
	 		ResultSet getListings = ps.executeQuery();
	 		
	 		while(getListings.next()){
	 			
	 	%>
	 	<tr>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><a href="viewListing.jsp?listID=<%= getListings.getInt("listID") %>&brand=<%= getListings.getString("brand") %>">View</a></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("status")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("name")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("brand")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("gender")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("size")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= String.format("%.2f", getListings.getDouble("startingPrice"))%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getListings.getString("closingDateTime")%></td>
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