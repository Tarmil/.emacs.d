#!/bin/sh

link() {
    ln -s "$PWD/$1" "$HOME/$2" 2> /dev/null && echo "Linked: $1" || echo "Exists: $1"
}

for x in .spacemacs .xmobarrc .xmonad .Xdefaults
do
    link "$x"
done

if ! [ -d "$HOME/.emacs" ]; then
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi

link polybar/ .config/
