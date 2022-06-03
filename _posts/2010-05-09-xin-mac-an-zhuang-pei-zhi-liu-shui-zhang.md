---
layout: post
title: "新 Mac 安装配置流水账"
tags:
  - "Mac"
---

今天周末，去看 MBP，对比了一下，13吋的确实有些小，小有小的好处，但那就不如买个 iPad了。因此冲动了一下，弄了个15吋，最低配。带Snow 10.6.3。很重的不过。

开机后，先用 BootCamp 安装了D版的 Win7。然后插入随机带的光盘，装好驱动。测试无线网连接正常后重启进入 Mac。装 Windows 只是为了网银。

虽然 Mac 在安装过程中提示可以同步其它 Mac 机上的数据，但以前用的 Leopard 上的一些软件都比较旧，另外我也想保持干净，所以还是一切都重新来。事实证明，换一台新机器的代价还是挺大的，需要重装所有的东西。

进入 Mac 后，先设置 Airport 连接无线网。然后下载安装 Chrome，FireFox。在 FireFox中搜索安装 Firebug 及 FoxProxy 插件。设置 ssh tunnel ，备翻墙用。

Multitouch 确实爽，但还是不大习惯。设置了一下 Trackpad，允许 Tap to Click 和 Dragging。 用起来习惯一点。两个手指一起点，就相当于右键。

做开发必须有 Xcode。原机器上的版本比较旧，只好下载新的了。由于下载需要比较长的时间（2.31G），所以先打开下载以节约时间。目前最新的版本是 3.2.2。颇费了一些周折。进入 所谓的 [Mac Dev Center](http://developer.apple.com/mac/)，每次点击 Download Xcode 3.2.2 and iPhone SDK 3.2 for Snow Leopard 都提示要想下载首先注册 Apple ID，以前注册过，但是忘记了。重新注册了一个，登录都正常，还显示 Hi, Seven Du。但每次点那个链接还是提示登录。我就登录了 7 遍。在放弃之前我试了一下 [iPhone Dev Center](http://developer.apple.com/iphone/index.action)，好不容易从那里找到了下载链接。这是今天最郁闷的地方。

安装 VirtualBox。DropBox。Adium，Skype，这些都很简单，用 chrome 一搜网址，下载，安装就搞定。

安装 iworks 和 MS Office. 这些东西 99% 的情况下都不用。但还得装上浪费空间。

安装 iTerm，Mac 自带的 term 不好用。

安装 Google Quick Search Box，代替以前的 QuickSilver，超好用。将快捷键设为 ctrl + Space。

安装 Fun Input Toy，我用五笔，装好后在系统设置 language & text 中选择输入法，拼音和五笔。

安装 TextMate，我用的是 1.7.5 。完毕后第一次使用时会提示创建符号链接 /usr/bin/mate，这样以后就可以在项目目录中使用“mate .”打开整个工程了。Textmate 1.x 对中文支持不好。只能安装个中文字体凑合，下载 <http://wuhongsheng.com/tmp/TextMate.ttf.tar.bz2>。解压后得到一个字体文件，双击即可安装。然后，打开 Textmate，选 Preference，将字体设为则安装的 Textmate 字体就可以了。

从以下地址下载 Mac 版的 git:
http://code.google.com/p/git-osx-installer/ 最新的版本是： git-1.7.1-intel-leopard.dmg。

下载完成后双击打开该磁盘映象文件，然后双击执行其中的 git-1.7.1-intel-leopard.pkg，其默认的安装位置是 /usr/local/git .
做符号链接将 git 命令放到搜索路径中：

    mkdir /usr/local/bin
    sudo ln -sf /usr/local/git/bin/git /usr/local/bin/

在主目录下编辑或创建 .bash_profile

	# some more ls aliases
	alias ll='ls -l'
	alias la='ls -A'
	alias l='ls -CF'

	# enable programmable completion features (you don't need to enable
	# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
	# sources /etc/bash.bashrc).
	if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
	fi

	export PATH=/opt/local/bin:$PATH:/var/lib/gems/1.8/bin:/usr/local/git/bin

	alias psgrep='ps aux | grep'
	alias netgrep='netstat -an | grep'
	alias c='ssh -l app '

	alias mysqlstart='sudo -u mysql mysqld_safe &'
	alias mysqlstop='mysqladmin -u root shutdown'

	alias poststart='postgres -D /usr/local/var/postgres'

	export PATH=/opt/local/bin:/opt/local/sbin:$PATH

	alias ls='ls -F -G'
	alias cdgems='cd /opt/local/lib/ruby/gems/1.8/gems/'

	export EDITOR=vi

使用“点”命令使之起作用（或重启iTerm使之起作用，在iTerm中开新窗口是不会起作用的，因此一定要完全退出iTerm）：
	. .bash_profile

安装 [zoiper](http://www.zoiper.com/) 和 [X-Lite](http://www.counterpath.com/)。

Xcode 下载完了，安装 Xcode，所有需要编译的东西都需要先用到它。

以前都用 mac ports，现在据说 brew 比较好用。安装 brew，先变成 root 用户 <http://www.dujinfang.com/past/2009/12/21/homebrewmacosx-xia-xin-de-ruan-jian-bao-guan-li-gong-ju/>

    sudo su
    curl -L http://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local

如果以后希望 sudo 可以不输入密码，则以 root 执行 visudo 加入一行(我的用户名是 seven)

    seven   ALL=(ALL) NOPASSWD: ALL

安装完成后再变会普通用户 exit 或 ctrl + D

安装 mysql

    sudo brew install mysql

初始化数据库

    sudo -u mysql mysql_install_db

启动数据库

    sudo -u mysql mysql_safe &

连接数据库

    mysql

以后可以使用 mysqlstart 和 mysqlstop 启动的关闭数据库（因为我刚才已经在 .bash_profile 里写好了）

安装 postgresql，它只能以普通用户权限启动，在 Linux 上通常都是建一个 postgres 用户，但是在 Mac 上建一个用户没 Linux 上简单，索性就用我的 seven（因为我只是开发用，也就无所谓安全了。我发现系统自带了一个 \_mysql 用户，因此上面安装 mysql 时用 mysql 就没问题。你也可以让 postgres 以 mysql 运行 ）

    sudo brew install postgresql
    sudo mkdir /usr/local/var/postgres
    sudo chown seven /usr/local/var/postgres
    initdb /usr/local/var/postgres

完成后会提示启动方式

    postgres -D /usr/local/var/postgres
或
    pg_ctl -D /usr/local/var/postgres -l logfile start

我已经将第一条命令起了个别名叫 poststart 写到 .bash_profile 里了。

Mac 自带了Ruby 1.8.7，安装 ruby gems

	sudo gem install unicorn
	sudo gem install mongrel
	sudo gem install shotgun
	sudo gem install rails
	sudo gem install sinatra
	sudo gem install mysql
	sudo gem install monk
	....

后来发现 mysql gem 有问题，启动 rails 时出现 Error: uninitialized constant MysqlCompat::MysqlRes 错误，查了一下 <http://www.ruby-forum.com/topic/192550>，重新安装
    sudo gem uninstall mysql
    export ARCHFLAGS="-arch x86_64"; sudo gem install --no-rdoc --no-ri mysql -- --with-mysql-dir=/usr/local/Cellar/mysql/5.1.46/lib/mysql/ --with-mysql-config=/usr/local/Cellar/mysql/5.1.46/bin/mysql_config


安装过程中，顺便从我旧的机器上同步数据。不过，由于数据比较多，我还需要多一些时间来整理。

以上过程用了整整一下午，主要是由于 Xcode 下载太慢。中间没事干就看看邮件，打打俄罗斯方块。

就在大部分安装都已就绪时，忽然发现屏幕闪的厉害。某些区域看起来比 16 色还少。而且情况越来越严重。这种情况在最初则开机时也出现过，就是第一次开机播放苹果那段视频的时候。当时也没太在意，因为在后段就好了。在网上查了查，听说该机器能在集成显卡和独立显卡间自动切换，而切换并不完美。后来禁止了自动切换，问题依旧。重启，问题依旧。

肯定是硬件问题，没想到我的第一台Mac竟然这样。致电经销商，拿过去，还好，给换了一台。只是我一下午的安装看来都白费了！ 不过，想起 Mac 在首次开机时可以同步其它机器上的数据。因此就用火线连了两台机器，果然可以同步。由于数据量太大，为了节约时间，只同步了部分数据。大部分同步的数据都正常工作，系统的设置也保留。只是用户的某些个性化设置需要重设。另外，Win7还得重新装。

就这样，折腾了一天。回家插上移动G3无线网卡。发表这篇文章。


更新：2010-07-21

安装 PHP postgresql extension: Mac默认安装的是 PHP Version 5.3.1，只有mysql扩展，没有postgres。网上有人说需要重新编辑PHP，其实不需要，只安装postgres extension即可。

<code>
# 下载源代码，注意我下的是5.3.2，安装没问题，如果有问题，你可以装 5.3.1
$ wget http://cn.php.net/distributions/php-5.3.2.tar.bz2
# 解压
$ tar -xjf php-5.3.2.tar.bz2
$ cd php-5.3.2/ext/pgsql
$ phpize
$  ./configure --with-pgsql=/usr/local/Cellar/postgresql/8.4.3/
$ make -j2
$ sudo make install
Installing shared extensions:     /usr/lib/php/extensions/no-debug-non-zts-20090626/
$ cd /etc
$ sudo cp php.ini-default php.ini
</code>

然后在php.ini中加入 extension = pgsql.o

<code>
apachectl restart
</code>

看 phpinfo()，成功。

更新 20130216:

好像有更好的工具出现了： http://boxen.github.com/
