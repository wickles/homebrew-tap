# homebrew-macports

[![BSD 2-Clause License](https://flat.badgen.net/badge/license/BSD%202-Clause/blue)](https://opensource.org/licenses/BSD-2-Clause)
[![Latest Release](https://flat.badgen.net/github/release/idleberg/homebrew-macports)](https://github.com/idleberg/homebrew-macports/releases)
[![CI](https://img.shields.io/github/workflow/status/idleberg/homebrew-macports/CI?style=flat-square)](https://github.com/idleberg/homebrew-macports/actions)

Homebrew tap for [MacPorts](https://www.macports). Wait, what?! Well, it was *you* who googled it, so don't you look funny at me!

## Installation

Tap this repository in order to be able to install its casks/formulae

```sh
$ brew tap idleberg/macports
```

## Usage

By default, it is recommended to install MacPorts as a cask

```sh
$ brew install --cask macports
```

### Danger Zone

As an alternative, this repository also includes an *experimental* formula to install MacPorts without root privileges.

```sh
$ brew install macports
```

:warning: Installing MacPorts to `/usr/local` might conflict with your Homebrew setup and hence it is not recommended to install this formula, unless you know what you're doing.

## License

This work is licensed under the [BSD 2-Clause License](LICENSE)
