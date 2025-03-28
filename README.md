<p align="center">
  <img alt="branding" width="192" src="./data/icons/dev.geopjr.Collision.svg">
</p>
<h1 align="center">Collision</h1>
<h4 align="center">Check hashes for your files</h4>
<p align="center">
  <br />
    <a href="https://github.com/GeopJr/Collision/blob/main/CODE_OF_CONDUCT.md"><img src="https://img.shields.io/badge/Code%20of%20Conduct-GNOME-26a269.svg?style=for-the-badge&labelColor=f6d32e" alt="Code of Conduct - GNOME" /></a>
    <a href="https://github.com/GeopJr/Collision/blob/main/LICENSE"><img src="https://img.shields.io/badge/LICENSE-BSD--2--Clause-26a269.svg?style=for-the-badge&labelColor=f6d32e" alt="BSD-2-Clause" /></a>
    <a href="https://github.com/GeopJr/Collision/actions"><img src="https://img.shields.io/github/actions/workflow/status/geopjr/Collision/ci.yml?branch=main&labelColor=f6d32e&style=for-the-badge" alt="ci action status" /></a>
</p>

<p align="center">
    <img alt="screenshot" width="640" src="https://media.githubusercontent.com/media/GeopJr/Collision/main/data/screenshots/screenshot-1.png"><br />
    <a href='https://flathub.org/apps/details/dev.geopjr.Collision'>
      <img alt='Download on Flathub' src='https://flathub.org/api/badge?svg&locale=en'/>
    </a>
</p>

# Building

## Dependencies

- `Crystal` - `~1.15.1`
- `GTK`
- `libadwaita`
- `gettext`

### Makefile

1. `$ make`
2. `# make install` # To install it

# Nautilus Extension

Collision offers a nautilus / GNOME Files extension that adds a "Check Hashes" context menu item.

## Dependencies

- `nautilus`
- [`nautilus-python`](https://repology.org/project/nautilus-python/versions)

## Makefile

`$ make install_nautilus_extension`

# Sponsors

<div align="center">

[![GeopJr Sponsors](https://cdn.jsdelivr.net/gh/GeopJr/GeopJr@main/sponsors.svg)](https://github.com/sponsors/GeopJr)

</div>

<hr />

<p align="center">
  <a href='https://circle.gnome.org/'>
    <img width='240' alt='Part of GNOME Circle' src='https://i.imgur.com/vyIKlW3.png'/>
  </a><br />
  <a href='https://stopthemingmy.app'>
    <img width='240' alt='Please do not theme this app' src='https://stopthemingmy.app/badge.svg'/>
  </a><br />
  <a href="https://hosted.weblate.org/engage/collision/">
    <img width='240' src="https://hosted.weblate.org/widgets/collision/-/collision/287x66-white.png" alt="Translation status" />
  </a><br />
  </a>
</p>

# Contributing

1. Read the [Code of Conduct](https://github.com/GeopJr/Collision/blob/main/CODE_OF_CONDUCT.md)
2. Fork it ( https://github.com/GeopJr/Collision/fork )
3. Create your feature branch (git checkout -b my-new-feature)
4. Commit your changes (git commit -am 'Add some feature')
5. Push to the branch (git push origin my-new-feature)
6. Create a new Pull Request
