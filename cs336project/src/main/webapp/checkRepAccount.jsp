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
	
	String repID = request.getParameter("repID");
	String password = request.getParameter("repPassword");
	
	String insertQuery = "INSERT INTO custRep(repID, password) VALUES(?, ?)";
	PreparedStatement ps = con.prepareStatement(insertQuery);
	ps.setString(1, repID);
	ps.setString(2, password);
	ps.executeUpdate();
	response.sendRedirect("createRep.jsp");
	

} catch(SQLException e){
	out.print(e);
}
%>





</body>
</html>