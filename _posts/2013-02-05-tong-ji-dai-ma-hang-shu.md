---
layout: post
title: "统计代码行数"
tags:
  - "shell"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>

前两天需要统计一下代码的行数，找到一些有意思有脚本。人的智慧真是无穷无尽啊，有 shell 的, AWK 的， Perl 的，Python 的之类。

* <http://stackoverflow.com/questions/450799/shell-command-to-sum-integers-one-per-line>

* <http://stackoverflow.com/questions/2702564/how-can-i-quickly-sum-all-numbers-in-a-file>

看看这些，长了不少见识，我最终是用如下命令实现的：

    find . -name "*.erl" -exec wc -l {} \; | \
    sed -e "s/^ *//" | cut -d " " -f 1 | \
    paste -sd+ - | bc
    
    91917

比较长，不过学了一个 paste 命令。

后来发现有更短的：

    find . -name "*.erl" -exec wc -l {} \; | \
    awk '{a+=$1} END {print a}'

    91917

还有更短的：

    wc -l `find . -name "*.erl"` | tail -n1

    91917 total

当然，也可以把 | tail -n1 省掉 :) 。

