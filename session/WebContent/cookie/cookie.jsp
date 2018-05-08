<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h4>Cookie Page</h4>
	
	<% 
		//获取所有的 Cookie
		Cookie [] cookies = request.getCookies();
		if(cookies != null && cookies.length > 0){
			for(Cookie c: cookies){
				//获取 Cookie 的 name 和 value
				String name = c.getName();
				String value = c.getValue();
				out.print(name + ": " + value + "<br>"); 
			}
		}else{
			//1. 新创建一个 Cookie 对象
			Cookie cookie = new Cookie("test", "testValue");
			
			//若赋值为 0 表示立即删除该 Cookie, 但还有调用 resppnse.addCookie() 通知浏览器. 
			//设置为负数，则是一个内存 Cookie, 设置为正数表示是一个持久化 Cookie
			//cookie.setMaxAge(60);
			
			//设置 Cookie 的作用范围
			cookie.setPath(request.getContextPath());
			
			//2. 回传给浏览器
			response.addCookie(cookie);
		}
		
		out.print("time: " + new java.util.Date());
	
	%>
	
</body>
</html>