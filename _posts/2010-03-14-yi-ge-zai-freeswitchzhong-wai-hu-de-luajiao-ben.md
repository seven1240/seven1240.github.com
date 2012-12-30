---
layout: post
title: "一个在FreeSWITCH中外呼的Lua脚本"
---

# {{ page.title }}

一个在FreeSWITCH中外呼的脚本

前几天，一个朋友问我能否实现在FS中外呼，然后放一段录音，我说当然能，写个简单的脚本就行。但后来他说还要知道呼叫是否成功，我说，那就需要复杂一点了。

当然，这个应用很简单，就没必要使用event\_socket那些复杂的东东。写了一个Lua脚本，基本能满足要求了。

思路是将待呼号码放到一个文件(number\_file\_name)中，每个一行，然后用Lua依次读每一行，呼通后播放file\_to\_play，结果写到log\_file\_name中。为保证对方应该后才开始播放，需要ignore\_early\_media参数，否则，对方传回铃音或彩铃时播放就会开始，而那不是我们想要的。

<code>
prefix = "{ignore_early_media=true}sofia/gateway/cnc/"
number_file_name = "/usr/local/freeswitch/scripts/number.txt"
file_to_play = "/usr/local/freeswitch/sounds/custom/8000/sound.wav"
log_file_name = "/usr/local/freeswitch/log/dialer_log.txt"
</code>

简单起见，包装一个函数：

<code>
function debug(s)
	freeswitch.consoleLog("notice", s .. "\n")
end
</code>

定义呼叫函数。freeswitch.Session会呼叫一个号码，并一直等待对方应答。然后，streamFile播放一段声音，挂机。最后，函数返回挂机原因 hangup\_cause。
<code>
function call_number(number)
	dial_string = prefix .. tostring(number);
	
	debug("calling " .. dial_string);
	session = freeswitch.Session(dial_string);

	if session:ready() then
		session:sleep(1000)
		session:streamFile(file_to_play)
		session:hangup()
	end
	-- waiting for hangup               
	while session:ready() do
		debug("waiting for hangup " .. number)
		session:sleep(1000)
	end
    
	return session:hangupCause()
end
	
</code>

实际的代码是从这里开始执行的。首先打开存放电话号码的文件（准备读），和呼叫日志（准备写，追加）。

然后是无限循环(while)，每次读取一行，当读到空行或文件尾时，退出。

while 循环中，读到的每一行实际上是一个号码，调用上面定义的call\_number进行呼叫，并将呼叫结果写到log\_file中。

<code>
number_file = io.open(number_file_name, "r")
log_file = io.open(log_file_name, "a+")

while true do

	line = number_file:read("*line")
	if line == "" or line == nil then break end

	hangup_cause = call_number(line)
	log_file:write(os.date("%H:%M:%S ") .. line .. " " .. hangup_cause .. "\n")
end

</code>

很简单，很强大，是吧？

将脚本存到scripts目录中（通常是/usr/local/freeswitch/scripts/)，起名叫dialer.lua，在FreeSWITCH控制台或fs\_cli中执行：

<code>
luarun dialer.lua
</code>

完整的脚本：

* <http://fisheye.freeswitch.org/browse/freeswitch-contrib/seven/lua/dialer.lua?hb=true>

另外还有一个 batch_dialer:

* <http://fisheye.freeswitch.org/browse/freeswitch-contrib/seven/lua/batch_dialer.lua?hb=true>
* FreeSWITCH提供的API：<http://wiki.freeswitch.org/wiki/Mod_lua>

* Lua语言：<http://www.lua.org/>
