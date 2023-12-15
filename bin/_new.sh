#!/bin/bash

cd `dirname $0`

F=../_posts/`date +%Y-%m-%d-`$1.md

cp _template $F

echo >> $F
echo "本文永久链接：<https://www.dujinfang.com/`date +%Y/%m/%d/`$1.html> 。" >> $F
echo >> $F

echo $F done!
