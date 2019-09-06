<% /**
	*@author Kyle Weinert
	**/
	%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<html>
<head>
<title>Results</title>
</head>
<body>

	<h3>Select the node to start at:</h3>
	<%@ include file="./DBInfo.jsp"%>
	<% String node = request.getParameter("node");%>
	  
	<%
		Connection conn =null;
		Statement stmt =null;
		ResultSet rs1 =null;
		ResultSet rs2 =null;
		//DB_USERNAME = (String)session.getAttribute("username");
		//DB_PASSWORD = (String)session.getAttribute("password");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
			stmt = conn.createStatement();
			
			
			ArrayList<String> list = new ArrayList<String>();
			list.add(node);
			String query = "select n.endnode from nodes n inner join nodes x on n.startnode = ?";
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.clearParameters();
			pstmt.setString(1, node);
			rs1= pstmt.executeQuery();
			
			ResultSetMetaData rsMetaData;
			rsMetaData = rs1.getMetaData();
			
			while (rs1.next()) {
				for (int i = 0; i < rsMetaData.getColumnCount(); i++) {
					
					if(!list.contains(rs1.getString(i+1))){
					list.add(rs1.getString(i+1));
					}
					
				}
				
			}
			
			rs1.close();
			
			query = "select x.endnode from nodes n inner join nodes x on n.startnode = ? and n.endnode = x.startnode";
			pstmt = conn.prepareStatement(query);
			pstmt.clearParameters();
			pstmt.setString(1, node);
			rs2= pstmt.executeQuery();
			
			rsMetaData = rs2.getMetaData();
			while (rs2.next()) {
				for (int i = 0; i < rsMetaData.getColumnCount(); i++) {
					
					if(!list.contains(rs2.getString(i+1))){
					list.add(rs2.getString(i+1));
					}
					
				}
				
			}
			
			for (int i = 0; i < list.size(); i++) {
				out.println(list.get(i));
				
			}
			
			
			//System.out.println(sqlQuery);
			
			
			//JOptionPane.showMessageDialog(null, toShow);
			
			
			rs2.close();
			
			

			
		} catch (SQLException e) {
			out.println("An exception occurred: " + e.getMessage());
			
			//String redirectURL = "login.jsp";
   			//response.sendRedirect(redirectURL);
			
		} finally {
			
			if (stmt!= null) stmt.close();
			if (conn != null) conn.close();
		}
	%>
</body>
</html>

