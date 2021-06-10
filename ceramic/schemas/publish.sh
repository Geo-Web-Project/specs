#!/bin/sh

for i in *.json; do
    SCHEMA=$(cat $i)
    echo "Publishing $i"
    ceramic schema create "$SCHEMA"
done