---
layout: post
title: "Ubuntu 安装Latex+UTF8字体问题"
---

# {{ page.title }}

本文写于2008年1月，从旧博客转过来的，显然已经过时了。但Latex是不会过时的，所以，没舍得丢。

首先参考了下面的文章，忘了从哪儿看到的了：

<code>
1. 安装texlive
可以先看看texlive有哪些东西：
apt-cache search texlive
一般我安装的是：
sudo apt-get install texlive texlive-math-extra texlive-latex-base texlive-latex-extra
 texlive-latex-recommended texlive-pictures texlive-science
 texlive-bibtex-extra texlive-common latex-beamer
（可能不全，但是基本差不多了）
其实如果空间够，直接一个
sudo apt-get install texlive-full latex-beamer
那个latex-beamer是做什么的呢？是一个很方便的制作幻灯片的宏包，可以google一下beamer看看。这里不多说了

2 安装cjk
sudo apt-get install latex-cjk-chinese ttf-arphic-* hbf-*
当然，如果硬盘够，直接latex-cjk-all也可以

3 安装字体
还是从sir上一篇帖子的回复上看到的（别按照那楼顶的做），帖子在这里：
http://www.linuxsir.org/bbs/showthread.php?t=249869
从这里下载字体：
ftp://cle.linux.org.tw/pub2/tex/cjk/fonts/nsungt1
下载解压后，执行那个install.sh的脚本（不要用root执行）
P.S. 那个FTP上还有不少好东西。比如这里就还有个楷体字体：
ftp://cle.linux.org.tw/pub2/tex/cjk/fonts/nkait1

4 测试
用这段代码试试：
\documentclass{article}
\usepackage{CJK}
\begin{CJK}{UTF8}{nsung}
\begin{document}
您
\end{CJK}
\end{document}
和网上很多代码不同的是：这里用的是UTF8编码（ubuntu默认的编码），字体为nsung
当然，如果安装了前面说的楷体，也可以把nsung改成nkai试试～

</code>

安装好了自然没什么问题，但是，UTF8编码的中文字体不知如何安装。

后来，我使用如下安装方式：
搜索需要安装的包：

<code>
$ sudo apt-cache search latex-cjk-

cjk-latex - installs all LaTeX CJK packages
latex-cjk-all - installs all LaTeX CJK packages
latex-cjk-chinese - Chinese module of LaTeX CJK
latex-cjk-chinese-arphic-bkai00mp - traditional Chinese KaiTi fonts for CJK
latex-cjk-chinese-arphic-bsmi00lp - traditional Chinese KaiTi fonts for CJK
latex-cjk-chinese-arphic-gbsn00lp - traditional Chinese KaiTi fonts for CJK
latex-cjk-chinese-arphic-gkai00mp - traditional Chinese KaiTi fonts for CJK
latex-cjk-common - LaTeX macro package for CJK (Chinese/Japanese/Korean)
latex-cjk-japanese - Japanese module of LaTeX CJK
latex-cjk-japanese-wadalab - type1 and tfm DNP Japanese fonts for latex-cjk
latex-cjk-korean - Korean module of LaTeX CJK
latex-cjk-thai - Thai module of LaTeX CJK

</code>

将所有与中文相关的包装上就行了：

<code>
apt-get install latex-cjk-chinese*
</code>

装好后再安装中文字体：（参考了好多文章，但五花八门，我使用下面的方法）

下载： http://www.ish.ci.i.u-tokyo.ac.jp/~jin/data/mkfont.tar.gz

<code>
tar xvzf mkfont.tar.gz
cd mkfont
cp /windows/Fonts/sim*.ttf .  #(把windows下的字体copy过来，注意simsum.ttc不行，要copy .ttf的)
./mkfont.sh simhei.ttf simhei hei    #转换黑体
</code>

然后就可以试一试了：

<code>
\usepackage{CJK}
\usepackage{default}

\begin{document}
\begin{CJK*}{UTF8}{kai}

dffsdfdsf
中华人民共和国 sdfsdf
\end{CJK*}
\end{document}

</code>
如何转换simsun.ttc我还不知道，不过，可以使用gbsn字体。

另外，生成pdf文件后发现中文无法拷贝，找了很多解决办法，最后发现将 \usepackage{CJK} 改为 \usepackage{CJKutf8}就OK了。
