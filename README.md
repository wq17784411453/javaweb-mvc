[演示链接](http://www.xidabadminton.top:8080/javaweb-mvc/index.jsp)
## javaweb-mvc
> - MVC的概念：是Model-View-Controller的简称，即模型-视图-控制器。MVC是一种设计模式，它va应用程序分成三个核心模块：模型、视图、控制器，他们各自处理自己的任务。
>   - 模型是应用程序的主体部分，模型表示业务数据和业务逻辑；一个模型能为多个视图提供数据；由于应用于模型的代码只需要写一次就可以被多个视图重用，所以提高了代码的可重用性。
>   - 视图是用户看到并与之交互的界面，作用如下：视图向用户显示相关的数据；接受用户的输入；不进行任何实际的业务处理。
>   - 控制器：接受用户的输入并决定调用哪个模型组件去处理请求，然后决定调用哪个视图来显示模型处理返回的数据
> - Model具体是什么？
>   - MVC Model基本上就是一个java的类。
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
>   - 连接数据库使用C3P0数据库连接池
>   - JDBC工具采用DBUtils
>   - 页面上的提示操作使用Query
> - 技术难点
>   - 多个请求用一个Servlet
>   - 模糊查询
>   - 在创建或修改的情况下，验证用户名是否已经被使用并给出提示
> - 注意：不能跨层访问；只能自上向下依赖，而不能自下向上依赖
