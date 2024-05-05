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
	
	<%
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
	
		String username = request.getParameter("username");
		String updatedPassword = request.getParameter("password");
		
		
		String query = "SELECT password, email FROM users WHERE username=?";
		PreparedStatement ps = con.prepareStatement(query);
		ps.setString(1, username);
		ResultSet getInfo = ps.executeQuery();
		
		
		
	%>
	
	<div style="text-align: center">
		<h1>Viewing <%=username %>'s Account</h1>
		<a href="editAccounts.jsp">Back</a>
	</div>
	
	
	<hr width="100%" size="2">
	
	
	<div style="text-align: center">
		
		Current Username: <strong><%=username %></strong>
		<br>
		<%while(getInfo.next()){ %>
			 Current Email: <strong><%=getInfo.getString(2) %></strong> <br>
			 
			 <%if(updatedPassword == null || updatedPassword.equals("")){ %>
				Current Password: <strong><%=getInfo.getString(1) %></strong>
		<%}else{ %> 
				Current Password: <strong><%=updatedPassword %></strong>
		<%}
		}%>
	</div>
	<br>
	<br>
	<div style="text-align: center">
		<form action="checkEditAccount.jsp?username=<%=username %>" method="POST">
			Update Username: <input type="text" name="newUsername"><input type="submit" value="Update">
			<br> <br>
			Update Email: <input type="email" name="newEmail"><input type="submit" value="Update">
			<br> <br>
			Update Password: <input type="text" name="newPassword"><input type="submit" value="Update">
		</form>
	</div>
	
	<br>
	
	<div style="text-align: center">
		<table align="center" style="width: 400px; max-width: 400px; margin-top: 20px; border-collapse: collapse;">
			<tr>
				<td style="border: 3px solid #dddddd; text-align: center; padding: 1px;">
					<h2>Delete Account</h2>
					<h4>(THIS CANNOT BE UNDONE)</h4>
				</td>
			</tr>
			<tr>
				<td style="border: 1px solid #dddddd; text-align: center; padding: 8px;">
					<form action="checkEditAccount.jsp?username=<%=username %>" method="post">
						<input type="hidden" name="delete" value="true">
						<button type="submit">DELETE USER</button>
					</form>
				</td>
		</table>
	</div>
	
	
	
	
	
	
	<%db.closeConnection(con);
	}catch(Exception e){
	out.print(e);
	}%>
	
	
	

</body>
</html>