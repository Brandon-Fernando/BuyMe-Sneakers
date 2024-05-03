<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>View Listing</title>
	
</head>
<body>
	<div style="text-align: center">
		<h1>Edit Listings and Bids</h1>
		<a href="editListingsBids.jsp">Back</a>
	</div>
	
	<hr width="100%" size="2">
	
	<%
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		String listID = request.getParameter("listID");
		String postedBy = request.getParameter("username");
		
		String ogPriceString = request.getParameter("originalPrice");
		Double ogPrice = null;
		if(ogPriceString != null && !ogPriceString.isEmpty()) {
		 	ogPrice = Double.parseDouble(ogPriceString);
		}
		
		
		
		String listingQuery = "SELECT * FROM createListing WHERE listID=?";
		PreparedStatement ps = con.prepareStatement(listingQuery);
		ps.setString(1, listID);
		ResultSet getListing = ps.executeQuery();
		
		
		String name = null; //2
		String brand = null; //3
		Double price = null; //6

		while(getListing.next()){
			name = getListing.getString(2);
			brand = getListing.getString(3);
			price = getListing.getDouble(6);
			
		}
		
		
		
	%>
	
	<div style="text-align: center">
			<h1 style="margin: 0;"><%= brand %> <%= name %></h1>
			<h5 style="margin: 5px 0;">Posted By: <%=postedBy %></h5>
			<%if(ogPrice == null){ %>
				<h3 style="margin: 5px 0;">Current Price: $<%= String.format("%.2f", price) %></h3>
			<%}else{ %>
				<h3 style="margin: 5px 0;">Current Price: $<%= String.format("%.2f", ogPrice) %></h3>
			<%} %>
	</div>
	

	
	
	
	<br>
	<br>
	
	<div style="text-align:center">
	<h2>Edit/Delete Bids</h2>
   			<%
   				String historyQuery = "Select b.bidID, b.price, p.username, b.dateTime, ol.listID " +
   					"FROM bids b " + 
   					"LEFT JOIN onListing ol ON ol.bidID = b.bidID " +
   					"LEFT JOIN places p ON p.bidID = b.bidID " + 
   					"WHERE ol.listID = ?";
   				PreparedStatement ps3 = con.prepareStatement(historyQuery);
   				ps3.setString(1, listID);
   				ResultSet bidHist = ps3.executeQuery();
   				
   				
   			
   				
   			%>
   			<div style="margin-left:auto; margin-right:0;">
   			<table style="border-collapse: collapse; width: 50%" align="center">
		   		<tr>
		   			<td style="border: 3px solid #dddddd; text-align: center; padding: 8px;">Bidder</td>
		   			<td style="border: 3px solid #dddddd; text-align: center; padding: 8px;">Bid Price</td>
		   			<td style="border: 3px solid #dddddd; text-align: center; padding: 8px;">Placed On</td>
		   			<td style="border: 3px solid #dddddd; text-align: center; padding: 2px;">Delete (CANNOT BE UNDONE)</td>
		   		</tr>
		   		<%while(bidHist.next()){ %>
		   		<tr><td style="border: 1px solid #dddddd; text-align: center; padding: 8px;"><%= bidHist.getString("username") %></td>
		   			<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;"><%= String.format("%.2f", bidHist.getDouble("price")) %> </td>
		   			<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;"><%= bidHist.getString("dateTime") %></td>
		   			
		   			<td style="border: 1px solid #dddddd; text-align: center; padding: 1px;">
		   				<form method="post" action="checkEditListingsBids.jsp?bidID=<%=bidHist.getString("bidID") %>&username=<%= postedBy%>&listID=<%=listID%>">
			   				<input type="hidden" name="deleteBid" value="true">
			   				<button type="submit">DELETE BID</button>
		   				</form>
		   				
		   			</td>
		   		</tr>
		   		<%} %>
		   		</table>
		   		</div>
   			</div>
	
	
	<br>
	<br>
	
	<div style="text-align: center">
		<table align="center" style="width: 400px; max-width: 400px; margin-top: 20px; border-collapse: collapse;">
			<tr>
				<td style="border: 3px solid #dddddd; text-align: center; padding: 1px;">
					<h2>Delete Listing</h2>
					<h4>(THIS CANNOT BE UNDONE)</h4>
				</td>
			</tr>
			<tr>
				<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
					<form action="checkEditListingsBids.jsp?listID=<%=listID %>" method="post">
						<input type="hidden" name="deleteListing" value="true">
						<button type="submit">DELETE LISTING</button>
					</form>
				</td>
		</table>
	</div>
	
	
	
	<%
	
	db.closeConnection(con);
	}catch(Exception e){
		out.print(e);
	}
	
		%>
	
	

</body>
</html>