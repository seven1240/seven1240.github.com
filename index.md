---
layout: default
title: {{ site.com }}
---

欢迎来到我的博客，更多信息，请参见 [关于我](/about.html)。 另外，我也有一个 [about.me](http://about.me/dujinfang) 页面。

<hr>

<ul class="posts">
  {% for post in site.posts limit:30 %}
    <li><span>{{ post.date | date: "%Y-%m-%d" }}</span> &raquo; <a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
    <li><span><a href="/posts.html">更多文章...</a></li>

</ul>

<br><br>

<hr>
友情链接：
<a href="http://czb.im" target="_blank">大熊笔记</a>
