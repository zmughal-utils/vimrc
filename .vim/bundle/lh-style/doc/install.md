# Installation

  * Requirements:
      * Vim 7.+,
      * [lh-vim-lib](http://github.com/LucHermitte/lh-vim-lib) (v4.0.0),
      * [editorconfig-vim](https://github.com/editorconfig/editorconfig-vim) (optional).
  * Install with [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager) any plugin that requires lh-style should be enough.
  * With [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager), install `lh-style` (this is the preferred method because of the [dependencies](http://github.com/LucHermitte/lh-style/blob/master/addon-info.json)).

    ```vim
    ActivateAddons lh-style
    " will also install editorconfig-vim
    ```

  * [vim-flavor](http://github.com/kana/vim-flavor) (which also supports dependencies)

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

  * Clone from the git repositories, and update your [`'runtimepath'`](http://vimhelp.appspot.com/options.txt.html#%27runtimepath%27)

    ```bash
    git clone git@github.com:LucHermitte/lh-vim-lib.git
    git clone git@github.com:LucHermitte/lh-style.git
    # Optional
    git clone git@github.com:editorconfig/editorconfig-vim'
    ```
