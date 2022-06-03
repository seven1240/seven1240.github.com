---
layout: post
title: "Sinatra 中 ERB 模板的 HTML 转义"
tags:
  - "sinatra"
  - "erb"
  - "rails"
---


在Rails的ERB模板中, 经常会用到HTML转义, 最近使用Sinatra, 发现用不了, 最后搜到了这篇文章:

[Sinatra ERB Escaping](http://adam.blog.heroku.com/past/2009/8/4/sinatra_erb_escaping/)

Rails:
```
<%=h article.author %>
```

Sinatra:

```
helpers do
  alias_method :h, :escape_html
end

```
