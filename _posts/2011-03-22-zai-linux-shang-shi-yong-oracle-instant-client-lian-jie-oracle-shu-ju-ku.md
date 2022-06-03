---
layout: post
title: "在 Linux 上使用 oracle instant client 连接 oracle 数据库"
tags:
  - "linux"
  - "oracle"
---

多年没用过 oracle 了，今天一个朋友让我帮它解决 oracle 连接问题，就帮忙研究了一下，也算复习一下吧。要说 oracle 这个东西真复杂， 网上的文档也五花八门，试了好多种组合，才最后搞定。

我最初用 oracle 的时候是 oracle 8，是安装在一台 TRU 64 UNIX上，Compaq 的小型机。后来，还用过 oracle 9 之类的。9i 和 10g 基本没怎么用。现在的版本都到11g了，发现有了好多变化。

两台 oracle 服务器，一台运行 oracle 11g express edition, 另一台则是 windows。

需要的东西基本上都可以在 <http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html> 下载。因为服务器是64位的，当然就下64位的程序。服务器是 CentOS 5.5。

## instant client

有了 instant client，确实比以前方便多了，不用设一大堆的环境变量。

为了方便测试，顺便装了 sqlplus，另外，也装了 odbc

    rpm -ivh oracle-instantclient11.2-basic-11.2.0.2.0.x86_64.rpm
    rpm -ivh oracle-instantclient11.2-sqlplus-11.2.0.2.0.x86_64.rpm
    rpm -ivh oracle-instantclient11.2-odbc-11.2.0.2.0.x86_64.rpm

因为对这些东西不熟悉，所以看看它都装了些什么是很有帮助的：

	$ rpm -qpl oracle-instantclient11.2-basic-11.2.0.2.0.x86_64.rpm 
	/usr/lib/oracle/11.2/client64/bin/adrci
	/usr/lib/oracle/11.2/client64/bin/genezi
	/usr/lib/oracle/11.2/client64/lib/libclntsh.so.11.1
	/usr/lib/oracle/11.2/client64/lib/libnnz11.so
	/usr/lib/oracle/11.2/client64/lib/libocci.so.11.1
	/usr/lib/oracle/11.2/client64/lib/libociei.so
	/usr/lib/oracle/11.2/client64/lib/libocijdbc11.so
	/usr/lib/oracle/11.2/client64/lib/ojdbc5.jar
	/usr/lib/oracle/11.2/client64/lib/ojdbc6.jar
	/usr/lib/oracle/11.2/client64/lib/xstreams.jar
	$ rpm -qpl oracle-instantclient11.2-sqlplus-11.2.0.2.0.x86_64.rpm 
	/usr/bin/sqlplus64
	/usr/lib/oracle/11.2/client64/bin/sqlplus
	/usr/lib/oracle/11.2/client64/lib/glogin.sql
	/usr/lib/oracle/11.2/client64/lib/libsqlplus.so
	/usr/lib/oracle/11.2/client64/lib/libsqlplusic.so
	$ rpm -qpl oracle-instantclient11.2-odbc-11.2.0.2.0.x86_64.rpm 
	/usr/lib/oracle/11.2/client64/lib/libsqora.so.11.1
	/usr/share/oracle/11.2/client64/ODBCRelnotesJA.htm
	/usr/share/oracle/11.2/client64/ODBCRelnotesUS.htm
	/usr/share/oracle/11.2/client64/ODBC_IC_Readme_Unix.html
	/usr/share/oracle/11.2/client64/odbc_update_ini.sh

把 .bashrc 里加了以下环境变量

    LD_LIBRARY_PATH=/usr/local/lib:/usr/lib/oracle/11.2/client64/lib

连接本机上的 express edition 成功

    sqlplus user/pass@127.0.0.1/XE

但用以下命令连接远程机器上的服务怎么也不成功
    sqlplus64 user/pass@192.168.1.99:1521/orcl

    SQL*Plus: Release 11.2.0.2.0 Production on Tue Mar 22 19:57:35 2011

    Copyright (c) 1982, 2010, Oracle.  All rights reserved.

    ERROR:
    ORA-12514: TNS:listener does not currently know of service requested in connect
descriptor

后来只好用 tns 了。在 /usr/lib/oracle/11.2 下创建 tnsnames.ora

    mkdir -p /usr/lib/oracle/11.2/network/admin/tnsnames.ora

编译 tnsnames.ora 如下：

    orcl =
        (DESCRIPTION =
                (ADDRESS_LIST =
                        (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.99)(PORT = 1521))
                )
                (CONNECT_DATA =
                        (SERVER=DEDICATED)
                        (SID = orcl)
                )
        )

在 .bashrc 中添加如下环境变量

    export ORACLE_HOME=/usr/lib/oracle/11.2
    export TNS_ADMIN=/usr/lib/oracle/11.2/network/admin

重新登录 shell（我试过直接 source .bashrc ，但总不对劲，后来重新登录 shell 好了，原因不明，没有求证）。


以下命令连接

    sqlplus64 user/pass@orcl


## ODBC

用 yum 安装的 ODBC 版本比较低，忘了有个什么错误了。反正我直接删掉了，下载最新的代码编译安装。

	wget ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.0.tar.gz
	tar xvzf unixODBC-2.3.0.tar.gz
	cd unixODBC-2.3.0
	./configure && make && make install


unixodbc.org 上只说明有个 easysoft 的 oracle odbc 驱动，咨询了一下，一台机器需要几千英磅。后来发现 oracle 自己有 ODBC 驱动了（好像是从 10g 开始就有的，我不知道，因此走了弯路）。

执行以下命令会生成 /usr/local/etc/odbcinst.ini 以及在当前用户目录下生成 .odbc.ini

    sh /usr/share/oracle/11.2/client64/odbc_update_ini.sh /usr/local

但是它生成的 odbcinst.ini 中 Driver 的路径是错的，需要改成

    [Oracle 11g ODBC driver]
    Description     = Oracle ODBC driver for Oracle 11g
    Driver          = /usr/lib/oracle/11.2/client64/lib/libsqora.so.11.1


.odbc.ini 基本不用改，我只把 ServerName 改成 127.0.0.1/XE

	[OracleODBC-11g]
	Application Attributes = T
	Attributes = W
	BatchAutocommitMode = IfAllSuccessful
	BindAsFLOAT = F
	CloseCursor = F
	DisableDPM = F
	DisableMTS = T
	Driver = Oracle 11g ODBC driver
	DSN = OracleODBC-11g
	EXECSchemaOpt =
	EXECSyntax = T
	Failover = T
	FailoverDelay = 10
	FailoverRetryCount = 10
	FetchBufferSize = 64000
	ForceWCHAR = F
	Lobs = T
	Longs = T
	MaxLargeData = 0
	MetadataIdDefault = F
	QueryTimeout = T
	ResultSets = T
	ServerName = 127.0.0.1/XE
	SQLGetData extensions = F
	Translation DLL =
	Translation Option = 0
	DisableRULEHint = T
	UserID = 
	StatementCache=F
	CacheBufferSize=20
	UseOCIDescribeAny=F

使用 isql -v OracleODBC-11g user pass 连接成功

将 ServerName 改成 orcl  ，连接远程服务器成功。


## 更新：Erlang ODBC

一直想试一下 Erlang ODBC，正好借朋友的机器试一下。安装 erlang，然后测试（使用express 自带的 hr 数据库），出错。

        $ erl
    	1> odbc:start().
	ok
	2> {ok, C} = odbc:connect("DSN=OracleODBC-11g;UID=hr;PWD=hr", []).

	=ERROR REPORT==== 22-Mar-2011::20:15:11 ===
	ODBC: received unexpected info: {tcp_closed,#Port<0.702>}


	=ERROR REPORT==== 22-Mar-2011::20:15:11 ===
	** Generic server <0.39.0> terminating 
	** Last message in was {#Port<0.700>,{exit_status,23}}
	** When Server state == {state,#Port<0.700>,
	                               {<0.32.0>,#Ref<0.0.0.39>},
	                               <0.32.0>,undefined,on,undefined,undefined,on,
	                               connecting,undefined,0,
	                               [#Port<0.698>,#Port<0.699>],
	                               #Port<0.701>,#Port<0.702>}
	** Reason for termination == 
	** {port_exit,collecting_of_driver_information_faild}
	** exception error: no match of right hand side value {error,connection_closed}

查了半天，有人说要禁掉 scrollable_cursors:

	3> {ok, C} = odbc:connect("DSN=OracleODBC-11g;UID=hr;PWD=hr", [{scrollable_cursors, off}]).
	{ok,<0.44.0>}
	4> 
	4> odbc:sql_query(C, "select * from tab").
	{selected,["TNAME","TABTYPE","CLUSTERID"],
	          [{"REGIONS","TABLE",null},
	           {"COUNTRIES","TABLE",null},
	           {"LOCATIONS","TABLE",null},
	           {"DEPARTMENTS","TABLE",null},
	           {"JOBS","TABLE",null},
	           {"EMPLOYEES","TABLE",null},
	           {"JOB_HISTORY","TABLE",null},
	           {"EMP_DETAILS_VIEW","VIEW",null}]}

但对于更新(或 insert，我觉得可能是对于所有不返回结果的语句)，以及查些不支持的（或会出错的）查询，会crash

	5> odbc:sql_query(C, "desc job_history"). 

	=ERROR REPORT==== 22-Mar-2011::20:20:13 ===
	ODBC: received unexpected info: {tcp_closed,#Port<0.713>}


	=ERROR REPORT==== 22-Mar-2011::20:20:13 ===
	** Generic server <0.44.0> terminating 
	** Last message in was {#Port<0.711>,{exit_status,19}}
	** When Server state == {state,#Port<0.711>,
	                               {<0.40.0>,#Ref<0.0.0.62>},
	                               <0.40.0>,undefined,on,false,false,off,
	                               connected,undefined,0,
	                               [#Port<0.709>,#Port<0.710>],
	                               #Port<0.712>,#Port<0.713>}
	** Reason for termination == 
	** {port_exit,could_not_access_column_count}
	{error,connection_closed}

从网上找到几个相关的贴子，如<http://erlang.2086793.n4.nabble.com/PATCH-ODBC-application-discarding-sqlstate-in-get-diagnos-function-td2119719.html>，但这个 patch 应该在 R13B 就打入了，而我是用的 R14B，查看源代码也没有问题。没有深究。但回头在我机器(MAC/R13B02)与 mysql ODBC 连接却没发现问题。究竟也不知道是 Erlang 版本问题还是 oracle/mysql 问题。总之，到此为止了，这种商业的数据库可查找的资料比较少，用起来费劲。
