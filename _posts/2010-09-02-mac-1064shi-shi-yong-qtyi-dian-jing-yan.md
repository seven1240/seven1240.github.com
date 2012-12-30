---
layout: post
title: "Mac 10.6.4上使用QT一点经验"
---

# {{ page.title }}

呵呵，没想到，又拾起了桌面开发。

这次开发一个客户端，需集成SIP和WEB/Flash。选择了基于libfreeswitch的方案，从FSComm上得到启发，就顺便抄了些代码。由于 FSComm使用QT， 就开始使用QT。

QT对于跨平台来说还是很好用的。尤其喜欢其emit机制。但由于以前没有使用经验，还是遇到了一些困难。而且，好像在我涉及的领域，资料还很少啊。

首先当然是先编译FSComm，当初装的QT是32位的，而在我的机器上，libfreeswitch已经编译成64位了。参考一些资料，说要64位的QT只能自己编译。但后来发现那些说法已经过时了，其实官方已经支持64位了，重下了一遍 Qt libraries 4.6.3 for Mac，安装完了就好了。

编译FSComm顺利通过，有点兴奋，是啊，64bit Native。

新建了我的工程，从FSComm抄了些代码（没有直接在上面改是因为我想从头学起，而且这样比起直接改厚道点吧 :p ）。调试，编译，虽然费了不少时间，但是进展还算顺利。

后来，加入webView，主要是加载一个Flash页面。但是悲剧了，能找到的资料不多，能找到的资料都很简单，但我试了各种方法怎么也加载不出来。最后才想起来--Flash不支持64位！晕倒。

为了验证我的想法，写了个DEMO，放到32位的XP上，Flash加载成功了。

由于我下的QT本身支持32和64位的，所以只是将 .pro 文件中加上 CONFIG += x86 就可以直接编译成32位。问题是需要32位的 libfreeswitch。试了很多configure 选项都没有成功，包括-arch i386， -m 32 ， --host=i386等，最后，放弃，在一台旧的32位的Mac上编译完成，把代码copy过来就完了事。

一切进展顺利，全部32位后，也能加载  Flash了 ... <http://www.dujinfang.com/past/2010/9/2/qt-zhong-jia-zai-flash/>

但后来遇到个问题，加载另一个Flash时总时出问题：

    <Error>: kCGErrorIllegalArgument: CGSGetWindowBounds: NULL window

同时，Flash中任何按钮都不响应。查了好久，才发现是QT的一个BUG-- 应该跟这个有关吧<http://trac.webkit.org/changeset/60621>？由于4.7还不是正式版的，因此还想使用4.6。当然，这需要把那个patch打到4.6上。是啊，这两年被开发工具的BUG吓怕了。专家建议永远不要使用最新的版本，因为，不管操作系统还是开发工具，当它们和你的代码都不稳定的时候，查找BUG将是个恶梦。记得以前编程序从来不考虑这些问题，按照文档上的例子搞起来就能用；而现在，多数都不能用，总是发现各种各样的问题。

首先要重新编译QT4.6了，下载了4.6.3的源代码，编译无论如何都不通过。算了，还是4.7吧，且不管是不是稳定，把代码跑起来再说。而且，也省得打Patch了。

下载了代码4.7.0，编译

    ./configure -prefix-install -prefix /opt/qt -no-framework -opensource -nomake examples -nomake demos -arch i386
    make -j2
    make install

以上主要是参考了 <http://www.kangq.mobi/bbs/read.php?tid=26040> 和 <http://www.xtuple.org/node/2937>

不幸的是，它在编译过程中还是尝试链接到我64位的MySQL及PostgreSQL库上，我没选 -plugin-sql-xxx 啊。懒得再找帮助，直接在 src/plugins/sqldrivers 下写了个假的 Makefile

<code>
all:
        echo skip

install:
        echo skip
</code>


我将自己编译的安装到 /opt/qt，不使用framework，这样代码发布的时候省心些（估计），当然，我只编译了32位的。默认是debug版的，想要 release版估计还得重新编译，太费时间了，编译一遍用了好几个小时。

真希望以后GO语言能强大起来，据说编译速度快得多。

没有重装 QT Creator，直接用旧的就行了，只是编译工程的时候需要在 Projects 里选择 QT version 一项，选择我新编译的版本。

要跨平台嘛，当程序写的差不多的时候就要到windows上编译了。也是颇费周折。

首先我下载的QT是minGW版的，结果有段FreeSWITCH代码不通过，因为它定义了一些 \_WIN32 和 VC 版本相关的宏。所以，只好又下载了VC版的库。当然，还下载了 VS2008 Express版。

在QT Creator里更改 projects 里的 QT version，指向VC 版的。编译成功。

花了不少时间搞懂这些东西，也走了好多弯路，记在这里不容易忘记。

