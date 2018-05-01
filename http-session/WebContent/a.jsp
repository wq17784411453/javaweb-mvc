<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<% 
		HttpSession session2 = request.getSession(false); 
	%> 
	
	<h4>AAA PAGE</h4>
	
	<a href="b.jsp">To B Page</a>
	
	<% 
		session.setAttribute("time", new Date());
	%>
	currentTime: <%= new Date() %>
	<br><br>
	sessionTime: <%= session.getAttribute("time") %>
	
</body>
</html>