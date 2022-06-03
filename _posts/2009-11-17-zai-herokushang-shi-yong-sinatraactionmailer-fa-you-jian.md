---
layout: post
title: "在heroku上使用 Sinatra+ActionMailer 发邮件"
tags:
  - "sinatra"
  - "ruby"
---



Heroku有一个sendgrid Addon，对于Rails应该是0配置的，但我使用Sinatra，所以想试试[Pony](http://github.com/adamwiggins/pony)，但无论如何都无法连接SMTP。后来，查看官方文档，除提到必须使用ActionMailer外，没有任何有用的信息：

> If you are using Sinatra/Merb/etc or have disabled ActionMailer, please make sure to enable/install it before installing this add-on(Sendgrid)。

无奈，换成ActionMailer，希望它能自动配置。但还是搞不定。Google了下，发现都是配置Gmail的。后来，无意间在push的时候看到以下信息：
```
-----> Heroku receiving push
-----> Sinatra app detected
-----> Not a Rails app, can't install the plugin quick_sendgrid
       Compiled slug size is 576K
-----> Launching...... done
```

看来只能手工配了，可是参数如何设呢？当然[Sendgrid](http://sendgrid.com/)是免费的，你完全可以自己注册一个账号。不过既然heroku已经帮你注册了账号，就应该不用重复注册。最后想起了一个好东西：

```
$ heroku console
ruby console for example.heroku.com
>> ENV
=> {"SELINUX_INIT"=>"YES", "CONSOLE"=>"/dev/console", "INLINEDIR"=>"/home/slugs/6495......, "SENDGRID_USERNAME"=>.....}
>>
```

呵呵，找到就好办了，配置ActionMailer(是的，在非Rails环境下也可以使用，google "actionmailer without rails"):

```
require 'action_mailer'
class NotificationMailer < ActionMailer::Base
  def newpost_notification(post)
    recipients   'xx@example.com'
    subject      "Welcome"
    from         "yy@example.com"
    body         :message => "Hello World"
    content_type "text/html"
  end
end

NotificationMailer.template_root = File.dirname(__FILE__) + '/../views'
NotificationMailer.smtp_settings = {
  :address => "smtp.sendgrid.net",
  :port => 25,
  :domain => ENV["SENDGRID_DOMAIN"],
  :user_name => ENV["SENDGRID_USERNAME"],
  :password => ENV["SENDGRID_PASSWORD"],
  :authentication => :login
}

```

再放个erb模板到views/对应的目录下就行了。注意:domain是必须有的。呵呵，虽然发信成功了，但ActionMailer还是挺复杂的，想简单还是再试下Pony吧，有了以上参数应该很容易配置的。

另外，我想，如果你自己去Sendgrid申请账号的话，那个addon都可以不用加。Nice Hero-Cool :)。
