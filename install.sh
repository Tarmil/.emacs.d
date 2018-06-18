#!/bin/sh

link() {
    ln -s "$PWD/$1" "$HOME/$2" 2> /dev/null && echo "Linked: $1" || echo "Exists: $1"
}

for x in .emacs.d .xmobarrc .xmonad .Xdefaults
do
    link "$x"
done

link polybar/ .config/
