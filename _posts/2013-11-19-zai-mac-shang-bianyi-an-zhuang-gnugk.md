---
layout: post
title: "在Mac上编译安装GnuGK"
tags:
  - "GnuGK"
  - "H323"
  - "VoIP"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>

[GnuGK](http://www.gnugk.org)是一个GNU的开源项目，这帮GNU们没几个是用Mac的，虽然官网上说支持Mac，但没找到相关的编译安装资料。有已经编译好的二进制版本也是几年前的。

当然，在Linux上编译安装很顺利，但每次测试还得起个虚拟机，有点麻烦。所以，还是花时间研究了一下。

首先，GnuGK依赖[h323plus](http://www.h323plus.org)和ptlib，由于这两个库以前已经装过了，因此，没太费劲。

编译GnuGK的时候出现以下错误：

    $ make
    make DEBUG= default_depend
    Created dependencies.
    make DEBUG=1 default_depend
    Created dependencies.
    make DEBUG= P_SHAREDLIB=0 default_target
    make -C /usr/local/src opt
    make[2]: *** No rule to make target `opt'.  Stop.
    make[1]: *** [/usr/local/lib/libh323_Darwin_x86_64__s.a] Error 2
    make: *** [optnoshared] Error 2

不知道干什么的，也没再研究，先`make install`再说：

    $ make install
    make: *** No rule to make target `/usr/local/share/ptlib//lib_Darwin_x86_64/libpt.dylib', needed by `versionts.h'.  Stop.

看样子是找不到编译规则，并且该路径下也没有对应的文件，链接一个：

    mkdir -p /usr/local/share/ptlib/lib_Darwin_x86_64/
    cd /usr/local/share/ptlib/lib_Darwin_x86_64/
    ln -sf /usr/local/lib/libpt.dylib .

然后在Makefile里添加一个假的规则：

    usr/local/share/ptlib//lib_Darwin_x86_64/libpt.dylib:
            echo ok

然后又提示找不到 `/libpt.dylib`，在Makefile中再加一条：

    /libpt.dylib:
            echo ok

然后`make install`，居然安装成功。

