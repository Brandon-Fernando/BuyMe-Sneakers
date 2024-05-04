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
    
    <%
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		String username = (String) session.getAttribute("user");
		if(username == null){
			response.sendRedirect("login.jsp");
		}
		
		String searched = request.getParameter("search");
		
		String sortOption = request.getParameter("sortByOptions");
		   String sortQuery = null;
		   if(sortOption == null){
			   sortQuery = "SELECT * FROM createListing WHERE name LIKE '%"+searched+"%'";
		   }else if(sortOption.equals("Mens")){
			   sortQuery = "SELECT * FROM createListing WHERE gender = 'Mens' AND name LIKE '%"+searched+"%'";
		   }else if(sortOption.equals("Womens")){
			   sortQuery = "SELECT * FROM createListing WHERE gender = 'Womens' AND name LIKE '%"+searched+"%'";
		   }else if(sortOption.equals("lowToHigh")){
			   sortQuery = "SELECT * FROM createListing WHERE name LIKE '%"+searched+"%' ORDER BY startingPrice";
		   }else if(sortOption.equals("highToLow")){
			   sortQuery = "SELECT * FROM createListing WHERE name LIKE '%"+searched+"%' ORDER BY startingPrice DESC";
		   }else if(sortOption.equals("open")){
			   sortQuery = "SELECT * FROM createListing WHERE status = 'Open' AND name LIKE '%"+searched+"%'";
		   }else if(sortOption.equals("closed")){
			   sortQuery = "SELECT * FROM createListing WHERE status = 'Closed' AND name LIKE '%"+searched+"%'";
		   }else{
			   sortQuery = "SELECT * FROM createListing WHERE name LIKE '%"+searched+"%'";
		   }
		   
		   
		   PreparedStatement ps = con.prepareStatement(sortQuery);
		   ResultSet getSearched = ps.executeQuery();
			
		   
		   
		   
	%>
	
	
	<h1 style="text-align: center">Search results for: <%=searched %></h1>
	<div class="container" style="text-align: center">
    	<form class="form-inline" method="post" action="search.jsp">
    		<input type="text" name="search" class="form-control" placeholder="Search listings here">
    		<button type="submit" name="save" class="btn btn-primary">Search</button>
    	</form>
    </div>
    
    <br>
    
    <form class="inline" method="post" action="search.jsp?search=<%=searched %>">
	    	<select name="sortByOptions" id="sortByOptions">
	    		<option value="Mens">Mens</option>
	    		<option value="Womens">Womens</option>
	    		<option value="lowToHigh">Price (Low-High)</option>
	    		<option value="highToLow">Price (High-Low)</option>
	    		<option value="open">Status (Open)</option>
	    		<option value="closed">Status (Closed)</option>
	    	</select>
	    	<button type="submit" name="sortBy">Sort By</button>
	    </form>
	    <br>
	
  	
	    
	    
	    
		<table style="border-collapse: collapse; width: 100%">
	 	<tr> 
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;"></td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Status</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">ID</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Name</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Brand</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Gender</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Size</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Current Price</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Closing Date and Time</td>
	 	</tr>
	 	<%while(getSearched.next()){ %>
	 	<tr>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><a href="viewListing.jsp?listID=<%= getSearched.getInt("listID") %>&brand=<%= getSearched.getString("brand") %>">View</a></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getSearched.getString("status")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getSearched.getString("listID")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getSearched.getString("name")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getSearched.getString("brand")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getSearched.getString("gender")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getSearched.getString("size")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;">$<%= String.format("%.2f", getSearched.getDouble("startingPrice"))%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= getSearched.getString("closingDateTime")%></td>
	 	</tr>
	 	<% } %>
	 </table>
	
		   
	
	<%
	}catch(Exception e){
		out.print(e);
	}
    %>
   	
    
   
    
    
    
	
</body>
</html>