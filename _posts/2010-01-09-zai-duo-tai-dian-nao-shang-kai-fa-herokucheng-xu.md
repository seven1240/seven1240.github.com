---
layout: post
title: "在多台电脑上开发heroku程序"
tags:
  - "heroku"
  - "@tech"
---

由于需要在另外一台电脑上修改我的博客，而[heroku](http://heroku.com)的git是基于public key的，所以，如何上传public key就成了解决问题的关键。但是，heroku的文档中好像没有提到，不过，总是有办法的：

```
$ heroku help

keys                         # show your user's public keys
keys:add [<path to keyfile>] # add a public key
keys:remove <keyname>        # remove a key by name (user@host)
keys:clear                   # remove all keys

```

看到有个keys:add方法，因此我就执行了一下

```
heroku keys:add ~/.ssh/id_dsa.pub
```

输入电子邮件和密码后public key上传成功。

接下来，clone代码(需要先找到你的git_url)：

```
heroku list
heroku info --app <your_app_name>
git clone -o heroku <git_url> # sth. like git@heroku.com:<your_app_name>.git
```

Cool.

后来还从网上找到类似的一篇文章：<http://davidlowry.co.uk/using-another-computer-for-your-heroku-app/>
