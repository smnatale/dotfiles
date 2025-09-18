#!/usr/bin/env bash
languages=`echo "golang lua" | tr ' ' '\n'`
selected=`printf "$languages" | fzf`

if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

query=`echo $query | tr ' ' '+'`
curl -s cht.sh/$selected/$query?T | nvim -R -
