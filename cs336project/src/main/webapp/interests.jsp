<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Timestamp" %>




<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Interests</title>

</head>
<body>
<%try{
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	
	String username = (String) session.getAttribute("user");
	
	String selectQuery = "SELECT interests FROM interests WHERE username=?";
	PreparedStatement ps = con.prepareStatement(selectQuery);
	ps.setString(1, username);
	ResultSet getInterests = ps.executeQuery();


%>
	
	<h1 style="text-align: center">Set Your Interests</h1>
	<div style="text-align: center">
		<a href="account.jsp">Back</a>
	</div>
	
	<hr width="100%" size="2">
	
	<div style="text-align: center">
		<form method="post" action="checkInterests.jsp">
			<input type="text" name="interest">
			<input type="submit" value="Add Interest">
		</form>
	</div>
	
	<table align="center" style="width: 400px; max-width:400px; margin-top: 20px;">
		<tr>
			<td style="border: 3px solid #dddddd; text-align: center; padding 1px;"><h3>Your Interests</h3></td>
		</tr>
		<%while(getInterests.next()){ %>
		<tr>
			<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
			<%= getInterests.getString(1) %></td>
		</tr>
		<%} %>
	</table>
	
	<% db.closeConnection(con);
	}catch (Exception e){
		out.print(e);
	}%>
	
    
    
	
</body>
</html>