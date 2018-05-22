<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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

	<!-- 7. EL 的运算符 -->
	${param.score > 60 ? "及格" : "不及格" }
	<br>
	
	<% 
		List<String> names = new ArrayList<String>();
		names.add("abc");
		request.setAttribute("names", names);
	%>
	<!-- empty 可以作用于一个集合, 若该集合不存在或集合中没有元素, 其结果都为 true -->
	names is empty: ${empty requestScope.names }
	<br>
	
	<!-- 6. 其他隐含对象: pageContext 等(cookie, header, initParam 只需了解.) -->
	pageContext: pageContext 即为 PageContext 类型, 但只能读取属性就可以一直的 . 下去。 
	<br>
	contextPath: ${pageContext.request.contextPath }
	
	<br>
	sessionId: ${pageContext.session.id }
	
	<br>
	sessionAttributeNames: ${pageContext.session.attributeNames }
	
	<br>
	
	
	initParam: ${initParam.initName }
	<br>
	
	Accept-Language: ${header["Accept-Language"] }
	<br>

	JSESSIONID: ${cookie.JSESSIONID.name } -- ${cookie.JSESSIONID.value }
	<br>

	<!-- 5. 与输入有关的隐含对象: param, paramValues -->
	score: ${param.score }
	<%-- 
	<%= request.getParameter("score") %>
	--%>
	<br>
	names: ${paramValues.name[0].class.name }
	<%-- 
	<%= 
		request.getParameterValues("name")[0].getClass().getName()
	%>
	--%>
	<br>
	
	<!-- 4. 隐含对象之与范围相关的: pageScope, requestScope, sessionScope, applicationScope -->
	time: ${applicationScope.time.time }
	<%-- 
	<%= application.getAttribute("time") %>
	--%>
	<br>
	
	<!-- 3. EL 可以进行自动的类型转换 -->
	score: ${param.score + 11}
	<br>
	score: <%= request.getParameter("score") + 11 %>
	<br>
	
	<!-- 2. EL 中的隐含对象 -->
	<% 
		Customer cust2 = new Customer();
		cust2.setAge(28);
		request.setAttribute("customer", cust2);
	%>
	
	age: ${customer.age } 

	<br>
	<!-- 1. EL 的 . 或 [] 运算符 -->
	age: ${sessionScope.customer["age"] }
	
	<%-- 
		Customer customer = (Customer)session.getAttribute("customer");
		out.print(customer.getAge());
	--%>
	
	<% 
		Customer customer = new Customer();
		customer.setName("ATGUIGU");	
	
		session.setAttribute("com.atguigu.customer", customer);
	%>
	
	<br>
	<!--  
		如果域对象中的属性名带有特殊字符, 则使用 [] 运算符会很方便. 
	-->
	name: ${sessionScope["com.atguigu.customer"].name }
	
</body>
</html>