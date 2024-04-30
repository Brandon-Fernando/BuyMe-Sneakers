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
		
		String username = (String) session.getAttribute("user");
		if(username == null){
			response.sendRedirect("login.jsp");
		}
		String listID = request.getParameter("listID");
		String bid = request.getParameter("bidAmount");
		
		if (bid == null || bid.trim().isEmpty()) {
            response.sendRedirect("viewListing.jsp?listID=" + listID + "&error=emptyBid");
            return; // Stop further execution
        }
		
		String selectQuery = "SELECT startingPrice FROM createListing WHERE listID = ?";
		PreparedStatement ps = con.prepareStatement(selectQuery);
		ps.setString(1, listID);
		ResultSet getPrice = ps.executeQuery();
		getPrice.next();
		String price = getPrice.getString(1);
		
		Double bidAmount = Double.parseDouble(bid);
		Double currentPrice = Double.parseDouble(price);
		
		
		String autoBidQuery = "SELECT * FROM autoBids WHERE listID = ?";
		PreparedStatement ps2 = con.prepareStatement(autoBidQuery);
		ps2.setString(1, listID);
		ResultSet getAutoBid = ps2.executeQuery();
		
		
		if(bidAmount <= currentPrice){
			response.sendRedirect("viewListing.jsp?listID=" + listID + "&error=smallerBid");
            return; // Stop further execution
		}else{
			if(getAutoBid.next()){ //check if there exists an autobid for this listing
			double autoBidLimit = getAutoBid.getDouble("bidLimit");
			double autoBidIncrement = getAutoBid.getDouble("increment");
				
			String autoBidUser = getAutoBid.getString("username");
			
			if(bidAmount < autoBidLimit){ //add regular bid and then add the autobid
				
				//add regular bid
				String insert = "UPDATE createListing SET startingPrice = " + bidAmount + 
				" WHERE listID = " + listID;
				PreparedStatement ps3 = con.prepareStatement(insert);
				ps3.executeUpdate();
				
				
				insert = "INSERT INTO bids(price, dateTime)" + "VALUES(?, ?)";
				PreparedStatement ps4 = con.prepareStatement(insert);
				ps4.setDouble(1, bidAmount);
				ps4.setTimestamp(2, new Timestamp(new java.util.Date().getTime()));
				ps4.executeUpdate();
				
				
				insert = "INSERT INTO onListing(bidID, listID)"
						+ "VALUES((SELECT MAX(bidID) FROM bids), ?)";
				PreparedStatement ps5 = con.prepareStatement(insert);
				ps5.setString(1, listID);
				ps5.executeUpdate();
				
				
				insert = "INSERT INTO places(bidID, username)"
						+ "VALUES((SELECT MAX(bidID) FROM bids), ?)";
				PreparedStatement ps6 = con.prepareStatement(insert);
				ps6.setString(1, username);
				ps6.executeUpdate();
				
				
				
				//add autobid
				String selectNewPrice = "SELECT startingPrice FROM createListing WHERE listID = ?";
				PreparedStatement ps7 = con.prepareStatement(selectNewPrice);
				ps7.setString(1, listID);
				ResultSet getNewPrice = ps7.executeQuery();
				getNewPrice.next();
				
				double newPrice = getNewPrice.getDouble(1);
				double newAutoBidAmount = newPrice + autoBidIncrement;
				
				insert = "UPDATE createListing SET startingPrice = " + newAutoBidAmount + 
						" WHERE listID = " + listID;
				PreparedStatement ps8 = con.prepareStatement(insert);
				ps8.executeUpdate();
				
				
				insert = "INSERT INTO bids(price, dateTime)" + "VALUES(?, ?)";
				PreparedStatement ps9 = con.prepareStatement(insert);
				ps9.setDouble(1, newAutoBidAmount);
				ps9.setTimestamp(2, new Timestamp(new java.util.Date().getTime()));
				ps9.executeUpdate();
				
				
				insert = "INSERT INTO onListing(bidID, listID)"
						+ "VALUES((SELECT MAX(bidID) FROM bids), ?)";
				PreparedStatement ps10 = con.prepareStatement(insert);
				ps10.setString(1, listID);
				ps10.executeUpdate();
				
				
				insert = "INSERT INTO places(bidID, username)" 
						+ "VALUES((SELECT MAX(bidID) FROM bids), ?)";
				PreparedStatement ps11 = con.prepareStatement(insert);
				ps11.setString(1, autoBidUser);
				ps11.executeUpdate();
				
				//let autobid user know that its bid was outbid
				
				response.sendRedirect("viewListing.jsp?listID=" + listID);
			
				
			}else{ // if the bid is greater than the limit than the autobid cannot happen and so you add the regular bid
				//add regular bid
				String insert = "UPDATE createListing SET startingPrice = " + bidAmount + 
				" WHERE listID = " + listID;
				PreparedStatement ps12 = con.prepareStatement(insert);
				ps12.executeUpdate();
				
				
				insert = "INSERT INTO bids(price, dateTime)" + "VALUES(?, ?)";
				PreparedStatement ps13 = con.prepareStatement(insert);
				ps13.setDouble(1, bidAmount);
				ps13.setTimestamp(2, new Timestamp(new java.util.Date().getTime()));
				ps13.executeUpdate();
				
				
				insert = "INSERT INTO onListing(bidID, listID)"
						+ "VALUES((SELECT MAX(bidID) FROM bids), ?)";
				PreparedStatement ps14 = con.prepareStatement(insert);
				ps14.setString(1, listID);
				ps14.executeUpdate();
				
				
				insert = "INSERT INTO places(bidID, username)"
						+ "VALUES((SELECT MAX(bidID) FROM bids), ?)";
				PreparedStatement ps15 = con.prepareStatement(insert);
				ps15.setString(1, username);
				ps15.executeUpdate();
				
				
				response.sendRedirect("viewListing.jsp?listID=" + listID);
			}
			
			
		}else{ // if there is no autobid then you add the regular bid 
			//add regular bid
			String insert = "UPDATE createListing SET startingPrice = " + bidAmount + 
			" WHERE listID = " + listID;
			PreparedStatement ps16 = con.prepareStatement(insert);
			ps16.executeUpdate();
			
			
			insert = "INSERT INTO bids(price, dateTime)" + "VALUES(?, ?)";
			PreparedStatement ps17 = con.prepareStatement(insert);
			ps17.setDouble(1, bidAmount);
			ps17.setTimestamp(2, new Timestamp(new java.util.Date().getTime()));
			ps17.executeUpdate();
			
			
			insert = "INSERT INTO onListing(bidID, listID)"
					+ "VALUES((SELECT MAX(bidID) FROM bids), ?)";
			PreparedStatement ps18 = con.prepareStatement(insert);
			ps18.setString(1, listID);
			ps18.executeUpdate();
			
			
			insert = "INSERT INTO places(bidID, username)"
					+ "VALUES((SELECT MAX(bidID) FROM bids), ?)";
			PreparedStatement ps19 = con.prepareStatement(insert);
			ps19.setString(1, username);
			ps19.executeUpdate();
			
			
			response.sendRedirect("viewListing.jsp?listID=" + listID);
		}
	}
		
		
	} catch(SQLException e){
		out.print(e);
	}
	%>
	
	
</body>
</html>