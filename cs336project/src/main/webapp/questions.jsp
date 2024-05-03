<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Q & A</title>
<style>
    table { width: 100%; border-collapse: collapse; }
    th, td { border: 1px solid #dddddd; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; }
    .user-question { background-color: #e8f5e9; } /* Highlight for user's own questions */
</style>
<script>
function toggleAnswerForm(questionID) {
    var answerButton = document.getElementById('answerBtn_' + questionID);
    var answerForm = document.getElementById('answerForm_' + questionID);

    if (answerButton.style.display === 'none') {
        answerButton.style.display = 'inline';
        answerForm.style.display = 'none';
    } else {
        answerButton.style.display = 'none';
        answerForm.style.display = 'inline';
    }
}
</script>
</head>
<body>

<%-- Ensure user is logged in and retrieve user details --%>
<%
String userID = (String) session.getAttribute("user");
String employeeID = (String) session.getAttribute("employeeID");
String userRole = (String) session.getAttribute("userRole");

// out.println("userID: " + userID);
// out.println("employeeID: " + employeeID);
// out.println("userRole: " + userRole);
%>

<h1 style="text-align: center">Questions & Answers</h1>
<div style="text-align: center">
    <% if ("custRep".equals(userRole)) { %>
        <a href="repHomePage.jsp">Back</a>
    <% } else if ("admin".equals(userRole)) { %>
        <a href="adminHomePage.jsp">Back</a>
    <% } else { %>
        <a href="account.jsp">Back</a>
    <% } %>
</div>

<% // Search form for users to search questions
if (userID != null) { %>
    <h2>Search Questions</h2>
    <form action="questions.jsp" method="get">
        <input type="text" name="keyword" placeholder="Enter keyword">
        <input type="submit" value="Search">
    </form>
<% } %>

<% // Handling the search query
String keyword = request.getParameter("keyword");
String searchQuery = "SELECT * FROM questions ORDER BY questionDate DESC";

// Check if a keyword is provided
if (keyword != null && !keyword.isEmpty()) {
    searchQuery = "SELECT * FROM questions WHERE questionText LIKE ? OR subject LIKE ? ORDER BY (answerText IS NOT NULL) DESC, questionDate DESC";
}
%>

<% // Display questions based on search query if a keyword is provided
if (keyword != null && !keyword.isEmpty()) {
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        PreparedStatement pstmt = con.prepareStatement(searchQuery);
        pstmt.setString(1, "%" + keyword + "%");
        pstmt.setString(2, "%" + keyword + "%");
        ResultSet rs = pstmt.executeQuery();

        out.println("<table>");
        out.println("<tr><th>Subject</th><th>Question</th><th>Answer</th><th>Date Asked</th>" + (userID != null ? "<th>Action</th>" : "") + "</tr>");
        while(rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getString("subject") + "</td>");
            out.println("<td>" + rs.getString("questionText") + "</td>");
            out.println("<td>");
            if (rs.getString("answerText") != null) {
                out.println(rs.getString("answerText"));
            } else if ("custRep".equals(userRole)) {
                out.println("<button id='answerBtn_" + rs.getInt("questionID") + "' onclick='toggleAnswerForm(" + rs.getInt("questionID") + ")'>Answer</button>");
                out.println("<form id='answerForm_" + rs.getInt("questionID") + "' method='post' action='questions.jsp' style='display:none;'>" +
                        "<input type='hidden' name='answerID' value='" + rs.getInt("questionID") + "'/>" +
                        "<textarea name='answerText' placeholder='Type your answer here'></textarea>" +
                        "<input type='submit' value='Submit'/></form>");
            }
            out.println("</td>");
            out.println("<td>" + rs.getTimestamp("questionDate") + "</td>");
            if (userID != null && userID.equals(rs.getString("customerUsername"))) {
                out.println("<td><form method='post' action='questions.jsp'><input type='hidden' name='deleteID' value='" + rs.getInt("questionID") + "'/><input type='submit' value='Delete'/></form></td>");
            }
            out.println("</tr>");
        }
        out.println("</table>");

        db.closeConnection(con);
    } catch (SQLException e) {
        e.printStackTrace();
    }
} else {
    // No keyword provided, do not execute the search
}
%>



<% // Form for regular users to submit new questions
if (userID != null) { %>
    <h2>Submit a New Question</h2>
    <form action="questions.jsp" method="post">
        <input type='text' name='subject' placeholder='Question Subject'>
        <textarea name='questionText' placeholder='Type your question here'></textarea>
        <input type='submit' value='Submit Question'>
    </form>
<% } %>


<% // Handling the new question submission
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("subject") != null) {
    String subject = request.getParameter("subject");
    String questionText = request.getParameter("questionText");

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        PreparedStatement pstmt = con.prepareStatement("INSERT INTO questions (subject, questionText, customerUsername, questionDate) VALUES (?, ?, ?, NOW())");
        pstmt.setString(1, subject);
        pstmt.setString(2, questionText);
        pstmt.setString(3, userID);
        pstmt.executeUpdate();

        db.closeConnection(con);
        response.sendRedirect("questions.jsp"); // Redirect to avoid form re-submission
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

//Handling deletion of a question
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("deleteID") != null) {
 int deleteID = Integer.parseInt(request.getParameter("deleteID"));
 ApplicationDB db = new ApplicationDB();
 Connection con = db.getConnection();
 PreparedStatement checkStmt = con.prepareStatement("SELECT customerUsername FROM questions WHERE questionID = ?");
 checkStmt.setInt(1, deleteID);
 ResultSet rsCheck = checkStmt.executeQuery();
 if (rsCheck.next()) {
     String questionOwner = rsCheck.getString("customerUsername");
     if (userID.equals(questionOwner) || "admin".equals(userRole) || "custRep".equals(userRole)) {
         PreparedStatement pstmt = con.prepareStatement("DELETE FROM questions WHERE questionID = ?");
         pstmt.setInt(1, deleteID);
         pstmt.executeUpdate();
         response.sendRedirect("questions.jsp"); // Redirect to avoid re-submission
     } else {
         out.println("<p>You do not have permission to delete this question.</p>");
     }
 } else {
     out.println("<p>Question not found.</p>");
 }
 db.closeConnection(con);
}

//Handling answer submission
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("answerID") != null && request.getParameter("answerText") != null) {
    int answerID = Integer.parseInt(request.getParameter("answerID"));
    String answerText = request.getParameter("answerText");

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        PreparedStatement pstmt = con.prepareStatement("UPDATE questions SET answerText = ? WHERE questionID = ?");
        pstmt.setString(1, answerText);
        pstmt.setInt(2, answerID);
        pstmt.executeUpdate();

        db.closeConnection(con);
        response.sendRedirect("questions.jsp"); // Redirect to avoid form re-submission
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

// Display questions from the database based on user role
try {
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    PreparedStatement pstmt;
    pstmt = con.prepareStatement("SELECT * FROM questions ORDER BY questionDate DESC");
    ResultSet rs = pstmt.executeQuery();

    out.println("<table>");
    out.println("<tr><th>Subject</th><th>Question</th><th>Answer</th><th>Date Asked</th>" + (userID != null ? "<th>Action</th>" : "") + "</tr>");
    while(rs.next()) {
        out.println("<tr>");
        out.println("<td>" + rs.getString("subject") + "</td>");
        out.println("<td>" + rs.getString("questionText") + "</td>");
        out.println("<td>");
        if (rs.getString("answerText") != null) {
            out.println(rs.getString("answerText"));
        } else if ("custRep".equals(userRole)) {
            out.println("<button id='answerBtn_" + rs.getInt("questionID") + "' onclick='toggleAnswerForm(" + rs.getInt("questionID") + ")'>Answer</button>");
            out.println("<form id='answerForm_" + rs.getInt("questionID") + "' method='post' action='questions.jsp' style='display:none;'>" +
                    "<input type='hidden' name='answerID' value='" + rs.getInt("questionID") + "'/>" +
                    "<textarea name='answerText' placeholder='Type your answer here'></textarea>" +
                    "<input type='submit' value='Submit'/></form>");
        }
        out.println("</td>");
        out.println("<td>" + rs.getTimestamp("questionDate") + "</td>");
        if (userID != null && userID.equals(rs.getString("customerUsername"))) {
            out.println("<td><form method='post' action='questions.jsp'><input type='hidden' name='deleteID' value='" + rs.getInt("questionID") + "'/><input type='submit' value='Delete'/></form></td>");
        }
        out.println("</tr>");
    }
    out.println("</table>");

    db.closeConnection(con);
} catch (SQLException e) {
    e.printStackTrace();
}
%>

</body>
</html>
