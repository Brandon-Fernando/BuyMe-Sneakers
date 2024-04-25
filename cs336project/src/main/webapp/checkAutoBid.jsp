<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Timestamp" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Check Bid</title>
</head>
<body>
	<%@ page import ="java.sql.*" %>
	 <% 
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		
		String username = (String) session.getAttribute("user");
		
		String bidLimit = request.getParameter("bidLimit");
		String increment = request.getParameter("increment");
		
		String listID = request.getParameter("listID");
		
		
		String selectQuery = "SELECT startingPrice FROM createListing WHERE listID=(?)";
		PreparedStatement ps = con.prepareStatement(selectQuery);
		ps.setString(1, listID);
		ResultSet result = ps.executeQuery();
		result.next();
		String price = result.getString(1);
		
		
		
		String insert = "INSERT INTO autoBids(username, listID, increment, currentPrice, bidLimit) " +
		"VALUES (?, ?, ?, ?, ?) " + 
		"ON DUPLICATE KEY UPDATE increment = (?), bidLimit = (?), currentPrice = (?)";
		PreparedStatement ps2 = con.prepareStatement(insert);
		ps2.setString(1, username);
		ps2.setString(2, listID);
		ps2.setString(3, increment);
		ps2.setString(4, price);
		ps2.setString(5, bidLimit);
		ps2.setString(6, increment);
		ps2.setString(7, bidLimit);
		ps2.setString(8, price);
		ps2.executeUpdate();
		
	
		response.sendRedirect("viewListing.jsp?listID=" + listID);
	
	}catch(SQLException e){
		out.print(e);
	}
	%> 
	
	
			
			
		
	
	
	
	
</body>
</html> 













                 