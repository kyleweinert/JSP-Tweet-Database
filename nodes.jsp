
<%
	/**
	*@author Kyle Weinert
	**/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.concurrent.TimeUnit"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.math.BigInteger"%>
<html>
<head>
<title>Query Selection</title>
</head>
<body>

	<h3>Select query:</h3>
	<%@ include file="./DBInfo.jsp"%>
	<%
		session.setAttribute("username", request.getParameter("username"));
	%>
	<%
		session.setAttribute("password", request.getParameter("password"));
	%>
	<%
		//DB_USERNAME = request.getParameter("username");
	%>
	<%
		//DB_PASSWORD = request.getParameter("password");
	%>
	<%
		Boolean uadmin = false;
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement checku = null;
		ResultSet rs = null;
		ResultSet urs = null;

		try {
			//System.out.println("hib");
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
			String checkuser = "select count(*) from login where username = ? and upassword = ?";
			checku = conn.prepareStatement(checkuser);
			String u = (String) session.getAttribute("username");
			String s = (String) session.getAttribute("password");

			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(s.getBytes());
			BigInteger no = new BigInteger(1, hash);
			String hashtext = no.toString(16);
			while (hashtext.length() < 32) {
				hashtext = "0" + hashtext;
			}
			s = hashtext;
			//System.out.println(u);

			checku.setString(1, u);
			checku.setString(2, s);
			urs = checku.executeQuery();
			int count = 0;
			if (urs.next()) {
				count = urs.getInt(1);
			}
			if (count == 0) {
				throw new SQLException();
			}
			PreparedStatement admin = conn
					.prepareStatement("select uadmin from login where username = ? and upassword = ?");
			admin.setString(1, u);
			admin.setString(2, s);
			urs = admin.executeQuery();
			urs.next();
			if (urs.getInt(1) == 1) {
				uadmin = true;
				session.setAttribute("uadmin", uadmin);
			}
	%>
	<table>
		<tr>
			<td>Test Information</td>
			<td><input type="text" size="30" /></td>
		</tr>
	</table>
	<%
		stmt = conn.createStatement();
			//System.out.println("hic");
			String sqlQuery = "SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES where ROUTINE_SCHEMA = 'group18';";
			rs = stmt.executeQuery(sqlQuery);
			//System.out.println("hi");
	%>
	<form method="post" action="results.jsp">
		<select name="node">

			<%
				boolean selected = true;
					while (rs.next()) {

						if (selected) {
			%>
			<option selected><%=rs.getString(1)%></option>
			<%
				selected = false;
						} else {
			%>
			<option><%=rs.getString(1)%></option>
			<%
				}
					}
			%>
		</select>
		<p></p>
		<input type="submit" value="Run query">
	</form>
	<%
		} catch (SQLException e) {
			String redirectURL = "errormessage.jsp";
			response.sendRedirect(redirectURL);
		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	%>
</body>
</html>



