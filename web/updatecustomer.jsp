<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<c:if test="${requestScope.message != null }">
		<br>
		<font color="red">${requestScope.message }</font>
		<br>
		<br>
	</c:if>
	
	<c:set var="id" value="${customer != null ? customer.id : param.id }"></c:set>
	<c:set var="oldName" value="${customer != null ? customer.name : param.oldName }"></c:set>
	<c:set var="name" value="${customer != null ? customer.name : param.oldName }"></c:set>
	<c:set var="address" value="${customer != null ? customer.address : param.address }"></c:set>
	<c:set var="phone" value="${customer != null ? customer.phone : param.phone }"></c:set>
	
	<form action="update.do" method="post">
	
		<input type="hidden" name="id" value="${id }"/>
		<input type="hidden" name="oldName" value="${oldName }"/>
	
		<table align="center" border="1" style="margin:20px auto">
			<tr>
				<td><h2>消费者:</h2></td>
				<td><input type="text" name="name" 
					value="${name }"/></td>
			</tr>
			<tr>
				<td><h2>地址:</h2></td>
				<td><input type="text" name="address" 
					value="${address }"/></td>
			</tr>
			<tr>
				<td><h2>电话:</h2></td>
				<td><input type="text" name="phone" 
					value="${phone }"/></td>
			</tr>
			<tr>
				<td colspan="2"><input type="submit" value="Submit"/></td>
			</tr>
		</table>
	</form>
	
</body>
</html>
