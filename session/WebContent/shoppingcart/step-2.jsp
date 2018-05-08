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
<body>
	
	
	
	<form action="<%= request.getContextPath() %>/processStep2" method="post">
		<table class="table" align="center" style="vertical-align:top; width:800px; margin:auto;">
		
		<caption><h2>请输入寄送地址和信用卡信息</h2></caption>
  <thead>
    <tr>
      <th>寄送信息</th>
      <th>信息内容</th>
  </thead>
  <tbody>
		
			
			
			<tr>
				<td>姓名:</td>
				<td><input type="text" name="name"/></td>
			</tr>
			
			<tr>
				<td>寄送地址:</td>
				<td><input type="text" name="address"/></td>
			</tr>
			
			<tr>
				<td >信用卡信息</td>
			</tr>
			
		<tr>
			<td>种类:</td>
			<td>
				<input type="radio" name="cardType" value="Visa"/>Visa
				<input type="radio" name="cardType" value="Master"/>Master
			</td>
		</tr>
		
		<tr>
			<td>卡号:</td>
			<td>
				<input type="text" name="card"/>
			</td>
		</tr>
		
		<tr>
			<td colspan="2"><input type="submit" value="Submit"/></td>
		</tr>
		</tbody>	
	</table>
	</form>
	
</body>
</html>