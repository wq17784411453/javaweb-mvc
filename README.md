[演示链接](http://www.xidabadminton.top:8080/javaweb-mvc/index.jsp)

## 学习过程中记录的一些知识点和问题

### 问题：

> - 在创建数据表的时候，为什么要给name字段添加唯一的约束？

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

### 创建数据表

```mysql
mysql> Create table customers(
    -> id int primary key auto_increment,
    -> name varchar(30) not null unique,
    -> address varchar(30),
    -> phone varchar(30));
    mysql> alter table customers add constraint name_uk unique(name);//为name字段添加唯一的约束
```

### Module层

#### 加入`C3P0`数据源

1. 下载`C3P0`数据源包

2. 将数据源包拷贝到lib目录下

3. 在`src`目录下添加`c3p0-config.xml`文件

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <c3p0-config>
     <named-config name="mvcapp"> 
       <property name="user">*</property>
   	<property name="password">*</property>
   	<property name="driverClass">com.mysql.jdbc.Driver</property>
   	<property name="jdbcUrl">jdbc:mysql://localhost:3306/javaweb-mvc?useSSL=true</property>
       <property name="acquireIncrement">5</property>
       <property name="initialPoolSize">10</property>
       <property name="minPoolSize">10</property>
       <property name="maxPoolSize">50</property>

       <property name="maxStatements">20</property> 
       <property name="maxStatementsPerConnection">5</property>
     </named-config>
   </c3p0-config>
   ```

如果在运行程序出现错误:

```java
java.lang.NoClassDefFoundError: com/mchange/v2/ser/Indirector 
```

把`mchange-commons-java-0.2.11.jar`包也拷贝到lib目录

#### 编写`DAO`、`JDBCUtils`工具类和`CustomerDAO`接口

DAO:

```java
package com.mvcapp.dao;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.sql.Connection;
import java.util.List;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import com.mvcapp.db.JdbcUtils;

/**
 * @author zp
 * 封装了基本的CRUD的方法，以供子类继承使用
 * 当前DAO直接方法中获取数据库连接
 * 整个DAO采取DBUtils解决方案
 */
public class DAO<T> {
	private QueryRunner queryRunner = new QueryRunner();
	public Class<T> clazz;
	public DAO() {
		Type superClass = getClass().getGenericSuperclass();
		if(superClass instanceof ParameterizedType) {
			ParameterizedType parameterizedType = (ParameterizedType)superClass;
			Type[] typeArgs = parameterizedType.getActualTypeArguments();
			if(typeArgs != null && typeArgs.length > 0) {
				if(typeArgs[0] instanceof Class) {
					clazz = (Class<T>)typeArgs[0];
				}
			}
		}
	}
	/**
	 * 该方法封装了INSERT、DELETE、UPDATE操作
	 * @param sql : sql语句
	 * @param args　: 填充sql语句的占位符
	 */
	public void update(String sql, Object ...args) {
		Connection connection = null;
		try {
			connection = JdbcUtils.getConnection();
			queryRunner.update(connection,sql,args);
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JdbcUtils.releaseConnection(connection);
		}
	}
	/**
	 * 返回对应的Ｔ的一个实例类的对象
	 * @param sql
	 * @param args
	 * @return 
	 */
	public T get(String sql, Object ...args) {
		Connection connection = null;
		try {
			connection = JdbcUtils.getConnection();
			return queryRunner.query(connection,sql,new BeanHandler<>(clazz),args);
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JdbcUtils.releaseConnection(connection);
		}
		return null;
	}
	/**
	 * 返回T对应的List
	 * @param sql
	 * @param arge
	 * @return 
	 */
	public List<T> getForList(String sql, Object ...args){
		Connection connection = null;
		try {
			connection = JdbcUtils.getConnection();
			return queryRunner.query(connection,sql,new BeanListHandler<>(clazz),args);
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JdbcUtils.releaseConnection(connection);
		}
		return null;
	}
	/**
	 * 返回某一个字段的值：例如返回某一条记录的customerName,或返回数据表中有多少记录
	 * @param sql
	 * @param args
	 * @return 
	 */
	public <E> E getForValue(String sql, Object ...args) {
		Connection connection = null;
		try {
			connection = JdbcUtils.getConnection();
			return (E)queryRunner.query(connection,sql,new ScalarHandler(),args);
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JdbcUtils.releaseConnection(connection);
		}
		return null;
	}
}

```

JDBCUtils：

>  下载JDBCUtils包http://commons.apache.org/proper/commons-dbutils/download_dbutils.cgi

```java
QueryRunner queryRunner = new QueryRunner();
queryRunner.query(connection,sql,new BeanHandler<>(clazz),args);
queryRunner.query(connection,sql,new BeanListHandler<>(clazz),args);
(E)queryRunner.query(connection,sql,new ScalarHandler(),args);
```

#### 提供`CustomerDAO`接口的实现类`CustomerDAOJDBClmpl`

```java
package com.mvcapp.dao.impl;

import java.util.List;

import com.mvcapp.dao.CustomerDAO;
import com.mvcapp.dao.DAO;
import com.mvcapp.domain.CriteriaCustomer;
import com.mvcapp.domain.Customer;

public class CustomerDAOJdbcImpl extends DAO<Customer> implements CustomerDAO{

	@Override
	public List<Customer> getAll() {
		String sql = "SELECT id,name,address,phone FROM customers";
		return getForList(sql);
	}

	@Override
	public void save(Customer customer) {
		String sql = "INSERT INTO customers(name,address,phone) VALUES(?,?,?)";
		update(sql,customer.getName(),customer.getAddress(),customer.getPhone());
	}

	@Override
	public Customer get(Integer id) {	
		String sql = "SELECT id,name,address,phone FROM customers WHERE id=?";
		return get(sql,id);
	}

	
	@Override
	public void delete(Integer id) {
		String sql = "DELETE FROM customers WHERE id=?";
		update(sql,id);
	}

	@Override
	public long getCountWithName(String name) {
		String sql = "select count(id) FROM customers WHERE name=?";
		return getForValue(sql,name);
	}

	@Override
	public List<Customer> getForListWithCriteriaCustomer(CriteriaCustomer cc) {
		String sql = "SELECT id,name,address,phone FROM customers WHERE "
				+ "name like ? and address like ? and phone like ?";
		return getForList(sql, cc.getName(), cc.getAddress(), cc.getPhone());
	}

}
```

### Control层

> Control层由servlet组成，这里一个servlet处理多个请求。接受浏览器传来的请求并在解析请求调用Model层的API

#### 一个Servlet处理多个请求的方式

- 在请求后面加参数，在servlet中通过对参数的分析进行不同的响应

  请求:

  ```java
  /customer?methon=add
  /customer?methon=query
  /customer?methon=delete
  ```

- 直接设置不同的请求路径，在web.xml中设置使用同一个servlet响应，然后在servlet中分析servletpath来进行不同响应

  请求

  ```java
  /add.do
  /query.do
  /delete.do
  ```

  web.xml

  ```xml
  <servlet-mapping>
      <servlet-name>customerservlet</servlet-name>
      <url-pattern>*.do</url-pattern>
  </servlet-mapping>
  ```

  servlet中

  ```java
  // 获取方法名
  String  path = request.getServletPath();
  String methodName = path.substring(1,path.length()-3);
  try {
      // 获取方法
      Method method = this.getClass().getDeclaredMethod(methodName,                                                      HttpServletRequest.class, HttpServletResponse.class);
      // 执行方法
      method.invoke(this, request,response);			
  } catch (Exception e) {
      response.sendRedirect("error.jsp");
      e.printStackTrace();
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

#### 删除

1. 点击删除
2. 弹出
3. 获取id
4. 调用DAO删除
5. **重定向**到query.do

```java
int id = Integer.parseInt(request.getParameter("id"));
customerDao.delete(id);
try {
    response.sendRedirect("query.do");
} catch (IOException e) {
    e.printStackTrace();
}
```

不足:删除之后跳转回页面的查询条件是查询全部，与之前的查询条件不同

### View层

> View层包含index.jsp、error.jsp页面。

当请求页面不存在时显示error.jsp

```java
// 在catch中加入
response.sendRedirect("error.jsp");
```

