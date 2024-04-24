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
		
		Statement stmt = con.createStatement(); //for createListing
		Statement stmt2 = con.createStatement(); //for bids
		Statement stmt3 = con.createStatement(); // for onListing
				
		String username = (String) session.getAttribute("user");
				
		String listID = request.getParameter("listID");
		String bid = request.getParameter("bidAmount");
				
		String selectQuery = "SELECT startingPrice FROM createListing WHERE listID=(?)";
				
		PreparedStatement ps = con.prepareStatement(selectQuery);
		ps.setString(1, listID);
		ResultSet result = ps.executeQuery();
		result.next();
		String price = result.getString(1);
		Double bidNum = Double.parseDouble(bid);
		Double priceNum = Double.parseDouble(price);
		
		
		String insert = "Update createListing SET startingPrice = " + bidNum +
				" WHERE listID = " + listID;
		PreparedStatement ps2 = con.prepareStatement(insert);
		ps2.executeUpdate();
		
		
		insert = "INSERT INTO bids(price, dateTime)" + "VALUES(?, ?)";
		PreparedStatement ps3 = con.prepareStatement(insert);
		ps3.setString(1, bid);
		//ps3.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
		ps3.setTimestamp(2, new Timestamp(new java.util.Date().getTime()));
		ps3.executeUpdate();
		
		
		insert = "INSERT INTO onListing(bidID, listID)"
				+ "VALUES((SELECT MAX(bidID) FROM bids), ?)";
		PreparedStatement ps4 = con.prepareStatement(insert);
		ps4.setString(1, listID);
		ps4.executeUpdate();
		
		
		insert = "INSERT INTO places(bidID, username)"
				+ "VALUES((SELECT MAX(bidID) FROM bids), ?)";
		PreparedStatement ps5 = con.prepareStatement(insert);
		ps5.setString(1, username);
		ps5.executeUpdate();
		
		
	
	%>
	<jsp:forward page="viewListing.jsp">
	<jsp:param name="makeBid" value="Bid success!"/>
	<jsp:param name="listID" value="<%=listID %>"/>
	
	</jsp:forward>
	<%
	} catch (SQLException e){
		out.print(e);
	}
	%>
	
</body>
</html>