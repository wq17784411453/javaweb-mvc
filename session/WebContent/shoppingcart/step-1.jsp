<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

 <style>
        table,table tr th, table tr td { border:1px solid #DCDCDC; }
        table {  min-height: 25px; line-height: 35px; text-align: center; border-collapse: collapse; padding:2px;}   
 
 	a {TEXT-DECORATION:none}
 	body{      
        background-image: url(../imgs/gouwuche.jpg);      
        background-size:cover;    
     } 
 	
 </style>

<title>Insert title here</title>
</head>
<body style="text-align:center;">
	
	
	
	<form action="<%= request.getContextPath() %>/processStep1" method="post">
		<table class="table" align="center" style="vertical-align:top; width:800px; margin:auto;">
			<caption><h2>简易的书籍购物车</h2></caption>
  <thead>
    <tr>
      <th>书名</th>
      <th>简介</th>
      <th>购买</th></tr>
  </thead>
  <tbody>
			
			
			<tr>
				<td>Java</td>
				<td></td>
				<td><input type="checkbox" name="book" value="Java"/></td>
			</tr>
			
			<tr>
				<td>Oracle</td>
				<td></td>
				<td><input type="checkbox" name="book" value="Oracle"/></td>
			</tr>
			
			<tr>
				<td>Struts</td>
				<td></td>
				<td><input type="checkbox" name="book" value="Struts"/></td>
			</tr>
			<tr>
				<td>Linux</td>
				<td></td>
				<td><input type="checkbox" name="book" value="Struts"/></td>
			</tr>
			<tr>
				<td>c++</td>
				<td></td>
				<td><input type="checkbox" name="book" value="Struts"/></td>
			</tr>
			<tr>
				<td>嵌入式开发</td>
				<td></td>
				<td><input type="checkbox" name="book" value="Struts"/></td>
			</tr>
			
			<tr>
				<td colspan="3" align="center">
					<input type="submit" value="Submit"/>
				</td>
			</tr>
			</tbody>
		</table>
	</form>
	
</body>
</html>