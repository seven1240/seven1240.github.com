---
layout: post
title: "SIP客户端呼叫FreeSWITCH立即中断问题"
tags:
  - "freeswitch"
---

我们的教员使用SIP客户端连接FreeSWITCH。他们都分布在美国的各个州，大部分网络环境都很好。最近发现有几个教员总是拨号不成功（严格来说是FreeSWITCH应答后立即发BYE）。查找了所有可能的原因，最后在教员电脑上使用wireshark抓包，在服务器端用tshark看。发现SIP均正常，但在教员方发起第一个RTP包时，FreeSWITCH端会收到Invalid -\[Unreassembled Packet \[incorrect TCP checksum\]\]，而返回到教员电脑上则是 destination unreachable。我们尚未确认是MTU问题，而暂时把呼叫流程改为先从FreeSWITCH呼叫教员，就没有断线的问题了。

无论如何，下面是几个在Vista下查看和列改MTU的方法：

```
ping www.dujinfang.com -f -l 1500
ping www.dujinfang.com -f -l 1472
...
ping www.dujinfang.com -f -l 1400
```

如果MTU过长则会返回"Packet needs to be fragmented but DF set"，否则为正常"Reply from xxxx...."。参考：<http://help.expedient.com/broadband/mtu_ping_test.shtml>

还有

<http://www.neowin.net/forum/index.php?showtopic=513040>

<http://forums.techarena.in/operating-systems/1191328.htm>

<http://www.kitz.co.uk/adsl/vistaMTU.htm>
