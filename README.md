[演示链接](http://www.xidabadminton.top:8080/javaweb-mvc/index.jsp)

## 学习过程中记录的一些知识点和问题

### 问题：

> - 在创建数据表的时候，为什么要给name字段添加唯一的约束？
> - 在DAO.java里面T get为什么返回的是new BeanHandler<>(clazz)？
> - 在web上进行添加操作的时候，无法像最初在控制台测试test一样，自动添加id，所以对于查询出来的结果没有id号的，不能进行删除和更新。

### 知识点

## javaweb-mvc
> - MVC的概念：是Model-View-Controller的简称，即模型-视图-控制器。MVC是一种设计模式，它把应用程序分成三个核心模块：模型、视图、控制器，他们各自处理自己的任务。
>   - 模型是应用程序的主体部分，模型表示业务数据和业务逻辑；一个模型能为多个视图提供数据；由于应用于模型的代码只需要写一次就可以被多个视图重用，所以提高了代码的可重用性。
>   - 视图是用户看到并与之交互的界面，作用如下：视图向用户显示相关的数据；接受用户的输入；不进行任何实际的业务处理。
>   - 控制器：接受用户的输入并决定调用哪个模型组件去处理请求，然后决定调用哪个视图来显示模型处理返回的数据
> - Model具体是什么？
>   - MVC Model基本上就是一个java的类。
>   - Model将同时被Control和View访问。
>   - Model被Controller用来传输数据给到View层。
>   - View层将使用Model来在页面上显示数据。
>   - Model可以是具体的数据模型，实体类
> - View具体是什么？
>   - View层主要都是一些cshtml 页面文件，他们不包括后台代码。
>   - 在View层中可以对所有的页面，进行HTML生成和格式化。
>   - 可以在View层中使用内联代码，进行动态页面开发。
>   - View层中的cshtml 页面的请求，只能调用Controller中的方法。
> - Controller具体是什么？
>   - Controller基本上都是一些继承的类。
>   - Controller是整个MVC架构的核心。
>   - 在Controller类中的方法都是用来相应浏览器或者View层的请求。
>   - Controller将使用Model层来向View层的页面传输数据。
>   - Controller使用ViewData来传输任何数据给到View层。
> - 使用到的技术：
>   - MVC设计模式：JSP、Servlet
>   - 数据库MySQL
>   - 连接数据库使用C3P0数据库连接池
>   - JDBC工具采用DBUtils
>   - 页面上的提示操作使用Query
> - 技术难点
>   - 多个请求用一个Servlet
>   - 模糊查询
>   - 在创建或修改的情况下，验证用户名是否已经被使用并给出提示
> - 注意：不能跨层访问；只能自上向下依赖，而不能自下向上依赖

### 技术难点的实现

#### 多个请求用一个servlet


- 第一种：

  - 1.根据method请求参数的值；
  - 2.根据method的值调用对应的方法;

```jsp
<a href="CustomerServlet?method=add">add</a>，
```

此时在CustomerServlet类中添加实现add的方法。

```java
switch (method){
	case "add":  add(request,response);break;
	......}
private void add(.....){}
```

- 缺点：

  - 1.当添加一个请求时，需要在servlet中修改两处代码：switch，添加方法；
  - 2.url中使用method=xxx 暴露了要调用的方法，不私密，有安全隐患;

##### 第二种：

- 1.获取servletPath:/addCustomer.do或/query.do等；
- 2.去除/和.do得到要调用的方法名；
- 3.利用反射调用sevletPath对应的方法；
- 4.创建对应的方法;
  
  ```java
  	//1. 获取 ServletPath: /edit.do 或 /addCustomer.do
		String servletPath = req.getServletPath();
	//2. 去除 / 和 .do, 得到类似于 edit 或 addCustomer 这样的字符串
		String methodName = servletPath.substring(1);
		methodName = methodName.substring(0, methodName.length() - 3);	
		try {
	//3. 利用反射获取 methodName 对应的方法
			Method method = getClass().getDeclaredMethod(methodName, HttpServletRequest.class, 
					HttpServletResponse.class);
	//4. 利用反射调用对应的方法
			method.invoke(this, req, resp);
		} catch (Exception e) {
			e.printStackTrace();
	//可以有一些响应.
			resp.sendRedirect("error.jsp");
		}
```


#### 模糊查询

> 封装一个JavaBean作为模糊查询条件

SQL语句：

```sql
SELECT id,name,address,phone FROM customers WHERE name like %name% and address like %address% and phone like %phone%;
```

模糊查询条件：

```java
package com.mvcapp.domain;

public class CriteriaCustomer {
	private Integer Id;
	private String name;
	private String address;
	private String phone;
	
	public Integer getId() {
		return Id;
	}
	public void setId(Integer id) {
		Id = id;
	}
	public String getName() {
		if(name != null) {
			return "%"+name+"%";
		}else {
			return "%%";
		}
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAddress() {
		if(address != null) {
			return "%"+address+"%";
		}else {
			return "%%";
		}
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getPhone() {
		if(phone != null) {
			return "%"+phone+"%";
		}else {
			return "%%";
		}
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	@Override
	public String toString() {
		return "Customer [Id=" + Id + ", name=" + name + ", address=" + address + ", phone=" + phone + "]";
	}	
}
```












