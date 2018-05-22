<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 导入标签库(描述文件) -->    
<%@taglib uri="http://www.atguigu.com/mytag/core" prefix="atguigu" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<atguigu:readerFile src="/WEB-INF/note.txt"/>

	<br><br>
	
	<atguigu:max num2="${param.a }" num1="${param.b }"/>
	
	<br>
	
	<atguigu:hello value="${param.name }" count="10"/>
	
</body>
</html>