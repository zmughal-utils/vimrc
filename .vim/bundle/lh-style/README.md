# lh-style [![Last release](https://img.shields.io/github/tag/LucHermitte/lh-style.svg)](https://github.com/LucHermitte/lh-style/releases) [![Build Status](https://secure.travis-ci.org/LucHermitte/lh-style.png?branch=master)](http://travis-ci.org/LucHermitte/lh-style) [![Documentation Status](https://readthedocs.org/projects/lh-style/badge/?version=latest)](http://lh-style.readthedocs.io/en/latest/?badge=latest) [![Project Stats](https://www.openhub.net/p/21020/widgets/project_thin_badge.gif)](https://www.openhub.net/p/21020)


Discl. This page is currently under heavy reorganization!

TODO:

- Complete the documentation
- reorganize the sections to:
    -[X] Intro
    -[ ] Features
        -[ ] Code formatting
            -[x] rationale
            -[ ] end-user side
                -[x] `.editorconfig`
                -[x] `.clang-format` (to be implemented)
                -[x] `:UseStyle`
                -[x] `:AddStyle`
            -[ ] extending the style families
        -[x] Naming policies
    -[ ] API
    -[ ] Contributing
    -[X] Installation

## Introduction

lh-style is a vim script library that defines vim functions and commands that permit to specify stylistic preferences
like naming conventions, bracket formatting, etc.

In itself the only feature end-users can directly exploit is name converting based on the style name (`snake_case`,
`UpperCamelCase`...) like Abolish plugin does, or on a given identifier kind (function, type, class, attribute...).
Check `:NameConvert` and `ConvertNames` -- sorry I wasn't inspired.

The main, and unique, feature is this plugin is to offer core functionalities, related to code-style, other plugins can
exploit. Typical client plugins would be code generating plugins: wizards/snippet/abbreviation plugins, and refactoring
plugins.

The style can be tuned through options. The options are meant to be tuned by end-users, and indirectly used by plugin
maintainers.  See [API section](doc/API.md) to see how you could exploit these options from your plugins.

Snippets from [lh-cpp](http://github.com/LucHermitte/lh-cpp) and
[mu-template](http://github.com/LucHermitte/mu-template), and refactorings from
[lh-refactor](http://github.com/LucHermitte/lh-refactor) exploit the options offered by lh-style for specifying code
style.


> Note: The library has been extracted from [lh-dev](http://github.com/LucHermitte/lh-dev) v2.x.x. in order to remove dependencies to [lh-tags](http://github.com/LucHermitte/lh-tags) and other plugins from template/snippet expander plugins like [mu-template](http://github.com/LucHermitte/mu-template). Yet, I've decided to reset the version counter to 1.0.0.

---

## Features

lh-style permits to adjust the style of the code you generate along two axis:

- you can define a [naming policy](doc/naming.rst)
- you can define a [formatting style](doc/code-formatting.rst) regarding the placement of brackets, spaces, newlines, and
  so on.

---

## Contributing
Contributions are welcomed. I've yet to write a proper CONTRIBUTING.md guide regarding copyright, licence and so on.

---
## Installation
  * Requirements:
      * Vim 7.+,
      * [lh-vim-lib](http://github.com/LucHermitte/lh-vim-lib) (v4.0.0),
      * [editorconfig-vim](https://github.com/editorconfig/editorconfig-vim) (optional).
  * Install with [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager) any plugin that requires lh-style should be enough.
  * With [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager), install lh-style (this is the preferred method because of the [dependencies](http://github.com/LucHermitte/lh-style/blob/master/addon-info.txt)).
```vim
ActivateAddons lh-style
" will also install editorconfig-vim
```
  * [vim-flavor](http://github.com/kana/vim-flavor) (which also supports
    dependencies)
```
flavor 'LucHermitte/lh-style'
" will also install editorconfig-vim
```
  * Vundle/NeoBundle:
```vim
Bundle 'LucHermitte/lh-vim-lib'
Bundle 'LucHermitte/lh-style'
" Optional
Bundle 'editorconfig/editorconfig-vim'
```
  * Clone from the git repositories
```
git clone git@github.com:LucHermitte/lh-vim-lib.git
git clone git@github.com:LucHermitte/lh-style.git
" Optional
git clone git@github.com:editorconfig/editorconfig-vim'
```
