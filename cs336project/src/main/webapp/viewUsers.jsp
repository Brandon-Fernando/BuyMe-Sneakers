<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Timestamp" %>




<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>View Users</title>

</head>
<body>

	<h1 style="text-align: center">View Other Users</h1>
	<div style="text-align: center">
		<a href="account.jsp">Back</a>
	</div>
	
	<hr width="100%" size="2">
	
	<div style="text-align: center">
		<form method="post" action="viewUsers.jsp">
			<input type="text" name="searchUsers">
			<input type="submit" value="Search User">
		</form>
	</div>
	
<%try{
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	
	String userSearch = request.getParameter("searchUsers");
	
	String selectListings = "SELECT cl.name, cl.listID, cl.brand, cl.status "
			+ "FROM createListing cl "
			+ "INNER JOIN userPosts up ON up.listID = cl.listID "
			+ "WHERE up.username = ?";
	PreparedStatement ps = con.prepareStatement(selectListings);
	ps.setString(1, userSearch);
	ResultSet userListings = ps.executeQuery();
	
	
	String selectBiddings = "SELECT cl.name, b.price, b.dateTime, cl.brand, cl.listID "
			+ "FROM bids b "
			+ "INNER JOIN onListing ol ON ol.bidID = b.bidID " 
			+ "INNER JOIN places p ON p.bidID = b.bidID "
			+ "INNER JOIN createListing cl ON cl.listID = ol.listID "
			+ "WHERE p.username = ?";
	PreparedStatement ps2 = con.prepareStatement(selectBiddings);
	ps2.setString(1, userSearch);
	ResultSet userBiddings = ps2.executeQuery();
	

%>
	
	
	<% if(userSearch != null){ %>
		<h2 style="text-align: center">You Are Viewing <%= userSearch %>'s Activity</h2>
	
	
	<div style="text-align: center">
		<table align="center" style="width: 400px; max-width: 400px; margin-top: 20px;">
			<tr>
				<td style="border: 3px solid #dddddd; text-align: center; padding: 1px;"><h3>User's Listing History</h3></td>
			</tr>
			
			<%while(userListings.next()){ %>
			<tr>
				<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
					<a href="viewListing.jsp?listID=<%= userListings.getInt(2) %>&brand=<%= userListings.getString(3) %>">
					<%=userListings.getString(3)%> <%=userListings.getString(1) %>
					</a> (<%=userListings.getString(4) %>)
				</td>
			</tr>
			<%}%>
		</table>
	</div>
	
	<br>
	
	<div style="text-align: center">
		<table align="center" style="width: 400px; max-width: 400px; margin-top: 20px;">
			<tr>
				<td style="border: 3px solid #dddddd; text-align: center; padding: 1px;"><h3>User's Bidding History</h3></td>
			</tr>
			<%while(userBiddings.next()){ %>
			<tr>
				<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
					<%=userSearch %> bid <strong>$<%=userBiddings.getString(2) %></strong> on <a href="viewListing.jsp?listID=<%= userBiddings.getInt(5) %>&brand=<%= userBiddings.getString(4) %>">
					<%=userBiddings.getString(4) %> <%=userBiddings.getString(1) %>
					</a> on <%=userBiddings.getString(3) %>.
				</td>
			</tr>
			<%}
			}%>
		</table>
	</div>

<% }catch(Exception e){
	 	out.print(e);
	 	}%>
	
    
    
	
</body>
</html>