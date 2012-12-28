---
layout: default
title: "在FreeSWITCH中执行长期运行的嵌入式脚本--Lua语言例子"
---

# {{ page.title }}

众所周知，FreeSWITCH中可以使用嵌入式的脚本语言javascript、lua等来控制呼叫流程。而更复杂一点操作可能就需要使用[Event Socket](http://wiki.freeswitch.org/wiki/Event_Socket)了。其实不然，嵌入式的脚本也可以一直运行，并可以监听所有的Event，就像使用Event Socket起一个单独的Daemon一样。

这里我们以lua为例来讲一下都有哪些限制以及如何解决。

首先，在控制台或fs\_cli中执行一个Lua脚本有两种方式，lua和luarun。二者的不同就是lua是在当前线程中运行的，所以，它会阻塞；而luarun会spawn一个新的线程，不会阻塞当前的线程执行。

另外，你也可以写到lua.conf配置文件中，这样它就能随FreeSWITCH一起启动。

<code>
	<param name="startup-script" value="gateway_report.lua"/>
</code>

脚本后面可以加参数，如 luarun test.lua arg1 arg2，在脚本中，就可以通过argv[1], argv[2]来获得参数的值。而argv[0]是脚本的名字。

如果要让脚本一直运行，脚本中必须有一个无限循环。你可以这样做：

<code>
while true do
  -- Sleep for 500 milliseconds
  freeswitch.msleep(500);
  freeswitch.consoleLog("info", "blah...");
end
</code>

但这样的脚本是无法终止的，由于FreeSWITCH使用swig支持这些嵌入式语言，而有些语言没有退出机制，所以，所有语言的退出机制都没有在FreeSWITCH中实现，即使unload相关的语言模块也不行，也是因为如此，为了避免产生问题，所有语言模块也都不能unload。

另外，使用freeswitch.msleep() 也不安全，Wiki上说: Do not use this on a session-based script or bad things will happen。

既然是长期运行的脚本，那，为什么为停止呢？是的，大部分时间你不需要，但，如果你想修改脚本，总不会每次都重启FreeSWITCH吧？尤其是在调试的时候。

那，还有别的办法吗？

我们可以使用事件机制构造另一个循环：

<code>
con = freeswitch.EventConsumer("all");                                                                         
for e in (function() return con:pop(1) end) do
  freeswitch.consoleLog("info", "event\n" .. e:serialize("xml"));
end
</code>

上面的代码中，con被初始化成一个事件消费者。它会一直阻塞并等待FreeSWITCH发出一个事件，并打印该事件的XML表示。当然，事件总会有的。如每个电话初始化、挂机等都会有相应的事件。除此之外，FreeSWITCH内部也会毎20秒发出一个heartbeat事件，这样你就可以定时执行一些任务。

当然如果使用 con:pop(0)也可以变成无阻塞的，但你必须在循环内部执行一些sleep()以防止脚本占用太多的资源。

通过这种方法，你应该就能想到办法让脚本退出了。那就是，另外执行一个脚本触发一个custom的事件，当该脚本监测到特定的custom事件后退出。当然你也可以不退出，比方说，打印一些信息以用于调试。

我写了一个gateway\_report.lua脚本。就用了这种技术。思路是：监听所有事件。如果收到hangup，则判断是通过哪个gateway出去的，并计算一些统计信息。如果需要保存这些信息，可以有以下几种方式：

1）fire\_event，即触发另一个事件，这样，如果有其它程序监听，就可以收到这个事件，从而可以进行处理，如存入数据库等。

2）http\_post，发一个HTTP post请求到一个HTTP server，HTTP server接收到请求后进行下一步处理。其中，http\_post是无阻塞的，以提高效率，即只发请求，而不等待处理结果。

3）db，可以通过luasql直接写到数据库，未完全实现

4）当然你也可以直接通过io.open写到一个本地文件，未实现...

由于这种脚本会在FreeSWITCH内部执行，需要消耗FreeSWITCH的资源，因此，在大话务量（确切来说是“大事件量”）的情况下还是应该用Event Socket。

完整的代码在 <http://svn.freeswitch.org/svn/freeswitch/trunk/seven/lua/gateway_report.lua>

其它参考资料：

* FreeSWITCH提供的API：<http://wiki.freeswitch.org/wiki/Mod_lua>

* Lua语言：<http://www.lua.org/>
