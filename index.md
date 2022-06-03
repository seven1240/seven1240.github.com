---
layout: default
title: {{ site.com }}
---

欢迎来到我的博客，我是杜金房，程序员一枚。创业者、VoIP和RTC相关行业，热爱写代码、热爱开源。更多信息，请参见 [关于我](/about.html)。 另外，我也有一个 [about.me](http://about.me/dujinfang) 页面。

我写过几本书，有的出版有的没出版，可以[到这里查看](http://book.dujinfang.com) 。

下面是我在社交网络上常用的头像，前两个是我的好朋友闫七郎画的，最后一个是我自己画的。

<div style="display: flex; flex-direction: row; justify-content: space-between; align-self: center;">
<img width="200px" style="align-self: center;" src="/images/seven-bingbing.jpg">
<img width="200px" style="align-self: center;" src="/images/seven.jpg">
<img width="100px" style="align-self: center;" src="/images/7-200.jpg">
</div>

<hr>

下面是我最近的一些博客文章：

<ul class="posts">
  {% for post in site.posts limit:30 %}
    <li class="post-list"><span>{{ post.date | date: "%Y-%m-%d" }}</span> &rarr;
    <a href="{{ post.url }}"><strong>{{ post.title }}</strong></a>
    {% for tag in post.tags limit:30 %}
      <span style="color:#999">&nbsp;&nbsp;|&nbsp;&nbsp;{{ tag }}</span>
    {% endfor %}
    </li>
  {% endfor %}
    <li class="post-list"><span><a href="/posts.html">更多文章...</a></span></li>

</ul>

<br><br>
