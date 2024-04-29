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

	<%-- <%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection(); 
		String username = (String) session.getAttribute("username");
		if(username == null){
			response.sendRedirect("login.jsp");
		}
	%> --%>
	<h1 style="text-align: center">Create Listing</h1>
	<div style="text-align: center">
		<form method="post" action="checkListing.jsp" align="center">
		<table align="center">
		<tr>    
			<td>Item Name</td><td><input type="text" name="name"></td>
		</tr>
		
		<tr>
			<td>Brand</td>
			<td>
				<select name="brand">
					<option value="Blank1">---</option>
					<option value="Nike">Nike</option>
					<option value="Adidas">Adidas</option>
					<option value="Jordan">Jordan</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<td>Gender</td>
			<td> 
				<select name="gender">
					<option value="Blank">---</option>
					<option value="Mens">Mens</option>
					<option value="Womens">Womens</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<td>Size</td>
			<td> 
				<select name="size"> 
					<option value="Blank2">---</option>
					<option value="4">4</option>
					<option value="4.5">4.5</option>
					<option value="5">5</option>
					<option value="5.5">5.5</option>
					<option value="6">6</option>
					<option value="6.5">6.5</option>
					<option value="7">7</option>
					<option value="7.5">7.5</option>
					<option value="8">8</option>
					<option value="8.5">8.5</option>
					<option value="9">9</option>
					<option value="9.5">9.5</option>
					<option value="10">10</option>
					<option value="10.5">10.5</option>
					<option value="11">11</option>
					<option value="11.5">11.5</option>
					<option value="12">12</option>
					<option value="13">13</option>
					<option value="14">14</option>
					<option value="15">15</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<td>Starting Price</td><td><input type="number" name="price" min="0.01" value="0" step="0.01"></td>
		</tr>
		
		<tr>
			<td>Minimum Price (hidden and optional)</td><td><input type="number" name="minPrice" min="0" value="0" step="0.01"></td>
		</tr>
		
		<tr>
			<td>Closing Date and Time</td>
				<td><input type="datetime-local" name="dateTime"></td>
		</tr>
		
		<tr>
			<td colspan="2" style="text-align: center"><input type="submit" value="Create Listing" style="width: 100%"></td>
		</tr>
		
		<tr>
		<%
		String error = request.getParameter("error");
		if(error != null && error.equals("empty")){
		%>
		<td colspan="2" style="text-align: center"><div style="color: red;">Please fill out all fields.</div></td>
		<%
		}	
		%>
		</tr>
		
		<tr>
			<td colspan="2" style="text-align: center"><a href="account.jsp">Back</a>
		</tr>
		</table>
		</form>
		
		
	</div>

</body>
</html>