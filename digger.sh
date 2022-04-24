#!/bin/bash

token="$2"

if [ "$1" = "-l" ] || [ "$1" = "-log" ] || [ "$1" = "log" ];
then
    ruby digger.rb -l
elif [ "$1" = "-t" ] || [ "$1" = "-token" ] || [ "$1" = "token" ];
then
    ruby digger.rb -t "$token"
else
    ruby digger.rb
fi