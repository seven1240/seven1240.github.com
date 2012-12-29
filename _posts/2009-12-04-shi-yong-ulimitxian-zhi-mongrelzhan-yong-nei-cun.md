---
layout: default
title: "使用ulimit限制mongrel占用内存"
---

# {{ page.title }}

长期运行的mongrel会有内存泄漏，且有时由于开发人员的不慎会引起mongrel占用大量的内存，严重时会引起服务器失去响应而崩溃。当然，使用monit能在一定程序上解决问题，但monit每隔一段时间检测一次内存占用，所以，对于内存占用迅速提高的情形，monit反应就太慢了。因此考虑使用ulimit。但ulimit是针对shell进行限定的。由于我们同时运行着数十个mongrel进程，所以不可能在同一个shell中限制，因此，我修改了mongrel_rails，对每一个mongrel进程进行限制。如果内存占用超标，杀无赦。

ulimit是shell内建命令，不能直接在Ruby中调用，因此换为shell脚本，同时将原文件改名。这样，对init/monit及capistrano脚本都没有影响。只是注意以后升级mongrel时小心别覆盖了这个文件（mongrel还会升级吗？）。

<code>
cd /usr/bin
mv mongrel_rails mongrel_rails_ruby
cat > mongrel_rails << EOF
#!/bin/sh

#limit 600M?
MEM_LIMIT=600000

#ulimit -t 20
#ulimit -d $MEM_LIMIT
#ulimit -m $MEM_LIMIT
ulimit -v $MEM_LIMIT

mongrel_rails_ruby $@
EOF

</code>


Ref: <http://www.ibm.com/developerworks/cn/linux/l-cn-ulimit/index.html>
