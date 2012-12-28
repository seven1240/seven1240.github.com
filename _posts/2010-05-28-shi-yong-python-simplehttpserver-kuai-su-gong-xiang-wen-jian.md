---
layout: default
title: "使用 Python SimpleHTTPServer 快速共享文件"
---

# {{ page.title }}

今天，朋友要我给它传一些照片和几个视频文件。使用QQ传了几个照片，但视频实在是太慢了。便想用HTTP。

我启动了 Mac 上的  Web sharing(它会启动 Apache)，将需要的文件放到 ~/Sites 目录下，在浏览器中打开 http://localhost/~seven/ 能正常看到内容。上 ip138.com 找到我的我网 IP，在路由器上打开端口转发，NAT到我的机器上，测试使用外网IP也正常。把链接发过去，结果对方打不开。SSH 登录到一个外网服务器，使用 curl http://我的外网IP/~seven/ 果然打不开。

ping 不通。 traceroute 也不通。但我 ADSL 上网没题。后来想起了有些地方可能屏蔽了 ADSL 用户的 80 端口。但换 Apache 的端口需要改配置文件，当然，这也算不上麻烦，但我想找个更简单的方案。

打开一个 Sinatra 工程， 将内容copy到 public/ 目录里。重新设置端口转发，使用默认的 9393。确实可以访问了，证实是 80 端口被屏蔽。但 Sinatra 默认不支持文件列表。

后来Google 一下，找到一个 SimpleHTTPServer， 它是一个 Python 模块，在我的系统上是自带的。

转到照片目录下，使用

    python -m SimpleHTTPServer 

便以当前目录为根目录，打开一个 Web 服务器，由于默认的端口是8000，而为了避免重新设置路由器上的端口转发，我指定了 9393  端口:

    python -m SimpleHTTPServer 9393

成功了，酷！

为了方便以后使用，写了个 alias 加入了我的 .bash\_profile 中

    alias http="python -m SimpleHTTPServer"

以后，我再想分享什么文件，只需 cd 到相关目录，执行 http 或 http 9393 就可以了。

还有一个问题，假设有人给我分享文件它又没有 Python 可怎么办呢？又 Google，发现了 Droopy: <http://stackp.online.fr/?p=28>。它打开一个 HTTP 服务，允许别人把文件上传给我。另外，还发现一个 woof: <http://www.home.unix-ag.org/simon/woof.html>，但没试过。
