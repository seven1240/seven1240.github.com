---
layout: post
title: "使用30行Erlang代码克隆一个TinyURL"
tags:
  - "erlang"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>


[TinyURL](http://tinyurl.com)是一种短域名服务，就是把很长的URL转换成比较短的。也许你觉得没什么用，起初我也这么认为，而且看到别人用时也很不理解，但后来才了现它真的很有用--它真的可以把很长的URL转换成很短的。当然，最重要的不在于它的压缩率多么有效，关键是缩短后很方便在手机上发送了。

我在TinyURL上试了一下，96个字符的地址最后转成了26。当然，越长的地址就越明显。

<code>

TinyURL was created!

The following URL:

    http://www.google.cn/search?hl=zh-CN&q=www.dujinfang.com&btn
    G=Google+%E6%90%9C%E7%B4%A2&aq=f&oq=

has a length of 96 characters and resulted in the following TinyURL which has a length of 26 characters:

    http://tinyurl.com/yj4bu56

</code>

当然，还有其它网站如bit.ly、tr.im等可以生成更短的域名，因为它们本身的域名就短。好玩起见，我也把本博客的post地址Tiny了一下，效果见下面的"短地址"（当然，最重要的是[先缩短域名](http://www.7ge.cn/717)了 :lol ）。

<code>
diff --git a/lib/post.rb b/lib/post.rb
--- a/lib/post.rb
+++ b/lib/post.rb
+	
+	def short_url
+	  "http://www.7ge.cn/7#{id.to_s(36)}"
+	end

diff --git a/main.rb b/main.rb
 
+get '/7*' do
+  id = request.path_info.sub(/^\/7/,'').to_i(36)
+	post = Post.filter(:id => id).first    
+	
+	if post
+	  redirect post.url, 301
+	else 
+	  redirect '/', 302
+  end
+end
+  

diff --git a/views/post.erb b/views/post.erb

+		短地址：<input value="<%= post.short_url %>" size="40"/><br>

</code>

写这篇文章是源于前几天看到的一篇Blog--[Clone TinyURL in 40 lines of Ruby code](http://blog.saush.com/2009/04/13/clone-tinyurl-in-40-lines-of-ruby-code/)，内容非常精彩，作者只用了40几行代码就实现了，他命名为[Snip](snip.heroku.com)，源代码在[作者的github](http://github.com/sausheong/snip/)。正好最近学习Erlang，我就用Erlang把Snip又克隆了一下，除去[MochiWEB](http://code.google.com/p/mochiweb/) 框架，竟然用了不到30行代码。

<code>
svn checkout http://mochiweb.googlecode.com/svn/trunk/ mochiweb-read-only
cd mochiweb-read-only
make
escript scripts/new_mochiweb.erl test
cd test
</code>

注意，我用的是最新的Erlang R13B02-1，旧一点的Erlang在执行escript时会出错。

首先，修改页面，priv/www/index.html，加入一个简单的Form:

<code>
<h1>Erlang Snip</h1>
 
<form method="post" action="/">
	Your Url: <input name="url" size="60"/>
	<input type="submit" value="Submit">
</form>
</code>

接下来，我只修改了test_web.erl，加了一些代码：
<code>
	ets:new(urls, [named_table, public]),
</code>

初始化一个表，用于存储URL数据。在此仅为演示，使用了内存表，如果需要永久存储，则可以使用DETS或mnesia。

<code>
        Method when Method =:= 'GET'; Method =:= 'HEAD' ->
             case filelib:is_file(filename:absname(Path, DocRoot)) of
                true ->  Req:serve_file(Path, DocRoot);
		false -> handle_get(Req)
            end;
        'POST' ->
            case Path of
		[] -> handle_post(Req);
                _ -> Req:not_found()
            end;
</code>

以上，代码判断请求的文件是否存在，不存在则转到我们自己写的函数handle_get/post处理。

<code>
	handle_post(Req) ->
		LastId = ets:info(urls, size) + 10000,
</code>

此处我们简单的根据ets表的大小生成ID，在高并发的情况下应该避免这样用。另外，+10000只是为了模拟数据表中有很多的记录。

其它代码应该很直观，也是用了36进制的ID，请查看[GitHub上全部的源代码](http://github.com/seven1240/ErlangSnip/)。

<code>

make
./start-dev.sh
</code>

打开你的浏览器，访问localhost:8000/就可以了，加入几条记录，在Erlang的console中可以查看全部数据表：
<code>
ets:tab2list(urls).
</code>

关于MochiWeb可以参考一下Erlang-China上的[实战MochiWeb](http://erlang-china.org/start/mochiweb_intro.html).
