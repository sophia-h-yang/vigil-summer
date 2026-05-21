#!/bin/zsh

set -x

if [ -d "$1" ]; then
	echo "It's a directory!"
	ls "$1" | wc -l
else
	echo "It's not a directory!"
fi
