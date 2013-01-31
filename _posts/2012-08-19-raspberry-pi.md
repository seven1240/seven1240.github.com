---
layout: post
title: "Raspberry Pi"
tags:
  - "freeswitch"
  - "erlang"
  - "RaspberryPi"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>


在 Element14上订了一个[Raspberry Pi](http://www.raspberrypi.org/),不到两周的时间就到货了，只可惜到货时我刚刚踏上去米国的征程。回来后的几天也一时没时间弄，但心里还是痒痒的。适逢周末路过中关村，就买了一个HDMI转VGA的转接线，都赶上Pi的一半贵了。但是没办法，大部分显示器还是VGA的。

刚看了一下好像没带任何外围配件，幸好我有根Kindle4的USB-miniUSB的线，插上后就当电源了。结果插上后有一个灯亮了，但显示器怎么都不亮，上网一查还得自己准备SD卡，原来没做好家庭作业，看看表离中关村下班还差半小时，飞奔还来得急，便立马去搞了3个SD卡回来，这玩意不贵，多弄几个好折腾。

准备SD卡，我是在Mac上做的，参考了<http://elinux.org/RPi_Easy_SD_Card_Setup>很简单。

由于上面那个链接中提到的RAsPiWrite Paython脚本在我机器上有问题，便直接手工做。

插上SD卡，发现设备名称是 /dev/disk1

     $ df -h

<pre>
Filesystem      Size   Used  Avail Capacity  iused   ifree %iused  Mounted on
/dev/disk0s2   233Gi  203Gi   30Gi    88% 53291729 7777711   87%   /
devfs          194Ki  194Ki    0Bi   100%      670       0  100%   /dev
map -hosts       0Bi    0Bi    0Bi   100%        0       0  100%   /net
map auto_home    0Bi    0Bi    0Bi   100%        0       0  100%   /home
/dev/disk1s1   3.6Gi  2.3Mi  3.6Gi     1%        0       0  100%   /Volumes/NO NAME
</pre>

把挂上的分区 unmount 掉

     sudo diskutil umount /dev/disk1s1

开始copy，我使用的是 debian wheezy 那个img。注意这里使用的是裸设备 rdisk1。

     sudo dd bs=1m if=../2012-07-15-wheezy-raspbian.img of=/dev/rdisk1


dd 是非常安静的，但在写的过程中可以按Ctrl+T查看进度。

完成后，它会自动又mount上，再 unmount 掉

     sudo diskutil umount /dev/disk1s1


把SD卡插到Pi上，启动，显示器还是不亮。郁闷。不知道我的转接线有问题，还是15吋的显示器太小了。

插上网线，有灯在闪，好像网络通了。但显示器不亮，从网上看到默认是不开SSH的好像，心想找个键盘试试吧，看能不能闭着眼开启SSH。但找了半天，找到两个键盘都是串口的，一个USB的也没有。

就在准备放弃的时候，心想还是再试一把，碰下运气。功夫不负有心人，找开跟由器一看，果然有个 raspberrypi 的主机占用了 192.168.1.113的一个IP，尝试ssh，居然连上了，输入用户名密码 pi/raspberry，登录成功。

     pi@raspberrypi ~ $ uname -a
     Linux raspberrypi 3.1.9+ #168 PREEMPT Sat Jul 14 18:56:31 BST 2012 armv6l GNU/Linux


<pre>
pi@raspberrypi ~ $ cat /proc/cpuinfo
Processor       : ARMv6-compatible processor rev 7 (v6l)
BogoMIPS        : 697.95
Features        : swp half thumb fastmult vfp edsp java tls
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x0
CPU part        : 0xb76
CPU revision    : 7

Hardware        : BCM2708
Revision        : 0002
Serial          : 000000004e0b1e44
</pre>

系统提示执行以下命令

     sudo raspi-config

出现一个菜单 ，其中第二项 expand_rootfs 非常重要，如果你的SD卡大于2G的话，其余的空间是浪费的，该项可以把 root 分区扩充到所有空间。

扩充完以后重启。从能Ping通到能SSH这段时间比较长，我还以为扩充坏了，重做了好几次，费了不少时间。现在想来，可能重启后在校验文件系统吧，由于我显示器不亮，因此看不到过程。



    info               Information about this tool                     │
        │           expand_rootfs      Expand root partition to fill SD card           │
        │           overscan           Change overscan                                 │
        │           configure_keyboard Set keyboard layout                             │
        │           change_pass        Change password for 'pi' user                   │
        │           change_locale      Set locale                                      │
        │           change_timezone    Set timezone                                    │
        │           memory_split       Change memory split                             │
        │           ssh                Enable or disable ssh server                    │
        │           boot_behaviour     Start desktop on boot?                          │
        │           update             Try to upgrade raspi-config    



下一步，执行

     apt-get update
     apt-get install screen

第一步当然是先装 screen，因为 Pi 运行起来较慢，放到 screen 里比较安全

     apt-get install git

呵呵，就可以安装软件了。

最想装的就是 FreeSWITCH，但Erlang装的比较快，下载源代码 ./configure && make && make install 就完了（当然，这个过程也得用了几个小时吧，没统计）。

<pre>
pi@raspberrypi ~/work/otp_src_R15B01 $ erl
Erlang R15B01 (erts-5.9.1) [source] [async-threads:0] [kernel-poll:false]

Eshell V5.9.1  (abort with ^G)
1>
 </pre>


（待续）

