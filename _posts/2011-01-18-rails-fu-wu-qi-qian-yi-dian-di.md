---
layout: post
title: "Rails 服务器迁移点滴"
---

# {{ page.title }}

我们有 [数十个 rails 应用](http://en.oreilly.com/rails2010/public/schedule/detail/14302)。以及基于 FreeSWITCH 的VoIP 系统。由于考虑以后的发展做了一个艰难的决定--搬家。以前采用运计算主机托管方案，虽然不用自己维护硬件但也少了好多灵活性，而且带宽和内存很贵，而 Rails 又是吃内存的东西。

原来所有服务运行5台在双核服务器4G内存的服务器上，操作系统为 Ubuntu 7.10。Rails 版本为 2.3.4。

新服务器采用虚拟化和物理服务器结合的方式。两台 4 核 16G 内存 CentOS 运行 FreeSWITCH 以及 Skype 网关，主备用，由于系统较为复杂，暂未设置热备。

除 VoIP 平台外，其它主机及虚拟化平台全部使用 Ubuntu 10.04 LTS。

两台 6 核 32 G 内存虚拟化运行 Rails。使用 lxc 及 KVM 虚拟化方案。由于我们以前只有 Xen 的虚拟化经验，但 Xen 的前景不明，所以这次采用了 lxc ，基本上采用 lxc 与 KVM 重复配置，以防止一种方案出问题时迅速切换到另一种。

两台 4 核 16 G 内存数据库服务器主备用，采用 lxc 及  KVM 虚拟化结合运行 Mysql 及 MS SqlServer （以支持旧的 windows 应用）。 


以前所有服务都是混合配置，新的架构由于采用了虚拟化，很方便的按功能进行了划分，如专门运行 nginx 的 proxy server、访问磁盘阵列的 file server 、专门用于监控的服务器，专门运行 rails 的服务器等。每种服务器都成对配置，根据情况使用负荷分担（如 rails）或冷备用（如 file server）。

Rails2 和 Rails3 的程序都跑到不同的虚拟机上，减少了版本交叉的复杂性。由于新的 Ubuntu 10.04 与旧的 7.10 差了很多，Ruby Gems 也更新了不少，有的甚至没有人维护了。所以采取了一个简单的方案，Rails2的应用全部从旧服务器上 copy Gems。因为打算以后所有应用都升级到 Rails3，所以，没有必要再去调试所有 Gem 的依赖性了，而且时间也不允许。

Rails2 全部使用 REE(Ruby Enterprise Edition 1.8.7)；而 Rails3则使用 Ruby 1.9。

全部 Rails 均使用 Unicorn。Rails 的部署方式有很多 Mongrel Cluster、Thin、Passenger 等等，我们几乎都尝试过，但喜欢 Unicorn 就只因为喜欢一句话：[I like Unicorn because it's UNIX](http://www.google.com.hk/search?sourceid=chrome&ie=UTF-8&q=I+like+unicorn+because+it's+unix)。 

时间紧任务重，虽然做了好多准备但还是不够充分。由于服务器全部远程操作(全在美国)，也增加了好多不便和工作量。

首先装好OS，测试。装好虚拟机，测试。

将新系统及数据库全部转移到新服务器上测试。准备工作完毕。睡觉。

半夜起来开始干活。改 Nginx 配置，全部重定向到静态页面。（还好，我们允许停机迁移，这省了不少事）。我们还没做到像 Google 那样将系统做成只读的。但我们的网站主页都是CMS系统，不受影响。

停掉所有 rails。dump 数据库，load 到新机器上。

将美国服务器DNS改到新服务器上。

启动新机器上的 rails，测试。

将旧服务器上的 nginx 全部 proxy_pass 到新服务器上（防止某些地方的DNS没有刷新）。

新国内服务器 nginx proxy 到新服务器上。测试，完成。

给大家发邮件，睡觉。

但这一觉睡得不踏实，还没经过检验呢。

上午被电话叫醒了，办公室呼叫中心出了问题，某些相关业务忘了更换服务器IP了。修好。

CAS[http://www.jasig.org/cas] 登录出了问题。新的 CAS 服务器 session 数据竟超过4K。想办法修好。

最头痛的是遇到了 MySQL 问题：
 Mysql::Error: Lost connection to MySQL server during query

查了N久，试了好多网上提到的方法都没解决。包括设置 reconnect: true ，MySQL 后台也没错误日志。终于定位到问题，它只发生在第二个及后续的数据库连接上。我们的应用会连接多个数据库，第一个数据库从来没出问题。最后想起来了，是 Unicorn preload_app 问题。以前都是 false 的。但在新的环境下，由于增加了  Newrelic[newrelic.com] 监控，为了使它能工作，只好设成 true。

preload_app 配合 REE 能节省内存，而且  Newrelic 也依赖于它工作。没办法，为了稳定，只好让  Newrelic 下岗了。

不过后来又找到一种方案让 Newrelic 重新工作，将 environment.rb 中加入 

  NewRelic::Agent.after_fork(:force_reconnect => true)

<http://support.newrelic.com/discussions/support/2909-unicorn-without-preload_app-with-rails>

Rails3 中 relative_url_root 不好用了。而我们的业务完全部署在同一域名下，根据子目录路由到不同的程序。所以，unicorn_rails \-\-path 就不好用了。这一点很讨厌，至少在每次版本升级都会遇到该问题。不过，还好，总是能找到解决方案：

<http://stackoverflow.com/questions/3181746/what-is-the-replacement-for-actioncontrollerbase-relative-url-root>

UPDATE: 后来发现还有一种方案，似乎更简单：

在 config.ru 中加
 map '/subdir' do
      run xxxx:Application
 end

<http://summit360.co.uk/2010/09/rails_3_unicorn.html>

期间还发现一个很严重的问题，就是每个服务器时间都不一样，有的还差得离谱；也忘了把所有的 localtime 改成 UTC，结果有的是 MST，有的都是没见过的时区名。最后虽然加了NTP，但调整服务器时间确实影响了一部分数据。其实这一点早就想到了，但忘了加到 check list 里，忙起来，就忘了。

随便写写吧，总算还是迁移成功了。其实，比预想的结果要好。在如此短的时间内做这么大的迁移，心里还真是没底。

最初，我们的系统也是从只有一台服务器开始的。当我接手做系统管理员的时候，就已经有三个 rails 程序了。三年前，我把这三个 rails 程序从三个独立域名部署到一个下面，后来就发展成了几十个。

为了能搭建测跟服务器相同的测试环境，我们买了两台好的 PC，在办公室采用了 Xen 虚拟化方案，即每台虚拟机对应一台真实的物理服务器。使用效果很不错。

后来我们开使使用[Webistrano](https://github.com/peritor/webistrano/wiki/)管理和部署应用程序。与我们的CAS系统集成，方便了许多。

我们用过 Apache, Mongrel Cluster，也用过 Apache Passenger，Nginx Passenger。都遇到过各种各样的问题。 最后转到了 Unicorn。Unicorn 确实很优雅。

除 Rails 外，我们也有几个 Sinatra 程序，及 PHP、Erlang 等应用。它们都很好地发挥了自己的长处，优雅地协同工作着。

好长时间不写东西了，有点乱，聊作点纪念。
