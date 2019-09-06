<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import= "java.security.MessageDigest"%>
<%@ page import= "java.math.BigInteger"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	<h3>Creating account...</h3>
	<%@ include file="./DBInfo.jsp"%>
	<% session.setAttribute("username", request.getParameter("username"));%>
	<% session.setAttribute("password", request.getParameter("password"));%>
	<%
	Connection conn =null;
	PreparedStatement pstmt = null;
	ResultSet rs =null;
	try{
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
		String add = "insert into login(username, upassword, uadmin) values(?, ?, false)";
		pstmt = conn.prepareStatement(add);
		pstmt.setString(1, (String)request.getParameter("username"));
		String u = request.getParameter("password");
		
		MessageDigest digest = MessageDigest.getInstance("SHA-256");
		byte[] hash = digest.digest(u.getBytes());
		BigInteger no = new BigInteger(1, hash);
		String hashtext = no.toString(16);
		while (hashtext.length() < 32) { 
            hashtext = "0" + hashtext; 
        } 
		u = hashtext;
		
		pstmt.setString(2, u);
		pstmt.executeUpdate();
	} catch (SQLException e) {
		String redirectURL = "errormessageNewAccount.jsp";
		response.sendRedirect(redirectURL);
	} finally {
		if (rs!= null) rs.close();
		if (pstmt!= null) pstmt.close();
		if (conn != null) conn.close();
	}
	
	String redirectURL = "login.jsp";
	response.sendRedirect(redirectURL);
	%>
</body>
</html>