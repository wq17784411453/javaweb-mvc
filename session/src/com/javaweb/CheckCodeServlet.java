package com.javaweb;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CheckCodeServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//1. 获取请求参数: CHECK_CODE_PARAM_NAME
		String paramCode = request.getParameter("CHECK_CODE_PARAM_NAME");
		
		//2. 获取 session 中的 CHECK_CODE_KEY 属性值
		String sessionCode = (String)request.getSession().getAttribute("CHECK_CODE_KEY");
		
		System.out.println(paramCode);
		System.out.println(sessionCode); 
		
		//3. 比对. 看是否一致, 若一致说明验证码正确, 若不一致, 说明验证码错误
		if(!(paramCode != null && paramCode.equals(sessionCode))){
			request.getSession().setAttribute("message", "验证码不一致!");
			response.sendRedirect(request.getContextPath() + "/check/index.jsp");
			return;
		}
		
		System.out.println("受理请求!");
		
	}

}
