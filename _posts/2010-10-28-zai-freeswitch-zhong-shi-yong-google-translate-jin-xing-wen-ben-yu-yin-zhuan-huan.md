---
layout: post
title: "在 FreeSWITCH 中使用 google translate 进行文本语音转换"
tags:
  - "freeswitch"
  - "tips"
---

今天，偶然发现 google translate 一个很酷的功能，TTS。

在浏览器中输入 http://translate.google.com/translate_tts?q=hello+and+welcome+to+w+w+w+dot+dujinfang+dot+com&tl=en 然后立即就可以播放声音。

又试了一下这个，呵呵 http://translate.google.com/translate_tts?q=欢迎光临七哥的博客&tl=zh ，也好用。

我在Mac上分别用 Safari, Chrome 和 FireFox 都测试通过。

那么，能不能在 FreeSWITCH 里用呢？当然，FreeSWITCH 通过 mod_shout 支持 mp3！

默认的 FreeSWITCH 中 mod_shout 是不编译的，所以需要自己编译。到源代码目录下，执行

    make mod_shout-install

就装好了（当然，前提是你已经用源代码安装了 FreeSWTICH 的情况，参见  [电子书第二章](/past/2010/4/14/freeswitch-chu-bu/)）。

在 FreeSWITCH 命令行上装入模块：

    load mod_shout

测试一下：

    originate user/1000 &playback(shout://translate.google.com/translate_tts?q=hello+and+welcome+to+www+dot+dujinfang+dot+com&tl=en)

太爽了。但中文的没有成功，不知道为什么。

当然你也可以写到 [Dialplan](http://www.freeswitch.org.cn/blog/past/2010/10/22/ren-shi-bo-hao-ji-hua-dialplan/) 中，然后呼叫 1234 试一下 :D（为了排版方便，我换行了，记着shout 那一行别断行）

	<extension name="Free_Google_Text_To_Speech">
	     <condition field="destination_number" expression="^1234$">
	      <action application="answer" data=""/>
	      <action application="playback"
                       data="shout://translate.google.com/translate_tts?
                       q=hello+and+welcome+to+www+dot+dujinfang+dot+com&tl=en"/>
	     </condition>
	</extension>
