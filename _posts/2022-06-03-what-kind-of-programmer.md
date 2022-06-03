---
layout: post
title: "你是一个什么样的程序员"
tags:
  - "shell"
---

又看了一遍9年前的文章[你是一个什么样的程序员](/2013/02/05/ni-shi-yi-ge-shen-me-yang-de-cheng-xu-yuan.html)，重新运行了一下当年的命令，最大的变化是`code`和`docker`。


```
$ history | awk '{CMD[$2]++;count++;} END \
{ for (a in CMD )print CMD[a] " " CMD[a]/count*100 "% " a }' | \
grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10

     1	3438  33.1533%    git
     2	1277  12.3144%    cd
     3	917   8.84282%    ls
     4	640   6.17165%    make
     5	298   2.87367%    tig
     6	283   2.72903%    rm
     7	276   2.66152%    cp
     8	241   2.32401%    cat
     9	225   2.16972%    code
    10	176   1.6972%     docker
```
