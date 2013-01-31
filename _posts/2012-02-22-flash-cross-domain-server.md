---
layout: post
title: "Flash cross domain server"
tags:
  - "flash"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>


使用 socket.io，对于不支持 websocket 的浏览器，会自动 fallback 到  flash 方案。但是 flash 需要一个 cross domain server，还运行在特权端口，比较麻烦。

自已写了一个 ruby 版的，一般的测试也够用了，哈：


<code>
#!/usr/bin/env ruby

require 'socket'
xml='<cross-domain-policy><allow-access-from domain="*" to-ports="*" /></cross-domain-policy>'

while true do
        TCPServer.open("0.0.0.0", 843) {|serv|
                s = serv.accept
                s.puts xml
                s.close
        }
end
</code>
