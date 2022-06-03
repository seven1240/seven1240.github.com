---
layout: post
title: "也谈 FreeSWITCH 中语音识别"
tags:
  - "ASR"
  - "freeswitch"
---

前段时间有一个语音识别的项目，便轻轻地研究了一下，虽没有达到预期的效果，但过程还是比较有趣。

题目是这样的：给定一些潜在客户，用 FreeSWITCH 自动呼叫，如果用户应答，则转至 IVR，播放欢迎信息甚至转至人工座席；如果客户不应答，则获取不应答原因。

该想法想要达到的目标是：1）客户关怀。客户注册即可收到关怀电话（当然前提是留下电话号码。OK，发短信是另一种方式，但我这们里讨论的是语音）；2）过滤无效客户。从不同渠道来的客户数据良莠不齐，有的甚至50%以上都无法打通，所以，把这部分数据过滤掉显然是很有意义的。

虽然我们在外呼中使用 SIP，但被叫用户在PSTN，而PSTN信令网一个很令人讨厌的地方就是返回的信令不准确，所以，你无法从信令层面获取被叫用户的状态（空号，忙等），而只能从语音层面去“听”。当然，听，对于人来说是没有问题的，但对于机器来说，就不轻松了，它需要使用语音识别（ASR，Automatic Sound Recognition)技术来实现。

Sphinx 应该是开源的语音识别公认的比较好的软件。幸运的是 FreeSWITCH 带了 pocket\_sphinx 模块。它即能进行连续的识别，也能针对关键词进行识别，在测试阶段，成功率还是比较高的。但实际上我们真正要测的数据太烂，所以没有收到好的效果。

## 样本

目前PSTN网上有各种语音数据，除了各种各样的彩铃之外，便是五花八门的语音提示，而且，针对同一种挂机原因，有各种不同版本的语音提示。为了获取样本，我打了不同省市不同运营商的电话并录音：

    originate sofia/gateway/blah/139xxxxxxxx &record(/tmp/testx.wav)

作为测试，我选择了以下几种：

1. 您拨的号码是空号，请查证再拨....(无限循环）
1. 对不起，您拨叫的用户不方便接听您的电话，请稍后再拨。Sorry, the subscriber you have dialed is not convenient to answer now, please dial again later. (循环...)
1. 您好，您所拨打的号码是空号，请核对后再拨。您好，您所拨打的号码是空号，请核对后再拨。Sorry, the number YOU dialed doesn't exist, please check it and dial again.(循环... 一个问题是 YOU 有必要强调吗？)
1. 号码是空号，请查证后再拨。 Sorry, The number you have dialed is not in service, please check the number and dial again. (循环）

如果你听一下，你会发现真是太难听了。那么大的电话公司，不能找个专业的人录音吗？（个人感觉 test4.wav 还是比较专业）


[test1.wav](http://commondatastorage.googleapis.com/dujinfang.com/sounds/hangup_cause/test1.wav)
[test2.wav](http://commondatastorage.googleapis.com/dujinfang.com/sounds/hangup_cause/test2.wav)
[test3.wav](http://commondatastorage.googleapis.com/dujinfang.com/sounds/hangup_cause/test3.wav)
[test4.wav](http://commondatastorage.googleapis.com/dujinfang.com/sounds/hangup_cause/test4.wav)

## 第一种方案，关键词

我将几个关键字写进了 grammer中，如:

```

grammar hpcause;

<service> = [ service ];
<rejected> = [ convenient ];
<busy> = [ busy ];
<konghao> = [ konghao ];
<exist> = [ exist ];
public <hpcause> = [ <service> | <rejected> | <busy> | <konghao> | <exist> ];

```

实际测试中，我甚至将“空号”（konghao）作为关键词加上去，的确有时候能识别出来。由于中英文混杂，识别率太低。纯英文的环境比较理想。

## 第二种方案，连续识别

当然我也试过连续的语音识别，效果都不理想。pocket\_sphinx 是支持中文的，但配置比较复杂，而且我也怀疑它在中英文混合识别方面的效果到底如何。


## 第三种方案，只录音，采用外部程序识别

要想在 FreeSWITCH 中准确识别这么复杂的情况看来是不现实的。另一种想法就是只录音，而采用外部程序（可能还是 Sphinx）来识别。可以针对中英文各识别一次，去掉不能识别的部分，我相信效果还是可以的。但没有试过。

## 第四种方案，Google Voice

实际上 Google Voice 有一个很有趣的功能就是 Voice Mail，当你的电话无法接通时，它可以录音，并能转换成文本。我今天忽然想到，能否让 Google Voice 来替我们做这项工作 ？如果行，对于每个 Voice Mail 我们都能收到一封电子邮件，岂不是绝了？

我赶紧试了以下命令：

    originate {ignore_early_media=true}sofia/gateway/blah/1717673xxxx 'sleep:3,playback:/home/app/t/test4.wav' inline

上面，我呼叫我的 Google Voice 号码，并拨放声音文件，为了等待 Google Voice 启动 Voice Mail，暂停了3秒。其中使用了 FreeSWITCH 的 inline dialplan。

不得不说，人家 Google Voice 的功力就是比较深，以下是呼叫结果（虽然它花了好长时间生成这些文本）：

1. But how much you called her some cat content, a lot. But how much you called her some cat content walk. But how much you called her chin cat content walk. But how much you called her some cat content water. But how much you called her some cat content walk. But how much you called her team cat content walk. But how much you called her teams have content walk. But how much you called her team cat content walk. But how much you called her team captain sample. But how much you called her some cat content. Blah. But how much you called her team packing 10 o'clock. But.

由于第一条语音是纯中文的，对比一下，可以发现 GV 的想象力是比较丰富的。

    您 拨的      号   码是         空     号
      But       How  much      Called  her

2. Dave, date which he didn't full full time. Thank you can. Looking for some sure. Okay well, sorry the subscriber to get that out. If not, yes right now. Please check it out later, date which he didn't hopeful. I think you can. Looking for some chance. Okay well, sorry. The subscriber to get that out. If not, yes uncertain, so. Please straight out later. If You Keep Doing phone found antiquing employer some chocolates as well. Sorry. The subscriber you have dialed is not company as uncertain. So please straight out later. Hey Vicky, but I think in full full time. Thank you been looking for. So, I'm sure. Okay well, sorry. The subscriber you have dialed is house company as of right now lease without a later Hello. Hey Vicky, like, I can hopeful. I think you can get them some chocolates at. Well, sorry. The subscriber you have dialed is not come again it's on sale now. Please straight out later. Hey Vicky, but I don't know 4 phone so I think you can get some fire some chocolate at 40 sorry. The subscriber you have dialed is not come again it's on sat. Now, Please, straight out later.


"not convenient" 跟 "not come again" 相比意思应该差不多吧？哈


3. Com critical table, the com the job without the how much you can call team critical examples of the the number in the Dells doesn't exist. Please check it and Dale again the com job without a, how much you can call few critical table, the com the job without a, how much you can call team critical to thank both of these, the number in the Dells doesn't exist. Please check it and down again.

至少有关键字 "doesn't exist"

4. This is not in service. Please check the number and dial again, yeah. How, the bloodhound I should call me a call. If you could take a look at all. The number you have dialed is not in service. Please check the number and dial again.

事实证明老四的英文说的不错，英文部分识别的一字不差。


## 结论

看来中英混合识别的难度还是比较大的。但我想，不管PSTN的语音再怎么变态，毕竟它是有限的，我们只要采集所有的语音样本，做到100%识别应该是不难的。  
