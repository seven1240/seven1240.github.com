---
layout: default
title: {{ site.com }}
---

欢迎来到我的博客，更多信息，请参见 [关于我](/about.html)。 另外，我也有一个 [about.me](http://about.me/dujinfang) 页面。

<hr>

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
