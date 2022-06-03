---
layout: post
title: "使用Idp_proxy代理并缓存S3文件"
tags:
  - "nginx"
  - "idp_proxy"
  - "erlang"
---


[书接上文](/past/2009/11/9/shi-yong-nginxrailsjin-xing-wen-jian-xia-zai-kong-zhi-he-huan-cun-jing-xiang/). 由于我们不能用Nginx直接请求S3，所以需要通过一个中间代理。最初，我是用Ruby+Eventmachine实现的。完成后发现性能不好，当然也可能是我的代码有问题。不管怎么说，实现该功能最佳的语言还是Erlang。我也没编多少代码，只是Mochiweb框架的基础上加了些功能。当然并不是很完美，但是基本可以工作。另外，这也只是一个思路，真正用于生产系统肯定还要更多的优化。

代码放到[Git Hub上](http://github.com/seven1240/idp_proxy)上.

<code>
git clone git://github.com/seven1240/idp_proxy.git
</code>

你需要手工下载[mochiweb](http://code.google.com/p/mochiweb/)，解压缩后放到deps目录中，或放到其它位置但在deps目录中做个符号链接（就像我在原代码中做的一样）。

另外，目前它使用[s3sync](http://s3sync.net/wiki)获取S3上的文件，你需要把它放到某个路径下让Idp_proxy能找到它（见下面配置）。另外你需要先编辑s3config.yml以保证s3cmd.rb工作正常。看s3sync的README吧。

修改src/idp_proxy.hrl中的相关配置：

INTERNAL_PATH: 相对路径，将被从请求路径中去掉，并把剩下的部分与DOC_ROOT拼成本地文件的路径。

TMP_PATH: 下载时临时存放文件的目录

DOC_ROOT: 就是www root。

<code>
cd idp_proxy/deps/mochiweb
make
cd ../..
make
</code>

一切就绪后就可以启动了：

<code>
./start-dev.sh
</code>

测试

<code>
test/test.sh
</code>

根据测试结果你可以判断它是不是正常工作。接在来需要修改Nginx的配置(在a.com上):

<code>
        location /file-internal {
                internal;
                alias /home/some_dir/file-internal;

                proxy_set_header  X-Uri $uri;

                if (!-f $request_filename) {
                        proxy_pass http://127.0.0.1:8910;
                }
        }
</code>

以上配置假定Idp_proxy运行在本机8910端口上。当然，你也可以将Idp_proxy运行在别的机器上，并在Nginx上开户proxy_store功能来缓存文件。

注意，上面的配置中，我们加入了一个X-Uri的自定义HTTP头。因为，我们为了保护文件，文件路径可能会被加密，这就造成了路径不一致，如：

<code>
curl http://a.com/rails/4hjgqei-加-密-ogjgh4t409dkfjdk.mp3
</code>

请求到达rails_app后，rails会将以上路径解密，并在sendfile时返回真正的文件路径，如/file-internal/abc.mp3。Nginx得到该路径后，如果在本地找不到对应的文件，它就会向Idp_proxy发起请求，但在请求的HTTP头中，GET后的路径是不变的，所在我们才加了个自定义的Http header，用户识别，如：

<code>
GET /rails/4hjgqei-加-密-ogjgh4t409dkfjdk.mp3 HTTP/1.1
Connection: close
X-Uri: /file-internal/abc.mp3
</code>

然后Idp_proxy会根据 X-Uri所指定的文件名到S3上下载对应的文件。

如果不用X-Uri，或许可以使用rewrite，rewrite会将$uri重写后放到GET 后，但我没试过：

<code>
	rewrite (.*) $1 break;
</code>
