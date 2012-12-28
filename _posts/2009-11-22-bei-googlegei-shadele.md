---
layout: default
title: "被Google给Shade了"
---

# {{ page.title }}

今天在更新网站时突然出现全站变成灰色，所有链接都不能访问。起初还以为惹着了GFW呢，今天访问heroku时就很慢，且时断时续。下午还莫名其妙的收到北京市公安局的短信，虚惊一场。，原文如下：

> 北京市公安局提醒您：凡是接到陌生人要求转账、汇款的短信或电话，请您做到不听、不信、不转账、不汇款，并立即拨打110报警，以防受骗。

这不算扰民吗？我Skype上几乎天天有骗钱的，以前也报过警，也没什么回应。现在公安干警技术这么强，再说骗子都公布了400电话和网站，擒他们还不是小菜一碟吗？怎么骗子就不见少？再说了，不听、不信、不被骗能立案吗？

好了，言归正传，公安还是为老百姓好。再说了，这次也不是GFW的原因，因为上述问题只出现在Firefox上，用Safari就没事了。FireBug了下，在Google Analytics下多了一行代码，靠，给整个Shade了。手工把height改成0就没事了，可是总不能不刷新呀。Google了一下ga_shade，发现遇到这一问题的不止我一个人，后来清除了浏览器Session了事。

听别人说也是只影响FF，Hmm.......

<code>
<div style=”position: absolute; left: 0px; top: 0px; width: 100%; 
height: 1000px; background-color: rgb(238, 238, 238); 
opacity: 0.5; z-index: 100000; display: block;” id=”ga_shade”></div>
</code>
