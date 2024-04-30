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
	try {
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		String username = (String) session.getAttribute("user");
		if(username == null){
			response.sendRedirect("login.jsp");
		}
		
		Statement stmt = con.createStatement(); 
		
		
		String newName = request.getParameter("name");
		String newBrand = request.getParameter("brand");
		String newGender = request.getParameter("gender");
		String newSize = request.getParameter("size");
		String newPrice = request.getParameter("price");
		String newMinPrice = request.getParameter("minPrice");
		String newDateTime = request.getParameter("dateTime");
		
		if(newName == null || newName.trim().isEmpty()){
			response.sendRedirect("createListing.jsp?error=empty");
			return;
		}else if(newBrand == null || newBrand.equals("Blank1")){
			response.sendRedirect("createListing.jsp?error=empty");
			return;
		}else if(newGender == null || newGender.equals("Blank")){
			response.sendRedirect("createListing.jsp?error=empty");
			return;
		}else if(newSize == null || newSize.equals("Blank2")){
			response.sendRedirect("createListing.jsp?error=empty");
			return;
		}else if(newDateTime == null || newDateTime.trim().isEmpty()){
			response.sendRedirect("createListing.jsp?error=empty");
			return;
		}
		
		String insert = "INSERT INTO createListing(name, brand, gender, size, startingPrice, minPrice, closingDateTime)"
				+ "VALUES(?, ?, ?, ?, ?, ?, ?)";
		
		PreparedStatement ps = con.prepareStatement(insert);
		
		ps.setString(1, newName);
		ps.setString(2, newBrand);
		ps.setString(3, newGender);
		ps.setString(4, newSize);
		ps.setString(5, newPrice);
		ps.setString(6, newMinPrice);
		ps.setString(7, newDateTime);
		ps.executeUpdate();
		
		String newUsername = (String) session.getAttribute("user");
		
		insert = "INSERT INTO userPosts(listID, username) " + 
		"VALUES((Select Max(listID) FROM createListing), ?)";
		ps = con.prepareStatement(insert);
		ps.setString(1, newUsername);
		ps.executeUpdate();
	
	%>
	<jsp:forward page="account.jsp">
	<jsp:param name="listingCheck" value="Listing successfully created."/> 
	</jsp:forward>
	<% 
	} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
	}
	%>
	
</body>
</html>