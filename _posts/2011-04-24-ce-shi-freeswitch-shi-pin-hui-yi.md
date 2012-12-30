---
layout: post
title: "测试 FreeSWITCH 视频会议"
---

# {{ page.title }}

一直想测一直  FreeSWITCH 的视频会议功能，但以前只有两个支持  H263 的设备 (Huawei视频电话及一个 Xlite），未能好好体验。最近买了两个 XPT8886 视频电话及一个 Bria 软电话授权，总算是可以测试三方会议了。

首先，要在 sofia profile 中设置支持的视频编码，简单起见我直接在 vars.xml 中设置了：

    <X-PRE-PROCESS cmd="set" data="global_codec_prefs=PCMU,PCMA,GSM,H264,H263-1998,H263"/>
    <X-PRE-PROCESS cmd="set" data="outbound_codec_prefs=PCMU,PCMA,GSM,H264,H263-1998,H263"/>

首先将所有视频设备设成只支持 H263，让我所有支持视频的设备连接互拨，测试均正常。然后将所有电话打入默认的电话会议号码 3000 ，电话会议正常。经过研究源代码，发现流程是这样的：

* 每个会议里都有一个 video 线程

* 每个会议里会有一个标志，叫做 floor，一般来说，当前正在发言的人会拥有这个 floor

* 拥有 floor 的人的视频会广播到所有的终端上，包括它自己

如果在会议中，另一个人开始讲话，视频就会发生切换，但切换的画面会出现马赛克，而且有些慢，即使在局域网环境中也如此。

接下来测试 H264，由于我华为的设备不支持H264只好放到一边了。

全部打入 3000 以后发现 XPT8886 终端的视频不能正常显示，而 Bria 的则正常。百般测试无果只好查看源代码了，最后发现，在 mod_conference 的 1011 行左右，有一段检测 i-frame 的代码，对于 Bria 能检测通过，而 XPT8886 发出的 RTP 包无论如何都检测不通过，后来，直接将其改成 iframe = 1 ，视频功能正常。

    } else if (vid_frame->codec->implementation->ianacode == 99) {	/* h.264 */
        iframe = (*((int16_t *) vid_frame->data) >> 5 == 0x11);

画质明显比 H263 好得多，切换也快得多。

在广域网的环境下测了一下，效果还不错。连接美国的 FreeSWITCH 服务器，发现视频质量很差，当然了，视频需要到美国绕一圈再回来，当然会大打折扣。准备哪天找个老外测一测，看看效果。
