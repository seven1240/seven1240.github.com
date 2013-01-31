---
layout: post
title: "FreeSWITCH 中的感人故事 - FreeSWITCH 帮我找到了工作"
tags:
  - "故事"
  - "心情"
  - "freeswitch"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>


今天，跟 FreeSWITCH 邮件列表中的一位网友聊天，忽然想到了它曾发到列表中的一则故事。感悟颇多。

该网友是一个盲人，靠屏幕阅读软件看电脑，用语音识别软件转换成文字跟我聊天（Google Talk）。我一直有个疑问，我用 FreeSWITCH 毛算也有三年了，在学习和使用中经常遇到一些问题，我手眼健全都需要很常时间解决，作为一个盲人，他是怎么做到的呢？

从聊天的语言来看，跟正常人别无二致，而且，可能是他使用语音识别的缘故，反应起来甚至比正常人都快。

当然，跟他聊天并没能完全解答我的疑问。我想，如果有机会去阿尔及利亚，我一定找机会就见见他。

在工作的生活中，每当忙了、累了，我就想到这则故事。今天，我使得他同意，把全文翻译成中文，放到这里。需要指出，由于原文可能是用语音识别写的，因此有些句子不太顺，我尽量按我的理解翻译了。


= . = . = . = . = . = . = . = . = . = . =

FreeSWITCH 帮我找到了工作

邮件列表中的同学们，大家好,

我叫 Meftah Tayeb，来自阿尔及利亚。我双目失明，但自从 1.0.1 时代（版本）就开始使用 FreeSWITCH。

我最开始用的是 Asterisk，在我的生命中，它是一款非常奇怪的 VoIP 软件。感谢 Miconda 在 IRC 上的 #openser 道，把我从 Asterisk “重定向”到 FreeSWITCH，那是2008年的事情。

我于2008年12月开始学习 VoIP 的基础知识。感谢 IRC 上 #freeswitch 频道上的伙计们对我的帮助。最开始有 anthm，Michael S Collin, brian (BKW), 感谢你们以及其它所有的好人。

在2009年8月，阿尔及利亚电信以及政府开始屏蔽 SIP 流。我并不使用 SIP 来做 VoIP 生意，但是，老实说，我只是想用 SIP 连接到每周一次的 FreeSWITCH 公共电话会议，在会议里，大家都讨论 VoIP。我开始向我当地政府（或电信，原文是 local city）抱怨此事，但没人理我。我想直接进入总经理办公室，因为没有SIP我无法使用我的PC。我找到了总经理秘书，他接待了我，并听取了我的抱怨：“你们为什么屏蔽SIP？”。然后他问我：“那你为什么一定需要SIP？你想无证经营 VoIP 业务吗？” 我把我的实际情况告诉他。他说：“好吧，没问题，我会给你开通SIP，但你下周一要到这里来。”。我说：“OK， 那没问题”。

然后，我回到家，看到了新的东西：

1. 一个静态IP地址，绑定在我的 ADSL 帐户上
2. 完全开放的 SIP

OK， 在下个周一我到了总经理办公室，见到了总经理秘书。使我奇怪的是，他问我：”你有工作吗？” 我说没有。他说：“你肯定有，告诉我”，我还是说没有。然后他说：“你在为阿尔及利亚电信工作”！ ;)

他给了我一个惊喜！现在，他给了我一个好工作，免费的房子，以及免费的护理，还有司机。

所以，在这里谢谢 FreeSWITCH 项目，特别是 FreeSWITCH 的主人以及所有贡献者。

谢谢。


邮件原文在此（<http://lists.freeswitch.org/pipermail/freeswitch-users/2010-June/058789.html>），以下是全文拷贝：

	get your job aguinst freeswitch 						


	hello list,
	i am meftah tayeb, a blind person from algeria that was using freeswitch
	sunse 1.0.1 release
	i started firstly with asterisk, that was the very strangett voip
	application in my life
	and thank to miconda that redirected me to freeswitch, from asterisk in
	#openser in 2008
	i started learning voip basic in dec 2008
	thank to the #freeswitch folk that teached me all this, including
	firstly anthm, Michael S Collin, brian (BKW), sekil the nice GUI and all
	other
	in ogust 2009, algeria telecom and the algeria gouvernmant started
	blocking sip traffic
	i was not using it for voip business, but, honestly, just to connect to
	the public freeswitch conference and the weekely  voip users conference
	i start a complain in my local city, no reply from AT
	i decided to go to the general office, because i can't use my PC without SIP
	i got the general directore secrutary
	ok, he receyved me and heare me saying why you are blocking sip?
	so he asked me
	why you need sip?
	do you do voip business without autorisation?
	i explaned to him my actual situation and he say: ok, no problem i will
	open the sip for you, but conditionaly
	the next mondey you will be here
	i say ok no problem
	so, i returned to my home and i see something new:
	1. a static ip address linked to my ADSL account
	2. sip completly open
	ok, next monday i was in the general office and i meet the gebneral
	directotore surprisingly
	he asked me:
	do you have a job?
	i say no
	but he say yes, you have, tel me
	i say no aguin
	and he say you work for algeria telecom
	;)
	he surprised me with this
	now, he gave me a:
	good job
	free house
	free care with driver
	so please say thank to the freeswitch project especialy the owner and
	try to donate to him a much a pocible
	thank you
