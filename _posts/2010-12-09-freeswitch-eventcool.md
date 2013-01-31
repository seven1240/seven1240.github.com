---
layout: post
title: "FreeSWITCH EventCool"
tags:
  - "freeswitch"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>


一直使用 fs\_cli /event plain all 调试 FreeSWITCH events，甚是不便。前几天看到一个叫 [Chicago Boss](http://www.chicagoboss.org/) 的 Framework，感觉很好玩，便试了一把，顺便写了这个叫 EventCool 的工具。

<https://github.com/seven1240/FreeSWITCH-EventCool>

