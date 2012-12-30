---
layout: post
title: "在 Mac 上使用 ODBC 连接 MS SQL SERVER"
---

# {{ page.title }}

多年不用 M$ 的东东了，不过今天一个朋友问我在 Mac 上怎么连接 SQL Server，没法说服他换数据库，只得花时间帮忙研究了一下。反正是挺麻烦。

首先下载 sql server express 2008 R2，发现在我的 XP 上安装不上，大概是缺少 power shell 之类的。看到网上有人安装成功的，但也有人说官方说不支持 XP，懒得弄，重新下载了个 sql server express 2005。

安装完成后发现它不监听 1433 端口。试了好多配置选项都不行，最后发现得把 dynamic ports 禁掉才可以。

启动 sql server configuration manager，找到 sql server 2005 network configuration, Protocols for Express .... TCP/IP Enable，选择属性，切换到 Ip Adresses 页，把所有 Dynamic ports 属性改成空值，把TCP Port改成 1433。

重启 sql server 服务，并关掉防火墙（省得麻烦）。当然，建个测试数据库 test_db。

在 Mac 上安装 freetds <http://www.ibiblio.org/pub/Linux/ALPHA/freetds/stable/> 我试了几个版本 patched 或 stable 以及最新的 0.91RC2 都没问题。

  ./configure --prefix=/usr/local/freetds
  make && sudo make install

测试连接
  cd /usr/local/freetds/bin
  ./tsql -H 192.168.7.6 -p 1433 -U sa -P blah -D test_db

连接不成功，揭示
<code>
 locale is "en_US.UTF-8"
locale charset is "UTF-8"
Msg 20017, Level 9, State -1, Server OpenClient, Line -1
Unexpected EOF from the server
Msg 20002, Level 9, State -1, Server OpenClient, Line -1
Adaptive Server connection failed
There was a problem connecting to the server
</code>

在服务器端事件查看器中提示

<code>
The login packet used to open the connection is structurally invalid; the connection has been closed. Please contact the vendor of the client library. [CLIENT: 192.168.7.5]
</code>

改 /usr/local/freetds/etc/freetds.conf

<code>
[ms]
	host = 192.168.7.6
	port = 1433
	tds version = 8.0
	uid = sa
	pwd = blah
	client charset = UTF-8
</code>

然后用 -S 连接成功，看来命令行不知少什么参数

  ./tsql -S ms -U sa -P blah -D test_db

然后配置 ODBC，下载 Mac 上的 odbd administration tools （苹果网站上有），添加驱动 (driver)。然后需要添加好多参数，但都是人工添加，一点提示都没有。上网找了好久，测了好几次才成功。另外还添加了一个 User DSN。

当然，其它没那么复杂，直接找到 odbcinst.ini 和 odbc.ini 改就行。我机器上是在 ~/Library/ODBC 下找到的。最后配置如下：

odbcinst.ini:

<code>
[ODBC Drivers]
MSSQL = Installed

[ODBC Connection Pooling]
PerfMon    = 0
Retry Wait = 

[MSSQL]
Driver = /usr/local/freetds/lib/libtdsodbc.0.so
Setup  = 
SERVER = ms
</code>

其中 SERVER = ms 对应 freetds.conf 中的 ms


odbc.ini:

<code>
[ODBC]
Trace         = 1
TraceAutoStop = 0
TraceFile     = /tmp/a.log
TraceLibrary  = 

[ODBC Data Sources]
ms = MSSQL

[ms]
Driver      = /usr/local/freetds/lib/libtdsodbc.0.so
# Server      = 192.168.7.6
ServerName  = ms
Port        = 1433
TDS_Version = 8.0
Database    = test
Charset     = UTF-8
Description = mssql
</code>

上面的 ServerName = ms 对应 freetds.conf 中的 ms， Server 一行注释掉了，因为不好用。

用 iodbctest 测试

  iodbctest "UID=sa;PWD=blah;DSN=ms"
  select * from a;

连接查询成功。晕，这么点破事浪费我好几个小时(加上下载的时间)。
