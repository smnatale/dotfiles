#!/usr/bin/env bash
languages=`echo "golang lua" | tr ' ' '\n'`
selected=`printf "$languages" | fzf`

if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

query=`echo $query | tr ' ' '+'`
case "$selected" in
    golang) ft="go" ;;
    *)      ft="$selected" ;;
esac

curl -s "cht.sh/$selected/$query?T" | nvim -R -c "setfiletype $ft" -
