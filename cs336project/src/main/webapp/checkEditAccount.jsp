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
	<%
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
	
		String oldUsername = request.getParameter("username");
		String newUsername = request.getParameter("newUsername");
		String newPassword = request.getParameter("newPassword");
		String newEmail = request.getParameter("newEmail");
		String delete = request.getParameter("delete");
		
		
		if(delete != null && delete.equals("true")){
			String deleteBidQuery = "DELETE FROM bids WHERE bidID=("
					+ "SELECT p.bidID "
					+ "FROM places p "
					+ "WHERE username=?)";
			PreparedStatement ps2 = con.prepareStatement(deleteBidQuery);
			ps2.setString(1, oldUsername);
			ps2.executeUpdate(); 
			
			
			String deleteQuery = "DELETE FROM users WHERE username=?";
			PreparedStatement ps = con.prepareStatement(deleteQuery);
			ps.setString(1, oldUsername);
			ps.executeUpdate();
			
			
			
						
			
		}else{
			if(newPassword != null && !newPassword.isBlank()){
				String updateQuery = "UPDATE users SET password=? WHERE username=?";
				PreparedStatement ps = con.prepareStatement(updateQuery);
				ps.setString(1, newPassword);
				ps.setString(2, oldUsername);
				ps.executeUpdate();
				
				response.sendRedirect("viewEditAccounts.jsp?password="+newPassword+"&username="+oldUsername);
			}
			
			if(newUsername != null && !newUsername.isBlank()){
				String updateQuery = "UPDATE users SET username=? WHERE username=?";
				PreparedStatement ps = con.prepareStatement(updateQuery);
				ps.setString(1, newUsername);
				ps.setString(2, oldUsername);
				ps.executeUpdate();
				
				response.sendRedirect("viewEditAccounts.jsp?username=" +newUsername);
				
			}
			
			if(newEmail != null && !newEmail.isBlank()){
				String updateQuery = "UPDATE users SET email=? WHERE username=?";
				PreparedStatement ps = con.prepareStatement(updateQuery);
				ps.setString(1, newEmail);
				ps.setString(2, oldUsername);
				ps.executeUpdate();
				
				response.sendRedirect("viewEditAccounts.jsp?username=" +oldUsername);
				
			}
			
			
			
			
			
		}
		
		response.sendRedirect("editAccounts.jsp");
		
		db.closeConnection(con);
	}catch(Exception e){
		out.print(e);
	}
	
	%>




</body>
</html>