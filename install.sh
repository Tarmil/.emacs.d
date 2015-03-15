#! /bin/sh

for x in .emacs.d .xmobarrc .xmonad .Xdefaults
do
    ln -s "$(pwd)/$x" ~ 2> /dev/null && echo "Linked: $x" || echo "Exists: $x"
done
