---
layout: post
title: "在Mac上安装rrdtool问题"
tags:
  - "rrdtool"
  - "mac"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>

前天用安装rrdtool时遇到一个bug：


	(process:16981): GLib-GObject-CRITICAL **: gtype.c:2720: You forgot to call g_type_init()

	(process:16981): GLib-CRITICAL **: void g_once_init_leave(volatile void *, gsize): assertion `result != 0' failed

	(process:16981): GLib-GObject-CRITICAL **: gtype.c:2720: You forgot to call g_type_init()

	(process:16981): GLib-CRITICAL **: void g_once_init_leave(volatile void *, gsize): assertion `result != 0' failed

	(process:16981): GLib-GObject-CRITICAL **: gtype.c:2720: You forgot to call g_type_init()

	(process:16981): GLib-GObject-CRITICAL **: gtype.c:2720: You forgot to call g_type_init()

几番搜索后找到这个补丁： <https://github.com/oetiker/rrdtool-1.x/issues/374>

不知道怎么打补丁，顺便学习了一下这个： <https://github.com/mxcl/homebrew/wiki/Formula-Cookbook>

原来 brew 可以交互式的产生补丁，直接使用以下命令可以进到一个新的shell中。

	brew install --interactive --git foo

然后手工修改文件，最后使用 git diff | pbcopy 将补丁粘帖到剪贴板。按 exit 退出交互式 shell。然后使用 

	brew edit rrdtool-1

进入 formula 的编辑界面，把上面的补丁粘贴到文件尾部存盘退出就行了。最后重新使用 brew install 在安装就能把刚才的补丁打进去。

补丁文件如下，还没来得及怎么研究把补丁提交给组织。



	diff --git a/src/rrd_graph.c b/src/rrd_graph.c
	index 5f70a38..303d3f3 100644
	--- a/src/rrd_graph.c
	+++ b/src/rrd_graph.c
	@@ -4066,6 +4066,8 @@ void rrd_graph_init(
	     static PangoFontMap *fontmap = NULL;
	     PangoContext *context;
	 
	+    g_type_init();
	+
	 #ifdef HAVE_TZSET
	     tzset();
	 #endif
