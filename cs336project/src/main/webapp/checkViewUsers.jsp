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
	
	String username = (String) session.getAttribute("user");
	if(username == null){
		response.sendRedirect("login.jsp");
	}
	String interest = request.getParameter("interest");
	
	String insertQuery = "INSERT INTO interests(username, interests) VALUES(?, ?)";
	PreparedStatement ps = con.prepareStatement(insertQuery);
	ps.setString(1, username);
	ps.setString(2, interest);
	ps.executeUpdate();
	response.sendRedirect("interests.jsp");
	

} catch(SQLException e){
	out.print(e);
}
%>





</body>
</html>