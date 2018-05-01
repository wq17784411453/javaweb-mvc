[演示链接](http://www.xidabadminton.top:8080/javaweb-mvc/index.jsp)

## 学习过程中记录的一些知识点和问题

### 问题：

> - 在创建数据表的时候，为什么要给name字段添加唯一的约束，目的是什么？
> - 在DAO.java里面T get为什么返回的是new BeanHandler<>(clazz)？
> - 在web上进行添加操作的时候，无法像最初在控制台测试test一样，自动添加id，所以对于查询出来的结果没有id号的，不能进行删除和更新。
> - 在执行更新操作的时候，Newcustomer.jsp和updateCustomer.jsp能汇总到一个页面吗？

### 解决：

> - 第三个：在创建数据库的时候，没有指定id为主键，所以在CustomerServlet类里面无法获取参数id。

### 知识点

# 第八周

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


> - 第一种：
>   - 1.根据method请求参数的值；
>   - 2.根据method的值调用对应的方法;

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

> - 缺点：
>   - 1.当添加一个请求时，需要在servlet中修改两处代码：switch，添加方法；
>   - 2.url中使用method=xxx 暴露了要调用的方法，不私密，有安全隐患;

> - 第二种：
>   - 1.获取servletPath:/addCustomer.do或/query.do等；
>   - 2.去除/和.do得到要调用的方法名；
>   - 3.利用反射调用sevletPath对应的方法；
>   - 4.创建对应的方法;
  
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


#### 查询

> - Servlet：
>   - 调用 CustomerDAO 的 getAll() 得到 Customer 的集合
>   - 把 Customer 的集合放入 request 中
>   - 转发页面到 index.jsp(不能使用重定向)
> - jsp:
>   - 获取request中的Customers属性
>   - 遍历显示

```java
private void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
				
		List<Customer> customers = customerDAO.getAll();		
		request.setAttribute("customers", customers);		
		request.getRequestDispatcher("/index.jsp").forward(request, response);
	}
```

#### 模糊查询

> - 根据传入的name，address，phone进行模糊查询
> - 例子：name:a、address：b、phone：3 则SQL语句的样子为：SELECT id, name, address, phone FROM customers WHERE name LIKE '%a%' AND address LIKE '%b%' AND phone LIKE '%3%'
> - 需要在CustomerDAO接口中定义一个getForListWithCriteriaCustomer(CriteriaCustomer cc)。其中CriteriaCustomer用于封装查询条件：name，address，phone。因为查询条件很多时候和domain类并不相同，所以要做成一个单独的类
> - 拼SQL：
>   - SQL：
>   - 为了正确的填充占位符时，重写了CriteriaCustomer的getter：

```sql
"SELECT id, name, address, phone FROM customers WHERE " +"name LIKE ? AND address LIKE ? AND phone LIKE ?";
```

```java
	public String getAddress() {
		if(address == null)
			address = "%%";
		else
			address = "%" + address + "%";
		return address;
	}
```

> - CriteriaCustomer对象，再调用getForListWithCriteriaCustomer(CriteriaCustomer cc)方法

> - 底层实现
>   - 在CustomerDAO类里面封装了查询条件
>   - 具体实现在CustomerDAOJdbcImpl类里面

```java
	/**
	 * 返回满足查询条件的 List
	 * @param cc: 封装了查询条件
	 * @return
	 */
	public List<Customer> getForListWithCriteriaCustomer(CriteriaCustomer cc);
```

```java
public class CustomerDAOJdbcImpl extends DAO<Customer> implements CustomerDAO{

	public List<Customer> getForListWithCriteriaCustomer(CriteriaCustomer cc) {
		String sql = "SELECT id, name, address, phone FROM customers WHERE " +
				"name LIKE ? AND address LIKE ? AND phone LIKE ?";
		//修改了 CriteriaCustomer 的 getter 方法: 使其返回的字符串中有 "%%".
				//若返回值为 null 则返回 "%%", 若不为 null, 则返回 "%" + 字段本身的值 + "%"
		return getForList(sql, cc.getName(), cc.getAddress(), cc.getPhone());
	}
```

# 第九周

> - 删除操作：
>   - 超链接：delete.di?id=<%=cunstomer.getid()%>
>   - servlet的delete方法：
>      - 获取id
>      - 调用DAO执行删除
>      - 重定向到query.do（若目标页面不需要读取当前请求的request属性，就可以使用重定向），将显示删除后的customer的list
>   - JSP上的jQuery提示：
>     - 确定要删除xx的信息吗？

```jsp
<script type="text/javascript">
	
	$(function(){
		$(".delete").click(function(){
			var content = $(this).parent().parent().find("td:eq(1)").text();
			var flag = confirm("确定要是删除" + content + "的信息吗?");
			return flag;
		});
	});
```

> - 添加：
>   - add new customer超链接连接到customer.jsp
>   - 新建newcustomer.jsp
>   - 在CudtomerServlet的addCustomer方法中

```java
		//1. 获取表单参数: name, address, phone
		String name = request.getParameter("name");
		String address = request.getParameter("address");
		String phone = request.getParameter("phone");
		//2. 检验 name 是否已经被占用:
		//2.1 调用 CustomerDAO 的 getCountWithName(String name) 获取 name 在数据库中是否存在
		long count = customerDAO.getCountWithName(name);
		//2.2 若返回值大于 0, 则响应 newcustomer.jsp 页面: 
		//通过转发的方式来响应 newcustomer.jsp
		if(count > 0){
			//2.2.1 要求再 newcustomer.jsp 页面显示一个错误消息: 用户名 name 已经被占用, 请重新选择!
			//在 request 中放入一个属性 message: 用户名 name 已经被占用, 请重新选择!, 
			//在页面上通过 request.getAttribute("message") 的方式来显示
			request.setAttribute("message", "用户名" + name + "已经被占用, 请重新选择!");
			//2.2.2 newcustomer.jsp 的表单值可以回显. 
			//通过 value="<%= request.getParameter("name") == null ? "" : request.getParameter("name") %>"
			//来进行回显
			//2.2.3 结束方法: return 
			request.getRequestDispatcher("/newcustomer.jsp").forward(request, response);
			return;
		}
		//3. 若验证通过, 则把表单参数封装为一个 Customer 对象 customer
		Customer customer = new Customer(name, address, phone);
		//4. 调用 CustomerDAO 的  save(Customer customer) 执行保存操作
		customerDAO.save(customer);
		//5. 重定向到 success.jsp 页面: 使用重定向可以避免出现表单的重复提交问题.  
		response.sendRedirect("success.jsp");
		//request.getRequestDispatcher("/success.jsp").forward(request, response);
	}
```


> - 修改：
>   - 先显示（select操作）修改的页面，再进行修改（update操作）
>   - 显示修改页面：
>      - update的超链接：
>      - edit方法：
>      - JSP页面：
>          - 获取请求域中的customer对象，调用对应的字段的get方法来显示值；
>          - 使用隐藏域来保存要修改的customer对象的id：<input type="hidden" name="id" value="${id }"/>；
>          - 使用隐藏域来保存oldName：<input type="hidden" name="oldName" value="${oldName }"/> ；
>          - 关于隐藏域：和其他的表单域一样可以被提交到服务器，只不过在页面上不显示；
>      - 提交到update.do
>   - 修改操作：
>      - update方法：
>      - updatecustomer.jsp：隐藏域的问题，回显的问题
>      - Newcustomer.jsp和updateCustomer.jsp能汇总到一个页面吗？

```java
//1. 获取表单参数: id, name, address, phone, oldName
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String oldName = request.getParameter("oldName");
		//2. 检验 name 是否已经被占用:
				//2.1 比较 name 和 oldName 是否相同, 若相同说明 name 可用. 
				//2.1 若不相同, 则调用 CustomerDAO 的 getCountWithName(String name) 获取 name 在数据库中是否存在
		if(!oldName.equalsIgnoreCase(name)){
			long count = customerDAO.getCountWithName(name);
			//2.2 若返回值大于 0, 则响应 updatecustomer.jsp 页面: 通过转发的方式来响应 newcustomer.jsp
			if(count > 0){
				//2.2.1 在 updatecustomer.jsp 页面显示一个错误消息: 用户名 name 已经被占用, 请重新选择!
				//在 request 中放入一个属性 message: 用户名 name 已经被占用, 请重新选择!, 
				//在页面上通过 request.getAttribute("message") 的方式来显示
				request.setAttribute("message", "用户名" + name + "已经被占用, 请重新选择!");
				//2.2.2 newcustomer.jsp 的表单值可以回显. 
				//address, phone 显示提交表单的新的值, 而 name 显示 oldName, 而不是新提交的 name
				//2.2.3 结束方法: return 
				request.getRequestDispatcher("/updatecustomer.jsp").forward(request, response);
				return;
			}
		}
		//3. 若验证通过, 则把表单参数封装为一个 Customer 对象 customer
		Customer customer = new Customer(name, address, phone);
		customer.setId(Integer.parseInt(id)); 
		//4. 调用 CustomerDAO 的  update(Customer customer) 执行更新操作
		customerDAO.update(customer);
		//5. 重定向到 query.do
		response.sendRedirect("query.do");
	}
```

> - 深入理解面向接口编程：在类中调用的接口的方法，而不必关心代码的具体实现。这将有利于代码的解耦。使程序有更好的可移植性和可扩展性

动态修改Customer的存储方式：通过修改类路径下的switch.properties文件的方式来实现type=xml或者type=jdbc
>   - CustomerServlet中不能再通过private CustomerDAO customerDAO=new CudtomerDAOXMLImpl（）；的方式来写死实现类
>   - 需要通过一个类的一个方法来获取具体得实现类得对象


## javaweb-session

### Session 的创建和销毁

> - page 指定的 session 属性: 
>   - 默认情况下, 第一次访问一个 WEB 应用的一个 JSP 页面时, 该页面都必须有一个和这个请求相关联的 Session 对象. 
因为 page 指定的 session 属性默认为 true
>   - 若把 session 属性改为 false, JSP 页面不会要求一定有一个 Session 对象和当前的 JSP 页面相关联
所以若第一次访问当前 WEB 应用的 JSP 页面时, 就不会创建一个 Session 对象. 
>   - 创建一个 Session 对象: 若 page 指定的 session 设置为 false 或 在 Servlet 中可以通过以下 API 获取 Session 对象. 

request.getSession(flag): 若 flag 为 true, 则一定会返回一个 HttpSession 对象, 如果已经有和当前 JSP 页面关联的 HttpSession
对象, 直接返回; 如果没有, 则创建一个新的返回. flag 为 false: 若有关联的, 则返回; 若没有, 则返回 null

request.getSession(): 相当于 request.getSession(true);

>   - Session 对象的销毁: 

①. 直接调用 HttpSession 的 invalidate()
②. HttpSession 超过过期时间. 
③. 卸载当前 WEB 应用.

```xml
	> 返回最大时效: getMaxInactiveInterval() 单位是秒
	> 设置最大时效: setMaxInactiveInterval(int interval)
	> 可以在 web.xml 文件中配置 Session 的最大时效, 单位是分钟. 
	
	<session-config>
        <session-timeout>30</session-timeout>
    	</session-config>
``` 

> - 注意: 关闭浏览器不会销毁 Session!











