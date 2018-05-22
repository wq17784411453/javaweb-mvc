<%@page import="com.atguigu.javaweb.Customer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<jsp:useBean id="customer" class="com.atguigu.javaweb.Customer" 
		scope="request"></jsp:useBean>
	
	<jsp:useBean id="customer2" beanName="com.atguigu.javaweb.Customer"
		type="java.lang.Object" scope="request"></jsp:useBean>
		
	<%-- 
		Object customer2 = request.getAttribute("customer2");
		if(customer2){
			customer2 = Class.forName("com.atguigu.javaweb.Customer").newInstance();
			request.setAttribute("customer2", customer2);
		}
	--%>	
		
	<!-- 若 property 的值为 *, 省略 value 属性值, 则将自动为所有属性赋值为对应的请求参数的值.  -->	
	<jsp:setProperty property="*" name="customer"/>
	
	<%-- 
	<jsp:setProperty property="name" value="ATGUIGU2" name="customer"/>
	--%>
	
	age: <jsp:getProperty property="age" name="customer"/> 
	<br>
	name: <jsp:getProperty property="name" name="customer"/>
	<br>
	id: <jsp:getProperty property="id" name="customer"/>
	
	<%-- 
	<%= customer.getAge() %>
	--%>
		
	<%-- 
		customer.setAge(10);
	--%>	
	
	<%-- 
		//1. 从 scope(session) 中获取 id(customer) 属性值, 赋给 class(com.atguigu.javaweb.Customer) 
		//类型的 id(customer) 变量
		Customer customer = (Customer)session.getAttribute("customer");
		
		//2. 若属性值为 null, 则利用反射创建一个新的对象, 把该对象赋给 id(customer), 并以 id(customer) 
		//为属性名让如到 scope(session) 中.
		if(customer == null){
			customer = (Customer)Class.forName("com.atguigu.javaweb.Customer").newInstance();
			session.setAttribute("customer", customer);
		}
	--%>
	
</body>
</html>