---
layout: post
title: "使用Nginx+rails进行文件下载控制和缓存镜象"
tags:
  - "技术"
  - "nginx"
  - "cache"
  - "web"
---


sendfile不仅能有效提供发送文件的效率，而且也是保护受限访问文件的一种有效方法。另外，Nginx也可以实现缓存和镜象。

假设我们在A国有服务器 a.com， 前端使用Nginx，而后端使用rails。所有发给Nginx的请求都会到Rails，由Rails决定某用户是否有访问某文件的权限，如果有，则返回一个X-Accel-Redirect HTTP头，让Nginx把文件发给用户。

<code>
        location /rails {
		proxy_pass http://rails_app;
	}
        location /file-internal {
                internal;
                alias                /home/some_dir/file-internal;
        }
</code>

其中 internal指明Nginx只能内部使用，用户不可能通过 http://a.com/file-internal/xx.jpg 等直接访问文件。而且，alias所指的路径必须是nginx能访问的路径：本地磁盘，NFS，NAS，NBD等。

后端的代码可以这样写：

<code>
php:
header("X-Accel-Redirect: /file-internal/filename.jpg");
                                                     
Ruby/Rails:
head(:x_accel_redirect => "/file-internal/filename.jpg",
      :content_disposition => "attachment; filename=\"real_filename.jpg\"")  
</code>

随着业务扩大，我们的业务发展到了B国，同时我们在B国建立了服务器以加速访问，原A国用户仍访问a.com。用户访问b.com时，将所有请求都转发到a.com上，配置如下。

<code>
        location /rails {
		proxy_pass http://a.com; # nginx on a.com
	}
</code>

如果用户下要下载文件，为了加速访问，我们需要将文件缓存到b.com上。如果是不受保护的文件，我们只需要简单用的squid之类的反向代理就够了，但要实现下载控制，我们仍需将用户请求转发到a.com服务器上进行验证，但可以通过sendfile使用本地镜象。b.com的配置变为：

<code>
        location /rails {
		proxy_pass http://rails_app_on_a.com;
	}
        location /file-internal {
                internal;
                alias                /home/some_dir/file-internal;
        }
</code>

这样，就需要用rsync之类的工具来同步文件，使b.com和a.com上的静态文件保持一致。不过，Nginx也支持动态镜象。思路是，如果b.com上找不到静态文件，则再向a.com发起一次请求，于是b.com上的配置改为：

<code>
        location /rails {
		proxy_pass http://rails_app_on_a.com;
	}
        location /file-internal {
                internal;
                alias                /home/some_dir/file-internal;

                proxy_store          on;
                proxy_store_access   user:rw  group:rw  all:r;
                proxy_temp_path      /tmp/nginx_temp;

                if (!-f $request_filename) {
                        proxy_pass http://a.com;
                }
        }
</code>
 
注意，上述配置中，/file-internal下如果找不到文件时，则向a.com上的nginx再发起一次请求（注意，这时不能是rails_app_on_a.com了，否则就死循环了），取得对应的文件，并保存到本地。这样，如果再有下一次请求，b.com就不用再去a.com上找了。这种机制在Nginx中不叫cache而称为镜象。当然你需要再写个脚本定期清理一下本地的镜象，否则磁盘空间100%了可就不好了。

随着业务的持续增长，a.com上的文件持续增多，但有些文件很少被访问到。所以我们决定把旧的文件都放到S3上。如果用户在a.com上也找不到文件，则a.com必须能到S3上把文件取回来，并在本地放一段时间。

S3也直接支持HTTP访问，原则上来说我们可以使用与上述同样的技术来做。但我们也想保护S3上的文件不被别人访问到，就没有简单的办法了。所以我们自己写了一个代理，它就像b.com上Nginx的镜像功能一样，不同的是它的后端不是a.com，而是S3。具体方法见下一篇：
[使用Idp-proxy代理并缓存S3文件](/past/2009/11/9/shi-yong-idp_proxydai-li-bing-huan-cun-s3wen-jian/).
