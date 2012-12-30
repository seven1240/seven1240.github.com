---
layout: post
title: "Deploy dozens of rails applications into one domain"
---

# {{ page.title }}

We eventually have more than 30 rails applications running. Back to the days when we had only 3, we deploy each to a separate domains:

    app1.example.com
    app2.example.com
    app3.example.com

They looks beautiful. But, the 3 apps actually working together to do one big task. It would looks better to be served in one domain:

    www.example.com/app1/
    www.example.com/app2/
    www.example.com/app3/

The advantage to use one domain is that it’s more beautiful – You may don’t even notice it’s actually 3 apps! And now they finally grew to more than 30s by using the great framework and architecture – eco_apps (<http://github.com/idapted/eco_apps>).

The other advantage more than beautiful is that you will never worry about the javascript cross-domain requests, direct or AJAX.

Perhaps the easiest way to deploy multiple apps to subdirs is to use passenger:

<http://www.modrails.com/documentation/Users%20guide%20Nginx.html#deploying_rails_to_sub_uri>

<http://www.modrails.com/documentation/Users%20guide%20Apache.html#deploying_rails_to_sub_uri>

But we had bad experience with passenger. One rails app stuck on some memcache server failure. Passenger was trying to start it over and over again and blocked all processes – the whole server suddenly stopped responding to anything! Perhaps they already fixed that, but we still think it’s better to serve rails “out” of Nginx or Apache.

First we need all rails apps to run in a subdir, no matter mongrel

    mongrel_rails --prefix=/app1 ...

unicorn:

    unicorn_rails --path /app1

or swiftiplied/evented mongrel or thin.

We use Unicorn(<http://github.com/blog/517-unicorn>) for rails and Nginx as a reverse proxy:

Nginx conf:

<code>
upstream app1{
  server localhost:10010;
}

upstream app2{
  server localhost:10020;
}

upstream app3{
  server localhost:10030;
}

...

upstream app30{
  server localhost:10300;
}


server {
        listen   80;
        server_name  www.example.com;

        location / {
                root    /home/app/root;
        }

        location /app1 {
                root   /home/app/app1/current/public;
                proxy_pass http://app1;
        }

        location /app2 {
                root   /home/app/app2/current/public;
                proxy_pass http://app2;
        }
        .....
}

</code>

That’s it. Take a look at <http://github.com/idapted/eco_apps> to see how we make dozens of rails apps working together.
