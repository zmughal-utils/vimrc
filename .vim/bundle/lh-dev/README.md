# lh-dev [![Build Status](https://secure.travis-ci.org/LucHermitte/lh-dev.png?branch=master)](http://travis-ci.org/LucHermitte/lh-dev) [![Project Stats](https://www.openhub.net/p/21020/widgets/project_thin_badge.gif)](https://www.openhub.net/p/21020)

## Introduction

lh-dev is a VimL for plugins oriented toward coding. It provides language independent functions that can be used by these plugins. The functions themselves can be specialized on a filetype basis.

I'll first present options that end-user of plugins based on lh-dev may tune, then the API itself for coding plugin authors.

Note: Starting with v2.0.0, naming policies and coding style policies have been
extracted to [lh-style project](http://github.com/LucHermitte/lh-style).


## Options

## API

This part is just a draft for the moment.

### Themes

#### class
#### type
#### function

Function boundaries can be obtained with `lh#dev#find_function_boundaries()`
The analysis currently relies on ctags and on |matchit|. The code can be
specialized though (see [Inherited filetypes](#inherited-filetypes)).

Two mappings are also provided to select function boundaries, or to apply
operators on function boundaries.

  - `v_if` in strict visual mode (not in select mode)
  - `o_if` on operators.

For instance:

  - `vif` selects the current function
  - `yif`  |yank|s the current function
  - `dif`  |delete|s the current function

This can also be used to define a way to jump to the start/end of the current
function in languages such as C++:
```vim
" excerpt from [lh-cpp](https://github.com/LucHermitte/lh-cpp).
nnoremap <silent> <buffer> [[ :call lh#dev#_goto_function_begin()<cr>
onoremap <silent> <buffer> [[ :<c-u>call lh#dev#_goto_function_begin()<cr>
nnoremap <silent> <buffer> ][ :call lh#dev#_goto_function_end()<cr>
onoremap <silent> <buffer> ][ :<c-u>call lh#dev#_goto_function_end()<cr>
```

#### instruction
#### tags
#### Import statements can be automatically added in files with
    `lh#dev#import#add()`.  See the following templates that exploit it:

```
VimL:" C++ std::vector<> snippet
VimL: let s:value_start = '¡'
VimL: let s:value_end   = s:value_start
VimL: let s:marker_open  = '<+'
VimL: let s:marker_close = '+>'
VimL: call s:AddPostExpandCallback('lh#dev#import#add("<vector>")')
std::vector<¡s:Surround(1, '<+type+>')¡> <++>
```

```
VimL:" Python os.path.exists() snippet
VimL:" hint: os.path.exists()
VimL: let s:value_start = '¡'
VimL: let s:value_end   = s:value_start
VimL: let s:marker_open  = '<+'
VimL: let s:marker_close = '+>'
VimL: call s:AddPostExpandCallback('lh#dev#import#add("os", {"symbol": "path"})')
os.path.exists(¡s:Surround(1, '<+type+>')¡)<++>
```

### Filetype polymorphism

Most features provided by lh-dev can be specialized according to the filetype, usually of the current file.

#### Options

Options can be obtained with:
 * `lh#ft#option#get(name, filetype [, default [, scopes]])`

    This returns which ever exists first among: `b:{filetype}_{name}`, or
    `g:{filetype}_{name}`, or `b:{name}`, or `g:{name}`. `{default}` is
    returned if none exists. Default value for `{default}` is
    [`g:lh#option#unset`](http://github.com/LucHermitte/lh-vim-lib).

 * `lh#ft#option#get_postfixed(name, filetype [, default [, scopes]])`

    This returns which ever exists first among: `b:{name}_{filetype}`, or
    `g:{name}_{filetype}`, or `b:{name}`, or `g:{name}`. `{default}` is
    returned if none exists. Default value for `{default}` is
    [`g:lh#option#unset`](http://github.com/LucHermitte/lh-vim-lib).

    This flavour is more suited to variables like
    `g:airline#extensions#btw#section` and
    `g:airline#extensions#btw#section_qf`.

##### Notes
  * Filetype inheritance is supported.
  * The order of the scopes for the variables checked can be specified through the optional argument `{scope}`.

##### How to set these variables ?
  * `g:{name}` is a global default option for all filetypes best set from a `.vimrc` or a plugin
  * `g:{filetype}_{name}` is a global default option for a specific filetype (and its sub-filetypes) best set from a `.vimrc` or a plugin
  * `b:{name}` is a local option for all filetypes, best set for a [vimrc\_local](https://github.com/LucHermitte/local_vimrc), or possibly a ftplugin.
  * `b:{filetype}_{name}` is a local option for a specific filetype (and its sub-filetypes), best set for a [vimrc\_local](https://github.com/LucHermitte/local_vimrc), or possibly a ftplugin.


#### Functions

Entry point: `lh#dev#{theme}#function()`

Default function: `lh#dev#{theme}#_function()`

Specialized function: `lh#dev#{filetype}#{theme}#_function()`

`lh#dev#option#call(name, filetype [, parameters])`

`lh#dev#option#pre_load_overrides(name, filetype [, parameters])`
`lh#dev#option#fast_call(name, filetype [, parameters])`

#### Filetype inheritance
`lh#ft#option#inherited_filetypes(filetypes)`

### Contributing
#### Language Analysis

## Installation
  * Requirements: Vim 7.+, [lh-vim-lib](http://github.com/LucHermitte/lh-vim-lib) (v4.0.0), [lh-tags](http://github.com/LucHermitte/lh-tags)
  * Install with [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager) any plugin that requires lh-dev should be enough.
  * With [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager), install lh-dev (this is the preferred method because of the [dependencies](http://github.com/LucHermitte/lh-dev/blob/master/addon-info.txt)).
```vim
ActivateAddons lh-dev
```
  * [vim-flavor](http://github.com/kana/vim-flavor) (which also supports dependencies)
```
flavor 'LucHermitte/lh-dev'
```
  * Vundle/NeoBundle:
```vim
Bundle 'LucHermitte/lh-vim-lib'
Bundle 'LucHermitte/lh-tags'
Bundle 'LucHermitte/lh-dev'
```
  * Clone from the git repositories
```
git clone git@github.com:LucHermitte/lh-vim-lib.git
git clone git@github.com:LucHermitte/lh-tags.git
git clone git@github.com:LucHermitte/lh-dev.git
```
