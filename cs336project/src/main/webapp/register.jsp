<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Register Form</title>
	</head>
<body>
	<div style="text-align: center">
		<h1>Create Account</h1>
		<form action="registerAccount.jsp" method="POST">
			Email: <input type="email" name="email" required> <br>
			Username: <input type="text" name="username" required/> <br/>
			Password:<input type="password" name="password" required/> <br/>
			<input type="submit" value="Register" style="width: 16%"/>
		</form>
		<br>
		<a href="login.jsp">Back</a>
	</div>
	
</body>
</html>