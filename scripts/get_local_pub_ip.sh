#!/usr/bin/env bash

# if [[ $(which dig 2&> /dev/null) ]]; then
if [[ $(dig +time=1 +tries=1 +short ns1.google.com 2&> /dev/null) ]]; then
    pubIP=$(dig TXT +time=3 +tries=1 +short o-o.myaddr.l.google.com @ns1.google.com | sed 's/"//g')
    suffix="32"
elif [[ $(curl -V 2> /dev/null) ]]; then
  pubIP=$(curl -s --connect-timeout 2 https://wtfismyip.com/text)
  suffix="32"
else
  pubIP="0.0.0.0"
  suffix="0"
fi

echo "{ \"ip\": \"$pubIP/$suffix\" }"
