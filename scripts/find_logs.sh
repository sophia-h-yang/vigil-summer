#!/bin/zsh

if grep -qi "$2" $(find "$1" -name "*.log"); then
    grep -i "$2" $(find "$1" -name "*.log");
else
    echo "no $2 found";
fi
