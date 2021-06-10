#!/bin/sh

for i in *.json; do
    idx definition:create me --name="$(cat $i | jq -r '.name')" --description="$(cat $i | jq -r '.description')" --schema="$(cat $i | jq -r '.schema')"
done