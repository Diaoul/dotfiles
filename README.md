<img src="https://dotfiles.github.io/images/dotfiles-logo.png" alt="dotfiles logo" width="400" />

_... my personal and constantly evolving collection_

![pre-commit](https://github.com/Diaoul/dotfiles/workflows/pre-commit/badge.svg)

## :package: Installation
With the [git bare](https://www.atlassian.com/git/tutorials/dotfiles) method
and [git sparse-checkout](https://git-scm.com/docs/git-sparse-checkout) to
ignore certain files.

```fish
git clone --bare https://github.com/Diaoul/dotfiles.git ~/.dotfiles
alias dotfiles "git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
dotfiles config --local status.showUntrackedFiles no
dotfiles sparse-checkout init
dotfiles sparse-checkout set "/*"
dotfiles sparse-checkout add "!/.github/"
dotfiles checkout
```

_I use Arch, btw._

## :art: What's in the box? Gruvbox!
I love [gruvbox](https://github.com/gruvbox-community/gruvbox) but I
will probably make a [Nord](https://www.nordtheme.com/) variant at some
point to feed my brain with more blue light!

### Fonts
* [Hack](https://sourcefoundry.org/hack/)
* [Cascadia Code](https://github.com/microsoft/cascadia-code)
* [Fira Code](https://github.com/tonsky/FiraCode) with stylistic sets
  zero ss01

There are other nice looking fonts [out](https://terminal.sexy/)
[there](https://www.programmingfonts.org/).

### GTK Theme
I use [Oomox](https://github.com/themix-project/oomox) to create my own
theme and icons variants.
To use it, just generate the theme using the Oomox GUI.

The mouse cursor is from `xcursor-breeze` from the AUR.

To preview and apply all those, I run `lxappearance`.

### Firefox
I published my own theme made with [Firefox Color](https://color.firefox.com/)
which is available [here](https://addons.mozilla.org/addon/yagdmit/).

## :hammer_and_wrench: Utilities
Amazing tools I use all the time!

* [exa](https://the.exa.website/) as a replacement for `ls`
* [bat](https://github.com/sharkdp/bat) instead of `cat` (with wings)
* [dog](https://dns.lookup.dog/) for coloured (and usable) `dig`
* [delta](https://github.com/dandavison/delta): `diff` with style
* [fd](https://github.com/sharkdp/fd) as a `find` alternative
* [ripgrep](https://github.com/BurntSushi/ripgrep) to kill old `grep`
* [fzf](https://github.com/junegunn/fzf) the fuzzy finder
* [starship](https://starship.rs/) ok this is not a tool but a cool prompt!
* [direnv](https://direnv.net/) for per-project environment

### Terminal emulators
Switching back and forth between [Kitty](https://sw.kovidgoyal.net/kitty/) and
[Alacritty](https://github.com/alacritty/alacritty) so I have configuration
for both!

## :gear: System configuration
### Font
From the [arch wiki](https://wiki.archlinux.org/index.php/Font_configuration).

```fish
ln -s /usr/share/fontconfig/conf.avail/09-autohint-if-no-hinting.conf /etc/fonts/conf.d/
ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
ln -s /usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/
# if you don't plan to use bitmap fonts
ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.com /etc/fonts/conf.d/
```

## :handshake: Thanks
I took inspiration from all over the internet. Feel free to poke around!

Logo courtesy of [jglovier](https://github.com/jglovier/dotfiles-logo)
