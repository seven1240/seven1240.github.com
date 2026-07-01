---
layout: post
title: "我终于又有了自己的 Linux 电脑"
tags:
    - "Linux"
    - "Mac"
    - "Debian"
category: "Linux"
description: "我在 Macbook Pro 上安装了 GNU/Linux Debian 13"
---

我喜欢 Linux，也拥有过自己的 Linux 电脑，后来换成了 Mac OS（后来变成macOS），就再也没有用过 Linux。当然，我这里说的是桌面版的 Linux。因为，平时，在服务端，甚至我的开发环境也大部分时间在 macOS上通过 Docker 跑 Linux。

说来话长。我最初是从 DOS 开始学电脑的，后来就喜欢上了 Linux，便把所有能装 Linux 的电脑都装上了 Linux，有双系统的，也有虚拟机的，一直是 Windows 和 Linux 混着用。再后来，我换到了 macOS，桌面版就再没回到过 Linux，也几乎再没用过 Windows，一晃也小二十年了。

然而，我总希望有朝一日能在桌面端再次用上 Linux。

我很关注 Linux 的进展，也总是会在虚拟机里安装上各种新版本试一试，然而，总是有各种原因，无法真正在电脑上安装桌面版 Linux。

在服务端，我一直用 Debian。桌面端，Ubuntu、Deepin、统信，各种版本都试过，各种臃肿，不好用。

最近，一次偶然的机会，我买了台二手 Macbook Pro。Intel版的，没有十年也有八年了吧，不过，看起来还很新，键盘上还有保护套。我就买了下来。

系统是Windows，我当然果断就装了Linux。这次选了 Debian 13。这不仅是我在服务端使用的版本，而且桌面版与其他版本比起来，正宗，不臃肿。

虽然无数次安装过Debian，这次，在Mac上装，还是踩了不少坑。

首先是最小化的网络安装的版，由于没有Wi-Fi驱动，无法安装。我便选了DVD版。好在我有一个USB转网口的转接器，接上有线，可以上网。

安装完 Debian 后，启动 Gnome 桌面，感觉非常好。下面就是进一步的配置了。

安装的时候，我安装了一个普通用户 seven，没有必要，不用 root。

但很多功能都需要 root，所以，先变成 root，配置一下 sudoer

visudo

在 %sudo 一行后，写入以下内容：

seven ALL = (ALL) NOPASSWD: ALL

这样，以后使用 sudo 以 root 身份运行程序时，不需要频繁输入密码。

下一步，将软件包的源配置成国内的源，这样以后安装其他软件就比较快。我使用的是清华的源  https://mirrors.tuna.tsinghua.edu.cn/help/debian/ 。当然，也可以选择163、华为、阿里或腾讯的源等。

装 curl，很多工具都需要 curl。

apt install curl

装 Pi。这是小龙虾背后用的 Agent。有了它，以后再装东西就方便很多。

配上 DeepSeek 的 Key，Pi 就活了。一般来说，使用 deepseek-v4-flash 模型就够了， pro 模型贵很多。

让 Pi 安装Wi-Fi驱动。基本的提示词如下：

我在mac上使用Debian，帮我装上WiFi驱动。

它就会自己安装了。期间，它会自动下载相关工具，编译并加载内核模块。

有了Wi-Fi，上网就方便多了，可以把网线断开。

摄像头驱动也需要自己装。当然，我也是让 Pi 装的。这个比较麻烦，来来回回试了好多次才装好。看提示，好像是 Mac 的每个摄像头都有不同的配置，需要从 macOS 上提取配置。由于我的电脑里已经没有旧的 macOS 驱动了，所以也提取不到配置。最后就是，摄像头驱动安装成功了，但效果好像不是很好。

我是一名程序员，最近我常用的编辑器是 Zed，Zed 一般只需按官方命令手动安装即可。Zed自带的Agent也很好用。实际上，有些操作，我也是在Zed里做的。

我还会安装 kitty 和 ghostty，支持 GPU 的终端程序，很好用。

我一般都使用英文给 Pi 下指令。但有时候中文更方便些，这时候，就需要安装中文输入法。我使用五笔，直接让 Pi 安装“五笔”或 “wubi” 都可以正确安装上（会先安装 fcitx）。Gnome 有 Wayland 和 X11 两个不同的版本，配置有差异。总之，只要不好用，就让 Pi 检查就行。多试几次就好了。最好是注销当前的会话重进，以及重启确认下。

Mac的键盘与常用的Windows/Linux键盘不一样，我习惯了Mac，因此，我也让Pi帮助映射一些快捷键，比如我习惯用 Cmd + 空格切换中英文输入法，而不是 Ctrl + 空格。

Linux 上的 Cmd + C、Cmd + V不好配，有时只能用 Ctrl + C、Ctrl + V，但是，在终端里都不好用，很多时候需要再多加一个 Shift 键，很不习惯。

对于笔记本而言，需要接 HDMI 双屏，有时候也需要适配一下。反正有问题就让 Pi 搞就行，一般都能搞定。

由于是新装的电脑，所以，本着搞坏了也不要紧的原则，大胆让 AI 去做。现在看起来，一切还都是比较顺利的。

Linux 上也有原生的微信了，试了下，还不错，除了基本的聊天，音视频通话也能正常。

腾讯会议也有 Linux 版。现在唯一的问题是企业微信没有原生 Linux 版的。

我试了几种不同的方案，WinApps、Winboat，都需要运行一个完整的Windows Docker，很重。所以，最后还是装了 Wine 版的，将就着用。

虽然 Debian 上也有 LibreOffice，但我还是装了 WPS。Linux 版的 WPS 没有广告，好像很清爽。当然，我只是试了一下，我基本也不用。

装 Chrome，默认安装的是 Chromium，社区版。Chromium 仅支持 DuckDuckGo 做默认搜索引擎，因此，有时候还是需要原装的 Chrome。

当然，说起来容易做起来难，实际上，我还是断断续续地折腾了好几天的。而且，很多时候，都需要有个代理才行（比如从Github下载文件，装Chrome或Chrome扩展等）。我一般使用 socks5 代理，这时候只需要告诉 Pi（或 Zed），必要的时候使用代理即可。当在，有些工具（如 Nodejs）并不支持 socks5 代理，它甚至会自动安装并配置 Privoxy。

现在，我有很多工作都可以在 Linux 上完成了。

上面这些都是凭记忆写的，我也没有截图。记个流水账以免以后再装的时候忘记。

本文永久链接：<https://www.dujinfang.com/2026/07/01/linux-on-mac.html> 。
