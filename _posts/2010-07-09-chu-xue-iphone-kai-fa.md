---
layout: post
title: "初学 iPhone 开发"
tags:
  - "iPhone"
---

iPhone 真是个有创意的产品，刚开始玩，有很多新奇好玩的游戏是意料之中的，但像手电筒、罗盘、水平仪、游标卡尺等应用却是大大出乎意料之外的。

iPhone 就一个 HOME 键，将简单发挥到了极致。手一痒，但也想写个 iPhone 的程序。正好公司也开始做移动方面的文章，也算是顺了东风了。

第一个 iPhone 程序
--------

我第一个动手的就是改造我的博客。网页版的，改起来最简单。需要说明，我的博客是基于 Sinatra 的，由于它[已经支持WAP](/past/2009/11/22/zai-sinatrazhong-zhi-chi-shou-ji-wapfang-wen/)了，再加上iPhone 支持也不难。简单起见，我只是判断了 user_agent:

<code>
  if request.user_agent.nil? || request.env['HTTP_VIA'] =~ /WAP/
    @is_wap = true
  elsif request.user_agent =~ /iPhone/
    @is_iphone = true
  end
</code>

接下来，无非就是在代码中看到 @is_iphone = true 的时候使用不同的 layout。界面部分我用了 [IUI](http://code.google.com/p/iui/)，当时还不知道[Sencha](http://www.sencha.com/)。

代码更新后，在 iPhone 上打开我的博客http://www.dujinfang.com 或 http://www.7ge.cn（这个短点，适合 iPhone，但没备案，因此未大力宣传）。按 Safari 浏览器下面的 "+" 按钮，选择“添加至主屏幕”，就在主屏幕上加了一个 Blog -7- 的应用程序（看起来像个应用程序，实际上还是 Safari，相当于个快捷方式吧，呵呵）。


越狱
--------

iPhone 好归好，但它有太多的限制。程序只能装 Apple Store 里的。但我只想写个程序，在我自己的手机上运行，为什么还得这么麻烦？当然，这并不是越狱的借口，只是，我希望看看我手机里到底有什么，我希望能与我的电脑共享文件，我希望....那就越吧。我的系统是3GS iOS3.1.3，按网上的教程一步步做下来并不怎么难，关键是大多数教程是教怎么在 Windows 下操作的，我在MAC上就多费了点劲。当然还有个小插曲，越狱重启后等了好长时间，标志越狱成功的进度条已经到头了，可就是不见动静，死机了？汗！学了一个强制重启的办法--同时按住 HOME 和 电源键，可再开机依然如故。请教高人，说可能要比较长的时间。没办法，放那儿不管了。过会再看时，果然好了。有了 Sydia 再装 OpenSSH、Terminal 之类的东东，就可以操作命令行了。只是现在还有一个问题，SSH 过一阵就不好用了，查看 /usr/sbin/sshd 文件没有了，从网上搜了很久没找到结果，难道我手机上有反 SSH 的东东？有认知道别忘了告诉我啊。现在我只好每次用的时间重装一下 OpenSSH。后来还找到一个办法，就是把 /usr/sbin/sshd 备份一下，每次到 Terminal 中执行 /usr/sbin/s -i ………

越狱的缺点是现在还不敢升级到 IOS4，虽然我很向往多任务...

第二个程序
------

第二个程序当然是 HelloWorld，我只是在 Xcode 中新建了一个工程，按模板生成了一个框架，按标签改成 Hello World! 在模拟器上运行OK，但无法编译到设备中去。找到 /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.1.3.sdk/SDKSettings.plist 将其中的 CODE_SIGNING_REQUIRED 改成 NO， 这样， Xcode 就不会要求 Code sign 了。另外，还得在我的工程中找到 Get Info -> Build -> Code Signing Identity，改成 Don‘t Code Sign。

Build and Run， 会出一点小错误，因为没经过签名的程序是不能安装到设备上去了。我们有 SSH 啊。直接在  build/Debug 目录中找到 生成的 iPhone 程序， scp -r Seven.app root@iphone-ip/Applications 就OK了。重启 iPhone，果然看到程序图标了。

另外，Sydia 中还有个 Respring 程序可以不用重启整个手机，而只重启面板。

还发现有个 phoneview 软件很好用的，可以直接访问 iPhone 上的文件系统。找了个破解版的，但在 iTunes 升级后就不好用了，只好又下载了个试用版的，但用它将程序上传到 iPhone 上发现有图标但不能运行。在 Xcode 的 Organizer 中看日志，发现是没有执行权限。打开 Terminal ，加上可执行权限就OK了。
    cd /Applications/Seven.app 
    chmod a+x seven

Titanium
------

后来发现这伙计挺好的，在[Titanium](http://www.appcelerator.com/)中可以直接使用 Javascript 写iPhone 程序，Titanium 会将 Javascript 映射到 iPhone 的 API。试着写了个程序，还不错。它最大的好处是同时支持 Andriod。

当然，如果开发复杂一点的程序，就发现它提供的 API 不够用。不过它支持模块，可以用 Object-C 或 Java (Andriod) 自己写模块。


Object-C
------

无论 Titanium 再怎么简单，复杂的应用还是得用 Object-C ，即使只写插件。有 C 和 C++ 的基础，但起来当然也不难，但还是需要一定时间熟悉它。而且无论怎么看，总觉得不如直接用 C 写的代码舒服。


Xcode
------

虽然都说它很强大，可是熟悉起来也不是那么简单。不习惯它带的编辑器，所以我大部分还是用 Textmate。习惯了写 Makefile，对于这种图形界面的东西看不适应。当然 xcodebuild 可以在命令行下运行，但网上找不到太多的资料，一切都得靠慢慢摸索了。
