<img src="https://dotfiles.github.io/images/dotfiles-logo.png" alt="dotfiles logo" width="400" />

_... my personal and constantly evolving collection_

![pre-commit](https://img.shields.io/github/actions/workflow/status/Diaoul/dotfiles/pre-commit.yml?label=pre-commit&style=for-the-badge)

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

GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME pre-commit install
```

_I use Arch, btw._

## :art: Style
I love [gruvbox](https://github.com/gruvbox-community/gruvbox) :heart:

### Font
Currently, I use [Cascadia Code](https://github.com/microsoft/cascadia-code)'s
Nerd Font variant but I switch regularly when I get too bored!

See my [fontconfig](.config/fontconfig/fonts.conf) for more details

There are other nice looking fonts [out](https://terminal.sexy/)
[there](https://www.programmingfonts.org/).

### Cursors
I use [Simp1e](https://gitlab.com/cursors/simp1e/) (Gruvbox variant) but there are
some great alternatives:
- [Capitaine](https://github.com/keeferrourke/capitaine-cursors) or its fork with Gruvbox support
- [Bibata](https://github.com/ful1e5/Bibata_Cursor)

### Icon theme
I use [Gruvbox-Plus](https://github.com/SylEleuth/gruvbox-plus-icon-pack) using
[my own package on the AUR](https://aur.archlinux.org/packages/gruvbox-plus-icon-theme-git).

### Theme
I use [Themix](https://github.com/themix-project/themix-gui) to create my own
theme (and icons) variants.

To preview and apply all those, I run `lxappearance`.

But since there is a bug with [GTK3 on Wayland](https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland),
I also run [this](.local/bin/import-gsettings.sh).

### Firefox
I published my own theme made with [Firefox Color](https://color.firefox.com/)
which is available [here](https://addons.mozilla.org/addon/yagdmit/).

### Brave
I rely on the GTK+ theme as the few available theme options don't allow to
create anything better.

### Spotify
Customized thanks to [Spicetify](https://github.com/khanhas/spicetify-cli).

But I mostly use [`spotify-player`](https://github.com/aome510/spotify-player).

### Discord
I use [BetterDiscord](https://betterdiscord.app/) with custom css.

## :hammer_and_wrench: System
### Display Manager
Running [SDDM](https://github.com/sddm/sddm) and very happy with its
multimonitor support.

### Window Manager
Previously on [bspwm](https://github.com/baskerville/bspwm), I now trust [Hyprland](https://github.com/hyprwm/Hyprland)
on Wayland for my tiling window management needs. I use 10 persistent workspaces
accross multiple monitors.

To handle monitor changes (plugging and unplugging on the dock), I've setup
[kanshi](https://sr.ht/~emersion/kanshi/) and listen to monitor changes on Hyprland's
socket.

### File Manager
Running [Thunar](https://docs.xfce.org/xfce/thunar/start) with a few plugins:
- thunar-archive-plugin
- thunar-media-tags-plugin
- thunar-volman
- tumbler
- raw-thumbnailer
- tumbler-stl-thumbnailer

### Terminal emulators
[foot](https://codeberg.org/dnkl/foot) is my go-to on Wayland but I also have
configs for [Kitty](https://sw.kovidgoyal.net/kitty/) and
[Alacritty](https://github.com/alacritty/alacritty), just in case.

### Tools
*Amazing tools I use all the time!*

- [eza](https://github.com/eza-community/eza) as a replacement for `ls`
- [bat](https://github.com/sharkdp/bat) instead of `cat` (with wings)
- [dog](https://dns.lookup.dog/) for coloured (and usable) `dig`
- [delta](https://github.com/dandavison/delta): `diff` with style
- [fd](https://github.com/sharkdp/fd) as a `find` alternative
- [ripgrep](https://github.com/BurntSushi/ripgrep) to kill old `grep`
- [fzf](https://github.com/junegunn/fzf) the fuzzy finder
- [starship](https://starship.rs/) ok this is not a tool but a cool prompt!
- [direnv](https://direnv.net/) for per-project environment

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
