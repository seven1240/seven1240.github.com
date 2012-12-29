---
layout: default
title: "在Sinatra中支持手机WAP访问"
---

# {{ page.title }}

由于我的手机浏览器超烂，所以很少拿它上网。日前试了试访问我的网站，竟然把“节省”显示成“节剩”，真让人哭笑不得。昨天，给老婆买了个AnyCall，上网好用多了，但是在加载Google JS代码时老出错。索性，写了个Wap版的。

本打算专门用个域名m.7ge.cn，后来觉得没必要，还是动态检测一下比较好，如果是手机，就用WAP的Layout。

由于手机型号、版本及运营商的差别，检测起来也不是那么简单，参考了[判断手机上网接入方法](http://bbs.blueidea.com/archiver/tid-2917554.html)一文，暂时只检测HTTP\_USER\_AGENT和HTTP\_VIA。

<code>
before do
  if request.user_agent.nil? || request.env['HTTP_VIA'] =~ /WAP/
    @is_wap = true
  end
end
</code>

<code>
get '/' do
  posts = Post.reverse_order(:created_at).limit(10)
	   
  if @is_wap
    erb :index_wap, :locals => {:posts => posts}, :layout => :layout_wap
  else
    comments = Comment.reverse_order(:created_at).limit(10)
    erb :index, :locals => { :posts => posts, :comments => comments }, :layout => false
  end
end
</code>

需要说明，layout参数一定需要是一个Hash(如上面的:layout\_wap)，否则不能正确显示。这种方法虽然不是最好的，但考虑改起来最简单，还是这样做了。WAP版的Layout如下：

<code>
<wml>
<head>
	<meta http-equiv="content-type" content="text/vnd.wap.wml; charset=utf-8" />
</head>
<card id="info" title="<%= Blog.title %>">
<h1><a href="/"><%= Blog.title %></a></h1>

<%= yield %>

</card>
</wml>


</code>

当然，我没有把所有页面都加上Wap支持，现在，就拿手机访问 7ge.cn 试试吧？
