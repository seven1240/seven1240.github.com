---
layout: post
title: "QT 中加载 Flash"
tags:
  - "QT"
  - "Flash"
---


[为了在QT中加载Flash，这几天搞得头很大](/past/2010/9/2/mac-1064shi-shi-yong-qtyi-dian-jing-yan/)。其实说来也简单，人家Flash不支持64位，所以，你的代码也只能是32位的。

加载 Flash当然需要 webkit 了，我就在 UI 上放了一个 webView。

以下代码让 webView 支持 plugin。

```
    QWebSettings *settings = ui->webView->settings();
    settings->setAttribute(QWebSettings::PluginsEnabled, true);
```

或者直接设成全局的也行：

```
    QWebSettings *websetting= QWebSettings::globalSettings();
    websetting->setAttribute(QWebSettings::JavascriptEnabled,true);
    websetting->setAttribute(QWebSettings::PluginsEnabled,true);
```

加载 Flash 就简单了，其实就一行，可怜我在64位的环境下折腾了半天：

    ui->webView->load(QUrl("http://blah.swf"));

我要加载的 Flash 是带参数的，据说可以这样用：

    ui->webView->load(QUrl("http://blah.swf?a=b&c=d"));

优雅起见，还可以使用 FlashVars，因此写了一个JS：

```

var t = '<embed src="' + url + '" ';
t += 'quality="high" bgcolor="" wmode="opaque" ';
t += 'width="100%" height="100%" name="interaction" align="middle" ';
t += 'play="true" loop="false"  allowScriptAccess="sameDomain" type="application/x-shockwave-flash" ';
t += 'pluginspage="http://www.adobe.com/go/getflashplayer" ';
t += 'flashvars="' + vars + '"></embed>';

document.write(t);

```

在QT中就这样用(通过JS设置FlashVars)：
```

    QFile file;
    file.setFileName(":/resources/loadflash.js");
    file.open(QIODevice::ReadOnly);
    QString js = file.readAll();
    file.close();

    QString js1 = "var url='http://blah.swf'; var vars='a=b&c=d';" + js
    ui->webView->page()->mainFrame()->evaluateJavaScript(js1);
```

这种方法不是万能的。我就用同样的代码加载两个不同的Flash，一个成功一个不成功。调起来那个累啊。最后猜想可能是那个有问题的Flash中不认识这样的参数，抑或是跨域？还好，还有其它的办法：

先在 webView 中加载一个空的 Flash ，或一个只包含空的Flash的HTML，然后，也是使用JS控制加载：

```
QWebFrame *frame = ui->webView->page()->mainFrame();
QWebElement e = frame->findFirstElement("embed");
e.evaluateJavaScript("this.FlashVars='a=b&c=d';"
    "this.LoadMovie(0, 'http://blah.swf');");
```

笔记备忘。

Update:

有位大师说，一般搞了N久才解决的问题，都是小问题 ....
