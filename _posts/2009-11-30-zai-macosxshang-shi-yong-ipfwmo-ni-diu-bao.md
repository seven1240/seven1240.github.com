---
layout: default
title: "在MacOSX上使用ipfw模拟丢包"
---

# {{ page.title }}

今天测试FreeSWITCH录音，需要在MacOSX上模拟丢包的环境，就写了一个简单的脚本。需要说明，由于UDP会有自动重发的机制，因此只有丢包率超过一定比例才会真正发生丢包。

<code>
#!/bin/sh

trap "ipfw delete 02000" EXIT
while :; do
        echo deny
        ipfw add 02000 deny udp from 192.168.1.21 to any in

        sleep 3

        echo allow
        ipfw delete 02000
        sleep 2
done
</code>

参考：<http://www.ibiblio.org/macsupport/ipfw/>
