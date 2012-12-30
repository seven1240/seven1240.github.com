---
layout: post
title: "在 Ubuntu 上使用 imagemagick 分割图片以及图片打印"
---

# {{ page.title }}

从我的旧博客上搬过来的，写于2008年2月。


昨天，使用imagemagick 分割图片时，除分割后的第一幅图片能打开外，其它图片用gimp打开时都有问题。

以下命令将大图片分割成多幅图片：

<code>
convert m.png -crop 1024×768 mm.png
</code>

google了一下，发现需要使用 +repage 参数，但是加了以后依然如故。

<code>
convert m.png -crop 1024×768 +repage mm.png
</code>

后来，使用如下命令搞定：

<code>
convert m.png -crop 1024×768 +repage mm_%02.png
</code>

批量打印图片可以直接使用如下命令：

<code>
for f in mm*.png; do lp -s -D ‘Color-LaserJet-4700’ ; done
</code>

不过，打印质量不好，最后我还是用Gimp的GutenPrint打印的。
