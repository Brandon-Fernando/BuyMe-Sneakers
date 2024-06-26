<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Account</title>
</head>
<body>

	<%
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		String username = (String) session.getAttribute("user");
		if(username == null){
			response.sendRedirect("login.jsp");
		}
		
		
		String selectQuery = "SELECT cl.name, cl.brand, cl.startingPrice, MAX(b.price) as userBid, cl.listID "
				+ "FROM places p "
				+ "INNER JOIN onListing ol ON ol.bidID = p.bidID "
				+ "INNER JOIN bids b ON b.bidID = ol.bidID "  
				+ "INNER JOIN createListing cl ON cl.listID = ol.listID "
			 	+ "WHERE p.username = ? AND cl.status = 'Open' "
			 	+ "GROUP BY ol.listID "
			 	+ "HAVING userBid < cl.startingPrice";
		PreparedStatement ps = con.prepareStatement(selectQuery);
		ps.setString(1, username);
		ResultSet outBid = ps.executeQuery();
		
		
		selectQuery = "SELECT cl.name, cl.brand, cl.startingPrice, MAX(ab.bidLimit) as limitNum, cl.listID "
				+ "FROM places p "
				+ "INNER JOIN onListing ol ON ol.bidID = p.bidID " 
				+ "INNER JOIN bids b ON b.bidID = ol.bidID "
				+ "INNER JOIN createListing cl ON cl.listID = ol.listID "
				+ "INNER JOIN autoBids ab ON ab.username = p.username " 
				+ "WHERE p.username = ? AND cl.status = 'Open' "
				+ "GROUP BY ol.listID "
				+ "HAVING cl.startingPrice > limitNum";
		PreparedStatement ps2 = con.prepareStatement(selectQuery);
		ps2.setString(1, username);
		ResultSet limitUnder = ps2.executeQuery();
		
		
		selectQuery = "SELECT cl.name, cl.brand, cl.listID "
				+ "FROM places p "
				+ "INNER JOIN onListing ol ON ol.bidID = p.bidID "
				+ "INNER JOIN bids b ON b.bidID = ol.bidID "
				+ "INNER JOIN createListing cl ON cl.listID = ol.listID "
				+ "WHERE cl.status = 'Closed' "
				+ "AND ((cl.minPrice > 0 AND b.price > cl.minPrice) "
				+ "OR (cl.minPrice = 0 AND b.price = (SELECT MAX(price) FROM bids WHERE bidID = ol.bidID))) "
				+ "AND p.username = ? "
				+ "GROUP BY ol.listID";
		PreparedStatement ps3 = con.prepareStatement(selectQuery);
		ps3.setString(1, username);
		ResultSet winner = ps3.executeQuery();
		
		
		selectQuery = "SELECT cl.name, cl.brand, cl.startingPrice, MAX(b.price) as userBid, cl.listID "
				+ "FROM places p "
				+ "INNER JOIN onListing ol ON ol.bidID = p.bidID "
				+ "INNER JOIN bids b ON b.bidID = ol.bidID "  
				+ "INNER JOIN createListing cl ON cl.listID = ol.listID "
			 	+ "WHERE p.username = ? AND cl.status = 'Closed' "
			 	+ "GROUP BY ol.listID "
			 	+ "HAVING userBid < cl.startingPrice";
		PreparedStatement ps4 = con.prepareStatement(selectQuery);
		ps4.setString(1, username);
		ResultSet loser = ps4.executeQuery();
		
		
		selectQuery = "SELECT cl.brand, cl.name, cl.startingPrice, cl.listID "
				+ "FROM createListing cl " 
				+ "INNER JOIN interests i ON cl.name LIKE CONCAT('%', i.interests, '%') "
				+ "WHERE cl.status = 'Open' AND i.username=?";
		PreparedStatement ps5 = con.prepareStatement(selectQuery);
		ps5.setString(1, username);
		ResultSet notifyInterests = ps5.executeQuery();
		
	%> 
	<div style="text-align: center">
		<h1>Hello, <%=session.getAttribute("user")%>!</h1>

		<a href="homePage.jsp">Home</a> |
		<a href="questions.jsp">Q & A</a> |
    	<a href="createListing.jsp">Create Listing</a> |
    	<a href ='interests.jsp'>Set Your Interests</a> |
    	<a href ='viewUsers.jsp'>View Other Users</a> |
    	<a href='logout.jsp'>Log out</a>
    	
	</div>
	
	<hr width="100%" size="2">
	
	<table align="center" style="width: 400px; max-width:400px; margin-top: 20px;">
		<tr>
			<td style="border: 3px solid #dddddd; text-align: center; padding: 1px;"><h3>Notifications</h3></td>
		</tr>
		<%
		while(outBid.next()){
		%>
		<tr>
			<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
			You have been out bid on the <%=outBid.getString(2) %> <%=outBid.getString(1) %> (ID: <%=outBid.getString(5) %>).
			<p>Your bid: $<%= String.format("%.2f", outBid.getDouble(4)) %> <br> Current Price: $<%= String.format("%.2f", outBid.getDouble(3)) %></p>
			</td>
		</tr>
		<% }%>
		
		<% 
		while(limitUnder.next()){ 
		%>
		<tr>
			<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
				The current bidding price on the <%=limitUnder.getString(2) %> <%=limitUnder.getString(1) %> (ID: <%=limitUnder.getString(5) %>) is greater than your bid limit.
				<p>Your Bid Limit: $<%= String.format("%.2f", limitUnder.getDouble(4)) %> <br> Current Bidding Price: $<%= String.format("%.2f", limitUnder.getDouble(3)) %></p>
			</td>
		</tr>
		<%} %>
		
		<%
		while(winner.next()){ 
		%>
		<tr>
			<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
			Congrats! You won the <%=winner.getString(2)%> <%=winner.getString(1) %> (ID: <%=winner.getString(3) %>)!
			</td>
		</tr>
		<% }%>
		
		<%
		while(loser.next()){
		%>
		<tr>
			<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
			Sorry, you lost the <%=loser.getString(2)%> <%=loser.getString(1) %> (ID: <%=loser.getString(3) %>).
			</td>
		</tr>
		<%} %>
		
		<%
		while(notifyInterests.next()){
		%>
		<tr>
			<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
			Your interest is now up for auction!
			<p><%= notifyInterests.getString(1) %> <%=notifyInterests.getString(2) %> $<%= String.format("%.2f", notifyInterests.getDouble(3)) %> (ID: <%=notifyInterests.getString(4) %>)</p>
		</tr>
		<%} %>
		
	</table>
	
	<%
	db.closeConnection(con);
	}catch (Exception e){
		out.print(e);
	}
	%>
	
</body>
</html>