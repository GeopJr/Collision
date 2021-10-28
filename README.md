<p align="center">
  <img alt="branding" width="256" src="https://i.imgur.com/Wsm0XqN.png">
</p>
<h1 align="center">Hashbrown</h1>
<h4 align="center">A simple GUI tool to generate, compare and verify MD5, SHA-1, SHA-256 & SHA-512 hashes.</h4>
<p align="center">
  <br />
    <a href="https://github.com/GeopJr/Hashbrown/blob/main/CODE_OF_CONDUCT.md"><img src="https://img.shields.io/badge/Contributor%20Covenant-v2.1-ff69b4.svg?style=for-the-badge&labelColor=f6d32e" alt="COC" /></a>
    <a href="https://github.com/GeopJr/Hashbrown/blob/main/LICENSE"><img src="https://img.shields.io/badge/LICENSE-BSD--2--Clause-000000.svg?style=for-the-badge&labelColor=f6d32e" alt="BSD-2-Clause" /></a>
    <a href="https://github.com/GeopJr/Hashbrown/actions"><img src="https://img.shields.io/github/workflow/status/geopjr/Hashbrown/Specs%20&%20Lint/main?labelColor=f6d32e&style=for-the-badge" alt="ci action status" /></a>
</p>

#

## Screenshots

<p align="center">
    <img alt="screenshot" width="768" src="https://i.imgur.com/96jhW14.png"><br />
    <img alt="screenshot" width="768" src="https://i.imgur.com/TxeJJuI.png">
</p>

#

## Installing

- [Flathub](https://flathub.org/apps/details/dev.geopjr.Hashbrown) [RECOMMENDED]
- [AUR](https://aur.archlinux.org/packages/hashbrown/) <sup>[git](https://aur.archlinux.org/packages/hashbrown-git/)</sup>

> Feel free to package Hashbrown for your favourite distro!

> If there are any issues with packaging caused by Hashbrown, please open an issue!

#

## Building

### Dependencies

- `Crystal` - `~1.2.1`
- `GTK`
- `libadwaita`

#### Manually

1. Install crystal
2. `$ shards install`
3. `$ crystal build src/hashbrown.cr --release`

#### Makefile

1. `make`
2. `# make install` # To install it

#

## Translations

Hashbrown is using in-house translation. There's multiple ways to translate it into a new language:

- By using POEditor.

- By copying `./translations/hashbrown.yaml` to `./translations/{lang}.yaml` and fill in the info.

If you are unsure, feel free to contact me!

#

## Contributing

1. Read the [Code of Conduct](https://github.com/GeopJr/Hashbrown/blob/main/CODE_OF_CONDUCT.md)
2. Fork it ( https://github.com/GeopJr/Hashbrown/fork )
3. Create your feature branch (git checkout -b my-new-feature)
4. Commit your changes (git commit -am 'Add some feature')
5. Push to the branch (git push origin my-new-feature)
6. Create a new Pull Request

#

## Extra

<p align="center">
  <a href='https://flathub.org/apps/details/dev.geopjr.Hashbrown'>
    <img width='240' alt='Download on Flathub' src='https://flathub.org/assets/badges/flathub-badge-i-en.png'/>
  </a><br />
  <a href='https://circle.gnome.org/'>
    <img width='240' alt='Part of GNOME Circle' src='https://i.imgur.com/vyIKlW3.png'/>
  </a><br />
  <a href='https://stopthemingmy.app'>
    <img width='240' alt='Please do not theme this app' src='https://stopthemingmy.app/badge.svg'/>
  </a>
</p>

### Contributors

<a href="https://github.com/GeopJr/Hashbrown/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=GeopJr/Hashbrown" />
</a>

Made with [contributors-img](https://contrib.rocks).
