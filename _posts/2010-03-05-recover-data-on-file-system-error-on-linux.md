---
layout: post
title: "Recover data on file system error on linux"
tags:
  - "linux"
---

One of our Linux server run into problem and mounted all file systems readonly.  And, unfortunately, We lost lots of data when we did a "fsck -y". Run a "ls" command on /var and /usr/lib lists out nearly nothing.

Worst of that, it was a database server and one of our databases didn't have any backup!! Cry cry!!

Anyway, we need to re-build the server. It's not hard since it was a Xen DomU and we just create a new one. But we still want to see how much data can be recovered.

cd into the famous lost+found, ls can list some dirs prefixed with #, then I run a find to get a list of all files: 
<code>
cd /lost+found
find .
./#975072/addons
./#975144
./#975144/dhclient.leases
./#975284
./#975348
./#975348/supported.d
./#975348/supported.d/en
./#975460
./#975474
./#975474/kmsg
./#1130956
./#1130956/dn2id.bdb
./#1130956/log.0000000003
./#1130956/log.0000000001
./#1130956/log.0000000008
./#1130956/log.0000000005
.
</code>

Even we can get some data back, we didn't recover our database. Fortunately we have db dumps for other databases... Backup is always important!
