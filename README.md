<p align="center">
  <img alt="branding" width="256" src="https://i.imgur.com/Wsm0XqN.png">
</p>
<h1 align="center">Hashbrown</h1>
<h4 align="center">A simple GUI tool to generate, compare and verify MD5, SHA-1 & SHA-256 hashes.</h4>
<p align="center">
  <br />
    <a href="https://github.com/GeopJr/Hashbrown/blob/main/CODE_OF_CONDUCT.md"><img src="https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg?style=for-the-badge&labelColor=f6d32e" alt="COC" /></a>
    <a href="https://github.com/GeopJr/Hashbrown/blob/main/LICENSE"><img src="https://img.shields.io/badge/LICENSE-AGPL--3.0-000000.svg?style=for-the-badge&labelColor=f6d32e" alt="AGPL-3.0" /></a>
    <a href="https://github.com/GeopJr/Hashbrown/actions"><img src="https://img.shields.io/github/workflow/status/geopjr/Hashbrown/Specs%20&%20Lint/main?labelColor=f6d32e&style=for-the-badge" alt="ci action status" /></a>
</p>

#

## Screenshots

<p align="center">
    <img alt="screenshot" width="768" src="https://i.imgur.com/7tEhM0z.png"><br />
    <img alt="screenshot" width="768" src="https://i.imgur.com/9KnlAd8.png"><br />
    <img alt="screenshot" width="768" src="https://i.imgur.com/OOLY7Cn.png"><br />
    <img alt="screenshot" width="768" src="https://i.imgur.com/iL20mHJ.png">
</p>

#

## Installing

- [Flathub](https://flathub.org/apps/details/dev.geopjr.Hashbrown) [RECOMMENDED]
- [AUR](https://aur.archlinux.org/packages/hashbrown/) <sup>[git](https://aur.archlinux.org/packages/hashbrown-git/)</sup>

> Feel free to package Hashbrown for your favourite distro!

> Don't forget to open an issue or a PR to have it included here.

> If there are any issues with packaging caused by Hashbrown, please open an issue!

#

## Building

### Dependencies

- `Crystal` - `~1.1.1`
- `GTK`
- `libgirepository1.0-dev`

#### Manually

1. Install crystal
2. `$ shards install`
3. `$ crystal build src/hashbrown.cr --release`

#### Makefile

1. `make`
2. `# make install` # To install it

#

## Translations

Hashbrown is using in-house translation. To translate it into another language, copy `./translations/hashbrown.js` to `./translations/{lang}.js` and fill in the info.

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
  </a>
  <a href='https://circle.gnome.org/'>
    <img width='240' alt='Part of GNOME Circle' src='https://i.imgur.com/vyIKlW3.png'/>
  </a>
</p>

### Contributors

<a href="https://github.com/GeopJr/Hashbrown/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=GeopJr/Hashbrown" />
</a>

Made with [contributors-img](https://contrib.rocks).
