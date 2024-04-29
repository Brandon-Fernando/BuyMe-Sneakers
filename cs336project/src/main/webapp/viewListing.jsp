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
	<h1 style="text-align: center">BuyMe Sneakers</h1> 
	<nav style="text-align: center">
		<a href="homePage.jsp">Home</a> |
    	<a href="nike.jsp">Nike Shoes</a> |
    	<a href="adidas.jsp">Adidas Shoes</a> |
    	<a href="homePage.jsp">Jordan Shoes</a> |
    	<a href="account.jsp">Account</a> 
    	
    </nav>
    
    <hr width="100%" size = "2">
	<%try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		
		String listID = request.getParameter("listID");
		String currentUser = (String) session.getAttribute("user");
		
		String listingQuery = "SELECT * FROM createListing WHERE listID=?";
		PreparedStatement ps = con.prepareStatement(listingQuery);
		ps.setString(1, listID);
		ResultSet getListing = ps.executeQuery();
		
		String name = null; //2
		String brand = null; //3
		String gender = null; //4
		Double size = null; //5
		Double price = null; //6
		Double minPrice = null; //7
		String closingDate = null; //8
		String status = null; //9
		
		String userQuery = "SELECT username FROM userPosts WHERE listID=?";
		PreparedStatement ps2 = con.prepareStatement(userQuery);
		ps2.setString(1, listID);
		ResultSet getUser = ps2.executeQuery();
		
		String username = null;
		
		
		while(getListing.next()){
			name = getListing.getString(2);
			brand = getListing.getString(3);
			gender = getListing.getString(4);
			size = getListing.getDouble(5);
			price = getListing.getDouble(6);
			minPrice = getListing.getDouble(7);
			closingDate = getListing.getString(8);
			status = getListing.getString(9);
		}
		
		while(getUser.next()){
			username = getUser.getString(1);
		}
		
		%>
		<div style="text-align: center">
			<h1 style="margin: 0;"><%= brand %> <%= name %></h1>
			<h5 style="margin: 5px 0;">Posted By: <%=username %></h5>
			<h5 style="margin: 5px 0;"><%= gender %> Size <%= size %></h5>
			
			
			<% if(status.equals("Open")) { %>
				<h3 style="margin: 5px 0;">Current Price: $<%= String.format("%.2f", price) %></h3>
			<%} 
			
				if(!username.equals(currentUser)){
					if(status.equals("Open")){
			%>
			<br>
			<br>
			<h2 style="text-align: center">Place a bid</h2>
   			<div style="text-align: center">
   				<form method="post" action="checkBid.jsp">
   				<table align="center">
   					<input type="hidden" name="listID" value="<%= listID %>">
   					<input type="hidden" name="price" value="<%= price %>">
   					<tr>
   						<td>Bid Amount</td><td><input type="number" name="bidAmount" min="0.01" value="0" step="0.01"></td>
   					</tr>
   			
   					<tr>
						<td colspan="2" style="text-align: center"><input type="submit" value="Set Bid" style="width: 100%"></td>
					</tr>
   				</table>
   				</form>
   				<%
   					String error = request.getParameter("error");
   					if(error != null && error.equals("emptyBid")){
  				%>
   					<div style="text-align: center; color: red; margin-bottom: 10px;">Please input a value for bid.</div>
   				<% 
   					}else if(error != null && error.equals("smallerBid")){
   				%>
   					<div style="text-align: center; color: red; margin-bottom: 10px;">Please input a bid greater than the current price.</div>
   				<%
   					}
   				%>
   			<br>
   		    <h2 style="text-align: center">Place an automatic bid</h2>
			
			<form method="post" action="checkAutoBid.jsp" style="text-align:center">
			   	<table align="center">
			   		<input type="hidden" name="listID" value="<%= listID %>">
   					<input type="hidden" name="price" value="<%= price %>">
			   		
			   		<tr>
			   			<td>Bid Limit</td><td><input type="number" name="bidLimit"></td>
			   		</tr>
			   			
			   		<tr>
			   			<td>Increment</td><td><input type="number" name="increment"></td>
			   		</tr>
			   			
			   		<tr>
						<td colspan="2" style="text-align: center"><input type="submit" value="Set Automatic Bid" style="width: 100%"></td>
					</tr>
			   	</table>
			   	</form>
			   </div>
   			   <%
			   		if(error != null && error.equals("emptyBidLimit")){
			   %>
			   		<div style="text-align: center; color: red; margin-bottom: 10px;">Please input a value for bid limit.</div>
			   <%
			   		}else if(error != null && error.equals("emptyIncrement")){
			   %>
			   		<div style="text-align: center; color: red; margin-bottom: 10px;">Please input a value for increment.</div>
			   <% 
			   		}else if(error != null && error.equals("smallerLimit")){
			   %>
			   		<div style="text-align: center; color: red; margin-bottom: 10px;">Please input a limit greater than the current price.</div>
			   <% 
			   		}
					}
				}
   			   
			   %>
			   
   			</div>	
   			
   			
   			<div style="text-align: center">
   				<%if(status.equals("Closed") && price >= minPrice){ %>
   					<br>
   					<h2 style="color: red; margin: 0;">ITEM SOLD</h2>
   					<h5 style="margin: 5px 0;">Final Price: $<%=price %></h5>
   				<%} else if(status.equals("Closed")){%>
   					<br>
   					<h2 style="color: red; margin: 0;">ITEM CLOSED</h2>
   					<h5 style="margin: 5px 0;"> No Winners</h5>
   					<h5 style="margin: 5px 0;"> Minimum Price: $<%=minPrice %> </h5>
   				<%} %>
   			</div>
   			
   			
   			<br>
   			<div style="text-align: center">
   			<h2>Bid History</h2>
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
   			<table style="border-collapse: collapse; width: 50%" align="center">
		   		<tr>
		   			<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Bidder</td>
		   			<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Bid Price</td>
		   			<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Placed On</td>
		   		</tr>
		   		<%while(bidHist.next()){ %>
		   		<tr><td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= bidHist.getString("username") %></td>
		   			<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= String.format("%.2f", bidHist.getDouble("price")) %></td>
		   			<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= bidHist.getString("dateTime") %></td>
		   		</tr>
		   		<%} %>
		   		</table>
   			</div>
			
			
			<br>
			<div style="text-align:center">
				<h2>Similar Items</h2>
			<%
				String similarQuery = "SELECT * from createListing WHERE listID !=? AND brand=?";
				PreparedStatement ps4 = con.prepareStatement(similarQuery);
				ps4.setString(1, listID);
				ps4.setString(2, brand);
				ResultSet simItems = ps4.executeQuery();
			%>
				<table style="border-collapse: collapse; width: 100%">
			 	<tr> 
			 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;"></td>
			 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Name</td>
			 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Brand</td>
			 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Gender</td>
			 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Size</td>
			 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Starting Price</td>
			 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Closing Date and Time</td>
			 	</tr>
			 	<%while(simItems.next()){ %>
			 	<tr>
			 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><a href="viewListing.jsp?listID=<%= simItems.getInt("listID") %>">View</a></td>
			 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("name")%></td>
			 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("brand")%></td>
			 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("gender")%></td>
			 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("size")%></td>
			 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("startingPrice")%></td>
			 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("closingDateTime")%></td>
			 	</tr>
		 	<%} %>
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