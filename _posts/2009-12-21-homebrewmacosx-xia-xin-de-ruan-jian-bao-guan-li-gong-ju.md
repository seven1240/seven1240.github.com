---
layout: post
title: "homebrew--MacOSX 下新的软件包管理工具"
---

# {{ page.title }}

一直使用macports在Mac上安装软件，但安装很慢，且它总是重复安装一些系统中已存在的库，很是讨厌。而且有时候某些依赖关系损坏，安装就失败，很多软件都不得不手动下载源代码编译，费时费力。

今天，忽然看到一个好东东Homebrew <http://github.com/mxcl/homebrew>。呵呵，还是第一次听说，试了试，用它装了rdis，看起来还不错。

<pre>
curl -L http://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local
brew install redis
</pre>

另有一篇中文的介绍：

<http://blog.jjgod.org/2009/12/21/homebrew-package-management/>
