<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%@ page import ="java.sql.*" %>
	<%try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		String bidID = request.getParameter("bidID");
		String user = request.getParameter("username");
		String deleteBid = request.getParameter("deleteBid");
		String deleteListing = request.getParameter("deleteListing");
		String listID = request.getParameter("listID");
		
		String ogPriceQuery = "SELECT originalPrice FROM createListing WHERE listID=?";
		PreparedStatement psOG = con.prepareStatement(ogPriceQuery);
		psOG.setString(1, listID);
		ResultSet getOGPrice = psOG.executeQuery();
		
		Double originalPrice = null;
		while(getOGPrice.next()){
			originalPrice = getOGPrice.getDouble(1);
		}
		
		
		
		if(deleteListing != null && deleteListing.equals("true")){
			String deleteListingQuery = "DELETE FROM createListing WHERE listID=?";
			PreparedStatement ps = con.prepareStatement(deleteListingQuery);
			ps.setString(1, listID);
			ps.executeUpdate(); 
			response.sendRedirect("editListingsBids.jsp");
		}
		
		if(deleteBid != null && deleteBid.equals("true")){
			String deleteBidQuery = "DELETE FROM bids WHERE bidID=?";
			PreparedStatement ps = con.prepareStatement(deleteBidQuery);
			ps.setString(1, bidID);
			ps.executeUpdate(); 
			
			String highestBidQuery = "SELECT MAX(b.price) "
					+ "FROM bids b "
					+ "INNER JOIN onListing ol ON ol.bidID = b.bidID "
					+ "WHERE listID=?";
			PreparedStatement ps2 = con.prepareStatement(highestBidQuery);
			ps2.setString(1, listID);
			ResultSet getNewPrice = ps2.executeQuery();
			
			Double newPrice = null;
			if(getNewPrice.next()){
				newPrice = getNewPrice.getDouble(1);
			}
			
			if(newPrice == null){
				String updateCurrentPrice = "UPDATE createListing SET startingPrice=? WHERE listID=?";
				PreparedStatement ps3 = con.prepareStatement(updateCurrentPrice);
				ps3.setDouble(1, originalPrice);
				ps3.setString(2, listID);
				ps3.executeUpdate();
				
				
			}else{
				String updateCurrentPrice = "UPDATE createListing SET startingPrice=? WHERE listID=?";
				PreparedStatement ps3 = con.prepareStatement(updateCurrentPrice);
				ps3.setDouble(1, newPrice);
				ps3.setString(2, listID);
				ps3.executeUpdate();
			}
			
			
		}
		response.sendRedirect("viewEditListingsBids.jsp?username="+user+"&listID="+listID+"&originalPrice="+originalPrice);
	%>
	
		
	<%
		db.closeConnection(con);
	}catch(Exception e){
		out.print(e);
	}
	%>
	
	



</body>
</html>