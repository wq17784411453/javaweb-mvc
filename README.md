[MVC演示链接](http://www.xidabadminton.top:8080/javaweb-mvc/index.jsp)

[Cookie演示链接](http://www.xidabadminton.top:8080/day_2/app_2/books.jsp)

[session之购物车演示链接](http://www.xidabadminton.top:8080/javaweb-httpsession/shoppingcart/step-1.jsp)


## 学习过程中记录的一些知识点和问题

### 问题：

> - 在创建数据表的时候，为什么要给name字段添加唯一的约束，目的是什么？
> - 在DAO.java里面T get为什么返回的是new BeanHandler<>(clazz)？
> - 在web上进行添加操作的时候，无法像最初在控制台测试test一样，自动添加id，所以对于查询出来的结果没有id号的，不能进行删除和更新。
> - 在执行更新操作的时候，Newcustomer.jsp和updateCustomer.jsp能汇总到一个页面吗？
> - 什么时候创建 HttpSession 对象?
> - 在 Serlvet 中如何获取 HttpSession 对象？
> - 什么时候销毁 HttpSession 对象?
> - 如何实现有状态的会话?
> - cookie是如何进行删除的？



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


### http-session


> - HttpSession 的生命周期：
>   - 什么时候创建 HttpSession 对象
>      - 对于 JSP: 是否浏览器访问服务端的任何一个 JSP, 服务器都会立即创建一个 HttpSession 对象呢？
>      - 不一定。
>         - 若当前的 JSP 是客户端访问的当前 WEB 应用的第一个资源，且 JSP 的 page 指定的 session 属性值为 false, 
则服务器就不会为 JSP 创建一个 HttpSession 对象;
>         - 若当前 JSP 不是客户端访问的当前 WEB 应用的第一个资源，且其他页面已经创建一个 HttpSession 对象，
则服务器也不会为当前 JSP 页面创建一个 HttpSession 对象，而回会把和当前会话关联的那个 HttpSession 对象返回给当前的 JSP 页面.
>      - 对于 Serlvet: 若 Serlvet 是客户端访问的第一个 WEB 应用的资源,
则只有调用了 request.getSession() 或 request.getSession(true) 才会创建 HttpSession 对象
>   - page 指令的 session=“false“  到底表示什么意思？
>      - 当前 JSP 页面禁用 session 隐含变量！但可以使用其他的显式的 HttpSession 对象

>   - 在 Serlvet 中如何获取 HttpSession 对象？
>      - request.getSession(boolean create): 
>      - create 为 false, 若没有和当前 JSP 页面关联的 HttpSession 对象, 则返回 null; 若有, 则返回 true	
>      - create 为 true, 一定返回一个 HttpSession 对象. 若没有和当前 JSP 页面关联的 HttpSession 对象, 则服务器创建一个新的
>      - HttpSession 对象返回, 若有, 直接返回关联的. 
>      - request.getSession(): 等同于 request.getSession(true)

>   - 什么时候销毁 HttpSession 对象:
>      - 直接调用 HttpSession 的 invalidate() 方法: 该方法使 HttpSession 失效
>      -  服务器卸载了当前 WEB 应用. 
>      -  超出 HttpSession 的过期时间.
>         - 设置 HttpSession 的过期时间: session.setMaxInactiveInterval(5); 单位为秒	
>         - 在 web.xml 文件中设置 HttpSession 的过期时间: 单位为 分钟. 
>      - 并不是关闭了浏览器就销毁了 HttpSession.

```xml
	<session-config>
        <session-timeout>30</session-timeout>
    </session-config>
```

> - 使用绝对路径：使用相对路径可能会有问题, 但使用绝对路径肯定没有问题. 
>   - 绝对路径： 相对于当前 WEB 应用的路径. 在当前 WEB 应用的所有的路径前都添加 contextPath 即可. 
>   - / 什么时候代表站点的根目录, 什么时候代表当前 WEB 应用的根目录
>      - 若 / 需要服务器进行内部解析, 则代表的就是 WEB 应用的根目录. 若是交给浏览器了, 则 / 代表的就是站点的根目录
>      - 若 / 代表的是 WEB 应用的根目录, 就不需要加上 contextPath 了. 

> - 表单的重复提交

>   - 重复提交的情况: 
>      - 在表单提交到一个 Servlet, 而 Servlet 又通过请求转发的方式响应一个 JSP(HTML) 页面, 
此时地址栏还保留着 Serlvet 的那个路径, 在响应页面点击 "刷新" 
>      - 在响应页面没有到达时重复点击 "提交按钮". 
>      - 点击 "返回", 再点击 "提交"
>   - 不是重复提交的情况: 点击 "返回", "刷新" 原表单页面, 再 "提交"。
>   - 如何避免表单的重复提交: 在表单中做一个标记, 提交到 Servlet 时, 检查标记是否存在且是否和预定义的标记一致, 若一致, 则受理请求,
并销毁标记, 若不一致或没有标记, 则直接响应提示信息: "重复提交" 
>      -  仅提供一个隐藏域: <input type="hidden" name="token" value="atguigu"/>. 行不通: 没有方法清除固定的请求参数. 
>      - 把标记放在 request 中. 行不通, 因为表单页面刷新后, request 已经被销毁, 再提交表单是一个新的 request.
>      - 把标记放在 session 中. 可以！
>         - 在原表单页面, 生成一个随机值 token
>         - 在原表单页面, 把 token 值放入 session 属性中
>         - 在原表单页面, 把 token 值放入到 隐藏域 中.
>         - 在目标的 Servlet 中: 获取 session 和 隐藏域 中的 token 值
>         - 比较两个值是否一致: 若一致, 受理请求, 且把 session 域中的 token 属性清除
>         - 若不一致, 则直接响应提示页面: "重复提交"

> - 使用 HttpSession 实现验证码

>    - 基本原理: 和表单重复提交一致:
>         - 在原表单页面, 生成一个验证码的图片, 生成图片的同时, 需要把该图片中的字符串放入到 session 中. 
>         - 在原表单页面, 定义一个文本域, 用于输入验证码. 
>         - 在目标的 Servlet 中: 获取 session 和 表单域 中的 验证码的 值
>         - 比较两个值是否一致: 若一致, 受理请求, 且把 session 域中的 验证码 属性清除
>         - 若不一致, 则直接通过重定向的方式返回原表单页面, 并提示用户 "验证码错误"


# 第十周

### cookie：

> - HTTP协议是一种无状态的协议，WEB服务器本身不能识别出哪些请求是同一个浏览器发出的，浏览器的每一次请求都是完全孤立的；即使http1.1支持持续链接，但当用户有一段时间没有提交请求，连接也会关闭；作为一个web服务器，必须能够采用一种机制来唯一的标识一个用户，同时记录该用户的状态。

> - 会话和会话状态：
>    - web应用中的会话是指一个客户端刘炼气与web服务器之间持续发生的一系列请求和响应过程。
>    - web应用的会话状态是指web服务器与浏览器在会话过程中产生的状态信息，借助会话状态
>    - web服务器能够把属于同一会话中的一系列的请求和响应过程关联起来

> - 如何实现有状态的会话：
>    - web服务器端程序要能从大量的请求消息中区分出哪些请求消息属于同一个会话，即能识别出来同一个浏览器的访问请求，这需要浏览器对其发出的每个请求消息都进行标识：属于同一个会话中的请求消息都附带同样的标识号，而属于不同会话的请求消息总是附带不同的标识号，这个标识号就称之为会话ID
>    - 在servlet规范中，常用Cookie和Session两种机制完成会话跟踪。

> - cookie机制：
>    - cookie机制采用的是在客户端保持HTTP状态信息的方案；
>    - cookie是在浏览器访问web服务器的某个资源时，由web服务器在http响应消息头中附带传送给浏览器的一个小文本文件。
>    - 一旦web浏览器保存了某个cookie，那么它在以后每次访问该web服务器时，都会在http请求头中将这个cookie回传给web服务器。
>    - 底层实现原理：web服务器通过在http响应消息中增加set-Cookie响应头字段将Cookie信息发送给浏览器，浏览器则通过在http请求消息中增加cookie请求头字段将cookie回传给web服务器；
>    - 一个cookie只能识别一种信息，它至少含有一个标识该信息的名称和设置值
>    - 一个web站点可以给一个web浏览器发送多个cookie，一个web浏览器也可以存储多个web站点提供的cookie
>    - 浏览器一般只允许存放300个cookie，每个站点最多存放20个cookie，每个cookie的大小限制为4kb。

> - 在servlet程序中使用cookie
>    - servlet API中提供了一个java.servlet.http.Cookie类来封装Cookie信息，它包含生成 Cookie信息和提取Cookie信息的各个属性的方法。
>    - cookie类的方法：
>       - 构造方法：public Cookie(String name,String value)
>       - getName方法
>       - setValue与getValue方法
>       - SetMaxAge与GetMaxAge方法
>       - setPath与getPath方法
>    - httpservletresponse接口中定义了一个addCookie方法，它用于在发送给浏览器的HTTP响应消息中增加一个Set-Cookie响应头字段。
>    - httpservletrequest接口中定义了一个getCookie方法，它用于从HTTP请求消息的Cookie请求字段中获取所有的Cookie项

> - Cookie的发送：
>    - 创建Cookie对象
>    - 设置最大时效
>    - 将Cookie放入到HTTP响应报头
>       - 如果创建了一个Cookie，并将它发送到浏览器，默认情况下它是一个会话级别的cookie；存储在浏览器的内存中，用户退出浏览器之后被删除，并给出一个以秒为单位的时间。将最大时效设为0则是命令浏览器删除该cookie
>       - 发送cookie需要使用httpservletresponse的addCookie方法，将cookie差插入到一个Set-Cookie HTTP响应报头中。由于这个方法并不修改任何之前指定的Set-Cookie报头，而是创建新的报头，因此将这个方法称为是addCookie，而非setCookie

> - 会话cookie和持久cookie的区别：
>    - 如果不设置过期时间，则表示这个cookie生命周期为浏览器会话期间，只要关闭浏览器窗口，cookie就消失了。这种生命周期为浏览器会话期的cookie被称为会话cookie。会话cookie一般不保存在硬盘上而是保存在内存里
>    - 如果设置了过期时间，浏览器就会把cookie保存到硬盘上，关闭后再次打开浏览器，这些cookie依然有效直到超过设定的过期时间
>    - 存储在硬盘上的cookie可以在不同的浏览器进程间共享，比如两个IE窗口。而对于保存在内存的cookie，不同的浏览器有不同的处理方式

> - 自动登陆：
>    - 不需要填写用户名和密码等信息，可以自动登陆到系统

> - books.jsp
>    - 显示最近浏览得五本书：
>       - 获取所有的cookie；
>       - 从中筛选出Book的Cookie；
>       - 如果cookiename为aiguigu_book_开头的即符合条件；
>       - 显示cookievalue
> - book.jsp
>    - 把书的信息以cookie的方式传回给浏览器，删除一个cookie：
>       - 确定要被删除的cookie：aiguigu_book_开头的cookie数量大于或等于5，若从books.jsp传入的book不在aiguigu_book_的cookie中，则删除较早的那个cookie（aiguigu_book_数组的第一个cookie），若在其中，则删除该cookie； 
>       - 把从books.jsp传入的book作为一个cookie返回


# 十一周和十二周

### EL表达式：

<%@ page isELIgnored="true"%> 表示是否禁用EL语言,TRUE表示禁止.FALSE表示不禁

语法格式：${expression}

EL提供.和[]两种运算符来存取数据。当要存取的**属性名称中包含一些特殊字符，如.或?等并非字母或数字的符号，就一定要使用 []**

取变量时，若没有指定范围，则会依序从Page、Request、Session、Application范围查找。

> - 属性范围在EL中的名称
```java

	Page            PageScope
	Request         RequestScope
	Session         SessionScope
	Application     ApplicationScope
```
> - EL中隐含对象：
>    - 与范围有关：使用时相当于 范围.getAttribute()
```java
	PageScope
	RequestScope
	SessionScope
	ApplicationScope
```
>    - 与输入对象有关：相当于 request.getParameter()或request.getParameterValues()
```java	
	param 获取一个参数
	paramValues 获取一组参数
```
> - 其他
```java
	cookie 通过cookie.cookie名获取cookie
	header
	headerValues
	initParam 当前web应用的初始化参数
	pageContext 即为PageContext类型，但只能读
```
> - EL可以进行自动的类型转换;EL关系运算符必须放在表达式里;Empty运算符：放在{}内首位，可作用于后边的集合。若该集合不存在或为空，则表达式输出为true


### 自定义标签

> - HelloWorld
>   - 创建一个标签处理器类: 实现 SimpleTag 接口. 
>   - 在 WEB-INF 文件夹下新建一个 .tld(标签库描述文件) 为扩展名的 xml 文件. 并拷入固定的部分: 并对 
description, display-name, tlib-version, short-name, uri 做出修改

```xml
<taglib xmlns="http://java.sun.com/xml/ns/j2ee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee http://java.sun.com/xml/ns/j2ee/web-jsptaglibrary_2_0.xsd"
    version="2.0">
    
  <description>JSTL 1.1 core library</description>
  <display-name>JSTL core</display-name>
  <tlib-version>1.1</tlib-version>
  <short-name>c</short-name>
  <uri>http://java.sun.com/jsp/jstl/core</uri>
  
</taglib>
```

>   - 在 tld 文件中描述自定义的标签:

```tag
<!-- 描述自定义的 HelloSimpleTag 标签 -->
  <tag>
  	<!-- 标签的名字: 在 JSP 页面上使用标签时的名字 -->
  	<name>hello</name>
  	
  	<!-- 标签所在的全类名 -->
  	<tag-class>com.atguigu.javaweb.tag.HelloSimpleTag</tag-class>
  	<!-- 标签体的类型 -->
  	<body-content>empty</body-content>
  </tag>
 ```
  
>   - 在 JSP 页面上使用自定义标签: 
>      - 使用 taglib 指令导入标签库描述文件: <%@taglib uri="http://www.atguigu.com/mytag/core" prefix="atguigu" %>
>      - 使用自定义的标签: <atguigu:hello/> 
	
>   - setJspContext: 一定会被 JSP 引擎所调用, 先于 doTag, 把代表 JSP 引擎的 pageContext 传给标签处理器类. 

```java
private PageContext pageContext;
	
@Override
public void setJspContext(JspContext arg0) {
	System.out.println(arg0 instanceof PageContext);  
	this.pageContext = (PageContext) arg0;
}
```

>   - 带属性的自定义标签:

>      - 先在标签处理器类中定义 setter 方法. 建议把所有的属性类型都设置为 String 类型. 

```java
private String value;
private String count;

public void setValue(String value) {
	this.value = value;
}

public void setCount(String count) {
	this.count = count;
}
```

>      - 在 tld 描述文件中来描述属性:

```xml
<!-- 描述当前标签的属性 -->
<attribute>
	<!-- 属性名, 需和标签处理器类的 setter 方法定义的属性相同 -->
	<name>value</name>
	<!-- 该属性是否被必须 -->
	<required>true</required>
	<!-- rtexprvalue: runtime expression value 
		当前属性是否可以接受运行时表达式的动态值 -->
	<rtexprvalue>true</rtexprvalue>
</attribute>
```

>      - 在页面中使用属性, 属性名同 tld 文件中定义的名字. 
```xml
<atguigu:hello value="${param.name }" count="10"/>
```
>   - 通常情况下开发简单标签直接继承 SimpleTagSupport 就可以了. 可以直接调用其对应的 getter 方法得到对应的 API 
```java
public class SimpleTagSupport implements SimpleTag{
    
    public void doTag() 
        throws JspException, IOException{}
    
    private JspTag parentTag;
    
    public void setParent( JspTag parent ) {
        this.parentTag = parent;
    }
    
    public JspTag getParent() {
        return this.parentTag;
    }
    
    private JspContext jspContext;
    
    public void setJspContext( JspContext pc ) {
        this.jspContext = pc;
    }
    
    protected JspContext getJspContext() {
        return this.jspContext;
    }
    
    private JspFragment jspBody;
                
    public void setJspBody( JspFragment jspBody ) {
        this.jspBody = jspBody;
    }
    
    protected JspFragment getJspBody() {
        return this.jspBody;
    }   
}
```


### JSTL:

> -  c:out 主要用于对特殊字符进行转换. 真正进行输出时, 建议使用 c:out, 而不是使用 EL
> - c:set: 可以为域赋属性值。 而对域对象中的 JavaBean 的属性赋值用的并不多. 
> - c:remove: 移除指定域对象的指定属性值(较少使用, 即便移除也是在 Servlet 中完成)
> - c:if: 在页面上对现实的内容进行过滤, 把结果存储到域对象的属性中. 但不灵活, 会被其他的自定义标签所取代. 
> - c:choose, c:when, c:otherwise: 作用同上, 但麻烦, 不灵活.
> - c:forEach: 对集合进行遍历的. 常用!
> - c:forTokens: 处理字符串, 类似于 String 累的 split() 方法(知道即可)
> - c:import: 导入页面到当前页面的. (了解)
> - c:redirect: 当前页面进行重定向的. (使用较少)
> - c:url: 产生一个 URL 的, 可以进行 URL 重写, 变量值编码, 较为常用. 

> - 开发有父标签的标签:
>    - 父标签无法获取子标签的引用, 父标签仅把子标签作为标签体来使用. 
>    - 子标签可以通过 getParent() 方法来获取父标签的引用(需继承 SimpleTagSupport 或自实现 SimpleTag 接口的该方法):
若子标签的确有父标签, JSP 引擎会把代表父标签的引用通过  setParent(JspTag parent)  赋给标签处理器
>    - 注意: 父标签的类型是 JspTag 类型. 该接口是一个空接口, 但是来统一 SimpleTag 和 Tag 的. 实际使用需要进行类型的强制转换.
>    - 在 tld 配置文件中, 无需为父标签有额外的配置. 但, 子标签是是以标签体的形式存在的, 所以父标签的 <body-content></body-content>
需设置为 scriptless
>    - 实现 
```jsp
<c:choose>
	<c:when test="${param.age > 24}">大学毕业</c:when>
	<c:when test="${param.age > 20}">高中毕业</c:when>
	<c:otherwise>高中以下...</c:otherwise>
</c:choose>

	> 开发 3 个标签: choose, when, otherwise
	> 其中 when 标签有一个 boolean 类型的属性: test
	> choose 是 when 和 otherwise 的父标签
	> when 在 otherwise 之前使用
	
	> 在父标签 choose 中定义一个 "全局" 的 boolean 类型的 flag: 用于判断子标签在满足条件的情况下是否执行. 
	
		* 若 when 的 test 为 true, 且 when 的父标签的 flag 也为 true, 则执行 when 的标签体(正常输出标签体的内容), 
		     同时把 flag 设置为 false
		* 若 when 的 test 为 true, 且 when 的父标签的 flag 为 false, 则不执行标签体. 
		* 若 flag 为 true, otherwise 执行标签体. 
```

> - 带标签体的自定义标签: 

>    - 若一个标签有标签体: 
```java
<atguigu:testJspFragment>abcdefg</atguigu:testJspFragment>
```
在自定义标签的标签处理器中使用 JspFragment 对象封装标签体信息. 

>    - 若配置了标签含有标签体, 则 JSP 引擎会调用 setJspBody() 方法把 JspFragment 传递给标签处理器类,在 SimpleTagSupport 中还定义了一个 getJspBody() 方法, 用于返回 JspFragment 对象. 
>    - JspFragment 的 invoke(Writer) 方法: 把标签体内容从 Writer 中输出, 若为 null, 则等同于 invoke(getJspContext().getOut()), 即直接把标签体内容输出到页面上.有时, 可以 借助于 StringWriter, 可以在标签处理器类中先得到标签体的内容: 
```java
//1. 利用 StringWriter 得到标签体的内容.
StringWriter sw = new StringWriter();
bodyContent.invoke(sw);
//2. 把标签体的内容都变为大写
String content = sw.toString().toUpperCase();
```
> - 在 tld 文件中, 使用 body-content 节点来描述标签体的类型: 

<body-content>: 指定标签体的类型, 大部分情况下, 取值为 scriptless。可能取值有 3 种：
empty: 没有标签体	
scriptless: 标签体可以包含 el 表达式和 JSP 动作元素，但不能包含 JSP 的脚本元素
tagdependent: 表示标签体交由标签本身去解析处理。
若指定 tagdependent，在标签体中的所有代码都会原封不动的交给标签处理器，而不是将执行结果传递给标签处理器

<body-content>tagdependent</body-content>

> - 定义一个自定义标签: <atguigu:printUpper time="10">abcdefg</atguigu> 把标签体内容转换为大写, 并输出 time 次到
浏览器上. 

> -  实现 forEach 标签: 
```jsp
	> 两个属性: items(集合类型, Collection), var(String 类型)
	
	> doTag: 
	
		* 遍历 items 对应的集合
		* 把正在遍历的对象放入到 pageContext 中, 键: var, 值: 正在遍历的对象. 
		* 把标签体的内容直接输出到页面上. 

    <c:forEach items="${requestScope.customers }" var="cust2">
		${pageScope.cust2.id } -- ${cust2.name } <br>
	</c:forEach>
```

# 十三周

> - Struts2概述：
>    - Struts2是一个用来开发MVC应用程序的框架，它提供了Web应用程序开发过程中的一些常见问题的解决方案：对来自用户的输入数据进行合法性验证、统一的布局、可扩展性、国际化和本地化、直接Ajax、表单的重复提交、文件的上传和下载

> - Struts2和Strus1
>    - 在体系结构方面更优秀：类更少，更高效：
>    - 在Struts2中无需使用“ActionForm”来封装请求参数；
>    - 扩展更容易：Struts2通过拦截器完成了框架的大部分工作.在Struts2中插入了一个拦截器对象相当简便易行
>    - 更容易测试：即使不使用浏览器也可以对基于Struts2的应用进行测试

> - VS自实现
>    - 搭建Struts2的开发环境
>    - 不需要显示的定义Filter，而使用的是struts2的配置文件
>    - detail.jsp比先前变得更简单了
>    - 步骤:
>       - 由 product-input.action 转到 /WEB-INF/pages/input.jsp
```xml	
	在 struts2 中配置一个 action
	
	<action name="product-input">
		<result>/WEB-INF/pages/input.jsp</result>
	</action>
```	
>       - 由 input.jsp 页面的 action: product-save.action 到 Product's save, 再到  /WEB-INF/pages/details.jsp
```xml
	<action name="product-save" class="com.atguigu.struts2.helloworld.Product"
		method="save">
		<result name="details">/WEB-INF/pages/details.jsp</result>	
	</action>
```	
>       - 在 Prodcut 中定义一个 save 方法, 且返回值为 details

> - result:

>    - result 是 action 节点的子节点
>    - result 代表 action 方法执行后, 可能去的一个目的地
>    - 一个 action 节点可以配置多个 result 子节点. 
>    - result 的 name 属性值对应着 action 方法可能有的一个返回值. 
>    - result 一共有 2 个属性, 还有一个是 type: 表示结果的响应类型
>    - result 的 type 属性值在 struts-default 包的 result-types 节点的 name 属性中定义.常用的有 :
>       - dispatcher(默认的): 转发. 同 Servlet 中的转发. 
>       - redirect: 重定向
>       - redirectAction: 重定向到一个 Action
>       - 注意: 通过 redirect 的响应类型也可以便捷的实现 redirectAction 的功能!
 ```xml   	
    <result name="index" type="redirectAction">
		<param name="actionName">testAction</param>
		<param name="namespace">/atguigu</param>
	</result>
	
	OR
	
	<result name="index" type="redirect">/atguigu/testAction.do</result>
```    	
>    - chain: 转发到一个 Action
>    - 注意: 不能通过 type=dispatcher 的方式转发到一个 Action;只能是:

 ```xml       
    <result name="test" type="chain">
		<param name="actionName">testAction</param>
		<param name="namespace">/atguigu</param>
	</result>	
	不能是:
	
	<result name="test">/atguigu/testAction.do</result>
```			
			     
> - ActionSupport

>    - ActionSupport 是默认的 Action 类: 若某个 action 节点没有配置 class 属性, 则 ActionSupport 即为
待执行的 Action 类. 而 execute 方法即为要默认执行的 action 方法
```xml
<action name="testActionSupport">
	<result>/testActionSupport.jsp</result>
</action>
等同于
<action name="testActionSupport"
	class="com.opensymphony.xwork2.ActionSupport"
	method="execute">
	<result>/testActionSupport.jsp</result>
</action>
```
>    - 在手工完成字段验证, 显示错误消息, 国际化等情况下, 推荐继承 ActionSupport. 

> - 关于 Struts2 请求的扩展名问题

>    - org.apache.struts2 包下的 default.properties 中配置了 Struts2 应用个的一些常量
>    - struts.action.extension 定义了当前 Struts2 应用可以接受的请求的扩展名.
>    - 可以在 struts.xml 文件中以常量配置的方式修改 default.properties 所配置的常量.
```xml
<constant name="struts.action.extension" value="action,do,"></constant>
```

> - action和action类
>    - action：代表一个struts2的请求；应用程序可以完成的每一个操作。例如：显示一个登陆表单，把产品信息保存起来
>    - action类：能够处理Struts2请求的类；普通的java类，可以有属性和方法，同时必须遵守下面的这些规则：属性的名字必须遵守与JavaBeans属性名相同的命名规则。属性的类型可以是任意类型，从字符串到非字符串(基本数据库类型)之间的数据转换可以自动发生；必须有一个不带参的构造器；至少提供一个struts在执行这个action时调用的方法；同一个Action类可以包含多个action方法；Struts2会为每一个HTTP请求创建一个新的Action实例

> - 在action中访问web资源
>    - 在Action中，可以通过一下方式访问web的HttpSession，HttpServletRequest，HttpServletResponse等资源：与Servlet API解耦的访问方式(只能访问有限的Servlet API对象，且只能访问有限的方法(读取请求参数，读写域对象的属性，))、与servlet API耦合的访问方式(可以访问更多的Servlet API对象，且可以调用其原生的方法)。

> - 什么是web资源？
>    - HttpServletRequest，HttpServletResponse，ServletContext等原生的Servlet ApI。

> - 为什么访问web资源？
>    - B\S的应用的Controller中必然需要访问web资源：向域对象中读写属性，读写Cookie，获取realPath。。。
















