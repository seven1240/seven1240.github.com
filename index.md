---
layout: default
title: {{ site.com }}
---

欢迎来到我的博客，更多信息，请参见 [关于我](/about.html)。

我也有一个 [about.me](http://about.me/dujinfang) 页面。

<hr>

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date: "%Y-%m-%d" }}</span> &raquo; <a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
