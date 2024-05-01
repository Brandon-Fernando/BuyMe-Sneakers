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
	String eID = request.getParameter("employeeID");
	String pwd = request.getParameter("password");
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectDB","root", "cs336project");
	
	Statement st = con.createStatement();
	ResultSet rs;
	rs = st.executeQuery("select * from admin where adminID ='" + eID + "' and password='" + pwd + "'");
	
	
	Statement st2 = con.createStatement();
	ResultSet rs2;
	rs2 = st2.executeQuery("select * from custRep where repID ='" + eID + "' and password='" + pwd + "'");
	
	
	if (rs.next()) {
		session.setAttribute("employeeID", eID); // the username will be stored in the session
		response.sendRedirect("adminHomePage.jsp");
	}else if (rs2.next()) {
		session.setAttribute("employeeID", eID); // the username will be stored in the session
		response.sendRedirect("repHomePage.jsp");
	} else {
		out.println("Invalid username or password <a href='adminCustLogin.jsp'>try again</a>");
	} 
	
%> 





</body>
</html>