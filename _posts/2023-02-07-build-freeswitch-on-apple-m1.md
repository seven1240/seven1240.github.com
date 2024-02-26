---
layout: post
title: "Build FreeSWITCH on Apple M1"
tags:
  - "FreeSWITCH"
---

Apple m1 is ARM64 architecture, FreeSWITCH already supporing it. However, Homebrew moved the default install path from /usr/local to /opt/homebrew on m1, breaks a log of build process.

FreeSWITCH depends on the homebrew version of SQLite, so we need to install it first.

```sh
brew install sqlite3
```

then build and install Sofia-SIP、libks and SpanDSP following on the standard build guide.

```
git clone https://github.com/freeswitch/sofia-sip
./bootstrap.sh
./configure
make && make install
```

```
git clone https://github.com/signalwire/libks
cmake .
make && make install
```

SpanDSP doesn't support PKG_CONFIG_PATH, so you have to find out the real include and libpath for libtiff and libjpeg, and pass them to configure. Note the version number might change, so you should find out yourself on your box if you build it sometimes later.

```
git clone https://github.com/freeswitch/spandsp
./bootstrap.sh
CFLAGS="-I/opt/homebrew/Cellar/libtiff/4.6.0/include -I/opt/homebrew/Cellar/jpeg/9e/include" LDFLAGS="-L/opt/homebrew/Cellar/libtiff/4.6.0/lib -L/opt/homebrew/Cellar/jpeg/9e/lib" ./configure
make && make install
```

then build FreeSWITCH.

```sh
git clone https://github.com/signalwire/freeswitch
./bootstrap.sh
./configure
make && make install
```

If you have problem, look:

- <https://github.com/freeswitch/spandsp/pull/46>
- <https://github.com/signalwire/freeswitch/pull/1956>

Have fun!
