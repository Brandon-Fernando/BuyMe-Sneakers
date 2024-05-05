<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Login Form</title>
	</head>
<body>
	<div style="text-align: center">
			<h1>Login</h1>
			<form action="checkLoginDetails.jsp" method="POST">
				Username or Email: <input type="text" name="username"/> <br/>
				Password:<input type="password" name="password"/> <br/>
				<input type="submit" value="Login"  style="width: 16%"/>
			</form>
			
			<p>Don't have an account? <a href='register.jsp'>Register</a></p>
			
		<p> Administrative Staff Member/Customer Representatives <a href="adminCustLogin.jsp">Log In</a>
		
		
		
	
	</div>
	
	
</body>
</html>