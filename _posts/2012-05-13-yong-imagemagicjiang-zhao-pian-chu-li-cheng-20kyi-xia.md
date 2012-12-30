---
layout: post
title: "用ImageMagic将照片处理成20k以下"
---

# {{ page.title }}

今天有个朋友让我帮忙处理个照片，说是报名考试之类的，要将一个100多k的.jpg 处理20k以下。用photoshop改了半天，都没法达到要求。不是太大，就是质量太差。我甚至将照片改成黑白的，把照片上的花衣服改成单色的，都不怎么管用。

后来得出结论，搞成20k以下又保持较好的质量是不可能的。不过上网 google 一下，确定有人用 windows
的画图程序之类的都能做到，看来去除了EXIF这类的信息能节省不少字节。

我没有windows，幸好以前装过 ImageMagic，请出来一试果然好用：

    convert original.jpg -strip -resample 72x72 -resize 120x160 stripped.jpg

其中 -strip 把 EXIF 之类的信息去掉； -resample 修改 resolution；-resize 修改照片大小。搞定。
