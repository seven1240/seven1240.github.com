---
layout: post
title: "在 Windows 上安装 UnxUtils"
tags:
  - "windows"
---

虽然恨死 Windows 却有时候离不开。好在有好人把一些经典的Unix工具都 port 到了 Windows 上，称之为 UnxUtils。

下载： <http://unxutils.sourceforge.net/>

就是一个压缩包，我解压缩后，直接放到了 C 盘根目录 C:\\UnxUtils

右键点击我的电脑，一直找到 -\> 属性 -\> 高级 -\> 环境变量，再在系统环境变量中找到 Path，编辑，在最后加入（注意路径的分隔符是分号）：

    ;C:\UnxUtils\usr\local\wbin

最后，我的环境变量看起来是这个样子（注意，我手工换行了）：

    %SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;
    C:\Program Files\TortoiseSVN\bin;C:\UnxUtils\usr\local\wbin

好了，开始 -\> 运行（我一般都直接按 Windows + R），输入 cmd，就可以使用经典的 Unix 命令了。

    ls

    whoami

    seq 1 10000

当然可以使用管道了：

    cat xxx.txt | grep keywords | sort | uniq -c

只是注意，find 命令与 Windows 系统中的重名，所以最好改个名字，改成 ufind.exe 什么的，可者，干脆把 Windows 版本的改了吧。

:), Have fun!
