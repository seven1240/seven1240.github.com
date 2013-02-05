#!/bin/bash

cd `dirname $0`

F=../_posts/`date +%Y-%m-%d-`$1

cp _template $F

echo $F done!


