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

### GTK Theme

I use [Oomox](https://github.com/themix-project/oomox) to create my own
theme and icons variants.
To use it, just generate the theme using the Oomox GUI.

To preview and apply all those, I run `lxappearance`.

### Cursors

- [Simp1e](https://gitlab.com/cursors/simp1e/) (Gruvbox variant)
- [Capitaine](https://github.com/keeferrourke/capitaine-cursors) or its fork with Gruvbox support
- [Bibata](https://github.com/ful1e5/Bibata_Cursor)

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

### Window Manager

I trust [bspwm](https://github.com/baskerville/bspwm) but I also keep an eye
on [Hyprland](https://github.com/hyprwm/Hyprland) on Wayland.

To handle monitor changes, I rely on [autorandr](https://github.com/phillipberndt/autorandr)
udev/systemd setup with a few tweaks.
In /usr/lib/systemd/system/autorandr.service, I bump `StartLimitIntervalSec` to 10 seconds.
In /lib/udev/rules.d/40-monitor-hotplug.rules, I rely on systemd for the switch as if it was
[installed with `MAKECMDGOALS=systemd`](https://github.com/phillipberndt/autorandr/blob/1.13.3/Makefile#L137):
```/bin/systemctl start --no-block autorandr.service```

### Terminal emulators

Switching back and forth between [Kitty](https://sw.kovidgoyal.net/kitty/) and
[Alacritty](https://github.com/alacritty/alacritty) so I have configuration
for both!
Keeping an eye on [foot](https://codeberg.org/dnkl/foot) on Wayland.

### Tools

Amazing tools I use all the time!

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
