<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

 <style>
        table,table tr th, table tr td { border:1px solid #DCDCDC; }
        table {  min-height: 25px; line-height: 35px; text-align: center; border-collapse: collapse; padding:2px;}   
 
 	a {TEXT-DECORATION:none}
 	body{      
        background-image: url(../imgs/cookie.jpg);      
        background-size:cover;    
     } 
 	
 </style>

<title>Insert title here</title>
</head>
<body style="text-align:center;">

<div style="vertical-align:top; width:800px; margin:auto;" >

<table class="table" width="50%" style="float:left;">
  <caption><h2>书单</h2></caption>
  <thead>
    <tr>
      <th>书名</th>
      <td></td>
      <th>点击添加到cookie</th></tr>
  </thead>
  <tbody>
    <tr class="active">
      <td>Java Web</td>
      <td></td>
      <td><a href="book.jsp?book=JavaWeb">添加</a></td></tr>
    <tr class="active">
      <td>Java</td>
      <td></td>
      <td><a href="book.jsp?book=Java">添加</a></td></tr>
    <tr class="active">
      <td>Oracle</td>
      <td></td>
      <td><a href="book.jsp?book=Oracle">添加</a></td></tr>
    <tr class="active">
      <td>Ajax</td>
      <td></td>
      <td><a href="book.jsp?book=Ajax">添加</a></td></tr>
    <tr class="active">
      <td>JavaScript</td>
      <td></td>
      <td><a href="book.jsp?book=JavaScript">添加</a></td></tr>
    <tr class="active">
      <td>Android</td>
      <td></td>
      <td><a href="book.jsp?book=Android">添加</a></td></tr>
    <tr class="active">
      <td>Jbpm</td>
      <td></td>
      <td><a href="book.jsp?book=Jbpm">添加</a></td></tr>
    <tr class="active">
      <td>Struts</td>
      <td></td>
      <td><a href="book.jsp?book=Struts">添加</a></td></tr>

    <tr class="active">
      <td>Hibernate</td>
      <td></td>
      <td><a href="book.jsp?book=Hibernate">添加</a></td></tr>
    <tr class="active">
      <td>Spring</td>
      <td></td>
      <td><a href="book.jsp?book=Spring">添加</a></td></tr>

      
  </tbody>
</table>
	
<%-- <h4>书单</h4>
	
	<a href="book.jsp?book=JavaWeb">Java Web</a><br><br>
	<a href="book.jsp?book=Java">Java</a><br><br>
	<a href="book.jsp?book=Oracle">Oracle</a><br><br>
	<a href="book.jsp?book=Ajax">Ajax</a><br><br>
	<a href="book.jsp?book=JavaScript">JavaScript</a><br><br>
	<a href="book.jsp?book=Android">Android</a><br><br>
	<a href="book.jsp?book=Jbpm">Jbpm</a><br><br>
	<a href="book.jsp?book=Struts">Struts</a><br><br>
	<a href="book.jsp?book=Hibernate">Hibernate</a><br><br>
	<a href="book.jsp?book=Spring">Spring</a><br><br>
 --%>		
	
	
	<table class="table" width="50%">
  	<caption><h2>cookie的记录</h2></caption>
  	  <thead>
    <tr>
      <th>cookie记录的最大数目为5个</th>
      
      
      

  </thead>
  <tbody>
	<td>
	<% 
		//显示最近浏览的 5 本书
		//获取所有的 Cookie
		Cookie [] cookies = request.getCookies();
	
		//从中筛选出 Book 的 Cookie：如果 cookieName 为 ATGUIGU_BOOK_ 开头的即符合条件
		//显示 cookieValue
		if(cookies != null && cookies.length > 0){
			for(Cookie c: cookies){
				String cookieName = c.getName();
				if(cookieName.startsWith("ATGUIGU_BOOK_")){
					out.println(c.getValue());
					out.print("<br>");
				}
			}
		}

	%>
	
	</td>
	</tbody>
	</table>
	</div>
		
	
	
</body>
</html>