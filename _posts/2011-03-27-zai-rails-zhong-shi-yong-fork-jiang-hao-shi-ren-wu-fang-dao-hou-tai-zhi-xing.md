---
layout: post
title: "在 Rails 中使用 fork 将耗时任务放到后台执行"
---

# {{ page.title }}

最天在检查问题时发现一个同事在执行后台任务的时候有问题，那是个很简单的rails应用，为了能让客户端能快速返回而使用  workling 将费时的工作放到后台执行。但后台的任务执行是单进程的，这就导致在大量并发的情况下有些任务得不到及时执行。当然理想状态是将后台做成多进程的，但由于任务太简单，没有必要为此做太多的工作。因此我给他写了个脚本：

    #!/usr/bin/env ruby

    cmd = "some slow system commands e.g. sleep 5"

    puts cmd

    fork do
        puts "in child process"
        sleep(5)
        puts(cmd)
        system("#{cmd} >>/tmp/a.log 2>&1")
        puts "child finished"
    end

    puts "parent finished"

上述脚本只是个例子，他什么也不做，只是立即产生一个新的子进程，新的进程在后台运行，而父进程立即退出，因此执行该脚本不会造成阻塞。费时的工作 （这里是 sleep 5）在后台执行，执行完毕后将结果写入日志 /tmp/a.log。

只需要在 rails 中简单调用这个脚本就可以了，当然有些 gem 如  spawn  等也是使用  fork 来克隆一个新进程，问题是如果直接在 rails  中调用 fork 的话，会 fork 整个 rails 环境，在某些简单的情况下显然是不经济的。

其实 fork 是最基本的系统调用。也许由于太基本而经常被忽略。但从另一方面也显示出，好多高层应用的开发者(如PHP，rails等)基本功不扎实，它们往往能找到并利用那些复杂的解决方案，但想不出这种简单的技巧。
