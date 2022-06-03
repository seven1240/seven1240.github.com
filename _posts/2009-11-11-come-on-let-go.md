---
layout: post
title: "Come on, Let's GO"
tags:
  - "go"
  - "zimbu"
---


接连看到出现了两个新语言[Zimbu](http://groups.google.com/group/zimbu-discuss)和[GO](http://golang.org)。出于对新事物的好奇和热爱，今晚把它们的文档都看了一下。

Zimbu出于著名的VIM的作者Moolenaar之手。他说道：Zimbu是一个实验性的编程语言，非常实用，简单直接。它集现有语言的优点于一身，同时也避开了它们的不足。Zimbu代码清晰易读，使用范围广泛——既能写OS kernel，又能写脚本，还能写大的GUI程序，而且可以编译和运行在几乎所有系统上。

确实，Zimbu的代码看起来挺好看，而且它是面向对象的，每个数据都看作是一个对象。相比而言，Go则不是。Go使用goroutine支持并发，而Zimbu却没提到这一点。从某种意义上说，除两者都是编译型语言外，它们的区别就好像Ruby与Erlang。它们都声称可以做操作系统一级的编程。Zimbu可以用于几乎所有系统上且可以转换为C代码，而Go目前好像只支持Linux和Mac。

Go的设计目标就是快。它试图结合动态语言（如Python）的开发速度和编译型语言（如C和C++）的性能和安全性。

自2007月起Robert Griesemer，Rob Pike和Ken Thompson开始构思Go语言。其它人不认识，最后一位如果排除重名的话就是他跟著名的C语言之父Dennis M Ritchie一起设计了UNIX。

“它编译起来非常快。即使编译很大的文件都能在几秒内完成，编译的二进制程序运行起来几乎跟C语言的一样快。” “我们希望Go能成为一种优秀的编程语言，它可以用于系统编程，同时支持多进程及一种新的轻量级的面向对象设计，还有一些很酷的特性如闭包和反射等。” 其官方网站如是说。

两者的Hello World:

hello.zu
<code>
MAIN()
  IO.write("Hello, World!\n")
}
</code>

hello.go
<code>
package main

import fmt "fmt" // Package implementing formatted I/O.

func main() {
	fmt.Printf("Hello, world; or 世界你好\n");
} 
</code>

Zimbu的主页放到google sites上，Go不知道，只知道golang.org的后台某些部分是用Go语言写的。两者在国内访问起来都有些困难。

[groups.google.com/group/zimbu-discuss](http://groups.google.com/group/zimbu-discuss/browse_thread/thread/6fcd680b52288c55)

但也还是等不及，考虑Concurrent的原因，先试了Go。

下载源代码，编译到最后测试不通过，但好在它是先安装后测试的，不影响使用：

错误信息如下:
<code>
seven@localhost:~/go/src/pkg/http$ make test
gotest
rm -f _test/http.a _gotest_.8
8g -o _gotest_.8 client.go fs.go request.go server.go status.go url.go    client_test.go request_test.go url_test.go
rm -f _test/http.a
gopack grc _test/http.a _gotest_.8 
--- FAIL: http.TestClient
        Get http://www.google.com/robots.txt: read tcp:192.168.1.4:50303->72.14.203.99:80: connection reset by peer
--- FAIL: http.TestRedirect
        Get http://codesearch.google.com/: read tcp:192.168.1.4:50304->64.233.189.102:80: connection reset by peer
FAIL
make: *** [test] Error 1
</code>

照着网上的例子编译了一个http server, 输入7777得到了一个QR code:
<img src="http://chart.apis.google.com/chart?chs=300x300&cht=qr&choe=UTF-8&chl=7777" />

Server端没用并发的情况下ab了一下：
<code>
seven@localhost:~$ ab -n 1000 -c 1 http://127.0.0.1:1718/

Server Software:        
Server Hostname:        127.0.0.1
Server Port:            1718

Document Path:          /
Document Length:        240 bytes

Concurrency Level:      1
Time taken for tests:   0.406426 seconds
Complete requests:      1000
Failed requests:        0
Write errors:           0
Total transferred:      299000 bytes
HTML transferred:       240000 bytes
Requests per second:    2460.47 [#/sec] (mean)
Time per request:       0.406 [ms] (mean)
Time per request:       0.406 [ms] (mean, across all concurrent requests)
Transfer rate:          716.00 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:     0    0   0.8      0      22
Waiting:        0    0   0.7      0      20
Total:          0    0   0.8      0      22

Percentage of the requests served within a certain time (ms)
  50%      0
  66%      0
  75%      0
  80%      0
  90%      0
  95%      0
  98%      1
  99%      1
 100%     22 (longest request)
</code>
