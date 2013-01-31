---
layout: post
title: "折腾 Google Chrome 的开发者工具及插件"
tags:
  - "chrome"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>


换了 Chrome 以后，用 Firefox 就很少了，但总是离不开。主要原因有二：

* Firebug，虽然Chrome中也有个类似的插件，但不怎么好用
* FoxProxy，貌似Chrome一直不支持SOCKS5。

今天忽然看到这个，着实兴奋了一下：<http://www.chromium.org/devtools>

遗憾的是，访问该链接需要翻山越岭。但这也不是太困难，有 Firefox+FoxProxy+SSH嘛。可是，我照着上面的介绍却怎么也无法在 right-top 上找到 Page Menu -&gt; Developer -&gt Developer Tools 。我用的是Mac版 5.0.375.70。偶然点了一下右键，菜单最下面有个 Inspect Element， 就是它了。

操作界面跟 Firebug 差不多，还没有详细对方两者的功能，但肯定不用为了一点点简单的调试换浏览器了。

有了这个，下一个心头大事当然是 Proxy 了，找到一个插件 <https://chrome.google.com/extensions/detail/caehdcpeofiiigpdhbabniblemipncjj>，看起来跟 FoxProxy 差不多。而点击链接却无法打开。使用 FireFox + 代理倒是能打开，却又无法安装，而在 Chrome 中却无法开启代理（我试过设置 Mac 的系统代理，打不开，可能是因为不支持Socks吧？）。先有鸡还是先有蛋？

搜遍了 Google，好像都说 Chrome 不支持 Socks。但皇天不负有心人，总算让我找到一个办法：

关掉 Chrome，在 Terminal 中执行：

    open -a "/Applications/Google Chrome.app" --args --proxy-server="SOCKS5://localhost:8765"

靠，还真管用。遂装了 Switchy。以及 <https://chrome.google.com/extensions/featured/web_dev> 上诸多插件。退出 Chrome，配置Switchy，倒是有个 Socks5 的选项，配上不好用。

如此说来，Chrome 是支持 SOCKS5 的，但我现在还没找到办法自由切换。因此，还是开两个浏览器方便些，墙内 Chrome 墙外 FireFox。
