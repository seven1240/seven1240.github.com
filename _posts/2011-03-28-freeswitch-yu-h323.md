---
layout: post
title: "FreeSWITCH 与 h323"
tags:
  - "freeswitch"
---

FreeSWITCH 中有两个 h323 的实现，[mod_opal](http://wiki.freeswitch.org/wiki/Mod_opal) 与 [mod_h323](http://wiki.freeswitch.org/wiki/Mod_h323)。两者都使用 ptlib，后者比较新一点。以前曾经测试过 mod_opal ，但没有成功，今天试了一下 h323，成功了。

实际步骤跟 wiki 上描述的差不多，我使用的是 ptlib-2.8.2 + h323plus-20100525 。在 CentOS 5.5 上。

安装过程中出现找不到头文件的错误，我没按 wiki 上指示的 copy  文件，而是直接修改 src/mod/end\_points/mod_h323/Makefile 把  /usr/include 及 /usr/lib  都改为 /usr/local/include 及 /usr/local/lib，然后  make && make install 成功。

由于我测试的 FS 在一台远程服务器上，NAT环境中，而 h323 穿越 NAT 就我看来比 SIP 复杂多了。于是我装了一个  PPTP VPN，远程拨入后，加了一个 listener(其中 6.100 为 VPN server 端IP):

   <listener name="default">
     <param name="h323-ip" value="192.168.6.100"/>
     <param name="h323-port" value="1720"/>
   </listener>

load mod_h323 测试连接成功。

mod_h323 使用了 [h.323plus](http://www.h323plus.org/)库，貌似可以在编译时通过 enable-h264 之类的支持视频，但好像  mod_h323 中还没有支持视频的选项。无论如果，音频还是相当好的。当然测试时也发现有锁的情况，通话非正常中断可能会出问题，也遇到一次  core dump。 鉴于模块还在开发中，有些错误是在所难免的。
