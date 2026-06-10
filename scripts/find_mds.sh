#!/bin/zsh

if 
    grep -qi "$2" $(find "$1" -name "*.md"); then
    grep -i "$2" $(find "$1" -name "*.md");
else
    echo "no $2 found";
fi
