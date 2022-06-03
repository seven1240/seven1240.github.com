---
layout: default
title: {{ site.com }}
---

# 所有文章 &nbsp;&nbsp;<small>[[ 所有标签 ]](/tags.html)</small>

<ul class="posts">
  {% for post in site.posts %}
    <li class="post-list"><span>{{ post.date | date: "%Y-%m-%d" }}</span> &rarr;
    <a href="{{ post.url }}"><strong>{{ post.title }}</strong></a>
    {% for tag in post.tags limit:30 %}
      <span style="color:#999">&nbsp;&nbsp;|&nbsp;&nbsp;{{ tag }}</span>
    {% endfor %}
    </li>
  {% endfor %}
</ul>
