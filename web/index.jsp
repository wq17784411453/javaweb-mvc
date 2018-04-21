<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="scripts/jquery-1.7.2.js"></script>
<script type="text/javascript">
	
	$(function(){
		$(".delete").click(function(){
			var content = $(this).parent().parent().find("td:eq(1)").text();
			var flag = confirm("确定要是删除" + content + "的信息吗?");
			return flag;
		});
	});

</script>
</head>
<body>
	
	<form action="query.do" method="post">
		<table align="center" border="1" style="margin:20px auto">
			<tr>
				<td><h2>消费者:</h2></td>
				<td><input type="text" name="name"/></td>
			</tr>
			<tr>
				<td><h2>地址:</h2></td>
				<td><input type="text" name="address"/></td>
			</tr>
			<tr>
				<td><h2>电话:</h2></td>
				<td><input type="text" name="phone"/></td>
			</tr>
			<tr>
				<td><input type="submit" value="Query"/></td>
				<td><a href="newcustomer.jsp"><h2>添加新的消费者</h2></a></td>
			</tr>
		</table>
	</form>
	
	<br><br>
	
	<c:if test="${!empty requestScope.customers }">

		<hr>	
		<br><br>
	 
		<table border="1" cellpadding="10" cellspacing="0" align="center">
			<tr>
				<th>^ID</th>
				<th>消费者</th>
				<th>地址</th>
				<th>电话</th>
				<th>更新\删除</th>
			</tr>
			
			<c:forEach items="${requestScope.customers }" var="cust">
					
					<tr>
						<td>${cust.id }</td>
						<td>${cust.name }</td>
						<td>${cust.address }</td>
						<td>${cust.phone }</td>
						<td>
							<c:url value="/edit.do" var="editurl">
								<c:param name="id" value="${cust.id }"></c:param>
							</c:url>
							<a href="${editurl }">UPDATE</a>
							<c:url value="/delete.do" var="deleteurl">
								<c:param name="id" value="${cust.id }"></c:param>
							</c:url>
							<a href="${deleteurl }" class="delete">DELETE</a>
						</td>
					</tr>
			
			</c:forEach>
			
		</table>
	</c:if>
	
</body>
</html>
