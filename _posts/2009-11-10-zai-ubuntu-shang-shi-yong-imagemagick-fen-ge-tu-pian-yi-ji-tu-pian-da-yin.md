---
layout: post
title: "在 Ubuntu 上使用 imagemagick 分割图片以及图片打印"
tags:
  - "linux"
---

从我的旧博客上搬过来的，写于2008年2月。


昨天，使用imagemagick 分割图片时，除分割后的第一幅图片能打开外，其它图片用gimp打开时都有问题。

以下命令将大图片分割成多幅图片：

```
convert m.png -crop 1024×768 mm.png
```

google了一下，发现需要使用 +repage 参数，但是加了以后依然如故。

```
convert m.png -crop 1024×768 +repage mm.png
```

后来，使用如下命令搞定：

```
convert m.png -crop 1024×768 +repage mm_%02.png
```

批量打印图片可以直接使用如下命令：

```
for f in mm*.png; do lp -s -D ‘Color-LaserJet-4700’ ; done
```

不过，打印质量不好，最后我还是用Gimp的GutenPrint打印的。
