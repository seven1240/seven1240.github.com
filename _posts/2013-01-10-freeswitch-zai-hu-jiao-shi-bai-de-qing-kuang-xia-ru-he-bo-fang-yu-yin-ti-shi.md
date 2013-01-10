---
layout: post
title: "FreeSWITCH在呼叫失败的情况下如何播放语音提示"
---

# {{page.title }}

看到好多网友问到这个问题。一般我们在打电话时会听到“您拨的电话正在通话中，请稍后再拨....”，或“电话无应答...”之类的提示，我们在 freeswitch 里也可以这样做。

其实很简单，默认的配置在呼叫失败时会转到 voicemail (语音信箱)，我们只需要在这里修改，让他播放一个语音提示，然后再进入语音信箱（或直接挂 断也行）。

找到  &lt;extension name="Local\_Extension"&gt;部分的最后几行

	<action application="bridge" data="user/${dialed_extension}@${domain_name}"/>
	<action application="answer"/>
	<action application="sleep" data="1000"/>
	<action application="bridge" data="loopback/app=voicemail:default ${domain_name} ${dialed_extension}"/>

其中，第一个 bridge 是说明去呼叫被叫号码，如果呼叫失败，则 dialplan 继续往下走，依次是

* 应答
* 睡一会
* 进入 voicemail

OK, 我们只需要把最后一个bridge那行改成

	<action application="playback" data="${originate_disposition}.wav"/>


重新打电话试一下吧，如果被叫忙，则 originate\_disposition 变量就是 USER\_BUSY ，用户没注册就是 USER\_NOT\_REGISTERED 之类的，你只需要保证相关目录下有相对应的声音文件即可（如果LOG中提示找不到声音文件的话试试自己录一个）。

当然，呼不通的原因可能有很多，你总不可能录上所有的声音文件是吧，有两种方法：

1) 使用一个 lua (或其它语言) 的脚本

	<action appliction="lua" data="/tmp/xxx.lua"/>

在 lua 脚本中可以拿到这个 originate\_disposition 变量，从而可以使用 if then else 之类的逻辑播放各种声音文件。


2) 当然，如果你脚本也不想编辑的话，实现上 FreeSWITCH 的 dialplan 功能是非常强大的，你只需要将呼叫转到播放不同声音文件的 dialplan：


	<action application="transfer" data="play-cause-${originate_disposition}"/>


然后创建如下 dialplan extension:

   <extension name="Local_Extension_play-cause">
      <condition field="destination_number" expression="^play-cause-USER_BUSY$">
      	<action application="playback" "/tmp/sounds/user-busy.wav"/>
      </condition>
   </extension>

   <extension name="Local_Extension_play-cause">
      <condition field="destination_number" expression="^play-cause-USER_NOT_REGISTERED$">
      	<action application="playback" "/tmp/sounds/user-not-registered.wav"/>
      </condition>
   </extension>

   <extension name="Local_Extension_play-cause">
      <condition field="destination_number" expression="^play-cause0(.*)$">
      	<!-- for all other reasons, play this file -->
      	<action application="log" data="WARNING hangup cause: $1"/>
      	<action application="playback" "/tmp/sounds/unknown-error.wav"/>
      </condition>
   </extension>


小结：

当然，能播放上面的声音文件还有一个前提，就是在第一个 bridge 前面要有以下两行：


	<action application="set" data="hangup_after_bridge=true"/>
	<action application="set" data="continue_on_fail=true"/>


第一行的作用是，如果第一个 bridge 成功了，被叫挂断电话后我们就没有必要再播放该声音了，因此直接挂机。当然这一行可以没有，那么你在后面的 originate\_disposition 里如果发现值是 "NORMAL\_CLEARING" （正常挂机）的情况再决定是否播放相关语音。

第二行的作用是，如果呼叫失败（空号，拒接等），继续往下走，否则(值为 false 的情况)到这里就挂机了。该变量的值还可以有以下几种，表示只有遇到这几种情况才播放语音，其它的就直接挂机。

	<action application="set" data="continue_on_fail=NORMAL_TEMPORARY_FAILURE,USER_BUSY,NO_ANSWER,TIMEOUT,NO_ROUTE_DESTINATION"/>

祝玩得开心！
