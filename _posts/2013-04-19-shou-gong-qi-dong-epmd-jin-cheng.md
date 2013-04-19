---
layout: post
title: "手工启动epmd进程"
tags:
  - "erlang"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>

epmd(Erlang Port Mapper Daemon)相关于Erlang集群系统的DNS，用于节点名称到IP地址是映射和查询，这一点，高手已经讲的很清楚了：<http://blog.yufeng.info/archives/539> .

FreeSWITCH中的mod\_erlang\_event模块相当于一个隐藏的Erlang节点（Hidden Node），它在启动时同样会查询和注册epmd服务，但今天发现在CentOS6.3上，如果FS启动到后面模式（-nc），则它不能正常启动epmd服务。具体原因尚不清楚。

由于它是第一个启动的Erlang节点，因此它会先负责把epmd启动起来，当然它不能正常工作的话，就需要手工先启动epmd了。

启动epmd的方法有很多种。但既然启动一个Erlang节点可以自动启动该服务，我们就试一试这种方法：

    erl -noshell -sname test@localhost -s init stop

以上方法可以正常启动 epmd，加到启动脚本中保证它在FreeSWITCH之前启动即可。

