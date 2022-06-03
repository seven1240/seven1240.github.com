---
layout: post
title: "在linux mail命令中使用自定义From地址发送邮件"
tags:
  - "shell"
  - "linux"
  - "CentOS"
---


测试使用不同的 Envelope 地址发送邮件，Google了一下发现有好多种方案，不过网上说的 -S 及 -a 开关在我的 CentOS 5 版上好像没有。最后找到了一种可用的方案 

    mail to@example.com -- -f from@example.com  

这样就可以使用 from@example.com 作为 From: 字段的地址了。 

参考：<http://stackoverflow.com/questions/54725/change-the-from-address-in-unix-mail>
