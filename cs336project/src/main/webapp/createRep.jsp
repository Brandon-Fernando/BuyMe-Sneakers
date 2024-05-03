<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create Customer Representative</title>
</head>
<body>
	<h1 style="text-align: center">Create Customer Representative Accounts</h1>
	<nav style="text-align: center">
		<a href="adminHomePage.jsp">Home</a> |
		<a href="questions.jsp">Q & A</a> |
		<a href="createRep.jsp">Create Customer Representative Accounts</a> |
		<a href="adminHomePage.jsp">Generate Sales Report</a> |
		<a href="logout.jsp">Log Out</a>
	</nav>
	
	<hr width="100%" size="2">
	
	<%
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		
		String selectQuery = "SELECT * FROM custRep";
		PreparedStatement ps = con.prepareStatement(selectQuery);
		ResultSet getReps = ps.executeQuery();
	
	
	%>
	
	
	<div style="text-align: center">
		<form method="post" action="checkRepAccount.jsp">
			Rep ID: <input type="text" name="repID"> 
			<br>
			Password: <input type="text" name="repPassword">
			<br>
			<input type="submit" value="Create Account" style="width: 16%">
		</form>
	</div>
	
	<br>
	
	<div style="text-align: center">
		<table align="center" style="width: 400px; max-width: 400px; margin-top: 20px;">
			<tr>
				<td style="border: 3px solid #dddddd; text-align: center; padding: 1px;">
					<h3>Customer Representative Accounts</h3>
				</td>
			</tr>
			<%while(getReps.next()){ %>
			<tr>
				<td style="border: 1px solid #dddddd; text-align: center; padding: 1px;">
					Rep ID: <%=getReps.getString(1) %> <br>
					Password: <%=getReps.getString(2) %>
				</td>
			</tr>
			<%} %>
		</table>
		
	</div>
	
	<%db.closeConnection(con);
	}catch (Exception e){
		out.print(e);
	}%>
	

</body>
</html>