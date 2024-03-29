---
layout: post
title: "FreeSWITCH背后的故事(译)"
tags:
  - "freeswitch"
---

本文由Anthony Minessale写于2007年5月。来自 [www.freeswitch.org](http://www.freeswitch.org/node/60)。翻译它是因为我觉得永远都不会过时... --Seven

我开发FreeSWITCH已经近两年的时间了。在我们第一个发行版即将发布的黎明之际，我想花一点时间来与大家分享一下软件背后的故事，并透露一点即将到来的消息。本故事也将会登在 [OST Magazine](http://www.ostelephony.com/)第一期上。呵，去下载一份吧，免费的！

写FreeSWITCH的想法诞生于2005年春的一次Asterisk开发者大会上。当时，我为Asterisk 1.2版贡献了大量的代码和新特性，并为其以后的发展提了好多思路。我们都认为在当时的Asterisk代码树中存在很严重的限制，并且面临着一些问题──修正一些问题时不仅会牺牲很多特性，而且还会花大量的时间。一种思路是建立新的代码分支，通过将大家已经熟悉的代码分开，新的分支就不会影响Asterisk用户的使用，从而能减轻好多开发的压力。问题是开发者都不希望将精力分散到同一份代码的两的版本上，因为那样他们就不得不将BUG修正和代码修改在两个分支间拷来拷去。我的建议是：在一个单独的代码库上从头创建一个Asterisk 2.0的分支，等一切就绪后再对外发布。我想那个想法确实打动了一些开发人员，但现实是，由于讨论的时间过长，最终大家都失去了兴趣。不过，我没有。

很明显，我是唯一一个认真考虑这一问题的。接下来我用了几天的时间在做一个白日梦──如何设计一个新的电话系统。之后，我再也无法抑制，便创建了一个新的目录开始从头写choir.c。是的，Choir是我为该工程的选的第一个名字。我希望不同的通信部件能够步调一致地协同工作，就像教堂的唱诗班那样优雅和谐（perfect harmony）。我又用了5天时间把我想到的点子都组织到几个文件里。最初的努力并不能装配成一个电话交换机。我知道，我需要创建一个稳定的核心，并应该能跨平台。所以最简单的是使用Apache APR库来搭建一个基本的子系统，让它能够动态装载共享模块并悠闲地停在屏幕上等待shutdown命令。实现这些代码用了另外6个月的时间。

在那5天里，我知道了写一个达到那种要求的可伸缩性程序并不是一件简单的事情。我最初的目标是捡起那些Asterisk丢掉的东西并加以改善。但随着思考的深入，我越来越觉得，实际上我想改进的是最基础的设计和功能。最终我得出结论，Asterisk不能实现一些我期望的功能是因为它不是我所需要的那种软件。也就在那时，我知道我不是要编写另外一个PBX，而是要开发一个完全不同级别的应用程序。我用了后续的几个月时间组织了第一届ClueCon年会来讨论如何合理的设计Choir。我希望在继续写任何代码之前能确信我有正确的计划。从这一点上说我仍在做相当的一部分Asterisk开发，并且我也在我写的一些第三方模块中来实验我的想法。另外，我也让我的同事们花了相当多的时间来争论在电话领域里如何“正确”地做事情，这也算是一种前瞻性吧。

在那年的ClueCon会议上，我有幸遇到一些在电话领域里很有影响力的开发者，并把很多灵感带回了家。同时，Asterisk阵营中的关系开始有些紧张，因为有几个开发者也打算建立新的分支。新的项目称为OpenPBX（现在叫Call Weaver），从某种意义上讲它引起了Asterisk社区的一次严重地分裂。最初，OpenPBX把我的许多第三方Asterisk模块加入到他们的新代码中，并就如何增强稳定性方面咨询我的建议。其中有一点，甚至他们还来看我是如何在我的新项目中实现的。可能我们能再打起精神来重写那些老的计划，但最终没有实现。不过，我想，最意义深远的一刻是──当有人问到我：“多长时间以后它才能打电话呢？”我不知道，所以我决定搞清楚。简短的回答是一星期。

与我想达到的目标相比，能打电话只是一个小小的胜利。我还有很多要做的事情。这一点不起眼的业绩得不到太多关注。好消息是，这一项目最终上路了。我深居简出，用了三个月时间试图能做出点能吸引公众眼球的东西。那段时间，项目的名字曾改为Pandora并最终成为FreeSWITCH。2006年1月我们公开的SVN仓库和一个邮件列表上线了。那时仅有几个模块和一个很短的特性列表。但我们有了一个可以工作的内核，它能够在包括Mac OS X，Linux和BSD的几个UNIX变种上编译和运行，并能在Microsoft Windows上以一个控制台程序运行。

随着时间的推移，我们也越加有动力。有时也停下来犯几个错误，然后继续前进，写几个新的模块。在试验了四个不同的SIP终点模块后，我们决定使用Sofia SIP。也曾试验过5个不同的RTP协议栈，最终决定还是我们自己写。同时我也开发了mod_dingaling来做与Google Talk的接口，以及一个多特性的会议桥。在第一年里，我主要关注如何在使核心尽量稳定的基础上，提供几个外部接口以便于其它模块的开发。如用于IVR的嵌入式的javascript，一个XML-RPC接口和一个用于远程控制和事件监控的基于TCP的Socket的接口。

第二年的ClueCon大会，那一天仿佛就是我白日梦醒来的日子。我第一次向我的同行们演示了FreeSWITCH。近九个月后，在距离第一个想法两年之际，第三届ClueCon一个月前，我们达到了开发的BETA阶段──FreeSWITCH 1.0发布在际了。我们也吸引了一些勇敢的开发者一道。他们已经把FreeSWITCH用于生产系统，并给我们提供了保证我们第一个发布版本成功的很重要的反馈。

在发布之前，最后一点工作是我新写的一个叫做OpenZAP的开源的TDM抽象库。使用BSD协议的mod_openzap模块将取代当时特定于Sangoma的mod_wanpipe，并提供Sangoma及其它几种TDM硬件（只需要开发对应的模块）支持。OpenZAP也将为模拟和ISDN信令提供一个简单的接口。OpenZAP的指导思想是──应用程序能使用同样的API去控制任何它所支持的TDM硬件。它提供一种方式能将所有不同的特性规范化。如果一种卡缺少某种特性，那么它就能以软件的形式实现，不管是在OpenZAP库中还是在与生产商硬件API通信的接口程序中。

我们在如此短的时间内做这么多事听起来好像是不可能的，但我想，最终，还是像格言里说的：“需要是发明之母。”接下来的路还很长。但我想就此机会感谢所有曾经帮助我们走了这么远的人。下面列表中是所有在我们AUTHORS文件中的人：

* Anthony Minessale II (就是我!)
* Michael Jerris (我们极具价值的编译专家和跨平台专家 cross-platformologist， [呵，这个词是我创造的])
* Brian K. West (我们挚爱的Mac权威，没有他的帮助，我们将寸步难行)
* Joshua Colp (帮助我们做了第一个SIP模块，虽然现在我们已经不用了)
* Michal "cypromis" Bielicki (他从第一天就加入进来了，感谢信任！)
* James Martelletti (把mono集成进了FreeSWITCH.)
* Johny Kadarisman (帮我们弄好了python模块)
* Yossi Neiman (写了mod_cdr收集通话详单)
* Stefan Knoblich (在我们的SIP之旅上帮助甚多)
* Justin Unger (找到很多BUG)
* Paul D. Tinsley (SIP presence以及其它好的建议)
* Ken Rice (为什么有这个名字？它给了我们做了很多测试和补丁)
* Neal Horman (在会议模块上有巨大贡献)
* Michael Murdock (我们CopperCom的朋友，有大量反馈和补丁)
* Matt Klein (大量SIP帮助，将帮我们确保FreeSWITCH运行于FreeBSD.)
* Justin Cassidy (幕后工作者，确保一切正常)
* Bret McDanel (敢吃螃蟹的人，试验了绝大多数的功能，最早发现了很多隐藏的BUG，我指的是得活节彩蛋！)
