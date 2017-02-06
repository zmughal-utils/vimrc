## 1. Features

### 1.1. Find and execute on files
This plugin define several commands that:
  1. search for files whose name match specified _{file-patterns}_ within list of directories (_{var}_, `$PATH` or '`runtimepath`').
  1. execute the Ex command _{cmd}_ on the files found, if any.

In other words, if you are an adept of:
```
$> find {path} -name {pattern} -exec {command}
```
then, you may be interested by these three VIM commands:
```
:SearchInVar[!] {var} {cmd} {file-patterns} .. [ "|[0]" {params} .. ]
:SearchInPATH[!]      {cmd} {file-patterns} .. [ "|[0]" {params} .. ]
:SearchInRuntime[!]   {cmd} {file-patterns} .. [ "|[0]" {params} .. ]
```

**Note:** All these commands, as well as the new `:Runtime` command provides contextual auto-completion on the command line.


### 1.2. Advanced files opening

#### 1.2.1. Split-Open files from '`path`'
```
:Split[!] {file-patterns} ...~
:Vsplit[!] {file-patterns} ...~
```
look for files into 'path' and split open them like |`:sp`| or |`:vsp`| do.

When [!] is included, all found files are opened.
When it is not included only the first file found is opened.

They are somehow equivalent to: `:SearchInVar &path :sp {file-patterns}`

**Note:** File-completion is provided, unlike |`:sp`| and |`:vsp`|.

#### 1.2.2. Goto-or-Split-Open files from '`path`'
```
GSplit[!] {file-patterns} ...~
GVSplit[!] {file-patterns} ...~
```
look for files into 'path'.

If several files match the _{file-patterns}_, the user will be asked to choose
one file to open.

If a matching file is already opened in a window, this window is made the
active window. If several files match, we jump to the first matching window.
Using {bang} (!) will override this behaviour. Instead, the user will be asked
which file must be opened if more than one match the {file-patterns}.

In either cases, if the selected (implicitly or explicitly) file is not already
opened in a window, then a new window is split opened (like |`:sp`| or |`:vsp`| do)
with the selected file.

**Notes**
  * These commands are related to |`:Sp`| and |`:Vsp`|.
  * File-completion is provided.
  * When several files match, common path denominator are stripped from the choices proposed (e.g. "/some/path/bar/file" and "/some/path/foo/file" are presented as "bar/file" and "foo/file")

#### 1.2.3. Goto ... which file ?

`gf`, `CTRL-W_f`, and `CTRL-W_v` have been overridden in order:
  * to ask the user which file must be opened if several files match,
  * and to jump to an already opened window containing the selected file.

|`CTRL-W_v`| will do work as |`CTRL-W_f`|, but the window will be split vertically.


#### 1.2.4. See also
A few plugins provide some similar features:
  * Takeshi Nishida's [fuzzy finder](http://www.vim.org/scripts/script.php?script_id=1984)
  * Hari Krishna Dara's [lookupfile](http://www.vim.org//scripts/script.php?script_id=1581)


## 2. Installation
  * Requirements: Vim 7.+, [lh-vim-lib](http://github.com/LucHermitte/lh-vim-lib)
  * With [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager), install `search-in-runtime` (this is the preferred method because of the dependencies)
```vim
ActivateAddons search-in-runtime
```
  * or you can clone the git repositories
```
git clone git@github.com:LucHermitte/lh-vim-lib.git
git clone git@github.com:LucHermitte/SearchInRuntime.git
```
  * or with Vundle/NeoBundle:
```vim
Bundle 'LucHermitte/lh-vim-lib'
Bundle 'LucHermitte/SearchInRuntime'
```

[![Project Stats](https://www.openhub.net/p/21020/widgets/project_thin_badge.gif)](https://www.openhub.net/p/21020)
