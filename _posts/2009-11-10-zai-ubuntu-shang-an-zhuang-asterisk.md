---
layout: post
title: "在 Ubuntu 上安装 Asterisk"
tags:
  - "asterisk"
  - "linux"
---


与许多VoIP爱好者一样，我也是从Asterisk开始的，只是没怎么深入。这篇文章是从我的旧博客上挪过来的，写于2008年1月。

---


其实在ubuntu上安装Asterisk很简单，apt-get 就搞定了

```
apt-get install asterisk
```

参考了下面一篇文章，但没搞那么复杂

[wiki.ubuntu.com/AsteriskOnUbuntu](https://wiki.ubuntu.com/AsteriskOnUbuntu)

由于没有FXO和FXS的硬件，只好用VoIP试试了。

Ubuntu自已带了Ekiga，可以使用SIP。

ubuntu中，asterisk服务以asterisk用户的身份运行，所以，可以用root或asterisk的身份登录的控制台：

sudo su asterisk asterisk -rvvv

就可以看到调试信息了。

配置文件都在/etc/asterisk下: 配置sip.conf

先将sip.conf备份一下子, Ubuntu自己带的有些复杂了，呵呵，对于新手来说，太长了。

```
mv sip.conf sip.conf.old

touch sip.conf

# cat sip.conf
[general]

bindport=5061
[1000]
type=friend
context=phones
host=dynamic

[1001]
type=friend
context=phones
host=dynamic

```

以上只是简单配置，不安全。设了两个号码 1000和1000，呵呵，主要是照asterisk的书上说的。注意，我把系统默认的端口从5060改成了5061，因为ekiga也要监听5060端口，会有冲突。

再配extensions.conf：记着先备份一下原来的啊

```
# cat extensions.conf
[globals]

[general]
autofallthrough=yes

[default]
exten => s,1,Verbose(1|Unrouted call handler)
exten => s,n,answer()
exten => s,n,Wait(1)
exten => s,n,Playback(tt-weasels)
exten => s,n,Hangup()
[incoming_calls]

[internal]
exten => 500,1,Verbose(1|Echo test application)
exten => 500,n,answer()
exten => 500,n,Echo()
exten => 500,n,Hangup()

[phones]
include => internal

```

好了，切换到asterisk控制台，运行

```
CLI> sip reload

CLI> dialplan reload
```

就可以了。打开ekiga，新建一个账户:

账户名称：随便起

注册商：127.0.0.1:5061

用户： 1000

密码：空着就行了

连接sip:500@127.0.0.1:5061 试试，如果成功，（保证你的耳机mic等好用先），你说话，就可以在耳机听到自己的声音了。

接下来再配置一个分机：extensions.conf 1001。 注意，里面的1002在下一步才用到，先配置上吧。

```
exten => 1000,1,NoOp()
exten => 1000,2,Monitor(wav,myfilename) 
exten => 1000,n,Dial(SIP/1000,30)
exten => 1000,n,Playback(the-party-you-are-calling&is-curntly-unavail)
exten => 1000,n,Hangup()

exten => 1001,1,NoOp()
exten => 1001,n,Dial(SIP/1001,30)
exten => 1001,n,Playback(the-party-you-are-calling&is-curntly-unavail)
exten => 1001,n,Hangup()

exten => 1002,1,NoOp()
exten => 1002,n,Dial(IAX2/idefisk,30)
exten => 1002,n,Playback(the-party-you-are-calling&is-curntly-unavail)
exten => 1002,n,Hangup()

```

配置好后，到控制台，打上

```
CLI> dialplan reload
```

就可以了。

但是，一台机器上不能测试两个分机（主要是mic不能重用），如果在你的局域网上有其它机器，就可以在其它机器上登录进行测试，只是需要将127.0.0.0改为你真实的ip地址，然后，就可以呼叫

sip:1000@你的IP:5061

或者：

sip:1001@你的IP:5061了。同时，在控制台上可以看到详细呼叫信息。

但我实验没有成功，能听到回铃音，也能听到提示音，但建立建话后听不到声音，不知道原因。（我是用另一台笔记本连交叉线测试的）。

设置iax。iax是另一种协议，可以使用kiax软件电话连.

```
apt-get install kiax
```

或者 apt-get install iaxcomm也可以，但未测试

配置iax.conf

```
# cat iax.conf
[general]
autokill=yes

[idefisk]
type=friend
host=dynamic
context=phones
```

完成后到控制台下：

```
CLI>module reload chan_iax2.so
```

就可以了。（因为dialplan上面已经配了，就是1002那个分机号码）

现在，启动kiax，添加个账户（比SIP简单），然后直接呼叫1000或1001都可以，能正常建立通话，也能彼此听到声音。


后来，从淘宝上买了一张Asterisk兼容卡，还连上了我的办公室电话呢。
