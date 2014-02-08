---
layout: post
title: "将Qt项目从Qt4移植到Qt5手记"
tags:
  - "Qt"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>

有一个旧的Qt项目，当初是用Qt4.7做的。Qt5发布以后，API有了很多改变。因此对源代码进行移植。

事实证明，由于项目比较简单，而且当时也没有使用QML，因此移植工作也不是很复杂，基本用了两个小时的时间就能在新的Qt5上编译了。现在，仅将过程简单记录一下。

参考资料：

* <https://qt-project.org/doc/qt-5.0/qtdoc/portingguide.html>
* <https://qt-project.org/doc/qt-5.0/qtdoc/portingcppapp.html>
* <http://qt-project.org/wiki/Transition_from_Qt_4.x_to_Qt5>

我使用的Qt版本是5.2.0，Mac版。

第一步，当然是先尝试编译，在出现了无数编译错误后放弃手工修改。

仔细阅读了参考资料后，发现有一个fixqt4headers.pl脚本可以帮助做部分自动修改。只是，找遍了我的硬盘也没找到该文件。好在它是一个Perl脚本，直接上网上搜了一个下来。直接执行时发现它需要知道QtCore头文件的路径，但是，奇怪的是，Mac的clang_64目录中并没有QtCore相关的头文件，最后只好以iOS版的代替，命令如下：

    QTDIR=/Users/dujinfang/Qt/5.2.0/ios perl ~/Downloads/fixqt4headers.pl

执行完毕后，可以发现它将原先的QtGui替换成了QtWidgets，如：

    -#include <QtGui/QApplication>
    +#include <QtWidgets/QApplication>

然后，将工程文件(.pro文件)中加上：

    QT += widgets

再手工尝试编译，还是报错，原来Qt5取消了`toAscii()`函数，全局查找替换，将它替换为`toLatin1()`后问题就解决了。

当然，QWebView也找不到了，还有一些其它的错误，我简单的将那些相关的代码都注释掉了。最后，在Mac上编译通过。

当然，编译通过还不代表完成了，原来的项目3年没有动了，后来还需要诸多更新和修改，以及学习新的Qt5的编程方式。不过，Qt5.2终于支持iOS和Andriod开发了，虽然还不是很完善，但期待它能做得更好。

是以为记。


