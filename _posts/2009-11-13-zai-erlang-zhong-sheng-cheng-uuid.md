---
layout: post
title: "在 Erlang 中生成 UUID"
tags:
  - "erlang"
---


在[github](http://github.com/travis/erlang-uuid)上有一个生成UUID的方法, 可是在最新的erlang R13B02-1中有问题, 原来Math:pow()会返回一个浮点数, 但random:uniform期望一个整数, 后来trunc了一下就行了:

```
v4() ->
    v4(random:uniform(erlang:trunc(math:pow(2, 48))) - 1,
    random:uniform(erlang:trunc(math:pow(2, 12))) - 1,
    random:uniform(erlang:trunc(math:pow(2, 32))) - 1, 
    random:uniform(erlang:trunc(math:pow(2, 30))) - 1).
```

[另外看到有人用了round](http://crackcell.javaeye.com/blog/493028).

但最后发现每次产生的UUID都是一样的. 后来才知道, random在同一个进程中会产生随机数, 但我的应用是每次都产生一个新进程, 而每个新进程的随机数种子都是一样的.

参考了以下文章, 需要 re-seed.

[www.lshift.net/blog/2006/09/06/random-in-erlang](http://www.lshift.net/blog/2006/09/06/random-in-erlang)

[http://www.no-spoon.de/2006/09/random-in-erlang-processes.html](http://www.no-spoon.de/2006/09/random-in-erlang-processes.html)

最后, 我发现我的应用只是为了产生一个进行时唯一的文件名, 索性用pid_to_list(Pid)实现了.
