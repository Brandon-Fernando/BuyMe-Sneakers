<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.Timestamp" %>




<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Accounts</title>

</head>
<body>
	<%
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		String query = "SELECT username FROM users";
		PreparedStatement ps = con.prepareStatement(query);
		ResultSet getUsers = ps.executeQuery();
	
	%>
	<div style="text-align: center">
		<h1>Edit User Accounts</h1>
		<a href="repHomePage.jsp">Back</a>
	</div>
	
	
	<hr width="100%" size="2">
	
	
	<div style="text-align: center">
		<table align="center" style="width: 400px; max-width: 400px; margin-top: 20px; border-collapse: collapse;">
			<tr>
				<td style="border: 3px solid #dddddd; text-align: center; padding: 1px;"><h2>All Users</h2></td>
			</tr>
			
		</table>
		
		<table align="center" style="width: 400px; max-width: 400px; border-collapse: collapse;">
			<%while(getUsers.next()){ %>
				<tr>
					<td style="border: 1px solid #dddddd; text-align: center; padding: 1px;">
						<a href="viewEditAccounts.jsp?username=<%= getUsers.getString(1) %>">Edit</a>
					</td>
					
					<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
					<%=getUsers.getString(1) %>
					</td>
				</tr>
			<%} %>
		</table>
	</div>
	
	<%db.closeConnection(con);
	}catch(Exception e){
		out.print(e);
	}%>
	
	
	
	
	
	
	
   
    
    
    
	
</body>
</html>