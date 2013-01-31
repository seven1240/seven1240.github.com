---
layout: post
title: "我也试用Chrome OS"
tags:
  - "chrome"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>


[我喜欢尝试新东西](/past/2009/11/25/just-because-you-can-do-something-doesnt-mean-you-should/)。虽然大家对Chrome OS褒贬不一，但还是觉得应该试一下，毕竟Google的东西还是值得学习的。虽然我知道[Richard Stallman](http://stallman.org/)是坚决反对云计算的。

新的Chrome OS出来以后，我一直无法用BT下载，今天终于看到了一个[电驴下载的](http://linux.cn/home/space-2-do-thread-id-1471.html)。很快就下完了。

在我的Mac上，创建一个虚拟机，加载硬盘，不能启动。自从用了VitualBOX 3.0.2就一直有这个问题，主要是不支持VT-x和AMD-V，但又没法Disable。我只好关掉VitualBOX，手工修改配置文件：

<code>
vi ~/Library/VirtualBox/Machines/Chrome/Chrome.xml 
</code>

把以下参数设成False。
<code>
        <HardwareVirtEx enabled="false"/>
</code>

再启动VitualBOX，好了，启动果然很快。登录页面显示的是Chromium OS，看来Chrome只是浏览器的名字。登录有点慢，Gmail的原因吧？抑或是虚拟机。操作起来也不顺畅，但打开某些页面倒挺快，如新浪和<http://www.eqenglish.com>，加载Flash也没问题，只是没在虚拟机里搞定声卡。

就一个浏览器，怎么关机啊？强关，VirtualBOX提示"send to shutdown signal"，好像是正常关了，再重启，正常。要是有个Shell该多好啊！本来就是Linux嘛。上网查了一下，果然有，还得到一组快捷键（在虚拟机下并不是所有的都好用）：

<code>
 快捷键（组合）  	何时使用  	功能
F12 	Running 	Toggle Window Overview
F8 	Running 	Toggle keyboard overlay showing all the shortcut keys
ESC 	Window Overview 	Exit Window Overview
F2 	Boot 	Startup options - disable internal HDD to boot from USB stick
Ctrl + Alt + T 	Running 	Open Terminal Window
Ctrl + Alt + N            	Chrome        	Open New Chrome Window
Ctrl + Alt + L 	Running 	Lock the screen
Ctrl + Alt + M 	Running 	Enable external monitor
Ctrl + , 	Chrome 	Goto battery and network settings page (localhost:8080)
Ctrl + Tab 	Chrome 	Next Tab
Ctrl + Shift + Tab 	Chrome 	Prior Tab
Ctrl + 1 through Ctrl + 8 	Chrome 	Switches to the tab at the specified position number on the tab strip
Alt + Tab 	Running 	Next Window
Alt + Shift + Tab 	Running 	Prior Window
Close Lid 	Running 	Sleep mode
Power-Key 	Running 	Shutdown
</code>

内核还是挺新的：

<code>
chronos@localhost:~$ uname -a
Linux localhost 2.6.30-chromeos-intel-menlow #1 SMP Thu Nov 19 20:37:56 UTC 2009 i686 GNU/Linux
</code>

