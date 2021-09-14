#!/bin/bash 

url="https://bibdata.princeton.edu/bibliographic"
for i in $(cat bibs_manifest); do
    content="$(curl -s "$url/$i")"
    echo "$content" >> "$i.xml"
done
