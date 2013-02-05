---
layout: post
title: "你是一个什么样的程序员"
tags:
  - "shell"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>

找到一个有意思的命令，可以看你是一个什么样的程序员。来自 <http://coolshell.cn/articles/8619.html>

    history | awk '{CMD[$2]++;count++;} END \
    { for (a in CMD )print CMD[a] " " CMD[a]/count*100 "% " a }' | \
    grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10

     1  109  21.8%  git
     2  80   16%    ls
     3  73   14.6%  cd
     4  22   4.4%   find
     5  20   4%     sudo
     6  16   3.2%   ping
     7  15   3%     for
     8  12   2.4%   tig
     9  12   2.4%   make
    10  9    1.8%   rm

看来我大部分时间还是在写代码。
