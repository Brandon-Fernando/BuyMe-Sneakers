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
	<div style="text-align: center">
		<h1>Hello, <%=session.getAttribute("user")%>!</h1>

		<a href="homePage.jsp">Home</a> |
    	<a href="createListing.jsp">Create Listing</a> |
    	<a href='logout.jsp'>Log out</a>
	</div>
	
	<hr width="100%" size="2">
	
	<h3 style="text-align: center">Notifications</h3>
</body>
</html>