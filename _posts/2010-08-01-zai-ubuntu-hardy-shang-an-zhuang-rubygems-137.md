---
layout: default
title: "在 Ubuntu Hardy 上安装rubygems 1.3.7"
---

# {{ page.title }}

今天，帮一个朋友解决gem问题，服务器是 Ubuntu 8.04 Hardy。所有 gem 操作都出 301 错误，gem env 显示如下：

<code>
# gem env
RubyGems Environment:
  - VERSION: 0.9.4 (0.9.4)
  - INSTALLATION DIRECTORY: /var/lib/gems/1.8
  - GEM PATH:
     - /var/lib/gems/1.8
  - REMOTE SOURCES:
     - http://gems.rubyforge.org
</code>

gem -v  显示版本号是 0.0.4，版本太老了。肯定是 gems.rubyforge.org重定向的原因，用 curl 检查，果然是重定向到 rubygems.org 了。 

<code>
curl -I gems.rubyforge.org
HTTP/1.1 301 Moved Permanently
Date: Sun, 01 Aug 2010 07:56:15 GMT
Server: Apache/2.2.3 (Red Hat) mod_ssl/2.2.3 OpenSSL/0.9.8e-fips-rhel5 Phusion_Passenger/2.2.15
X-Powered-By: Phusion Passenger (mod_rails/mod_rack) 2.2.15
X-Runtime: 0.000490
Set-Cookie: _test_session=BAh7BiIPc2Vzc2lvbl9pZCIlODdkYjBhYWU5NDg2YjA2MzM5Y2NhOWFjY2VlOGEwYjc%3D--bd78425fafbfa5e8edfb28f87805d82554e5d0b6; path=/; HttpOnly
Location: http://rubygems.org/
Status: 301
Content-Type: httpd/unix-directory
</code>
<code>
ERROR:  While executing gem ... (Gem::RemoteSourceException)
    HTTP Response 301
<code>

使用 gem sources -r  及 gem sources -c 都不好用，还是出错。最后，删掉重装：

<code>

apt-get remove rubygems
wget http://rubyforge.org/frs/download.php/70696/rubygems-1.3.7.tgz
tar xvzf rubygems-1.3.7.tag
cd rubygems-1.3.7
ruby setup.rb

</code>

最后提示安装了 /usr/bin/gem1.8，需要做个符号链接：

<code>
cd /usr/bin
ln -sf gem1.8 gem
</code>

Done.
